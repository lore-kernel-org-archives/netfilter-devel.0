From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v3 1/5] iptables: bugfix - prevent wrong syntax being accepted
 by the set match
Date: Sat, 29 Jun 2013 22:32:22 +0100
Message-ID: <51CF5266.90100@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:44308 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3F2Vcb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 17:32:31 -0400
Received: by mail-we0-f175.google.com with SMTP id t59so2187924wes.6
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jun 2013 14:32:30 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch corrects a bug, which was allowing wrong src and dst syntax to be
specified and accepted by the set match.

v1 * initial revision

Signed-off-by: Dash Four <mr.dash.four@googlemail.com>
---
  extensions/libxt_set.h | 8 ++++----
  1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_set.h b/extensions/libxt_set.h
index 47c3f5b..a352ac3 100644
--- a/extensions/libxt_set.h
+++ b/extensions/libxt_set.h
@@ -109,9 +109,9 @@ parse_dirs_v0(const char *opt_arg, struct xt_set_info_v0 *info)
  	
  	while (i < (IPSET_DIM_MAX - 1) && tmp != NULL) {
  		ptr = strsep(&tmp, ",");
-		if (strncmp(ptr, "src", 3) == 0)
+		if (strncmp(ptr, "src", 4) == 0)
  			info->u.flags[i++] |= IPSET_SRC;
-		else if (strncmp(ptr, "dst", 3) == 0)
+		else if (strncmp(ptr, "dst", 4) == 0)
  			info->u.flags[i++] |= IPSET_DST;
  		else
  			xtables_error(PARAMETER_PROBLEM,
@@ -135,9 +135,9 @@ parse_dirs(const char *opt_arg, struct xt_set_info *info)
  	while (info->dim < IPSET_DIM_MAX && tmp != NULL) {
  		info->dim++;
  		ptr = strsep(&tmp, ",");
-		if (strncmp(ptr, "src", 3) == 0)
+		if (strncmp(ptr, "src", 4) == 0)
  			info->flags |= (1 << info->dim);
-		else if (strncmp(ptr, "dst", 3) != 0)
+		else if (strncmp(ptr, "dst", 4) != 0)
  			xtables_error(PARAMETER_PROBLEM,
  				"You must spefify (the comma separated list of) 'src' or 'dst'.");
  	}

