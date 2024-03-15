Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAF21426E
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488064; cv=none; b=Ar9VEdP/FKZ59anSksl9cWXnom9hkyskg6zaY99Cv7jxJVob0GWeMFVPVC4glanQHcecXlYu9R+/dRbin5/h5FaKNs2UuFv0f27tt/Ye30t4K748S/opKqYyYtcS9YBujY4WY5J+ihdjYcV10a+KElLqYdavAFO1BYqUijrgyrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488064; c=relaxed/simple;
	bh=JqChCZiCtUeqEo1AxzifDFL1Y+y5eP7dJbVlfLAt6Ls=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PAIzEeYiM/6KMM80YrmEX1RAmB/hUwempHgtEeUqQJcHyBLqV+FEiiahJhq37DeUoEos4QjGO2xSuEhggx+tCxponQtSw97jmk8FoWxz6ONL63ZPd22MYK8gQ2yM6oFi43r6Oq4xRO7D6nUBKXKsa981rnrtWKg9iL2QjyvpnqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MmxDC38v; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MmxDC38v"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dc5d0162bcso13270935ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488062; x=1711092862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6qBiaL+Gh/Clq1wyRddmyy60C5FgymPxLdkAL/2Abc8=;
        b=MmxDC38vywvZ5EvfrtGCpMO++x6sVcL/hCffD4HDvbnqQsuEFMv/0L6drHZnYwaZoh
         qokjp/qT87ZOyTUztx1IlRMEdBCReN8rB8nv27ovSYNkrg0rDfAe7bOSgo0BrviAKkMR
         34tJ9JeL8HmG90Hli0CFnm883DEk4+7z3otA0BVP1Hx8ByHNT7qHt6A3bVfRTUn36ehZ
         P19lt/gl9FF0kzhc6JNzc8YY0fJnZtMIrS/fzXdZ2GWyKoyYb01ZthM8ELNpB7aHqK7V
         3mCPmTXuymqUuVPYjDWFDwahqRxKIjSiQ3/I1Nd+PgaSwCa/BpmrKYCYYwwjjuZibdP9
         LZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488062; x=1711092862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6qBiaL+Gh/Clq1wyRddmyy60C5FgymPxLdkAL/2Abc8=;
        b=AMYm9p9vfRlcAH7k61l8LymssLK7fn8kcAU4J/RoB9zfDU1tGeXSZuqJcRJPXDN+DX
         WyG1RfKe2oxX5Sq6LPD9HiXgdlo+4SE/e3Y03SoMgRmj2xEyZrF6BN+yNSE+FWDHHvyi
         Zt4z/FOehvbu3n7j3top4N1CzrEXTxtvX43MOUPM4mYq4wbOPJWectcAaIbXFU8h+8mp
         3f+aWPMwixH8gJ1aFH7cruC7P2dN5TFUhLZ4HSPcpVSqulbCBru3hD0osjyPvPeaZzjY
         RSqfzPtdHFZb+4XYJ+0TH6l8zQnuwcsWhKu3L8PpcpiFlZcKlBjSAePl2ulREvie0bcU
         Fl3w==
X-Gm-Message-State: AOJu0YwATqSu/EHK0TGTjSV8X/Qfpy+CBikeFqdx6Cx9u+IHB/5uM3Rd
	KDunh1xNh9KdMbjMLwRb5QmUVJiDEIbspe+xm6dkhQ9Qjo0jgkIvwejuhbKT
X-Google-Smtp-Source: AGHT+IH4LxgvgWYp/y7JqfLPkj9ynWe71wpy2IfWZCqgcDawc7kyjdeZySePXRt9aOemzNDUDgiCSA==
X-Received: by 2002:a17:902:fe01:b0:1db:de79:8664 with SMTP id g1-20020a170902fe0100b001dbde798664mr2005920plj.60.1710488062571;
        Fri, 15 Mar 2024 00:34:22 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:22 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 17/32] whitespace: remove trailing spaces from iftable.c
Date: Fri, 15 Mar 2024 18:33:32 +1100
Message-Id: <20240315073347.22628-18-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZcyaQvJ1SvnYgakf@calendula>
References: <ZcyaQvJ1SvnYgakf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Done in a separate commit to ease review of real changes.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/iftable.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/iftable.c b/src/iftable.c
index 22c3952..307acc1 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -121,7 +121,7 @@ static int iftable_add(struct nlmsghdr *n, void *arg)
  * \param n:	netlink message header of a RTM_DELLINK nlmsg
  * \param arg:	not used
  *
- * Delete an entry from the interface table.  
+ * Delete an entry from the interface table.
  * Returns -1 on error, 0 if no matching entry was found or 1 on success.
  */
 static int iftable_del(struct nlmsghdr *n, void *arg)
@@ -158,9 +158,9 @@ static int iftable_del(struct nlmsghdr *n, void *arg)
  * \param h pointer to nlif_handle created by nlif_open()
  * \param index ifindex to be resolved
  * \param name interface name, pass a buffer of IFNAMSIZ size
- * \return -1 on error, 1 on success 
+ * \return -1 on error, 1 on success
  */
-int nlif_index2name(struct nlif_handle *h, 
+int nlif_index2name(struct nlif_handle *h,
 		    unsigned int index,
 		    char *name)
 {
@@ -193,7 +193,7 @@ int nlif_index2name(struct nlif_handle *h,
  * \param h pointer to nlif_handle created by nlif_open()
  * \param index ifindex to be resolved
  * \param flags pointer to variable used to store the interface flags
- * \return -1 on error, 1 on success 
+ * \return -1 on error, 1 on success
  */
 int nlif_get_ifflags(const struct nlif_handle *h,
 		     unsigned int index,
@@ -324,7 +324,7 @@ static int nlif_catch_multi(struct nlif_handle *h)
 	return -1;
 }
 
-/** 
+/**
  * nlif_query - request a dump of interfaces available in the system
  * \param h: pointer to a valid nlif_handler
  */
-- 
2.35.8

