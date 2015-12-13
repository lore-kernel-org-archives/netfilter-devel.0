From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Sun, 13 Dec 2015 01:30:17 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1512130124180.832@nerf40.vanv.qr>
References: <n4g4s8$4pr$1@ger.gmane.org> <566BEF33.7090501@gmail.com> <alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu> <566C09F5.6080606@gmail.com> <alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu> <566C0E75.6080800@familie-kuntze.de>
 <566c4622.936d810a.ece67.ffffdfc9@mx.google.com> <20151212232044.GE12854@breakpoint.cc> <566cae67.86f60d0a.f3ad2.2638@mx.google.com> <alpine.LSU.2.20.1512130032300.32038@nerf40.vanv.qr> <566cb640.46dc0d0a.5c3cc.287a@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>,
	Noel Kuntze <noel@familie-kuntze.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	=?UTF-8?Q?Remzi_AKY=C3=9CZ?= <linuxliste@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:46812 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbbLMAaT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Dec 2015 19:30:19 -0500
In-Reply-To: <566cb640.46dc0d0a.5c3cc.287a@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2015-12-13 01:05, D=C3=A2niel Fraga wrote:
>> git log --oneline v4.3..v4.3.1 net/netfilter/ | wc -l
>> 0
>>=20
>> Now, that makes me wonder if 4.3.1 is the culprit, or whether your
>> surrounding system is. Like [...]
>
>	Anyway, don't you think nf_conntrack_ipv4 should be
>auto-selected when "state" module is selected?

nf_conntrack_ipv4 is indeed autoloaded (provided modprobe can do it)
when you cause instantiation of a xt_conntrack (or xt_state) rule
object through ip(4)tables. And if modprobe cannot satisfy the
request, that feeds back through the kernel and to iptables, which
may then report it to stderr.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
