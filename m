From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/03: ebtables: fix inversion in match code
Date: Mon, 19 Jan 2009 15:19:37 +0100 (MET)
Message-ID: <20090119141937.3312.73616.sendpatchset@x2.localnet>
References: <20090119141934.3312.15532.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net
To: stable@kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090119141934.3312.15532.sendpatchset@x2.localnet>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit c4010504f06c2a6570599d26173e3917b0398410
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Jan 19 15:11:44 2009 +0100

    netfilter: ebtables: fix inversion in match code
    
    Upstream commit d61ba9f:
    
    Commit 8cc784ee (netfilter: change return types of match functions
    for ebtables extensions) broke ebtables matches by inverting the
    sense of match/nomatch.
    
    Reported-by: Matt Cross <matthltc@us.ibm.com>
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 0fa208e..05f198d 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -80,7 +80,7 @@ static inline int ebt_do_match (struct ebt_entry_match *m,
 {
 	par->match     = m->u.match;
 	par->matchinfo = m->data;
-	return m->u.match->match(skb, par);
+	return m->u.match->match(skb, par) ? EBT_MATCH : EBT_NOMATCH;
 }
 
 static inline int ebt_dev_check(char *entry, const struct net_device *device)
