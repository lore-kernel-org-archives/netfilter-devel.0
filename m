Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9DB38F223
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 12:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770294627; cv=none; b=mkXeDC4WYp7s/gwkzmGUfUCrqMGL0EZgvymcnVPbP2MD/Xx8jL0ewhoYAEtbpsKlkSgHjcHqZMj0dr5PbeVZTJGitwZBKhhkzkAt/tzqh1ICChwaQZuh9jXpDnP2tIfZKk11waOXCMNtAahL1fZUVVj39FG3jYsT4etigvRy1bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770294627; c=relaxed/simple;
	bh=BdLeY/Wcp9Yp2LmkVEP9i8CAU+Ez17YaOPV00h+snL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRqJI9hIMKGfBTdEiXKodiDoQRb7/OwqtT08sDEh2dfWiDke52/4dRptuhW0CxCX8/pCfoJdm07/77Lql/z/Re4W6rCK4b71Lpt9ZTh1MWVjK2c1MhTT+CsfKVbW4WOnSYK8NFeemYVKiTJoZGJjCy7jroNlZuhAIOI6kyA7/mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X+XyFQv8; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X+XyFQv8"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-794911acb04so8914087b3.0
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Feb 2026 04:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770294626; x=1770899426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yrS9DvQduBuG9vFWu3R3S68L8j+kOMCWlO1YzP6LJOM=;
        b=X+XyFQv8iWownLFggkE+9ED2WrW4xBDz9gcqCLuqbiClC3C8Hy9S8qpXUpjRXig0et
         ZxhrR7ITmSCUg74iszcXbuZOFbJjXVwxhdSCXfKics5GbJqYS6FqjNQD8yfw9MIXwWF7
         II6nsJ5dFmS/wnqpIIvrs1MhNKJj4N9Z4VUdCtKJTCfoKolt5aTzu1kBpf2K1rHiMMg0
         WsRuUUy/IQuMpdbhlPKeEDzsypU8WviCp6c9Q5Ne4AZodRTWKXhc+byQioHhKMRoiC2K
         ZyQYG4J3Bl+SdY4PJCALDckUTyST9TJ9q6Bl3WvMxTerI/n9ecHeQSv6u5KgU5glAaLr
         YpDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770294626; x=1770899426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yrS9DvQduBuG9vFWu3R3S68L8j+kOMCWlO1YzP6LJOM=;
        b=p9V+Ly5GLYDyxm7N4i1vdHI8bVZ2nan6AOwqyE+Jayu9ybTQjwilFxDa0dqFBSrGd2
         SJW+tGNZZqrDSU/cjopa7zP+vxFgNoqIlEVfaPFTbE9Cx+SO0LFalc7aKXOC+uXvBi9P
         x+zC3C3WVSxRojlpQe/C6uNFbh1g3ewLKvZ020BhgpjVW1XB5+kpnc15oPinrBVa9qwy
         JXZ4WHzDLLrofH1slPSI4kviP8r9fTsKt2Tjcdi+m8QAcKCij0k7BKW7Fr19MzzDJKn2
         AHptgiKNQhiXvcLvtWK7oPmHURVEZzSp6VVfzjqbM6B64m8eNvaUfT2L5KJ0bmCJ2/RQ
         eO+w==
X-Forwarded-Encrypted: i=1; AJvYcCUI5M6ofgHVDEzfStABXNwkSQI2erVNwZC07JpUAx5mdiTxu8YPK5BoVbuPOSHGJ33XaZdbJKvFsbwhwTfDx1E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeJU0pjzhw5jl/2C4pFIWPAPcAcMmyZFjK8jzYNKrZhwGUDZFQ
	WmCQOD81AMv80G1rnBCTnzZyI84nVnjnVb3gE69ouYONyybkcIEmZ3fU
