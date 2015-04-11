From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH RFC 0/2] nftables: fix time parsing
Date: Sat, 11 Apr 2015 15:00:28 +0100
Message-ID: <1428760830-6135-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50803 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbbDKOAe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 10:00:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches attempt to fix time parsing to not require quotation marks
around the time spec and loosen the checks so times can also be specified
in smaller units.

Some testing indicates it works fine, however I'd put them into a branch
for 4.1 since I mainly need this fixed for the set timeout support.


Patrick McHardy (2):
  datatype: fix parsing of time type
  datatype: less strict time parsing

 src/datatype.c | 16 ----------------
 src/scanner.l  |  7 +++++++
 2 files changed, 7 insertions(+), 16 deletions(-)

-- 
2.1.0

