Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913BF13D8B4;
	Thu, 28 Nov 2024 12:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732798339; cv=none; b=pKCaV70NK5op2rHP+P/2i5wLhdEBv81b0bw9OJQI4jGuUyhwHf013fIJHgxfoBaaqk7Q8TftuGCsZ70fqq1zBb2PYuI4gxpiOuRfOnCw115L3pef10Ext1mbJRR+U1oGHoHyTIPJSKxG3XhnUI6KSCq2pe+FHLiOmFrYsG+bCGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732798339; c=relaxed/simple;
	bh=c0I1ebBoE0U20YC9Avj0dh3hMwsDJv34edqCQOxBSg8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TypnIBLgI4znCiIeOM3qEazGlsPiQeHwoMcjWovumQnr5vWizw2RVmRJBrt9aT+lbooKUiTf7La3kTjie1U+3Oilu8Y6b0qaXiMlnk4sZ9ZraBsJIiX6D/stqTl7LYq6luHMKHsCq4ZFYxIljB0VFW+tMv1QvmQWRgJGoX8lpJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XOH6DmSI; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XOH6DmSI"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7fb9b79ec6aso58618a12.3;
        Thu, 28 Nov 2024 04:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732798338; x=1733403138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qiFR6Ea/6okMG4DqQkGwh+G4hHAubOlQ92CrJDjCFBo=;
        b=XOH6DmSIDJWsxahOg9LP+PLTh7LZ36PvLYyMXJZ3JQGg9SMf+cJfSOax/6/UjqeGs8
         mxmQirDQscDI3K9aSAFE6nLcvk1kiLxjOaDO4GGYQ5w5+XBDBzjr//umAoQgW+7TwxEj
         1nWCYr5gS4NWLMLRH6ZFJhINWcGcVBNAWCEj9aFUwTRcDQV7FziCT1xpkMuaLBiTD5Ih
         tfOGH+jnNEf9tfP5W54y+k1w3x9AAbuWnA8Lh3JZfwXY5NJxu886GWIgEO+ss98zV9h4
         tgPcBzxdLBegrfCIzLATiEHluF0zTYo8H5okq3ScZIod4r2UneAh9ffyRNj/NQZcgLJX
         vLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732798338; x=1733403138;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qiFR6Ea/6okMG4DqQkGwh+G4hHAubOlQ92CrJDjCFBo=;
        b=DN7nscOIflzDThlZ/7Dri5uz4LFenVgM+SHDzOH9JBJowPw3EOEZJ3cDV1HH94eK0S
         dZuvjwIUvqUEGdjE7/gw6BmN9X6OWS4FE2ir//Z7HMWZlK39G27w1SSFMVSN+JiH33k9
         E9vOURlmFy8EYR373xULQmipYy4VimAFY+fvvhU+fGaTJ+Z0N8c5VRfhvsDqGxH07clQ
         qAYyp3SN2AWNF0sRQNi8wVIKWIVs1UjyPcMIxmtmdoaHuQ86HpyDzd5fpr0Lo1HiNjIY
         fXkHG6uAsvlnjYMQmLO8pT+1DJPUAUGgwF/puOE1qmOz1bRJXazD4v4bvBgNkZeKYKuK
         YlYg==
X-Forwarded-Encrypted: i=1; AJvYcCUt2tRSAzMzso0uDwb124TP9YaWO+m+ZMKLpE6I+voEixFraqdAA5s/fwiSYc215jNVFTvfuHYAWVzU9u4U4qAb@vger.kernel.org, AJvYcCVEVKRivWCjPtaIJ8rKxgtqLf57iFBztXrjbERmdPQZsW3OpIXLF8XeTNj1blH670ah1RRFcXarmzI5RGc=@vger.kernel.org, AJvYcCX6//InpzCYS81jFivkbcI7Xqivu4G1Zf78o9nzomVO5KI4HDNc7n/hHhx6YM/mlRScLijLwYAZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwrVhvzhOJheosuFDQCJmNsorEjVlPlXHpdWupw3og+l8V8Gazs
	Cnep69/nVF0n9kp7IXrChOgw3BijeqUH2iLSiKcvYz6xzFNwp6af
X-Gm-Gg: ASbGncvLl+QKMmeF+872ZeEgGPze45ZN5rQUT2f7m0Ur6nZHcGytvy8uaXUCOm9T4qr
	mnSRH536DCtjXWeTapUk2AYbmUvLu4w4anar0Mk3tvAv65z8W7rPuTQFyiexU3emcwcr9+b/sM6
	0MSNyW7qqj/1vWkwRxt82PCeIAXGFloNVOS+IXLywYTdNtxveatk/+dfI1BWqjTYR5N3+howFnQ
	lPU47kajeTzzj0ES4OoEhB2kmQ07ivOTXdfWiDDU5+97ghxp8fk9Ihw/9c211cuP6Nz9Kgc
X-Google-Smtp-Source: AGHT+IED2AaMgfEZlqIfP/s69awQSqsvaDuPzDwYjk0OI8Nkd9zv7CnIn9fcoZ9J++uE5eVxfP4qCw==
X-Received: by 2002:a05:6a20:3947:b0:1dc:77fc:1cd1 with SMTP id adf61e73a8af0-1e0e0ab441emr4995192637.3.1732798337804;
        Thu, 28 Nov 2024 04:52:17 -0800 (PST)
Received: from cavivies-mini.dev.lan ([103.127.243.132])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fc9c39f4b6sm1242793a12.70.2024.11.28.04.52.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 28 Nov 2024 04:52:17 -0800 (PST)
From: "caivive (Weibiao Tu)" <cavivie@gmail.com>
To: pablo@netfilter.org
Cc: kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"caivive (Weibiao Tu)" <cavivie@gmail.com>
Subject: [PATCH] NETFILTER: Fix typo in nf_conntrack_l4proto.h comment
Date: Thu, 28 Nov 2024 20:52:04 +0800
Message-Id: <20241128125204.73121-1-cavivie@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the comment for nf_conntrack_l4proto.h, the word "nfnetink" was
incorrectly spelled. It has been corrected to "nfnetlink".

Fixes a typo to enhance readability and ensure consistency.

Signed-off-by: caivive (Weibiao Tu) <cavivie@gmail.com>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 1f47bef51..c49e02377 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -30,7 +30,7 @@ struct nf_conntrack_l4proto {
 	/* called by gc worker if table is full */
 	bool (*can_early_drop)(const struct nf_conn *ct);
 
-	/* convert protoinfo to nfnetink attributes */
+	/* convert protoinfo to nfnetlink attributes */
 	int (*to_nlattr)(struct sk_buff *skb, struct nlattr *nla,
 			 struct nf_conn *ct, bool destroy);
 
-- 
2.39.5 (Apple Git-154)

