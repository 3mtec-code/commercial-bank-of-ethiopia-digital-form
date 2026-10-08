// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      formType: fields[1] as String,
      branch: fields[2] as String,
      date: fields[3] as String,
      accountHolderName: fields[4] as String,
      accountNumber: fields[5] as String,
      accountType: fields[6] as String,
      denominations: (fields[7] as Map).cast<String, int>(),
      totalAmount: fields[8] as double,
      amountInWords: fields[9] as String,
      sourceOfProceeds: fields[10] as String,
      phoneNumber: fields[11] as String,
      depositedBy: fields[12] as String,
      signatureData: fields[13] as String?,
      referenceNumber: fields[14] as String,
      status: fields[15] as String,
      createdAt: fields[16] as DateTime,
      expiresAt: fields[17] as DateTime,
      encryptedPayload: fields[18] as String?,
      binInFigure: fields[19] as String?,
      binInWords: fields[20] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.formType)
      ..writeByte(2)
      ..write(obj.branch)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.accountHolderName)
      ..writeByte(5)
      ..write(obj.accountNumber)
      ..writeByte(6)
      ..write(obj.accountType)
      ..writeByte(7)
      ..write(obj.denominations)
      ..writeByte(8)
      ..write(obj.totalAmount)
      ..writeByte(9)
      ..write(obj.amountInWords)
      ..writeByte(10)
      ..write(obj.sourceOfProceeds)
      ..writeByte(11)
      ..write(obj.phoneNumber)
      ..writeByte(12)
      ..write(obj.depositedBy)
      ..writeByte(13)
      ..write(obj.signatureData)
      ..writeByte(14)
      ..write(obj.referenceNumber)
      ..writeByte(15)
      ..write(obj.status)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.expiresAt)
      ..writeByte(18)
      ..write(obj.encryptedPayload)
      ..writeByte(19)
      ..write(obj.binInFigure)
      ..writeByte(20)
      ..write(obj.binInWords);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
