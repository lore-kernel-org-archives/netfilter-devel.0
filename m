From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Transfer stalls with NAT under 2.6.24.3
Date: Wed, 26 Mar 2008 20:16:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803262013200.13480@bizon.gios.gov.pl>
References: <47EA0DAB.7080205@securenet.de> <47EA1653.3080300@trash.net>
 <47EA2399.1080201@securenet.de> <47EA7023.3000405@trash.net>
 <Pine.LNX.4.64.0803261941460.1905@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-439890667-1206558994=:13480"
Cc: Patrick McHardy <kaber@trash.net>, Sven Riedel <sr@securenet.de>,
	netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0803261941460.1905@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-439890667-1206558994=:13480
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 26 Mar 2008, Jozsef Kadlecsik wrote:

> On Wed, 26 Mar 2008, Patrick McHardy wrote:
>
>>> During a run with stalls:
>>>
>>> nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
>>> SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D80 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56
>>> ID=3D44105
>>> DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160349927 ACK=3D596614326 WI=
NDOW=3D49248
>>> RES=3D0x00 ACK URGP=3D0 OPT
>>> (0101080A4558793C1B13CE350101051A491E8751491E8CA9491E7B71491E81F9491E40=
A9491E5B61)
>>>
>> Thanks, can you send a binary tcpdump (... -w file) of a connection
>> that triggers these messages please?
>
> Yes, a tcpdump of a full session which is stalled could help a lot.
>
> But it almost look like as a SACK related problem: isn't there a (new)
> device between the communicating parties which performs ISN randomization
> and fails to adjust SACK?

Yep.

$ ./optparse 0101080A4558793C1B13CE350101051A491E8751491E8CA9491E7B71491E81=
F9491E40A9491E5B61
No-Operation
No-Operation
TSOPT - Time Stamp Option(8) tv=3D1163426108 er=3D454282805
No-Operation
No-Operation
SACK(24) 1226737489:1226738857(1368) 1226734449:1226736121(1672) 1226719401=
:1226726241(6840)

So, SEQ=3D4160349927 & ACK=3D596614326 vs. 12267????? is obviously wrong.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-439890667-1206558994=:13480--
