From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next 5/5] netfilter: nfnetlink_log: just returns error for
 unknown command
Date: Tue, 5 Jan 2016 09:34:34 +0900
Message-ID: <20160105003434.GF27154@gmail.com>
References: <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
 <20151007042550.GC23203@gmail.com>
 <20151016170532.GA18148@salvia>
 <20151106004640.GA11266@gmail.com>
 <20151106004947.GB11266@gmail.com>
 <20151108221454.GA21221@salvia>
 <20160105002456.GA27154@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:35695 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbcAEAei (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 19:34:38 -0500
Received: by mail-pf0-f172.google.com with SMTP id 78so212330529pfw.2
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 16:34:38 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160105002456.GA27154@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch stops processing options for unknown command.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nfnetlink_log.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 6a57f10..643c2d3 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -888,7 +888,9 @@ static int nfulnl_recv_config(struct net *net, struct sock *ctnl,
 			goto out_put;
 		default:
 			ret = -ENOTSUPP;
-			break;
+			if (inst)
+				goto out_put;
+			goto out;
 		}
 	} else if (!inst) {
 		ret = -ENODEV;
-- 
1.7.10.4

