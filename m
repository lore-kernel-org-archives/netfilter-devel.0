From: Thomas Woerner <twoerner@redhat.com>
Subject: [IPTABLES 0/2] iptables-compat fixes
Date: Tue, 21 Jul 2015 15:45:40 +0200
Message-ID: <1437486342-6917-1-git-send-email-twoerner@redhat.com>
Cc: Thomas Woerner <twoerner@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600AbbGUNpq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jul 2015 09:45:46 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 010B04C0AB
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2015 13:45:45 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here are the first patches from my tests with iptables-compat and firewalld:

The first patch is enabling to insert a rule into rule_count+1 position. 
# iptables-compat -t filter -S INPUT
-P INPUT ACCEPT
[0:0] -A INPUT -s 1.2.3.4/32 -j DROP
# iptables-compat -t filter -I INPUT 2 -s 1.2.3.5 -j DROP 
# iptables-compat -t filter -S INPUT
-P INPUT ACCEPT
[0:0] -A INPUT -s 1.2.3.4/32 -j DROP
[0:0] -A INPUT -s 1.2.3.5/32 -j DROP
This is possible with iptables, but not possible with iptables-compat.
Maybe it would be good to add nft_rule_list_count or similar and use it here.

The second patch fixes the rule number handling in nft_rule_find and 
__nft_rule_list. The rule number is only valid in the selected table and chain 
and therefore may not be increased for other tables or chains. With this patch 
the correct rule will be removed with -D <name> i and listed with -S <name> i.

Thomas Woerner (2):
  iptables-compat: Allow to insert into rule_count+1 position
  iptables-compat: Increase rule number only for the selected table and
    chain

 iptables/nft.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

-- 
2.4.3

