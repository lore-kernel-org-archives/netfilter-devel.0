From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Sun, 13 Dec 2015 01:47:27 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1512130135350.32160@nerf40.vanv.qr>
References: <n4g4s8$4pr$1@ger.gmane.org> <566BEF33.7090501@gmail.com> <alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu> <566C09F5.6080606@gmail.com> <alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu> <566C0E75.6080800@familie-kuntze.de>
 <566c4622.936d810a.ece67.ffffdfc9@mx.google.com> <20151212232044.GE12854@breakpoint.cc> <566cae67.86f60d0a.f3ad2.2638@mx.google.com> <alpine.LSU.2.20.1512130032300.32038@nerf40.vanv.qr> <566cb640.46dc0d0a.5c3cc.287a@mx.google.com>
 <alpine.LSU.2.20.1512130124180.832@nerf40.vanv.qr> <566cbcbe.01ed0d0a.36f37.2c88@mx.google.com>
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
Received: from ares41.inai.de ([46.4.122.207]:47028 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbbLMAr2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Dec 2015 19:47:28 -0500
In-Reply-To: <566cbcbe.01ed0d0a.36f37.2c88@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2015-12-13 01:32, D=C3=A2niel Fraga wrote:

>On Sun, 13 Dec 2015 01:30:17 +0100 (CET)
>Jan Engelhardt <jengelh@inai.de> wrote:
>
>> nf_conntrack_ipv4 is indeed autoloaded (provided modprobe can do it)
>> when you cause instantiation of a xt_conntrack (or xt_state) rule
>> object through ip(4)tables. And if modprobe cannot satisfy the
>> request, that feeds back through the kernel and to iptables, which
>> may then report it to stderr.
>
>	No, I mean selected in the "make menuconfig" ;) If the user
>chooses to compile state module, menuconfig won't select automatically
>nf_conntrack_ipv4 (and it should, since it depends on it).

There is nothing to add to Kconfig, because there is no build-time=20
dependency here. In addition, some people might get grumpy if the=20
CONFIG_NETFILTER_XT_MATCH_CONNTRACK gained a dependency on something it=
=20
does not depend on at runtime in 100% of cases.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
