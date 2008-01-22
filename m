From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 06/11] remove obsolete prototypes
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141051.30077.70999.stgit@rabbit.intern.cm-ag>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:46709 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753597AbYAVONP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:13:15 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 include/network.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/include/network.h b/include/network.h
index 6dfd79d..e3e9ce1 100644
--- a/include/network.h
+++ b/include/network.h
@@ -55,7 +55,6 @@ struct mcast_sock;
 void build_netmsg(struct nf_conntrack *ct, int query, struct nethdr *net);
 int prepare_send_netmsg(struct mcast_sock *m, void *data);
 int mcast_send_netmsg(struct mcast_sock *m, void *data);
-int mcast_recv_netmsg(struct mcast_sock *m, void *data, int len);
 int handle_netmsg(struct nethdr *net);
 int mcast_track_seq(uint32_t seq, uint32_t *exp_seq);
 


