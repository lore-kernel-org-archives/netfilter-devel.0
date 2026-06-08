Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEFB3F9F45
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780932221; cv=none; b=i5yBucyU9sQqUQeDDtBiFgezTx2BVeD78SUkpGGqRwAkFsgDHbLOMviOnWrRlP/aHmE5UlD2KmR/B5j3oUciWRFzrHwA9T7SumEwGxKiwWsADj0WL5zCG9dR5k5nUqH9seglPWZPXOnEwKQo9owKw7+G4dRfHy2Ji42YHhMul/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780932221; c=relaxed/simple;
	bh=nXoL0RKKxegxkHGW6EazVetNUx8SoCpzwe3StgKon34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsxCTnRz34nG7D1wD2yQYOspWOneBTokBsgrJ59gcuzYVjb8DQpNCcLdAspLfV07rv1ShzJaaPXFLduqKW6la3ZWx1E5C5h1ZPpuU49hiYkC+E01yfy2F7vrFC+qSQrVHFG+54OXzztxTP+DY4lUXXt8CoEyLfmiVVRXiBOmHwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 706F9602F8; Mon, 08 Jun 2026 17:23:38 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Kyle Zeng <kylebot@openai.com>
Subject: [PATCH] netfilter: x_tables: avoid leaking percpu counter pointers
Date: Mon,  8 Jun 2026 17:23:17 +0200
Message-ID: <20260608152324.20700-3-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608152324.20700-1-fw@strlen.de>
References: <20260608152324.20700-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kyle Zeng <kylebot@openai.com>

The native and compat get-entries paths copy the fixed rule entry header
from the kernelized rule blob to userspace before overwriting the entry's
counter fields with a sanitized counter snapshot.

On SMP kernels, entry->counters.pcnt contains the percpu allocation
address used by x_tables rule counters. A caller can provide a userspace
buffer that faults during the initial fixed-header copy after pcnt has
been copied but before the later sanitized counter copy runs. The syscall
then returns -EFAULT while leaving the raw percpu pointer in userspace.

Copy only the fixed entry prefix before counters from the kernelized rule
blob, then copy the sanitized counter snapshot into the counter field.
Apply this ordering to the IPv4, IPv6, and ARP native and compat
get-entries implementations so a fault cannot expose the internal percpu
counter pointer.

Fixes: 71ae0dff02d7 ("netfilter: xtables: use percpu rule counters")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 net/ipv4/netfilter/arp_tables.c | 15 ++++++---------
 net/ipv4/netfilter/ip_tables.c  | 15 ++++++---------
 net/ipv6/netfilter/ip6_tables.c | 15 ++++++---------
 3 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 85a01cbe448a..5773366de242 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -702,14 +702,12 @@ static int copy_entries_to_user(unsigned int total_size,
 		const struct xt_entry_target *t;
 
 		e = loc_cpu_entry + off;
-		if (copy_to_user(userptr + off, e, sizeof(*e))) {
-			ret = -EFAULT;
-			goto free_counters;
-		}
-		if (copy_to_user(userptr + off
+		if (copy_to_user(userptr + off, e,
+				 offsetof(struct arpt_entry, counters)) ||
+		    copy_to_user(userptr + off
 				 + offsetof(struct arpt_entry, counters),
 				 &counters[num],
-				 sizeof(counters[num])) != 0) {
+				 sizeof(counters[num]))) {
 			ret = -EFAULT;
 			goto free_counters;
 		}
@@ -1327,9 +1325,8 @@ static int compat_copy_entry_to_user(struct arpt_entry *e, void __user **dstptr,
 
 	origsize = *size;
 	ce = *dstptr;
-	if (copy_to_user(ce, e, sizeof(struct arpt_entry)) != 0 ||
-	    copy_to_user(&ce->counters, &counters[i],
-	    sizeof(counters[i])) != 0)
+	if (copy_to_user(ce, e, offsetof(struct compat_arpt_entry, counters)) ||
+	    copy_to_user(&ce->counters, &counters[i], sizeof(counters[i])))
 		return -EFAULT;
 
 	*dstptr += sizeof(struct compat_arpt_entry);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index a0ceb618966f..e6e2a71d33b5 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -832,14 +832,12 @@ copy_entries_to_user(unsigned int total_size,
 		const struct xt_entry_target *t;
 
 		e = loc_cpu_entry + off;
-		if (copy_to_user(userptr + off, e, sizeof(*e))) {
-			ret = -EFAULT;
-			goto free_counters;
-		}
-		if (copy_to_user(userptr + off
+		if (copy_to_user(userptr + off, e,
+				 offsetof(struct ipt_entry, counters)) ||
+		    copy_to_user(userptr + off
 				 + offsetof(struct ipt_entry, counters),
 				 &counters[num],
-				 sizeof(counters[num])) != 0) {
+				 sizeof(counters[num]))) {
 			ret = -EFAULT;
 			goto free_counters;
 		}
@@ -1228,9 +1226,8 @@ compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 
 	origsize = *size;
 	ce = *dstptr;
-	if (copy_to_user(ce, e, sizeof(struct ipt_entry)) != 0 ||
-	    copy_to_user(&ce->counters, &counters[i],
-	    sizeof(counters[i])) != 0)
+	if (copy_to_user(ce, e, offsetof(struct compat_ipt_entry, counters)) ||
+	    copy_to_user(&ce->counters, &counters[i], sizeof(counters[i])))
 		return -EFAULT;
 
 	*dstptr += sizeof(struct compat_ipt_entry);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 24a590c87eac..77f7cf526df8 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -848,14 +848,12 @@ copy_entries_to_user(unsigned int total_size,
 		const struct xt_entry_target *t;
 
 		e = loc_cpu_entry + off;
-		if (copy_to_user(userptr + off, e, sizeof(*e))) {
-			ret = -EFAULT;
-			goto free_counters;
-		}
-		if (copy_to_user(userptr + off
+		if (copy_to_user(userptr + off, e,
+				 offsetof(struct ip6t_entry, counters)) ||
+		    copy_to_user(userptr + off
 				 + offsetof(struct ip6t_entry, counters),
 				 &counters[num],
-				 sizeof(counters[num])) != 0) {
+				 sizeof(counters[num]))) {
 			ret = -EFAULT;
 			goto free_counters;
 		}
@@ -1244,9 +1242,8 @@ compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
 
 	origsize = *size;
 	ce = *dstptr;
-	if (copy_to_user(ce, e, sizeof(struct ip6t_entry)) != 0 ||
-	    copy_to_user(&ce->counters, &counters[i],
-	    sizeof(counters[i])) != 0)
+	if (copy_to_user(ce, e, offsetof(struct compat_ip6t_entry, counters)) ||
+	    copy_to_user(&ce->counters, &counters[i], sizeof(counters[i])))
 		return -EFAULT;
 
 	*dstptr += sizeof(struct compat_ip6t_entry);
-- 
2.43.0
