From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Fri, 12 Oct 2007 12:09:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710121139240.10132@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710112238010.29814@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710120026240.14889@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1202461432-1192183755=:10132"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:40150 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbXJLKJ1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2007 06:09:27 -0400
In-Reply-To: <Pine.LNX.4.64.0710120026240.14889@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1202461432-1192183755=:10132
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 12 Oct 2007, Jozsef Kadlecsik wrote:

> On Thu, 11 Oct 2007, Krzysztof Oledzki wrote:
>
>> Something is still wrong in this area. With the recent fix there are no
>> more "invalid SYNIN=3D" messages, but with unsuccessful request simulate=
d
>> with "echo|nc" next connections are not possible.
> [...]
>> --- cut here ---
>> sysctl net.ipv4.ip_local_port_range=3D"50000 50003"
>> sysctl net.netfilter.nf_conntrack_log_invalid=3D255
>>
>> while true ; do echo|nc -w 1 wp.pl 80 2>/dev/null >/dev/null; echo -ne "=
HEAD /
>> HTTP/1.0\r\nHost: www.wp.pl\r\n\r\n"|nc -w 2 wp.pl 80 ; sleep 1 ; done
>> --- cut here ---
>
> Odd, but I could not reproduce it using my local test webserver.

I think you may test it with wp.pl, it is quite a big portal. No harm=20
will be done with little more requests. ;)

> However looking through the tcpdump and the kernel log, I think the=20
> problem is as follows: the aborted connection still lingers in conntrack=
=20
> for 10s (in order to catch late packets) and reopening after RST is not=
=20
> handled properly yet. You are digging into the grey areas of TCP=20
> conntrack ;-).
>
> Could you check the patch below?

Assuming that I did not mispatched my kernel, this patch does not solve=20
described problem. :( Do you need more tcpdumps or maybe a "conntrack -o=20
time -E" log?

Thank you.

Best regards,

 =09=09=09=09=09=09Krzysztof Ol=EAdzki
---187430788-1202461432-1192183755=:10132--
