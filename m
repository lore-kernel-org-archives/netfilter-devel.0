From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Introducing the Change API
Date: Sun, 05 Dec 2004 21:23:53 +0100
Message-ID: <41B36E59.5020800@trash.net>
References: <41B236F6.9090405@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41B236F6.9090405@eurodev.net>
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

Pablo Neira wrote:

> Hi,
>
> I've finished the change API patch which goes on top of the conntrack 
> event API[1]. This patch provides a way to modify some parts of a 
> conntrack such as protocol and helper private info.
>
> I've defined three generic functions:
>
> a) helper handlings
> generic_change_help
> generic_change_new_expect
>
> b) proto handlings
> generic_change_proto
>
> Since there are mostly the same thing, if there's any weird protocol, 
> we can still defined our own function. I've also added a new field in 
> ip_conntrack_protocol and ip_conntrack_helper, to make their locks, if 
> any, accessible. So it's flexible enough.
>
> Comments and review welcome.

Please prefix the generic_ names with ip_ct_ or something similar.
Some more comments below.

>
> Next step, work on the ctnetlink-nfnetlink stuff. Is there any plan to 
> push forward both patches?

I think that depends on what we want to do with ip_conntrack once
nf_conntrack is merged. Since I really don't feel like keeping
three codebases in sync (ip_conntrack 2.4 + 2.6 and nf_conntrack),
I would prefer to remove it. If we do this, it doesn't make much
sense to add further features to it. But I'm not sure what Harald's
and Krisztian's plans are for ct_sync, so they might disagree with me.

Regards
Patrick

>
> Refs:
> [1] 
> https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017453.html 
>
>
> -- 
> Pablo
>
>
>diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/net/ipv4/netfilter/ip_conntrack_core.c change/net/ipv4/netfilter/ip_conntrack_core.c
>--- linux-2.5/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-04 20:13:32.000000000 +0100
>+++ change/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-04 20:14:15.000000000 +0100
>@@ -1244,6 +1244,51 @@
> 	}
> }
> 
>+void generic_change_proto(struct ip_conntrack *ct,
>+			  union ip_conntrack_proto *p)
>+{
>+	struct ip_conntrack_tuple *t = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
>+	struct ip_conntrack_protocol *proto;
>+	
>+	proto = ip_ct_find_proto(t->dst.protonum);
>
^^^ Keep in mind for ctnetlink that you may not sleep here

>+	if (proto->lock != NULL) {
>+		WRITE_LOCK(proto->lock);
>
^^^ This won't compile with CONFIG_NETFILTER_DEBUG. I think
    using normal locks and locking functions is the easiest
    solution.

>+		memcpy(&ct->proto, p, sizeof(union ip_conntrack_proto));
>+		WRITE_UNLOCK(proto->lock);
>+	} else
>+		memcpy(&ct->proto, p, sizeof(union ip_conntrack_proto));
>+}
>+
>