X-Gm-Gg: AZuq6aIcfmgcE5AKC/1LwmiVjvUHTyY1NSyKguwygvTg5hDJNvLu6iBcz7nZrQzj/X5
	qxYs1KbIAMBXEXp/Rh3vCNW+wrHXNwVGxP1aHMekSwM1NZo1OIIRTmW7DkoSJpofNCAX5uJoHaK
	cOqI/adE4zmRRXsFdVfdUeh1hMnWe6J6rUkQuzoogB30R918z0KNs/qWhd6vpQBT1dzhwniCWl2
	CdlNRaEhW6/8m1hrvny374Jw6wuwxORUeAAwUfvHJyHxK/KWY+lRMv5d9QEnMgoyUzwYUCVw+l9
	/71+b3F5D6RJjpZJgSYYP8jCdLguf+bxg2fyj+3DPAhp+PkcG3L7Gpy2umo9pKAE25G32Ym6g3U
	AhXjlrszUqiue0/dFCenzOhsKsU8xq+fY8YHRw4HnLMzW7DUEZmrSHISx/ZT4O0y7752SjvzC8P
	oLGsUJ49YNbbh6y0qG/ImCeEaOxl1f69SuVNmdlazILZp+Azx3btSG1L7MMTi54lUe6U/WNenJv
	UOaWAJYtg==
X-Received: by 2002:a05:690c:e3ee:b0:794:e6c0:1e9d with SMTP id 00721157ae682-794fe678e95mr55962387b3.17.1770294626165;
        Thu, 05 Feb 2026 04:30:26 -0800 (PST)
Received: from localhost.localdomain (108-214-96-168.lightspeed.sntcca.sbcglobal.net. [108.214.96.168])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-794feff5cc7sm44122577b3.52.2026.02.05.04.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 04:30:25 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH v5] netfilter: annotate NAT helper hook pointers with __rcu
Date: Thu,  5 Feb 2026 20:30:17 +0800
Message-ID: <20260205123017.20152-1-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aYRqOW_kWlfcEtWM@strlen.de>
References: <aYRqOW_kWlfcEtWM@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The NAT helper hook pointers are updated and dereferenced under RCU rules,
but lack the proper __rcu annotation.

This makes sparse report address space mismatches when the hooks are used
with rcu_dereference().

Add the missing __rcu annotations to the global hook pointer declarations
and definitions in Amanda, FTP, IRC, SNMP and TFTP.

No functional change intended.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
v5:
  - Squash previous 5-patch series into a single patch (per Florian).
  - Fix parameter alignment in .h and .c files to match the opening
    parenthesis.

v4:
  - Extend the change from amanda to the other NAT helpers (ftp/irc/snmp/tftp).
  - Drop the proposed code simplification (typeof pattern).

v2:
  - Place __rcu annotation inside the pointer parentheses (per Florian).
  - Return to use standard rcu_dereference() instead of rcu_dereference_raw().

(no v3 posted)
---
 include/linux/netfilter/nf_conntrack_amanda.h | 12 ++++++------
 include/linux/netfilter/nf_conntrack_ftp.h    | 14 +++++++-------
 include/linux/netfilter/nf_conntrack_irc.h    | 12 ++++++------
 include/linux/netfilter/nf_conntrack_snmp.h   |  2 +-
 include/linux/netfilter/nf_conntrack_tftp.h   |  6 +++---
 net/netfilter/nf_conntrack_amanda.c           | 14 +++++++-------
 net/netfilter/nf_conntrack_ftp.c              | 14 +++++++-------
 net/netfilter/nf_conntrack_irc.c              | 13 +++++++------
 net/netfilter/nf_conntrack_snmp.c             |  8 ++++----
 net/netfilter/nf_conntrack_tftp.c             |  7 ++++---
 10 files changed, 52 insertions(+), 50 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_amanda.h b/include/linux/netfilter/nf_conntrack_amanda.h
index 6f0ac896fcc9..9f957598a9da 100644
--- a/include/linux/netfilter/nf_conntrack_amanda.h
+++ b/include/linux/netfilter/nf_conntrack_amanda.h
@@ -7,10 +7,10 @@
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
-extern unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
-					  enum ip_conntrack_info ctinfo,
-					  unsigned int protoff,
-					  unsigned int matchoff,
-					  unsigned int matchlen,
-					  struct nf_conntrack_expect *exp);
+extern unsigned int (__rcu *nf_nat_amanda_hook)(struct sk_buff *skb,
+						enum ip_conntrack_info ctinfo,
+						unsigned int protoff,
+						unsigned int matchoff,
+						unsigned int matchlen,
+						struct nf_conntrack_expect *exp);
 #endif /* _NF_CONNTRACK_AMANDA_H */
