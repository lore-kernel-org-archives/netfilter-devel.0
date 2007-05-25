From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: problems applying ipset patch
Date: Fri, 25 May 2007 16:04:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0705251555200.21023@blackhole.kfki.hu>
References: <4653F176.4040604@gmail.com>
	<1179908784.18674.39.camel@henriknordstrom.net>
	<4654006D.9050704@gmail.com>
	<1179910939.18674.46.camel@henriknordstrom.net>
	<4654051E.8060508@gmail.com>
	<1179914093.18674.65.camel@henriknordstrom.net>
	<46543EDD.8040009@gmail.com> <46555D5C.7030406@gmail.com>
	<Pine.LNX.4.64.0705241153430.18888@blackhole.kfki.hu>
	<4655668B.6000401@gmail.com>
	<1180002776.17774.18.camel@henriknordstrom.net>
	<46556CBE.9000408@gmail.com>
	<Pine.LNX.4.64.0705241321370.18888@blackhole.kfki.hu>
	<46559618.8040708@gmail.com>
	<Pine.LNX.4.64.0705241544070.18888@blackhole.kfki.hu>
	<4655997E.7010407@gmail.com>
	<4655AEB6.5060004@gmail.com> <4655B3A8.10809@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Andrea <andang76@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4655B3A8.10809@gmail.com>
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

> Another issue: trying to modify iptables rules file, I obtain something like:
>
> "iptables-restore v1.2.11: no command specified"
>
> Maybe is there a mess between old and new version of iptables?

Yes, it seem so. You wrote that you upgraded to the version 1.3.7.
So there must be at least two sets of iptables(-save|restore) commands on 
your machine.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
