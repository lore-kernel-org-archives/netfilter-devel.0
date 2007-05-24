From: Andrea <andang76@gmail.com>
Subject: Re: problems applying ipset patch
Date: Thu, 24 May 2007 12:45:18 +0200
Message-ID: <46556CBE.9000408@gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1180002776.17774.18.camel@henriknordstrom.net>
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

Henrik Nordstrom ha scritto:
> tor 2007-05-24 klockan 12:18 +0200 skrev Andrea:
>>> Please check out patch-o-matic-ng from the svn repository: I committed 
>>> the required changes yesterday to support kernel versions 2.6.21 and above.
>> is this snapshot compatible with 2.6.21?
>>
>> http://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/patch-o-matic-ng-20070523.tar.bz2
> 
> Should be fine. That snapshot is 10.5 hours old, and Jozsef's changed
> ipset 25 hours ago.
> 
> If in doubt verify that
> patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_SET.c is modified
> yesterday after unpacking the snapshot.
> 
>   ls -l patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_SET.c

I've just patched with patch-o-matic-ng-20070524.tar.bz2. So my config is:

-linux-2.6.21.1.tar.bz2
-patch-o-matic-ng-20070524.tar.bz2
-iptables-1.3.7.tar.bz2
-ipset-2.2.9a-20061009.tar.bz2  (maybe too old?)

Waiting compile-phase done, some questions:

- in make oldconfig I've set ipsets entries as modules (m): am I right?
- do I need to uninstall iptables before patch-compile-reinstall new 
version of iptables?

Thanks for the patience
