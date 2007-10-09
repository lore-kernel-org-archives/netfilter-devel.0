From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Tue, 9 Oct 2007 15:17:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710091347460.28832@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu> <4704812C.8080001@trash.net>
 <Pine.LNX.4.64.0710040926320.1587@blackhole.kfki.hu> <47049D5B.8050001@trash.net>
 <Pine.LNX.4.64.0710041018180.1677@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710052151180.11803@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710081117270.6987@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710081556570.30123@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710081559450.7995@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710081923390.30123@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710090956430.9508@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1722048986-1191935835=:28832"
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:53488 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbXJINRc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Oct 2007 09:17:32 -0400
In-Reply-To: <Pine.LNX.4.64.0710090956430.9508@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1722048986-1191935835=:28832
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 9 Oct 2007, Jozsef Kadlecsik wrote:

> On Mon, 8 Oct 2007, Krzysztof Oledzki wrote:
>
>>> What is the exact kernel version of this machine?
>> It is 2.6.22.6 exactly. AFAIK there is a new "tcp source port randomizat=
ion"
>> code included in 2.6.21 or 2.6.22. Maybe it is somehow related? Or maybe=
 it
>> only make the problem easier to trigger?
>
> I have downloaded and installed 2.6.22.6 and couldn't reproduce it. Have
> you got any non-default networking setting (like tcp_tw_reuse enabled)?
No:
net.ipv4.tcp_tw_reuse =3D 0

> Or, maybe, some special networking kernel option (TCP MD5 sigs, for
> example)?

No:
zcat /proc/config.gz |grep MD5S
# CONFIG_TCP_MD5SIG is not set

> Could you please instruct me what to do exactly to reproduce
> the problem?

--- cut here ---
sysctl net.ipv4.ip_local_port_range=3D"50000 50003"
sysctl net.netfilter.nf_conntrack_log_invalid=3D255

while true ; do echo -ne "HEAD / HTTP/1.0\r\nHost: www.wp.pl\r\n\r\n"|nc wp=
=2Epl 80 ; sleep 1 ; done
--- cut here ---

It takes a few seconds to generate a lot of "SEQ is under the lower bound"=
=20
and "ACK is under the lower bound" and finally "invalid SYNIN=3D".

In my original configuration ip_local_port_range is much, much bigger but=
=20
there are >> 100 new connections per second initiated.

Thank you.

Best regards,

 =09=09=09=09=09Krzysztof Ol=EAdzki
---187430788-1722048986-1191935835=:28832--
