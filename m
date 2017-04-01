From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: ctnetlink: using bit to represent the ct event
Date: Sat,  1 Apr 2017 20:31:32 +0800
Message-ID: <1491049892-17777-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:58560 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751410AbdDAMdQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Apr 2017 08:33:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Otherwise, creating a new conntrack via nfnetlink:
  # conntrack -I -p udp -s 1.1.1.1 -d 2.2.2.2 -t 10 --sport 10 --dport 20

will emit the wrong ct events(where UPDATE should be NEW):
  # conntrack -E
  [UPDATE] udp      17 10 src=1.1.1.1 dst=2.2.2.2 sport=10 dport=20
  [UNREPLIED] src=2.2.2.2 dst=1.1.1.1 sport=20 dport=10 mark=0

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 908d858..59ee27d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1929,9 +1929,9 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
 
 			err = 0;
 			if (test_bit(IPS_EXPECTED_BIT, &ct->status))
-				events = IPCT_RELATED;
+				events = 1 << IPCT_RELATED;
 			else
-				events = IPCT_NEW;
+				events = 1 << IPCT_NEW;
 
 			if (cda[CTA_LABELS] &&
 			    ctnetlink_attach_labels(ct, cda) == 0)
-- 
2.5.5


