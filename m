From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 1/3] tests: xlate: generalize owner
Date: Tue,  6 Jun 2017 00:08:26 +0200
Message-ID: <20170605220828.4738-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35496 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751276AbdFEWKa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2017 18:10:30 -0400
Received: by mail-wr0-f194.google.com with SMTP id g76so8660924wrd.2
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jun 2017 15:10:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The owner name was hard-coded in the owner extension translation test.
The translation process requires the user to exist in the system, so
this commit replaces it with the usual UID_MIN value (1000).

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 extensions/libxt_owner.txlate | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_owner.txlate b/extensions/libxt_owner.txlate
index eeca168b..86fb0585 100644
--- a/extensions/libxt_owner.txlate
+++ b/extensions/libxt_owner.txlate
@@ -4,5 +4,5 @@ nft add rule ip nat OUTPUT tcp dport 80 skuid 0 counter accept
 iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --gid-owner 0-10 -j ACCEPT
 nft add rule ip nat OUTPUT tcp dport 80 skgid 0-10 counter accept
 
-iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner ! --uid-owner pablo -j ACCEPT
+iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner ! --uid-owner 1000 -j ACCEPT
 nft add rule ip nat OUTPUT tcp dport 80 skuid != 1000 counter accept
-- 
2.11.0

