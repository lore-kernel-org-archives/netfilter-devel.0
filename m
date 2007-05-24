From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: problems applying ipset patch
Date: Thu, 24 May 2007 11:55:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0705241153430.18888@blackhole.kfki.hu>
References: <4653F176.4040604@gmail.com>
	<1179908784.18674.39.camel@henriknordstrom.net>
	<4654006D.9050704@gmail.com>
	<1179910939.18674.46.camel@henriknordstrom.net>
	<4654051E.8060508@gmail.com>
	<1179914093.18674.65.camel@henriknordstrom.net>
	<46543EDD.8040009@gmail.com> <46555D5C.7030406@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org,
	Henrik Nordstrom <henrik@henriknordstrom.net>
To: Andrea <andang76@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46555D5C.7030406@gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 24 May 2007, Andrea wrote:

> Tried again with   linux-2.6.21.1 kernel. It seems that kernet has been 
> compiled, but I've these warnings and errors:
>
> WARNING: "ipt_unregister_match" [net/ipv4/netfilter/ipt_set.ko] undefined!
> WARNING: "ipt_register_match" [net/ipv4/netfilter/ipt_set.ko] undefined!
> WARNING: "ipt_unregister_target" [net/ipv4/netfilter/ipt_SET.ko] undefined!
> WARNING: "ipt_register_target" [net/ipv4/netfilter/ipt_SET.ko] undefined!

Please check out patch-o-matic-ng from the svn repository: I committed 
the required changes yesterday to support kernel versions 2.6.21 and 
above.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
