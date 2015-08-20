From: Andreas Herz <andi@geekosphere.org>
Subject: [PATCH 1/1] added missing icmpv6 dest-unreach codes
Date: Thu, 20 Aug 2015 12:36:31 +0200
Message-ID: <1440066991-10979-1-git-send-email-andi@geekosphere.org>
Cc: Andreas Herz <andi@geekosphere.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:41407 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbHTKgw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 06:36:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Andreas Herz <andi@geekosphere.org>
---
 extensions/libip6t_icmp6.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 68b940b..e183ce6 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -19,8 +19,11 @@ static const struct icmpv6_names icmpv6_codes[] = {
 	{ "destination-unreachable", 1, 0, 0xFF },
 	{   "no-route", 1, 0, 0 },
 	{   "communication-prohibited", 1, 1, 1 },
+	{   "beyond-scope", 1, 2, 2 },
 	{   "address-unreachable", 1, 3, 3 },
 	{   "port-unreachable", 1, 4, 4 },
+	{   "failed-policy", 1, 5, 5 },
+	{   "reject-route", 1, 6, 6 },
 
 	{ "packet-too-big", 2, 0, 0xFF },
 
-- 
2.4.6