diff --git a/include/linux/netfilter/nf_conntrack_ftp.h b/include/linux/netfilter/nf_conntrack_ftp.h
index 0e38302820b9..939c847213b4 100644
--- a/include/linux/netfilter/nf_conntrack_ftp.h
+++ b/include/linux/netfilter/nf_conntrack_ftp.h
@@ -26,11 +26,11 @@ struct nf_ct_ftp_master {
 
 /* For NAT to hook in when we find a packet which describes what other
  * connection we should expect. */
-extern unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
-				       enum ip_conntrack_info ctinfo,
-				       enum nf_ct_ftp_type type,
-				       unsigned int protoff,
-				       unsigned int matchoff,
-				       unsigned int matchlen,
-				       struct nf_conntrack_expect *exp);
+extern unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
+					     enum ip_conntrack_info ctinfo,
+					     enum nf_ct_ftp_type type,
+					     unsigned int protoff,
+					     unsigned int matchoff,
+					     unsigned int matchlen,
+					     struct nf_conntrack_expect *exp);
 #endif /* _NF_CONNTRACK_FTP_H */
diff --git a/include/linux/netfilter/nf_conntrack_irc.h b/include/linux/netfilter/nf_conntrack_irc.h
index d02255f721e1..14ad5bfaad81 100644
--- a/include/linux/netfilter/nf_conntrack_irc.h
+++ b/include/linux/netfilter/nf_conntrack_irc.h
@@ -8,11 +8,11 @@
 
 #define IRC_PORT	6667
 
-extern unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
-				       enum ip_conntrack_info ctinfo,
-				       unsigned int protoff,
-				       unsigned int matchoff,
-				       unsigned int matchlen,
-				       struct nf_conntrack_expect *exp);
+extern unsigned int (__rcu *nf_nat_irc_hook)(struct sk_buff *skb,
+					     enum ip_conntrack_info ctinfo,
+					     unsigned int protoff,
+					     unsigned int matchoff,
+					     unsigned int matchlen,
+					     struct nf_conntrack_expect *exp);
 
 #endif /* _NF_CONNTRACK_IRC_H */
