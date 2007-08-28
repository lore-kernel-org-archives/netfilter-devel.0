From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [ANNOUNCE] ipset 2.3.0 released
Date: Tue, 28 Aug 2007 14:19:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708281417590.3018@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708281258370.6983@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708281258370.6983@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Aug 28 2007 13:05, Jozsef Kadlecsik wrote:
>
> I'm happy to announce the new ipset release. The main changes are
>
> - jiffies rollover bug in iptree type fixed (reported by Lukasz Nierycho
>   and others)
> - endiannes bug in iptree type fixed (spotted by Jan Engelhardt)

Was it really a bug? We were not sure about what order (hostorder,
networkorder) the tree is.

> - iptreemap type added (submitted by Sven Wegener)
> - 2.6.22/23 compatibility fixes (Jeremy Jacque)
> - typo fixes in ipset (Neville D)
> - separator changed to ':' from '%' (old one still supported) in ipset
>
> The manpage was updated as well.
>
> Please upgrade if you use the iptree map type.
>
> http://ipset.netfilter.org/

I'm kinda missing the kernel files. There is iptables, ipset-2.3.0, and
patch-o-matic, the latter of which contains no ipset kernel code even after
runme --download.



	Jan
-- 
