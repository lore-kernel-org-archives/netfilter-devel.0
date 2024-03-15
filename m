Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E2C14F65
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488088; cv=none; b=cV9gTvDeC1F7263ZZoc1FD6FNI07StI74wZISCMAc24y6bq1hYxesTolhjmKOGyBjpkXKGj+sgVfMwUX5ZhoHnh5NNpZEVavGnTzzcgkNI1sHBRpy2x84G+X3c13hYV7xiEijCunegHK/N7BEQNj+tv3WUpENNJ9NLWqhE1jsGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488088; c=relaxed/simple;
	bh=gni44YU0NuM/C71wumzm0bJHOQ17sj+cYCJ/Bw0iXhE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S37K6DuJVZYt2ypHB6HZNxh/G4oOSNKPaiALcHtDDrd3AZvEeydF9QtAiasd/DG1+BnHfhtHY8ZoEEIRWhGAQhhuWlsVOexrcV0rhyrfOKT6enVlBUidOT4gfES/UbbOuMMRs2ieSnt8SlL7T/NZppk/iM/Jh0d/xIxPJKi584o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RYrRk21O; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RYrRk21O"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dd10a37d68so15423755ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488086; x=1711092886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7vqXQbw0U2WkN67tI+q1ar0RcsrUjw8aAR0qLQGVJ+c=;
        b=RYrRk21OViNs5icBiaLPdtwgSrYke+fFSZ1gnTzED9vTpU1jf6J5Zsbzx8mShgad2W
         IFIz42VXXxxaXu0lhQkdZA7wG5rGJ2rxadTb0MHZ+ZC6d37QFbTTVAoErH3r27KvAOO9
         QgbEBjjv5gHRHm8OOITKdHlh9vuCoJgwHZWeNSLdKfHT/UPnr9O+lotBGn7r8+1d1D3g
         uE+m0IgcJt7oVfO9Ri2lOOe3TF3yzCIf8XFtx+TTsrwA9Kx5qoS2aGGTu+31SghaUmgO
         bMvOXuy5b6iWAzdbKXRx02C09W+thDeRBjPghyWpEb9/mas+JUXdnvQA43/lEDd8E7D2
         c3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488086; x=1711092886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7vqXQbw0U2WkN67tI+q1ar0RcsrUjw8aAR0qLQGVJ+c=;
        b=p7c+fo2iq8mLd+ndhH2II/LiGmi0938/9XOqenLZX26NH/LRA2kgY7Bsvcg8ccr3yL
         wdwieNDZ4WUEUzIGfEeDRfBxnVdBZoEk41UxhVesRm7JAoXWzukt7uC3/VZzHZe30HVk
         1EDNRj4fE6PUNlD8/bX7fYlTfHJntQDFgeSt69fqfZWoOuSQAlCbOVd8KO6FemHGC9h2
         UXF80mhNmMNJzvzxaL5lpyvyMw5pGb6kp+Wq9TrwqURg2oEUze1uKptc5gkH5DwenZno
         u9NH5f4LbR3CAvK81SudDTkWT0i/JCut9PPdam4ysHYQFR6fIU63R0Yd6G2XKA9pN8A+
         P5Rw==
X-Gm-Message-State: AOJu0YxFlvMNOwkKg6y9N3YzGfBljMNYFll8R2O3LmkHwdsacfH43vx5
	a/a1zwOqL/xlcYsPSwTeFT5bzxV08yWUhySq9w2zhLxp8riNjpOOw5VjCwN4
X-Google-Smtp-Source: AGHT+IEp7ropOqCYqSSv0jn3YDqCsaR3HRARfuuWKlxIyPFfSavneGNxjfnYIlVYCwK/BO+oSgUgqA==
X-Received: by 2002:a17:903:2607:b0:1dc:cbaa:f5dd with SMTP id jd7-20020a170903260700b001dccbaaf5ddmr3472297plb.39.1710488086656;
        Fri, 15 Mar 2024 00:34:46 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:46 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 31/32] src: Use a cast in place of convoluted construct
Date: Fri, 15 Mar 2024 18:33:46 +1100
Message-Id: <20240315073347.22628-32-duncan_roe@optusnet.com.au>
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

I.e. when calling list_del() and list_add().
We have a list of struct ifindex_node but the fns want struct list_head
which is at the head of struct ifindex_node.
Also audit counter loops to count downwards (c/w 0 is faster).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/iftable.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/iftable.c b/src/iftable.c
index 1a53893..7eada24 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -192,7 +192,7 @@ struct nlif_handle *nlif_open(void)
 	if (h == NULL)
 		goto err;
 
-	for (i=0; i < NUM_NLIF_ENTRIES; i++)
+	for (i = NUM_NLIF_ENTRIES - 1; i>= 0; i--)
 		INIT_LIST_HEAD(&h->ifindex_hash[i]);
 
 	h->nl = mnl_socket_open(NETLINK_ROUTE);
@@ -226,9 +226,9 @@ void nlif_close(struct nlif_handle *h)
 
 	mnl_socket_close(h->nl);
 
-	for (i=0; i < NUM_NLIF_ENTRIES; i++) {
+	for (i = NUM_NLIF_ENTRIES - 1; i>= 0; i--) {
 		list_for_each_entry_safe(this, tmp, &h->ifindex_hash[i], head) {
-			list_del(&this->head);
+			list_del((struct list_head *)this);
 			free(this);
 		}
 	}
@@ -359,7 +359,7 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 	this->index = ifi_msg->ifi_index;
 	this->type = ifi_msg->ifi_type;
 	this->flags = ifi_msg->ifi_flags;
-	list_add(&this->head, &h->ifindex_hash[hash]);
+	list_add((struct list_head *)this, &h->ifindex_hash[hash]);
 found:
 	mnl_attr_for_each(attr, nlh, sizeof(*ifi_msg)) {
 		/* All we want is the interface name */
-- 
2.35.8