diff --git a/include/linux/netfilter/nf_conntrack_snmp.h b/include/linux/netfilter/nf_conntrack_snmp.h
index 87e4f33eb55f..99107e4f5234 100644
--- a/include/linux/netfilter/nf_conntrack_snmp.h
+++ b/include/linux/netfilter/nf_conntrack_snmp.h
@@ -5,7 +5,7 @@
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 
-extern int (*nf_nat_snmp_hook)(struct sk_buff *skb,
+extern int (__rcu *nf_nat_snmp_hook)(struct sk_buff *skb,
 				unsigned int protoff,
 				struct nf_conn *ct,
 				enum ip_conntrack_info ctinfo);
diff --git a/include/linux/netfilter/nf_conntrack_tftp.h b/include/linux/netfilter/nf_conntrack_tftp.h
index dc4c1b9beac0..05c72d0bc98d 100644
--- a/include/linux/netfilter/nf_conntrack_tftp.h
+++ b/include/linux/netfilter/nf_conntrack_tftp.h
@@ -19,8 +19,8 @@ struct tftphdr {
 #define TFTP_OPCODE_ACK		4
 #define TFTP_OPCODE_ERROR	5
 
-extern unsigned int (*nf_nat_tftp_hook)(struct sk_buff *skb,
-				        enum ip_conntrack_info ctinfo,
-				        struct nf_conntrack_expect *exp);
+extern unsigned int (__rcu *nf_nat_tftp_hook)(struct sk_buff *skb,
+					      enum ip_conntrack_info ctinfo,
+					      struct nf_conntrack_expect *exp);
 
 #endif /* _NF_CONNTRACK_TFTP_H */
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 7be4c35e4795..c0132559f6af 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -37,13 +37,13 @@ MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
 module_param(ts_algo, charp, 0400);
 MODULE_PARM_DESC(ts_algo, "textsearch algorithm to use (default kmp)");
 
-unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
-				   enum ip_conntrack_info ctinfo,
-				   unsigned int protoff,
-				   unsigned int matchoff,
-				   unsigned int matchlen,
-				   struct nf_conntrack_expect *exp)
-				   __read_mostly;
+unsigned int (__rcu *nf_nat_amanda_hook)(struct sk_buff *skb,
+					 enum ip_conntrack_info ctinfo,
+					 unsigned int protoff,
+					 unsigned int matchoff,
+					 unsigned int matchlen,
+					 struct nf_conntrack_expect *exp)
+					 __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_amanda_hook);
 
 enum amanda_strings {
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 617f744a2e3a..5e00f9123c38 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -43,13 +43,13 @@ module_param_array(ports, ushort, &ports_c, 0400);
 static bool loose;
 module_param(loose, bool, 0600);
 
-unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
-				enum ip_conntrack_info ctinfo,
-				enum nf_ct_ftp_type type,
-				unsigned int protoff,
-				unsigned int matchoff,
-				unsigned int matchlen,
-				struct nf_conntrack_expect *exp);
+unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
+				      enum ip_conntrack_info ctinfo,
+				      enum nf_ct_ftp_type type,
+				      unsigned int protoff,
+				      unsigned int matchoff,
+				      unsigned int matchlen,
+				      struct nf_conntrack_expect *exp);
 EXPORT_SYMBOL_GPL(nf_nat_ftp_hook);
 
 static int try_rfc959(const char *, size_t, struct nf_conntrack_man *,
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 5703846bea3b..b8e6d724acd1 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -30,12 +30,13 @@ static unsigned int dcc_timeout __read_mostly = 300;
 static char *irc_buffer;
 static DEFINE_SPINLOCK(irc_buffer_lock);
 
-unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
-				enum ip_conntrack_info ctinfo,
-				unsigned int protoff,
-				unsigned int matchoff,
-				unsigned int matchlen,
-				struct nf_conntrack_expect *exp) __read_mostly;
+unsigned int (__rcu *nf_nat_irc_hook)(struct sk_buff *skb,
+				      enum ip_conntrack_info ctinfo,
+				      unsigned int protoff,
+				      unsigned int matchoff,
+				      unsigned int matchlen,
+				      struct nf_conntrack_expect *exp)
+				      __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_irc_hook);
 
 #define HELPER_NAME "irc"
diff --git a/net/netfilter/nf_conntrack_snmp.c b/net/netfilter/nf_conntrack_snmp.c
index daacf2023fa5..387dd6e58f88 100644
--- a/net/netfilter/nf_conntrack_snmp.c
+++ b/net/netfilter/nf_conntrack_snmp.c
@@ -25,10 +25,10 @@ static unsigned int timeout __read_mostly = 30;
 module_param(timeout, uint, 0400);
 MODULE_PARM_DESC(timeout, "timeout for master connection/replies in seconds");
 
-int (*nf_nat_snmp_hook)(struct sk_buff *skb,
-			unsigned int protoff,
-			struct nf_conn *ct,
-			enum ip_conntrack_info ctinfo);
+int (__rcu *nf_nat_snmp_hook)(struct sk_buff *skb,
+			      unsigned int protoff,
+			      struct nf_conn *ct,
+			      enum ip_conntrack_info ctinfo);
 EXPORT_SYMBOL_GPL(nf_nat_snmp_hook);
 
 static int snmp_conntrack_help(struct sk_buff *skb, unsigned int protoff,
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 80ee53f29f68..89e9914e5d03 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -32,9 +32,10 @@ static unsigned int ports_c;
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "Port numbers of TFTP servers");
 
-unsigned int (*nf_nat_tftp_hook)(struct sk_buff *skb,
-				 enum ip_conntrack_info ctinfo,
-				 struct nf_conntrack_expect *exp) __read_mostly;
+unsigned int (__rcu *nf_nat_tftp_hook)(struct sk_buff *skb,
+				       enum ip_conntrack_info ctinfo,
+				       struct nf_conntrack_expect *exp)
+				       __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_tftp_hook);
 
 static int tftp_help(struct sk_buff *skb,
-- 
2.43.0

