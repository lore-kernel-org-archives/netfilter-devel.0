From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Fri, 12 Oct 2007 20:09:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710122002020.10132@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710112238010.29814@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710120026240.14889@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710121139240.10132@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710121611580.15832@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-903745573-1192212573=:10132"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:47266 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbXJLSJo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2007 14:09:44 -0400
In-Reply-To: <Pine.LNX.4.64.0710121611580.15832@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-903745573-1192212573=:10132
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 12 Oct 2007, Jozsef Kadlecsik wrote:

> On Fri, 12 Oct 2007, Krzysztof Oledzki wrote:
>
>>> Odd, but I could not reproduce it using my local test webserver.
>>
>> I think you may test it with wp.pl, it is quite a big portal. No harm wi=
ll be
>> done with little more requests. ;)
>
> All of the machines I have got access are behind firewalls.

Oh, I see.

>>> Could you check the patch below?
>>
>> Assuming that I did not mispatched my kernel, this patch does not solve
>> described problem. :(
>
> The patch should have been applied on the top of the previous one I sent.

OK. I did it exactly this way.

>> Do you need more tcpdumps or maybe a "conntrack -o time -E" log?
>
> Could you send me a pcap file captured with '-s 0'? Then I could replay i=
t
> and see what happens.

Attached.

Oct 12 19:52:12 wrestler kernel: nf_ct_tcp: invalid packed ignored IN=3D OU=
T=3D SRC=3D195.177.210.7 DST=3D212.77.100.101 LEN=3D60 TOS=3D0x00 PREC=3D0x=
00 TTL=3D64 ID=3D57209 DF PROTO=3DTCP SPT=3D50001 DPT=3D80 SEQ=3D4171859972=
 ACK=3D0 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D0 OPT (020405B40402080A01C5577=
D0000000001030306) UID=3D0
Oct 12 19:52:12 wrestler kernel: nf_ct_tcp: killing out of sync session IN=
=3D OUT=3D SRC=3D212.77.100.101 DST=3D195.177.210.7 LEN=3D60 TOS=3D0x00 PRE=
C=3D0x00 TTL=3D57 ID=3D0 DF PROTO=3DTCP SPT=3D80 DPT=3D50001 SEQ=3D35124630=
29 ACK=3D4171859973 WINDOW=3D5792 RES=3D0x00 ACK SYN URGP=3D0 OPT (020405B4=
0402080A2261ACA501C5577D01030302)

Please let me know if you need more data.

Thank you.

Best regards,

 =09=09=09=09=09Krzysztof Ol=EAdzki
---187430788-903745573-1192212573=:10132
Content-Type: APPLICATION/octet-stream; name=wplog.gz
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0710122009330.10132@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=wplog.gz

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
XogPAAA=

---187430788-903745573-1192212573=:10132--
