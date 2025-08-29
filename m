Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB47EEDE;
	Fri, 29 Aug 2025 12:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756471901; cv=none; b=WGX5uOhv4QBxNTUqe1wEoH3A/kjHXAhr/kHjLX1zCjsGfiYVCSc0y5I1VRIwQ09/rQswvCOxLUnMQ5+UE4bgCilkozosHorH6PrG3PagRuCyIy+4OlimyQyJLhH1CWsasbtoM3MtutB6oOjnTa6YH1RAl6gyj8flLmd/PzDyWm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756471901; c=relaxed/simple;
	bh=7YQ+rmjHHaUQ1WEr5F07yUBM2mHD2CfG1mIXVQLf6KY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ouv1aAEHhWuesz4Zz6Ckcilhay2ixjS5MLgP/krdfOiuCqU7JkjFVVZ27JH5xdt2VSRuzxhC8hNAFGtZRO884PIsWEFWqmsXpMVN9VG6K4MZ8tpiINzCsZXUZLlyFIIBmSJYpRQKMUb2lIKVO9Af1F7++hJxbvBjmwD4J/eCSnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lbsp20pT; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lbsp20pT"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-248cb0b37dfso19437485ad.3;
        Fri, 29 Aug 2025 05:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756471900; x=1757076700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FbQ22ZHQLEXAa96ebGqBpErqKS8rumDHkwl0bRYbI5s=;
        b=lbsp20pT1RrBIrsmeq67xorqDhmJPvW7x6+HVvfOhVSycXxvzoEPin4JREbyCosJnV
         QCLul4Od0W+iquYElRX/ReDlIho+IiCzzA+mrFvoG7WBqv/AHcmucp18FQ+ZKxFOWFE4
         0VIjIIdThFrI5f38TuFVBajwB1xbOvBS5FvVH+6qL8kXOk6oaeh2yu2XPz/5yL+EmLmh
         VDrUeVzQgfW9BpEszgCIcu0rmRhVV0gykG9z1M4V5I/Ib/4riUzVZVfbGHcpkEhZpTdn
         ogLGxt2rYoBQ3bxFr/zOLxqvnGEoiuAbrb2O4G9KC+ZwoYBetH7LND/nWQtOqB9Ic9/M
         uSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756471900; x=1757076700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FbQ22ZHQLEXAa96ebGqBpErqKS8rumDHkwl0bRYbI5s=;
        b=T4ZJt4qdq5ufdyHeTlLAeBIbr/5+b7a3yjLDbNW+18PYKq1aSc81MGOIiS+NPo82tq
         shQk9gmJksvruqeKPNq/qHrC1vo63ZI+OJPTpUTjhez+/YcLEufok7rtZOm65tOlteFh
         7kCBZx0QCyZ83HO04TEYCGfy3TInGhVuuWAtNcFG/zjTXmZiI6FBjsmd5w+ISRysyJDS
         k9ds7fhqKIz5y31b/fsoFk5xajChmEk1JKeiL6sQeVImfyphcaAa08iD2/AHl0VhgLdx
         kOTKzkqr7HgK/5UQ3JTRgziaaHKUaB7kTNaB7MOHcbEKy9BPXFvvZyRcCjo4tvP1ZIu/
         jPzw==
X-Forwarded-Encrypted: i=1; AJvYcCU0Qke+f+Q5/xTual7Al6BdsT3fvdq7i9DMJob+32d4iiwFffifXetpOoMoZ0jTNQJpAuJICuQY@vger.kernel.org, AJvYcCVTE5XwdCxlFXJJ9J7F9Yl3LtpXWVQ+c8eWxvTAyW/MgUohnzMKQUtDPT5xvONCIU0cnOmzVJ7dch9PZDk=@vger.kernel.org, AJvYcCXIg3fUfBbwEBSe2JkiUuxzm33hQSJMgl474txJOEbIlojhkXRvqYDigpzsRee7MFKX7hWEkgh8LdON1heaqs3/@vger.kernel.org
X-Gm-Message-State: AOJu0YyXLZO5cdzrPpRvLKUXXCDn5HGB2VpowyINI0BvKqkhNPNTRqBl
	kHLDkitjphArQHv1NrYU5eV21SQyQuQFvfFGGc+TS6iZL/hJe4EptqyJ
