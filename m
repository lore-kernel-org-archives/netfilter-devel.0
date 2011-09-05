From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [iptables PATCH 1/2] Fix file descriptor leak on error
Date: Mon, 05 Sep 2011 22:24:45 +0200
Message-ID: <4E65300D.20900@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:53892 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab1IEUYt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:24:49 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by re04.intra2net.com (Postfix) with ESMTP id 7273730109
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2011 22:24:46 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id 4293C2AC54
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2011 22:24:46 +0200 (CEST)
Received: from pikkukde.a.i2n (unknown [192.168.12.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id 4E9AC2AC53
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2011 22:24:45 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 iptables/xtoptions.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/iptables/xtoptions.c b/iptables/xtoptions.c
index 04344af..4ee68fb 100644
--- a/iptables/xtoptions.c
+++ b/iptables/xtoptions.c
@@ -1133,6 +1133,7 @@ struct xtables_lmap *xtables_lmap_init(const char *file)
 	fclose(fp);
 	return lmap_head;
  out:
+	fclose(fp);
 	xtables_lmap_free(lmap_head);
 	return NULL;
 }
-- 
1.7.4.4

