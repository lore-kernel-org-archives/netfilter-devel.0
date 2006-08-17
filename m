From: Patrick McHardy <kaber@trash.net>
Subject: Re: lots of oopses
Date: Thu, 17 Aug 2006 19:04:43 +0200
Message-ID: <44E4A1AB.3000001@trash.net>
References: <44E49911.6080007@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070107020101070105020400"
Cc: l7-filter-developers@lists.sourceforge.net,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44E49911.6080007@ufomechanic.net>
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

This is a multi-part message in MIME format.
--------------070107020101070105020400
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Amin Azez wrote:
> The most recent oops where I forgot to unload most of the modules, but
> was running my layer7 load monitor crashed at a rule-add just after a
> conntrack flush. Layer7 is clearly implicated in this one. There is
> another oops further down where this is not the case.

The second one looks like a race in ipt_tables when changing the
ruleset (the attached patch should fix that). The first one looks
like a l7 bug.

BTW, what is ipt_vlan?

--------------070107020101070105020400
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: ip_tables: fix table locking in ipt_do_table

table->private might change because of ruleset changes, don't use it without
holding the lock.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 338fe5c67e8fb799c9e3470331db6f3c60a31b1e
tree 2dc15d63244ed18a8035ae483ae2d722e7fbcf62
parent 32ce9bc41528c327b1353713b2108d2213128dee
author Patrick McHardy <kaber@trash.net> Tue, 15 Aug 2006 16:06:57 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 15 Aug 2006 16:06:57 +0200

 net/ipv4/netfilter/arp_tables.c |    3 ++-
 net/ipv4/netfilter/ip_tables.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index df4854c..8d1d7a6 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -236,7 +236,7 @@ unsigned int arpt_do_table(struct sk_buf
 	struct arpt_entry *e, *back;
 	const char *indev, *outdev;
 	void *table_base;
-	struct xt_table_info *private = table->private;
+	struct xt_table_info *private;
 
 	/* ARP header, plus 2 device addresses, plus 2 IP addresses.  */
 	if (!pskb_may_pull((*pskb), (sizeof(struct arphdr) +
@@ -248,6 +248,7 @@ unsigned int arpt_do_table(struct sk_buf
 	outdev = out ? out->name : nulldevname;
 
 	read_lock_bh(&table->lock);
+	private = table->private;
 	table_base = (void *)private->entries[smp_processor_id()];
 	e = get_entry(table_base, private->hook_entry[hook]);
 	back = get_entry(table_base, private->underflow[hook]);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f316ff5..048514f 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -230,7 +230,7 @@ ipt_do_table(struct sk_buff **pskb,
 	const char *indev, *outdev;
 	void *table_base;
 	struct ipt_entry *e, *back;
-	struct xt_table_info *private = table->private;
+	struct xt_table_info *private;
 
 	/* Initialization */
 	ip = (*pskb)->nh.iph;
@@ -247,6 +247,7 @@ ipt_do_table(struct sk_buff **pskb,
 
 	read_lock_bh(&table->lock);
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
+	private = table->private;
 	table_base = (void *)private->entries[smp_processor_id()];
 	e = get_entry(table_base, private->hook_entry[hook]);
 

--------------070107020101070105020400--
