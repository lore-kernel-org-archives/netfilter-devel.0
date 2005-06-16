From: "SZALONTAI, Zoltan" <szazol@e98.hu>
Subject: Re: [PATCH] ipt_recent fixes
Date: Thu, 16 Jun 2005 13:01:55 +0200
Message-ID: <20050616110155.GA9669@bonifac.e98.hu>
References: <87ll6o1pbi.fsf@blackdown.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>, Stephen Frost <sfrost@snowman.net>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261540AbVFPLB6@vger.kernel.org>
To: Juergen Kreileder <jk@blackdown.de>
Content-Disposition: inline
In-Reply-To: <87ll6o1pbi.fsf@blackdown.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, May 09, 2005 at 03:50:09PM +0200, Juergen Kreileder wrote:
> 
> This patch fixes the problem by using get_seconds() instead of
> jiffies.  It also fixes some 64-bit issues.

I dont know this is correct, please review.

 Zoli


time_temp is used to store and reassign time_info.time which is unsigned long.

diff -u net/ipv4/netfilter/ipt_recent.c.orig net/ipv4/netfilter/ipt_recent.c
--- net/ipv4/netfilter/ipt_recent.c.orig	2005-06-12 22:18:41.000000000 +0200
+++ net/ipv4/netfilter/ipt_recent.c	2005-06-16 10:08:25.000000000 +0200
@@ -361,9 +361,9 @@
       int *hotdrop)
 {
 	int pkt_count, hits_found, ans;
-	unsigned long now;
+	unsigned long now, time_temp;
 	const struct ipt_recent_info *info = matchinfo;
-	u_int32_t addr = 0, time_temp;
+	u_int32_t addr = 0;
 	u_int8_t ttl = skb->nh.iph->ttl;
 	int *hash_table;
 	int orig_hash_result, hash_result, temp, location = 0, time_loc, end_collision_chain = -1;
