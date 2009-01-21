From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.28(.1) and netlink: scheduling while atomic
Date: Wed, 21 Jan 2009 10:54:51 +0100
Message-ID: <4976F0EB.8050806@trash.net>
References: <200901211029.01619.kgy@teledigit.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030801090002030200070305"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: =?ISO-8859-15?Q?K=F6vesdi_Gy=F6rgy?= <kgy@teledigit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50211 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbZAUJyx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:54:53 -0500
In-Reply-To: <200901211029.01619.kgy@teledigit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030801090002030200070305
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

Kövesdi György wrote:
> The new netlink interface allows to add NAT directly to a conntrack entry.
> If it is used when the moudule nf-nat-ipv4 is not loaded in, it results in 
> crash:
> BUG: scheduling while atomic
> It is in the kernels 2.6.28 and 2.6.28.1 in the function 
> ctnetlink_parse_nat_setup(): it calls request_module() which causes the 
> problem. If the module is already loaded, then there is no problem.


Thanks for the report. Does this patch fix it?

--------------030801090002030200070305
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3dddec6..c32a7e8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -831,13 +831,16 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 	if (!parse_nat_setup) {
 #ifdef CONFIG_MODULES
 		rcu_read_unlock();
+		spin_unlock_bh(&nf_conntrack_lock);
 		nfnl_unlock();
 		if (request_module("nf-nat-ipv4") < 0) {
 			nfnl_lock();
+			spin_lock_bh(&nf_conntrack_lock);
 			rcu_read_lock();
 			return -EOPNOTSUPP;
 		}
 		nfnl_lock();
+		spin_lock_bh(&nf_conntrack_lock);
 		rcu_read_lock();
 		if (nfnetlink_parse_nat_setup_hook)
 			return -EAGAIN;

--------------030801090002030200070305--
