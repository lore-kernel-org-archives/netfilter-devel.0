From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: problems applying ipset patch
Date: Thu, 24 May 2007 13:26:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0705241321370.18888@blackhole.kfki.hu>
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
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Andrea <andang76@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46556CBE.9000408@gmail.com>
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

> Henrik Nordstrom ha scritto:
>>> 
>>> http://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/patch-o-matic-ng-20070523.tar.bz2
>> 
>> Should be fine. That snapshot is 10.5 hours old, and Jozsef's changed
>> ipset 25 hours ago.
>> 
>> If in doubt verify that
>> patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_SET.c is modified
>> yesterday after unpacking the snapshot.
>>
>>   ls -l patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_SET.c
>
> I've just patched with patch-o-matic-ng-20070524.tar.bz2. So my config is:
>
> -linux-2.6.21.1.tar.bz2
> -patch-o-matic-ng-20070524.tar.bz2
> -iptables-1.3.7.tar.bz2
> -ipset-2.2.9a-20061009.tar.bz2  (maybe too old?)

That's good. (There was no need to fix the userspace tool since then.)

> Waiting compile-phase done, some questions:
>
> - in make oldconfig I've set ipsets entries as modules (m): am I right?

Fine.

> - do I need to uninstall iptables before patch-compile-reinstall new version 
> of iptables?

No, 'make install' will overwrite existing shared libraries and binaries. 
Just make sure you use the correct iptables binary if you have got one 
installed in another directory, too, from your distribution.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
