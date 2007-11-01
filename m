From: "Ron Lai" <ronlai@cs.stanford.edu>
Subject: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Thu, 1 Nov 2007 14:16:02 -0700
Message-ID: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0013_01C81C91.BB9AD020"
Cc: <netfilter@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0013_01C81C91.BB9AD020
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-15";
	reply-type=original
Content-Transfer-Encoding: 7bit

The log I got is listed below and the corresponding pcap file is attached.

Nov  1 21:14:54 ron kernel: ftp: Conntrackinfo = 2
Nov  1 21:14:54 ron kernel: ftp: Conntrackinfo = 2
Nov  1 21:14:54 ron kernel: ftp: dataoff(60) >= skblen(60)
Nov  1 21:14:54 ron kernel: ftp: dataoff(60) >= skblen(60)
Nov  1 21:14:54 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:14:54 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:14:54 ron kernel: nf_conntrack_ftp_help: wrong seq pos (UNSET)(0) 
or (UNSET)(0)
Nov  1 21:14:54 ron kernel: nf_conntrack_ftp_help: wrong seq pos 
(3267319485) or (UNSET)(0)
Nov  1 21:14:54 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:14:54 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:14:59 ron kernel: nf_conntrack_ftp_help: wrong seq pos (UNSET)(0) 
or (UNSET)(0)
Nov  1 21:14:59 ron kernel: nf_conntrack_ftp_help: wrong seq pos 
(3733317025) or (UNSET)(0)
Nov  1 21:14:59 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:14:59 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:14:59 ron kernel: find_pattern `227 ': dlen = 45
Nov  1 21:14:59 ron kernel: find_pattern `229 ': dlen = 45
Nov  1 21:14:59 ron kernel: find_pattern `227 ': dlen = 45
Nov  1 21:14:59 ron kernel: find_pattern `229 ': dlen = 45
Nov  1 21:14:59 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:14:59 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:15 ron kernel: find_pattern `PORT': dlen = 7
Nov  1 21:15:15 ron kernel: find_pattern `EPRT': dlen = 7
Nov  1 21:15:15 ron kernel: find_pattern `PORT': dlen = 7
Nov  1 21:15:15 ron kernel: find_pattern `EPRT': dlen = 7
Nov  1 21:15:15 ron kernel: find_pattern `227 ': dlen = 48
Nov  1 21:15:15 ron kernel: find_pattern `229 ': dlen = 48
Nov  1 21:15:15 ron kernel: find_pattern `227 ': dlen = 48
Nov  1 21:15:15 ron kernel: find_pattern `229 ': dlen = 48
Nov  1 21:15:15 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:15 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:15 ron kernel: find_pattern `PORT': dlen = 6
Nov  1 21:15:15 ron kernel: find_pattern `EPRT': dlen = 6
Nov  1 21:15:15 ron kernel: find_pattern `PORT': dlen = 6
Nov  1 21:15:15 ron kernel: find_pattern `EPRT': dlen = 6
Nov  1 21:15:15 ron kernel: find_pattern `227 ': dlen = 19
Nov  1 21:15:15 ron kernel: find_pattern `229 ': dlen = 19
Nov  1 21:15:15 ron kernel: find_pattern `227 ': dlen = 19
Nov  1 21:15:15 ron kernel: find_pattern `229 ': dlen = 19
Nov  1 21:15:15 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:15 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:19 ron kernel: find_pattern `PORT': dlen = 27
Nov  1 21:15:19 ron kernel: Pattern matches!
Nov  1 21:15:19 ron kernel: Skipped up to ` '!
Nov  1 21:15:19 ron kernel: Match succeeded!
Nov  1 21:15:19 ron kernel: conntrack_ftp: match `172,16,119,91,128,61' (20 
bytes at 3733317043)
Nov  1 21:15:19 ron kernel: FTP_NAT: type 0, off 5 len 20
Nov  1 21:15:19 ron kernel: calling nf_nat_mangle_tcp_packet
Nov  1 21:15:19 ron kernel: nf_nat_mangle_packet: Extending packet by 1 from 
79 bytes
Nov  1 21:15:19 ron kernel: nf_nat_resize_packet: Seq_offset before: 
offset_before=0, offset_after=0, correction_pos=0
Nov  1 21:15:19 ron kernel: nf_nat_resize_packet: Seq_offset after: 
offset_before=0, offset_after=1, correction_pos=3733317038
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317038->3733317038, ack from 3267319597->3267319597
Nov  1 21:15:19 ron kernel: find_pattern `PORT': dlen = 28
Nov  1 21:15:19 ron kernel: Pattern matches!
Nov  1 21:15:19 ron kernel: Skipped up to ` '!
Nov  1 21:15:19 ron kernel: Match succeeded!
Nov  1 21:15:19 ron kernel: conntrack_ftp: match `172,16,255,123,128,61' (21 
bytes at 3733317043)
Nov  1 21:15:19 ron kernel: conntrack_ftp: NOT RECORDING: 172.16.255.123 != 
172.16.119.91
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317038->3733317038, ack from 3267319597->3267319597
Nov  1 21:15:19 ron kernel: find_pattern `227 ': dlen = 30
Nov  1 21:15:19 ron kernel: find_pattern `229 ': dlen = 30
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3267319597->3267319597, ack from 3733317066->3733317065
Nov  1 21:15:19 ron kernel: find_pattern `227 ': dlen = 30
Nov  1 21:15:19 ron kernel: find_pattern `229 ': dlen = 30
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3267319597->3267319597, ack from 3733317065->3733317064
Nov  1 21:15:19 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317065->3733317066, ack from 3267319627->3267319627
Nov  1 21:15:19 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317066->3733317067, ack from 3267319627->3267319627
Nov  1 21:15:19 ron kernel: nf_conntrack_ftp_help: wrong seq pos 
(3733317066) or (3733317065)
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317064->3733317065, ack from 3267319627->3267319627
Nov  1 21:15:19 ron kernel: find_pattern `PORT': dlen = 1
Nov  1 21:15:19 ron kernel: find_pattern `EPRT': dlen = 1
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317065->3733317066, ack from 3267319627->3267319627
Nov  1 21:15:19 ron kernel: find_pattern `227 ': dlen = 33
Nov  1 21:15:19 ron kernel: find_pattern `229 ': dlen = 33
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3267319627->3267319627, ack from 3733317067->3733317066
Nov  1 21:15:19 ron kernel: find_pattern `227 ': dlen = 33
Nov  1 21:15:19 ron kernel: find_pattern `229 ': dlen = 33
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3267319627->3267319627, ack from 3733317066->3733317065
Nov  1 21:15:19 ron kernel: find_pattern `PORT': dlen = 6
Nov  1 21:15:19 ron kernel: find_pattern `EPRT': dlen = 6
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317065->3733317066, ack from 3267319660->3267319660
Nov  1 21:15:19 ron kernel: find_pattern `PORT': dlen = 6
Nov  1 21:15:19 ron kernel: find_pattern `EPRT': dlen = 6
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317066->3733317067, ack from 3267319660->3267319660
Nov  1 21:15:19 ron kernel: find_pattern `227 ': dlen = 53
Nov  1 21:15:19 ron kernel: find_pattern `229 ': dlen = 53
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3267319660->3267319660, ack from 3733317073->3733317072
Nov  1 21:15:19 ron kernel: find_pattern `227 ': dlen = 53
Nov  1 21:15:19 ron kernel: find_pattern `229 ': dlen = 53
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3267319660->3267319660, ack from 3733317072->3733317071
Nov  1 21:15:19 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317071->3733317072, ack from 3267319713->3267319713
Nov  1 21:15:19 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317072->3733317073, ack from 3267319713->3267319713
Nov  1 21:15:19 ron kernel: find_pattern `227 ': dlen = 24
Nov  1 21:15:19 ron kernel: find_pattern `229 ': dlen = 24
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3267319713->3267319713, ack from 3733317073->3733317072
Nov  1 21:15:19 ron kernel: find_pattern `227 ': dlen = 24
Nov  1 21:15:19 ron kernel: find_pattern `229 ': dlen = 24
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3267319713->3267319713, ack from 3733317072->3733317071
Nov  1 21:15:19 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317071->3733317072, ack from 3267319737->3267319737
Nov  1 21:15:19 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:19 ron kernel: Adjusting sequence number from 
3733317072->3733317073, ack from 3267319737->3267319737
Nov  1 21:15:23 ron kernel: find_pattern `PORT': dlen = 6
Nov  1 21:15:23 ron kernel: find_pattern `EPRT': dlen = 6
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3733317071->3733317072, ack from 3267319737->3267319737
Nov  1 21:15:23 ron kernel: find_pattern `PORT': dlen = 6
Nov  1 21:15:23 ron kernel: find_pattern `EPRT': dlen = 6
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3733317072->3733317073, ack from 3267319737->3267319737
Nov  1 21:15:23 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3733317077->3733317078, ack from 3267319737->3267319737
Nov  1 21:15:23 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3733317078->3733317079, ack from 3267319737->3267319737
Nov  1 21:15:23 ron kernel: find_pattern `227 ': dlen = 14
Nov  1 21:15:23 ron kernel: find_pattern `229 ': dlen = 14
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3267319737->3267319737, ack from 3733317079->3733317078
Nov  1 21:15:23 ron kernel: find_pattern `227 ': dlen = 14
Nov  1 21:15:23 ron kernel: find_pattern `229 ': dlen = 14
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3267319737->3267319737, ack from 3733317078->3733317077
Nov  1 21:15:23 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3267319751->3267319751, ack from 3733317079->3733317078
Nov  1 21:15:23 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3267319751->3267319751, ack from 3733317078->3733317077
Nov  1 21:15:23 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3267319752->3267319752, ack from 3733317080->3733317079
Nov  1 21:15:23 ron kernel: ftp: dataoff(52) >= skblen(52)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3267319752->3267319752, ack from 3733317079->3733317078
Nov  1 21:15:23 ron kernel: ftp: dataoff(40) >= skblen(40)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3733317077->3733317078, ack from 0->0
Nov  1 21:15:23 ron kernel: ftp: dataoff(40) >= skblen(40)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3733317078->3733317079, ack from 0->0
Nov  1 21:15:23 ron kernel: ftp: dataoff(40) >= skblen(40)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3733317077->3733317078, ack from 0->0
Nov  1 21:15:23 ron kernel: ftp: dataoff(40) >= skblen(40)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3733317078->3733317079, ack from 0->0
Nov  1 21:15:23 ron kernel: ftp: dataoff(40) >= skblen(40)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3733317078->3733317079, ack from 0->0
Nov  1 21:15:23 ron kernel: ftp: dataoff(40) >= skblen(40)
Nov  1 21:15:23 ron kernel: Adjusting sequence number from 
3733317079->3733317080, ack from 0->0

