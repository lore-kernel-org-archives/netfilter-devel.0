From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Fw: Re: 2.6.9-mm1
Date: Wed, 27 Oct 2004 12:25:36 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1098843936.22012.18.camel@localhost.localdomain>
References: <20041026034050.02f6e1ae.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20041026034050.02f6e1ae.akpm@osdl.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-10-26 at 03:40 -0700, Andrew Morton wrote:
> Another CONNTRACK_STAT_INC in preemptible code (destroy_conntrack).
> 
> What to do?

Tempting as it is to tell you to ask the person who wrote this code...

Name: Avoid warning on CONNTRACK_STAT_INC in destroy_conntrack()
Status: Trivial
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

ip_conntrack_put can be called in any context in theory: in
particular, MASQUERADE will can call it (via ip_ct_selective_cleanup)
when an interface comes up with a different address.

Move the CONNTRACK_STAT_INC inside the lock: it needs preemption
disabled.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .13939-linux-2.6-bk/net/ipv4/netfilter/ip_conntrack_core.c .13939-linux-2.6-bk.updated/net/ipv4/netfilter/ip_conntrack_core.c
--- .13939-linux-2.6-bk/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-22 16:55:44.000000000 +1000
+++ .13939-linux-2.6-bk.updated/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-27 12:24:13.000000000 +1000
@@ -312,6 +312,7 @@ destroy_conntrack(struct nf_conntrack *n
 		}
 		kmem_cache_free(ip_conntrack_expect_cachep, ct->master);
 	}
+	CONNTRACK_STAT_INC(delete);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	if (master)
@@ -320,7 +321,6 @@ destroy_conntrack(struct nf_conntrack *n
 	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
 	kmem_cache_free(ip_conntrack_cachep, ct);
 	atomic_dec(&ip_conntrack_count);
-	CONNTRACK_STAT_INC(delete);
 }
 
 static void death_by_timeout(unsigned long ul_conntrack)

-- 