X-Gm-Gg: ASbGncvKe/pN5kShoicLk9HFo+AvC7xuDfZhOnu6p0gdsgOeTD9bAMLYqyLb2thUTFx
	Nr8vSOZPCXsJ0K+JynbHq92oaHFytOdgSvA36wT3A9TZRK2mBK1NnqpGKXctTr++BjdTGcbxoID
	01RB+NF/ih596FbeaqdQoqBsbZE3kyzhkD/BYLJ6u/j/uOe4PR199L5JW/SLz6DgMBZiYLRX1eM
	Dc6FbUjYwOCAvuBcOsWUPrnp5LUd8KxaUgSNpxALBDH53ZWOlvMyZYL00QMTkYGHmPl7pc7I2Jx
	+20fctzexHlPeDBu34JRRpsFmTKAEAl67xmCyHgNm57X3KkHHtMiQpyZFOzBM1GOGoQSa8ecTS3
	st+eo5XuguZ/DRq6Nsb3n6mmk89nwI41RMOwthOr0e6xfCr639NQlgaNQh7zHVRiSPw/0HtUQ1D
	JWjoKMGL84SmEqJdNMkWXCAXHHo0RiZSWrvivcRjpE9F6c3wRaIC9FQCMd
X-Google-Smtp-Source: AGHT+IHfhaG7IoT+/pr6EbBa+C/IEVSHjsZayXVRU718QR9w71CLLwYP2PXOpS9Xww8NN75Tt+RmAg==
X-Received: by 2002:a17:903:246:b0:234:9656:7db9 with SMTP id d9443c01a7336-2462ef1f38emr310278445ad.32.1756471899595;
        Fri, 29 Aug 2025 05:51:39 -0700 (PDT)
Received: from vickymqlin-1vvu545oca.codev-2.svc.cluster.local ([14.116.239.33])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2490372ddb6sm25144835ad.48.2025.08.29.05.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 05:51:39 -0700 (PDT)
From: Miaoqian Lin <linmq006@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Joshua Hunt <johunt@akamai.com>,
	Vishwanath Pai <vpai@akamai.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linmq006@gmail.com
Subject: [PATCH] netfilter: xt_hashlimit: fix inconsistent return type in hashlimit_mt_*
Date: Fri, 29 Aug 2025 20:51:31 +0800
Message-Id: <20250829125132.2026448-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hashlimit_mt_v1() and hashlimit_mt_v2() functions return the
cfg_copy() error code (-EINVAL) instead of false when configuration
copying fails. Since these functions are declared to return bool,
-EINVAL is interpreted as true, which is misleading.

Fixes: 11d5f15723c9 ("netfilter: xt_hashlimit: Create revision 2 to support higher pps rates")
Fixes: bea74641e378 ("netfilter: xt_hashlimit: add rate match mode")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 net/netfilter/xt_hashlimit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 3b507694e81e..de54d8f37852 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -806,7 +806,7 @@ hashlimit_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
 
 	ret = cfg_copy(&cfg, (void *)&info->cfg, 1);
 	if (ret)
-		return ret;
+		return false;
 
 	return hashlimit_mt_common(skb, par, hinfo, &cfg, 1);
 }
@@ -821,7 +821,7 @@ hashlimit_mt_v2(const struct sk_buff *skb, struct xt_action_param *par)
 
 	ret = cfg_copy(&cfg, (void *)&info->cfg, 2);
 	if (ret)
-		return ret;
+		return false;
 
 	return hashlimit_mt_common(skb, par, hinfo, &cfg, 2);
 }
-- 
2.35.1

