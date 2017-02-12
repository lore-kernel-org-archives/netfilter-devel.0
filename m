From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables bug: Only the first two elements of a map are used for
 NAT
Date: Sun, 12 Feb 2017 18:49:03 +0100
Message-ID: <20170212174903.GA22940@salvia>
References: <7b9f63d7-b853-7005-78b1-fb3afc0d0c5a@wh2.tu-dresden.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Cc: netfilter-devel@vger.kernel.org
To: Simon Hanisch <hanisch@wh2.tu-dresden.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35822 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751217AbdBLRtQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Feb 2017 12:49:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EC143A416F
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 18:49:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DBAEBDA7FA
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 18:49:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2D0BDA801
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 18:49:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <7b9f63d7-b853-7005-78b1-fb3afc0d0c5a@wh2.tu-dresden.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Simon,

On Wed, Feb 08, 2017 at 07:11:17PM +0100, Simon Hanisch wrote:
> Hi,
> 
> we want to use a map for a large NAT setup, mapping subnets to a single
> IP. Thats why we wanted to use a map, but only the first two elements of
> the map are used for the NAT.
> I added two config examples to reproduce the bug. In the first example
> the NAT works fine for the network 100.64.15.0/24, in the second it does
> not. The only difference is the order of the map elements.
> We have build nft from the current master branch, last commit is
> 97a2a5bde2f03e33315eab4b76a9e69770b99351.
> 
> 
> 
> Working for 100.64.15.0/24
> 
> #!/usr/sbin/nft
> add chain nat postrouting { type nat hook postrouting priority 100 ;}
> add chain nat prerouting { type nat hook prerouting priority 0 ;}
> add map nat subnettoip { type ipv4_addr: ipv4_addr ; flags interval ; }
> add rule ip nat postrouting snat ip saddr map @subnettoip;
> add element nat subnettoip { 100.64.13.0/24 : 192.168.0.32 }
> add element nat subnettoip { 100.64.15.0/24 : 192.168.0.34 }
> add element nat subnettoip { 100.64.14.0/24 : 192.168.0.33 }
> 
> 
> Not working for 100.64.15.0/24
> 
> #!/usr/sbin/nft
> add chain nat postrouting { type nat hook postrouting priority 100 ;}
> add chain nat prerouting { type nat hook prerouting priority 0 ;}
> add map nat subnettoip { type ipv4_addr: ipv4_addr ; flags interval ; }
> add rule ip nat postrouting snat ip saddr map @subnettoip;
> add element nat subnettoip { 100.64.13.0/24 : 192.168.0.32 }
> add element nat subnettoip { 100.64.14.0/24 : 192.168.0.33 }
> add element nat subnettoip { 100.64.15.0/24 : 192.168.0.34 }

Thanks for the report, I can indeed reproduce it here.

I made a wrong assumption on an earlier patchset that aimed to fix
this. Would you please give a try to this patch to see if this solves
the problem for you?

Thanks.

--2fHTh5uZTiUOsy+g
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 71e8fb886a73..78dfbf9588b3 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -60,11 +60,10 @@ static bool nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
 		d = memcmp(this, key, set->klen);
 		if (d < 0) {
 			parent = parent->rb_left;
-			/* In case of adjacent ranges, we always see the high
-			 * part of the range in first place, before the low one.
-			 * So don't update interval if the keys are equal.
-			 */
-			if (interval && nft_rbtree_equal(set, this, interval))
+			if (interval &&
+			    nft_rbtree_equal(set, this, interval) &&
+			    nft_rbtree_interval_end(this) &&
+			    !nft_rbtree_interval_end(interval))
 				continue;
 			interval = rbe;
 		} else if (d > 0)

--2fHTh5uZTiUOsy+g--
