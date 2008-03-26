From: Patrick McHardy <kaber@trash.net>
Subject: Re: Transfer stalls with NAT under 2.6.24.3
Date: Wed, 26 Mar 2008 16:47:47 +0100
Message-ID: <47EA7023.3000405@trash.net>
References: <47EA0DAB.7080205@securenet.de> <47EA1653.3080300@trash.net> <47EA2399.1080201@securenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Sven Riedel <sr@securenet.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33445 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbYCZPrs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:47:48 -0400
In-Reply-To: <47EA2399.1080201@securenet.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sven Riedel wrote:
> Patrick McHardy wrote:
>> Sven Riedel wrote:
>>> Is this issue known/is there a patch available or would further 
>>> information be needed to help debug the problem?
>>
>> 2.6.24.3 includes a patches that was supposed to fix problems
>> with connections in TIME_WAIT state. Does 2.6.24.2 work better
>> for you?
> 
> The firewall system in question is currently productive. I _might_ be 
> able to try the other kernel tomorrow morning. Once I am able to try it 
> I'll let you know.
> 
>>
>> Please enable conntrack logging for TCP by executing:
>>
>> echo 6 >/proc/sys/net/netfilter/nf_conntrack_log_invalid
>>
>> and check whether you get any messages in the ring buffer.
> 
> Yep, lots ;)
> 
> In the following 100.100.100.100 is the external machine and 
> 200.200.200.200 is the NAT IP-Address on the firewall. A 5MB file was 
> transferred via scp to 100.100.100.100 from the internal network.
> 
> The output during a "clean" run, with an empty conntrack table and no 
> stalls:
> nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN= OUT=
> SRC=100.100.100.100 DST=200.200.200.200 LEN=64 TOS=0x00 PREC=0x00 TTL=56 
> ID=42121
> ...
> 
> During a run with stalls:
> 
> nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN= OUT=
> SRC=100.100.100.100 DST=200.200.200.200 LEN=80 TOS=0x00 PREC=0x00 TTL=56 
> ID=44105
> DF PROTO=TCP SPT=22 DPT=35858 SEQ=4160349927 ACK=596614326 WINDOW=49248
> RES=0x00 ACK URGP=0 OPT
> (0101080A4558793C1B13CE350101051A491E8751491E8CA9491E7B71491E81F9491E40A9491E5B61) 
> 
> 
> ^^^^ Transfer stalled here for ~10 seconds.
> 
> 
> printk: 22 messages suppressed.
> nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN= OUT=
> SRC=100.100.100.100 DST=200.200.200.200 LEN=72 TOS=0x00 PREC=0x00 TTL=56 
> ID=44113

Thanks, can you send a binary tcpdump (... -w file) of a connection
that triggers these messages please?
