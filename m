Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CF11E0E08;
	Tue,  8 Apr 2025 14:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122288; cv=none; b=L2goMk9HX8WgKk7PZCQ2aEY7q5FRPqQ1jt5Tv+KQT8IznBjGqIgDuJviIhybZP7iHxiL2PinOWeL82CK7o8JoMdf2t4mtITj+XArKus/uU/c2f1QoPhwL+6lVx/RS1b7bR+VW399XU421IqVzsx5pSqGeLFJfXqEfd9JGI84WvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122288; c=relaxed/simple;
	bh=4chn1/0IJNSwJ1oT95Yplw/ROsSLsSsjiBPzOuAxsgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSRr6t+KV9Cs7EQmAcDv0uooQBF9gbQYqkucih/qEtaNnNPAXmbeWwnN8I1sjQB8mmxAvZrf+LEx0D4x1CamP/Tx1tiGAQe6e8P4gkveuuryMUaAQLDnNzaDiHTZ809VDffLgw4ir1wTETDJADUYJWydWe5qq5u6Foh6eQsSUl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f+gPUbgO; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f+gPUbgO"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e61d91a087so8880704a12.0;
        Tue, 08 Apr 2025 07:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122284; x=1744727084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UWSHNbB5JKEbeWuUj8vjDFfUx12Bd6PhpeoYLsDsQTU=;
        b=f+gPUbgOLu/AjsutgyJ1PyRIwyLyJO3PSngDlYpLqVE3DDBQ0sIS7bXEvkIHI+fBDH
         u4inVUaUQqCXt5XxI3eGMugoPx00T/aFpVbaEnnYBiuKE/PTmtETyn4HBstk6TR9Wz8G
         hMv98l53H8mwTZCzTuzHuttKDwiQvjc688uvpsSheqxk8u2AwHKmHA8QcGIRAm2Sgub3
         362yi73Ui7Ijj9qVT4qEFdLgAEnLtr0MdU8XW178BHzE4iGiugeD4q8ipkZpW/A26lu5
         Ta+FWxkdOMd/6Mah1jcMb8UQaHMG3J7M2q4JkBFVDZU1y1O/M1IfDg6hxf2iARiSlMuW
         XZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122284; x=1744727084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UWSHNbB5JKEbeWuUj8vjDFfUx12Bd6PhpeoYLsDsQTU=;
        b=w66alTZZctLrx3cQOOZpoQf3tm0/z/u0tksKDAiqJ/nRMDNVaiFWvc7Nj0ZHMKFjHx
         dQUnZQ/kMz0SEfdmCHH+qoXAmdGQjqP73uw7sB6X5zshOJlwXfYxTgyBdQzoZdLE33Bp
         TDs3s9c4bWKgA9ZJmBKNtH3GYbSXUtVEiV8jMLfRduTCkDBmo4hQgVLoVSfMbEXnICm6
         P/Ziq9dy6EUfdZvmE6LHm+jXDzCNpNCkv8bFQ0man4T92aRdKyvUaP06fu/2AV/4Ebsz
         RiV+4mz9gMa7fer99URr/xDedX5iJqDIcVRA1k7Zv+9WvOBx10R4uPg25GXUnDFR6NyO
         LCTg==
X-Forwarded-Encrypted: i=1; AJvYcCWM/Q1BA2EPQCj/bpPloyMOQDowYnj1rmRi9NCDlwXn3UZfi+5cqXG5ZI5nCdUo3K9TPJkc5GOCXIh6+8OWqEQ=@vger.kernel.org, AJvYcCX2YNn6T8ntytrfjwMsbbxNusDMokO+DMCt4mbZDZPmNoNNhbNuKZjg4rQfWk30EfLFA2ZjxOCyq3MuLYxpD7l/@vger.kernel.org
X-Gm-Message-State: AOJu0YzkykPDLHh2SZeMFm30X1uOgO1oV+vzhRYiyQlvSHU0KAUWOGA3
	fNsr36LA9eoz3IRFq6rFGXrZA04YhLsznLnig/NHOd2BS39154kd
