From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: ICMP reject types?
Date: Tue, 1 Oct 2002 13:00:31 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0210011248170.4677-100000@dns.toxicfilms.tv>
References: <20021001100755.GC5609@aba.krakow.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-2?Q?Pawe=B3?= Krawczyk <kravietz@aba.krakow.pl>
In-Reply-To: <20021001100755.GC5609@aba.krakow.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Maybe it's my ignorance, but I feel that REJECT target --reject-with
> option is somewhat broken - you can set icmp-net-prohibited or
> host-prohibited ICMP replies, which are discouraged and obsoleted by RFC
> 1812, but you cannot use 0/13 ICMP (Admin prohibited), which is the one
> recommended by the RFC. Can anyone comment?
This item is actually on the TODO list and also has been coded by at least
two people seperatelly.
Unfortunately adding this reject type imposes some compatibility issues
with people having new libipt_REJECT.so and the old ipt_REJECT.o, which
will simply result in a DROP in case this new option is specified.

One possible solution is to use an userspace patch in patch-o-matic,
but Harald strongly disagrees with that and gets nautios when talking
about them and says he will not include those patches.

Also you could use my patch, which applied on the netfilter tree,
patches the libipt_REJECT.c and adds an item to patch-o-matic
to patch the kernel module so you can use admin-prohib.

Note, that this patch has been done versus the old netfilter tree, when
patch-o-matic was in userspace.

To avoid problems link the directories:

# ln -s patch-o-matic userspace/patch-o-matic
while sitting in /netfilter.

http://dns.toxicfilms.tv/netfilter/admin_prohib.diff


This patch contains a partial solution to compatibility issues, but in
this case, the issues come up with precompiled packages, and we're screwed
again :(

If someone has and idea, how to put it all together in a clean and elegant
way, please notify.

Best Regards,
Maciej Soltysiak
