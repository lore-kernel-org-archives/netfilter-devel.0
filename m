From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 05/09: ebtables: fix inversion in match code
Date: Mon, 12 Jan 2009 11:06:06 +0100 (MET)
Message-ID: <20090112100605.9280.2476.sendpatchset@x2.localnet>
References: <20090112100559.9280.23431.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090112100559.9280.23431.sendpatchset@x2.localnet>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit c6b52c688ecf03adb82724299b97701528821ca5
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jan 12 08:52:08 2009 +0100

    netfilter: ebtables: fix inversion in match code
    
    Commit 8cc784ee (netfilter: change return types of match functions
    for ebtables extensions) broke ebtables matches by inverting the
    sense of match/nomatch.
    
    Reported-by: Matt Cross <matthltc@us.ibm.com>
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 8a8743d..820252a 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -79,7 +79,7 @@ static inline int ebt_do_match (struct ebt_entry_match *m,
 {
 	par->match     = m->u.match;
 	par->matchinfo = m->data;
-	return m->u.match->match(skb, par);
+	return m->u.match->match(skb, par) ? EBT_MATCH : EBT_NOMATCH;
 }
 
 static inline int ebt_dev_check(char *entry, const struct net_device *device)
