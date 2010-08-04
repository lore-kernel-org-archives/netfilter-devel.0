From: Li Yewang <lyw@cn.fujitsu.com>
Subject: [iptables]fix a typo
Date: Wed, 04 Aug 2010 13:22:21 +0800
Message-ID: <4C58F90D.7080006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65095 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab0HDFWg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Aug 2010 01:22:36 -0400
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id F088C170178
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Aug 2010 13:22:33 +0800 (CST)
Received: from fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id o745JWrR011193
	for <netfilter-devel@vger.kernel.org>; Wed, 4 Aug 2010 13:19:32 +0800
Received: from [127.0.0.1] (unknown [10.167.141.89])
	by fnst.cn.fujitsu.com (Postfix) with ESMTPA id 5ED3A29141A
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Aug 2010 13:23:20 +0800 (CST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix a typo.


Signed-off-by: Li Yewang <lyw@cn.fujitsu.com>

---
  xtables.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xtables.c b/xtables.c
index ed082f3..31fd8f9 100644
--- a/xtables.c
+++ b/xtables.c
@@ -734,7 +734,7 @@ void xtables_register_match(struct xtables_match *me)
  	}

  	if (strlen(me->name) >= XT_EXTENSION_MAXNAMELEN) {
-		fprintf(stderr, "%s: target `%s' has invalid name\n",
+		fprintf(stderr, "%s: match `%s' has invalid name\n",
  			xt_params->program_name, me->name);
  		exit(1);
  	}
-- 
1.5.5.1

