From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset -L causing kernel panic when using macipmap
Date: Mon, 6 Dec 2004 11:37:43 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412061122280.5880@blackhole.kfki.hu>
References: <41B07CD8.8080800@routehat.org>
	<Pine.LNX.4.58.0412061024150.5880@blackhole.kfki.hu>
	<41B42E9F.2090208@routehat.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Peter Surda <shurdeek@routehat.org>
In-Reply-To: <41B42E9F.2090208@routehat.org>
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

On Mon, 6 Dec 2004, Peter Surda wrote:

> >Please use ipset 2.0 (i.e ipset utility and the kernel part from
> >patch-o-matic-ng) from the svn repository or download the snapshots from
> >http://people.netfilter.org/kadlec/ipset/install.html.
> >
> A whole upgrade is quite complicated, because I have my own distribution
> with a lot of patches in kernel and iptables and I wouldn't have the
> time to test it after an upgrade at the moment. In the meantime I'll try
> to backport this fix and also -S and -R functionality instead :-).

ipset does not conflict with anything else: only Makefile and Config.in
are affected from the other parts of the kernel tree. You could even copy
the files over your tree from patch-o-matic-ng.

The internals were completely reorganized in 2.0 to achieve the goals, so
you should actually reimplement -S and -R from scratch in ipset 1.0.

> Do I see correctly that the bug was a "- -" instead of "-" in the
> list_members function or is it more complicated and I have to use the
> whole diff of p-o-m-ng between 1.12. and 6.12.?

No, that was due to a stupid memcpy bug in ip_set_macipmap.c itself in
2.0.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