X-Gm-Gg: ASbGnct8zrZl58ywXIU9WzCBrGo3ZI4SnShXFJkZ77HAteEPPOHZgT8rJRun/lQjEbx
	zo5kea/6cAOBC/hzwfO3CozMS8d/5q9+xDSRekZzMh1t1Q9FFzDoT9fGR+5VuOiVcCvU5UGDzNv
	aTmpItjcLiVHs92so1rqIuBfOdvUQt4D1ICVpUcalJbXMNtYnzq+yK30akoX68HfC1DuNvImS8W
	epxdgPglVvkPnQSbdQ8f8xEoNW34nlp3Z3R6BWItPaZh8chrqaZmWTZkF+tM0oxqleJC9BH1yyn
	T5uUyZo+lHrGBScHQEJnfFem0mGIP3PECJWkZWuCB7n2IkdYH0lABqFx3IAigAurt8n9QEd80ep
	XLUFiL9SkpGFZsec4De2NHPOTY6db0iJocEOuhJKXe64P/CSfnGTYUQKnxOk6z/8=
X-Google-Smtp-Source: AGHT+IFrt4lj1ddzOvJCV2IvTlAskXKWdQiEa5yn6Cmc+uvHs2KRJLuJEULhy2w31ppVoQJn+yMQiA==
X-Received: by 2002:a17:907:7f91:b0:ac7:19c9:bb8e with SMTP id a640c23a62f3a-ac7d16ca982mr1372116966b.9.1744122284287;
        Tue, 08 Apr 2025 07:24:44 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c1db6ea1sm928770066b.143.2025.04.08.07.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:24:42 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 1/2] net: pppoe: avoid zero-length arrays in struct pppoe_hdr
Date: Tue,  8 Apr 2025 16:24:24 +0200
Message-ID: <20250408142425.95437-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142425.95437-1-ericwouds@gmail.com>
References: <20250408142425.95437-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jakub Kicinski suggested following patch:

W=1 C=1 GCC build gives us:

net/bridge/netfilter/nf_conntrack_bridge.c: note: in included file (through
../include/linux/if_pppox.h, ../include/uapi/linux/netfilter_bridge.h,
../include/linux/netfilter_bridge.h): include/uapi/linux/if_pppox.h:
153:29: warning: array of flexible structures

It doesn't like that hdr has a zero-length array which overlaps proto.
The kernel code doesn't currently need those arrays.

PPPoE connection is functional after applying this patch.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 drivers/net/ppp/pppoe.c       | 2 +-
 include/uapi/linux/if_pppox.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 68e631718ab0..17946af6a8cf 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -882,7 +882,7 @@ static int pppoe_sendmsg(struct socket *sock, struct msghdr *m,
 	skb->protocol = cpu_to_be16(ETH_P_PPP_SES);
 
 	ph = skb_put(skb, total_len + sizeof(struct pppoe_hdr));
-	start = (char *)&ph->tag[0];
+	start = (char *)ph + sizeof(*ph);
 
 	error = memcpy_from_msg(start, m, total_len);
 	if (error < 0) {
diff --git a/include/uapi/linux/if_pppox.h b/include/uapi/linux/if_pppox.h
index 9abd80dcc46f..29b804aa7474 100644
--- a/include/uapi/linux/if_pppox.h
+++ b/include/uapi/linux/if_pppox.h
@@ -122,7 +122,9 @@ struct sockaddr_pppol2tpv3in6 {
 struct pppoe_tag {
 	__be16 tag_type;
 	__be16 tag_len;
+#ifndef __KERNEL__
 	char tag_data[];
+#endif
 } __attribute__ ((packed));
 
 /* Tag identifiers */
@@ -150,7 +152,9 @@ struct pppoe_hdr {
 	__u8 code;
 	__be16 sid;
 	__be16 length;
+#ifndef __KERNEL__
 	struct pppoe_tag tag[];
+#endif
 } __packed;
 
 /* Length of entire PPPoE + PPP header */
-- 
2.47.1

