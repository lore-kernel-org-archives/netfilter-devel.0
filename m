From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: x_tables: don't reject valid target size on some architectures
Date: Wed,  1 Jun 2016 02:04:44 +0200
Message-ID: <1464739484-7817-1-git-send-email-fw@strlen.de>
Cc: john.stultz@linaro.org, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41949 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbcFAAEd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 20:04:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Quoting John Stultz:
  In updating a 32bit arm device from 4.6 to Linus' current HEAD, I
  noticed I was having some trouble with networking, and realized that
  /proc/net/ip_tables_names was suddenly empty.
  Digging through the registration process, it seems we're catching on the:

   if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
       target_offset + sizeof(struct xt_standard_target) != next_offset)
         return -EINVAL;

  Where next_offset seems to be 4 bytes larger then the
  offset + standard_target struct size.

next_offset needs to be aligned via XT_ALIGN (so we can access all members
of ip(6)t_entry struct).

This problem didn't show up on i686 as it only needs 4-byte alignment for
u64, but iptables userspace on other 32bit arches does insert extra padding.

Reported-by: John Stultz <john.stultz@linaro.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Fixes: 7ed2abddd20cf ("netfilter: x_tables: check standard target size too")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/x_tables.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index c69c892..2675d58 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -612,7 +612,7 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
 		return -EINVAL;
 
 	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
-	    target_offset + sizeof(struct compat_xt_standard_target) != next_offset)
+	    COMPAT_XT_ALIGN(target_offset + sizeof(struct compat_xt_standard_target)) != next_offset)
 		return -EINVAL;
 
 	/* compat_xt_entry match has less strict aligment requirements,
@@ -694,7 +694,7 @@ int xt_check_entry_offsets(const void *base,
 		return -EINVAL;
 
 	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
-	    target_offset + sizeof(struct xt_standard_target) != next_offset)
+	    XT_ALIGN(target_offset + sizeof(struct xt_standard_target)) != next_offset)
 		return -EINVAL;
 
 	return xt_check_entry_match(elems, base + target_offset,
-- 
2.7.3

