Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795738610;
	b=iGpnB/2mrm6pNruB3QZc7lask1BehUU0W5+i8p84xV6CYy0YWKWpxvqZ1mkSw+XHle3U
	 WvzXwC95pteo8PgpqqIXKaQ74mX1BPMAT/25MxMBlGVP7Asf6566ALZMAoOMK40lODAFs
	 n/C7ry3x0hZJdn7SV/KexuSmm8pDtKm9yXKlVdm1HirXl3qlrROwM1S1gI4+r/kw8LHrB
	 8NzwqsRuRQUKMCJnnhLGBc4t7q1Rc6+T/mbkEZCYQ7x2OZrno8KMLxTKYmpNTyd3FYzwr
	 dX1uyFBIWSoNWOW9ib1RmUgMIcsflF3TITSZkOhQEMpg8gzB6NddABJIZPwz98HL9Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795738610;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gye4YsbUN5yG8oY4A5kAtzWYZXrQDCSgln8D0vjm4yk=;
	b=j6h4qKE9JGeYhDLV5aJ5obxKPzW+9CMm34wwUn8rfOYVvcg8Ukzp8/s5lTrmlq4RofBG
	 Rh/tFcU3Qbvnzu+4PMhRm0aUO6poeS31NtqZKg4XIsn/HysZxs98KHWdxT6alrlddKT3R
	 7tvT1H3RCqxy9BAdRMr4B9c0I6IhwUfGXM2zoCgBE4IhKKyoYsfD+3XyqDS0SyRNz77KP
	 qv9yUrC/nX698beGNTny24h+dULh/f2LrOycVR5YFX6jq8WmvWnlWFkNGJA1qRnDMPZP/
	 obv2URlSZ1u95RODpRywBd3wpBNXC2G2IrkPru+fW1bV17QeQKS3nWDq+15Vv0FaE3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sBThwLrg;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91DD606A33C
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2026 00:16:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A91DD606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sBThwLrg
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb702a7548so68512575e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 16:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795738608; x=1796343408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gye4YsbUN5yG8oY4A5kAtzWYZXrQDCSgln8D0vjm4yk=;
        b=sBThwLrgwtNi/8V+i5S1cCVxWVRMg+L2Y0aTjHRPpx8c8uWlF6atBR2a4U/9ViPF/N
         JPpZAwHvyB4+9tipx396YodjkCn+rOfe2lENaGPMNlBJ0GNCCehx/uyfqHfzRqdpFTgM
         cZRd1rPnlDFW3Hh1yCBYH1LINsqHDqMpBSNBvgHSHPFWMxvWohlyTz2QSXhZyL2b6z26
         M2sUHErEMu0C/DuQPOLPmluzICGiH2bVMJZs6cHx5AEdjCLX0As+kKmm+2oxoShPI3M1
         /R0I9yWT3Kl9v7nzj7MHwDKFIt7EoczG0wYfYnpGHyXXopj9zSMIhm9uBegyCilBOmxf
         GWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795738608; x=1796343408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gye4YsbUN5yG8oY4A5kAtzWYZXrQDCSgln8D0vjm4yk=;
        b=IP2EYfKQSUhtVmhO4QT01G8NHWd12ALzG3IlCDirUyX+dE7BSoyewPWtR640eowBgn
         Tb8hDf/66RDBoU10+QGtgifMefafTVEUbeuulXHXpNIG2yR5GgcDfpyhxLmNepwz6sh9
         YTCVfCYzjjHSK+hN97NOyc5kr4XmXeZz3aX6lOaP8UuBVtYU7z/BTEr3lDMggo3OhMCW
         pdAbnDejH/OLdQzl4fwI2KnS/YxblJ1MhczMcM4N+ietqdWBBzPNyF2dI28JuUuwGDeK
         WGAXSUDTv7mC3iYKF2Gv1jxKdHmxRt08aNwCCOzzQ29CERlQY02toEQC0lCq1xbYtIed
         XpZQ==
X-Forwarded-Encrypted: i=1; AL+hErEWxihiQgPZ4ml2RkRW/RiXKeqcnG9xhXqShIf1dDzCKJ7wdMiBxTSUL8kTMEZ4ziT5IPe2m6vhLOYyigljGLg=@vger.kernel.org
X-Gm-Message-State: APuU4Z/M7Iqs1pWOTY4Xuow4AZov8C3RJ+SHZZcSt+3Uo/Oel7eqLKVM
	J8UcwomdER8Lz7JmXXqajn/7/eQE/+XOtq8qnRcU3J5WEBn8w7HogYY=
