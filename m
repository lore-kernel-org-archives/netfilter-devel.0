From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Sat, 12 Dec 2015 22:32:58 -0200
Message-ID: <566cbcbe.01ed0d0a.36f37.2c88@mx.google.com>
References: <n4g4s8$4pr$1@ger.gmane.org>
	<566BEF33.7090501@gmail.com>
	<alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu>
	<566C09F5.6080606@gmail.com>
	<alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu>
	<566C0E75.6080800@familie-kuntze.de>
	<566c4622.936d810a.ece67.ffffdfc9@mx.google.com>
	<20151212232044.GE12854@breakpoint.cc>
	<566cae67.86f60d0a.f3ad2.2638@mx.google.com>
	<alpine.LSU.2.20.1512130032300.32038@nerf40.vanv.qr>
	<566cb640.46dc0d0a.5c3cc.287a@mx.google.com>
	<alpine.LSU.2.20.1512130124180.832@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>,
	Noel Kuntze <noel@familie-kuntze.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Remzi =?UTF-8?B?QUtZw5xa?= <linuxliste@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.20.1512130124180.832@nerf40.vanv.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, 13 Dec 2015 01:30:17 +0100 (CET)
Jan Engelhardt <jengelh@inai.de> wrote:

> nf_conntrack_ipv4 is indeed autoloaded (provided modprobe can do it)
> when you cause instantiation of a xt_conntrack (or xt_state) rule
> object through ip(4)tables. And if modprobe cannot satisfy the
> request, that feeds back through the kernel and to iptables, which
> may then report it to stderr.

	No, I mean selected in the "make menuconfig" ;) If the user
chooses to compile state module, menuconfig won't select automatically
nf_conntrack_ipv4 (and it should, since it depends on it).

-- 
Linux 4.3.2: Blurry Fish Butt
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