ron
----- Original Message ----- 
From: "ron lai" <ronlai@cs.stanford.edu>
To: "ron lai" <ronlai@cs.stanford.edu>
Sent: Wednesday, October 31, 2007 10:07 PM
Subject: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6


>
> ----- Original Message ----- 
> From: "Patrick McHardy" <kaber@trash.net>
> To: "Ron Lai" <ronlai@cs.stanford.edu>
> Cc: <netfilter@vger.kernel.org>; "Netfilter Development Mailinglist"
> <netfilter-devel@vger.kernel.org>
> Sent: Monday, October 29, 2007 5:51 AM
> Subject: Re: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in
> 2.6.22.6
>
>
>> Ron Lai wrote:
>>> The packet dump from the 2.6.22.6 box in the middle is attached. In the
>>> trace 172.16.119.91 is the original IP address of the FTP client and
>>> 172.16.255.123 is the NATted address. The FTP server's address is
>>> 172.16.118.1.
>>>
>>> The problem happens between packet 31 and packet 34. Packet 31 indicates
>>> that the client expects ACK number 0x64b4dda9 for the PORT command it
>>> sends. However, the ACK number it actually gets is 0x64b4dda8.
>>
>>
>> Thats really odd. It properly adjusts the sequence number in the
>> original direction by +1, but incorrectly adjusts the acknowledgement
>> in the reply direction by -2. I don't see how this could happen with
>> the vanilla 2.6.22 kernel, are you using any additional patches?
>>
>> Otherwise please edit net/ipv4/netfilter/nf_nat_helper.c and add
>> a #define DEBUG at the first line, recompile and post the output
>> of the failed session (ideally two failed sessions). Thanks.
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe netfilter" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

------=_NextPart_000_0013_01C81C91.BB9AD020
Content-Type: application/octet-stream;
	name="ftp_test.pcap"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="ftp_test.pcap"

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
Fd6F5dgAAAAAUAQAAIVJAAA=

------=_NextPart_000_0013_01C81C91.BB9AD020--