X-Gm-Gg: AZFdTZeSuSJa7p1+I168TsMC/u96pKo0wx1lZYune8+Vin1OTC9XO/auJOFZtPvmjn7
	3oUyQAWItN0YLGs77O7l4DWrHzrh6vs+YbFDt3zgFuMqE4jwr2mGJNXAhKAeF+N/WwYrLoMU3Pi
	7ZNnodtSsRspODXRx1X+peJhGv1jTw9YWehmSNZR8/RAWyHe573UU5Nt53z912hmqN3HuFA4t9d
	IPI5RKV3oS9Fw/2UjnINKFiVbJTpe2kUXqkBdYIm/ZwYZyFr935V+YHlp9Be9BBcnJm3cHWVsp+
	JVB7PupfSLgJ8WAYM8QvgYzxh/R/FFJyFaFoB089N7Ph0B7qvlihnNdkV63uZbdRnO5+lEPnqhJ
	1QTHDn1KVbIdeVDxA1aUNnMXWNWMRgxo+XijM7UzV+6bV6lo8JNpJVJyQEE7bJLNEdw7g2pvNfT
	iqXTIi92f5hcNmOGmECns2kKWmfngPQdpV4imiIEv7/90yfgbUIW887SOaqaskY73IrsxsqaVkj
	bQcVynrRlVvLwtoC9d74CG0B5uNslFJjuoileuhR8J3dPq/7AbwdiYUqEed5mvAqmmnjISqe/Xi
	HU0aI2igwRhagQuA
X-Received: by 2002:a05:600c:800e:b0:4bb:7757:fe58 with SMTP id 5b1f17b1804b1-4bb8881b9d7mr470420415e9.19.1795738607998;
        Thu, 26 Nov 2026 16:16:47 -0800 (PST)
Received: from localhost.localdomain ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm356650865e9.3.2026.11.26.16.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 16:16:47 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	Christian Brauner <brauner@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v2 nf 2/5] netfilter: nft_meta: pin file with get_file_active before reading f_cred
Date: Fri, 27 Nov 2026 00:16:34 +0000
Message-ID: <20261127001637.1026589-3-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127001637.1026589-1-tristmd@gmail.com>
References: <20261127001637.1026589-1-tristmd@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

nft_meta_get_eval_skugid() reads sk->sk_socket->file->f_cred without
holding a reference to the file. Since the file slab uses
SLAB_TYPESAFE_BY_RCU, a concurrent close() may free and recycle the
file object, causing stale credential data to be read through f_cred.

Pin the file with get_file_active() before accessing its credentials
and release with fput() afterwards.

Found by manual code inspection; not triggered at runtime.

Fixes: 0ede61d8589c ("file: convert to SLAB_TYPESAFE_BY_RCU")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 net/netfilter/nft_meta.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 01cfbaa365250..abf0bbce9bfda 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -17,6 +17,7 @@
 #include <linux/random.h>
 #include <linux/smp.h>
 #include <linux/static_key.h>
+#include <linux/fs.h>
 #include <net/dst.h>
 #include <net/ip.h>
 #include <net/sock.h>
@@ -135,19 +136,17 @@ nft_meta_get_eval_skugid(enum nft_meta_keys key,
 			 const struct nft_pktinfo *pkt)
 {
 	const struct sock *sk = skb_to_full_sk(pkt->skb);
-	const struct socket *sock;
-	const struct file *file;
+	struct socket *sock;
+	struct file *file;
 
 	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
 		return false;
 
-	/* The sk pointer remains valid as long as the skb is. The sk_socket and
-	 * file pointer may become NULL if the socket is closed. Both structures
-	 * (including file->cred) are RCU freed which means they can be accessed
-	 * within a RCU read section.
-	 */
 	sock = READ_ONCE(sk->sk_socket);
-	file = sock ? READ_ONCE(sock->file) : NULL;
+	if (!sock)
+		return false;
+
+	file = get_file_active(&sock->file);
 	if (!file)
 		return false;
 
@@ -164,6 +163,7 @@ nft_meta_get_eval_skugid(enum nft_meta_keys key,
 		break;
 	}
 
+	fput(file);
 	return true;
 }
 
-- 
2.47.3

