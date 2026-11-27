Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795738611;
	b=bWbIKaHHRZ5c9nIEFZcwT2QRjIebT6xnPFvIzzCqBzNM4qAd4EhA9rr1bd2lOa4udlrq
	 Rwbx4upo7NxK0hrBZpihqVTKFfhTEQvxJmEn/lYt4dOfGaTKu5xWjLgL3/d6qr00tIkNT
	 OlaKMZchzFLo7f2xNsInYJIE2ftHcfRSoOtTtWzgajjv+3xbIa1HaMQUL+XAsRiDnSQmD
	 7P0GdoutlzE7mE48fEdp10UInn9ysNlACwmvOCcxtHts06jttnwZRiFfR3731LnyvQajm
	 6/Bp3+d1jqBDm4mDm/jq96mmDPgeWDzP1JeLlKNgeMalgmYM3xWIi6dwdJWAxoBj4ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795738611;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9nVnoKawCciJJKvofe0ViAurGqoccYhIy4wdIXnHSVE=;
	b=d155cX9gEQiLYg34WueYSVT0qUoAAOoo0eGc5f2t5TAEhbRzesRip06XTWfYwFv3wo2+
	 8j1APauxJ1kZqJ80NSrJNook7fs8NKuJK0kwNENnifviN/KYTH053EU5WK8m+xcJCtzVS
	 gfEEPkN6EWaRHkLBR488ne6f+PqwgxCqANN5v/EypgwPEcryHtF0Vqk8+ZYcSYkYHgCFt
	 fnH4zO8JXrSaX3ubQRlP05xYfmAf8C6boT23ANu7Rh35ULX4Gk+P/LdkWEhgypp0YXOjf
	 edRzLrw0+dfW/nNedkwoVUopdsjYcffk02nWQwDeu4VCShL/jh7SDdIQ9a07olQc0rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gTyRMsh9;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA82606A695
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2026 00:16:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EA82606A695
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gTyRMsh9
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so76173695e9.2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 16:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795738608; x=1796343408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9nVnoKawCciJJKvofe0ViAurGqoccYhIy4wdIXnHSVE=;
        b=gTyRMsh9XGGeLgDZLXjO7XZSKbo+yBjLM9WRsFDN86Q2ovOeLCH4qChPqGozxhmVNS
         C2hqkmY72B9gawQh8BMCZ6/54ms0o4T9rs+rsOh2aIDIXYh6z9F6RyBrum53dxgrvaRw
         W/qFLObMtiCACdySief3G1IBZBuRQKL6je9gxQSBn1ObifSbv66SJclVPcGQPdSzX+Aj
         mc426/+ugAtnGKpvXPrRgCDd3nex+ulW9xLKvRye/jQHADqFebQQcpbRhgwiPPAddgDm
         NjIPr5CmPEsadmfz2cNBp3zC+g/dTY558D23aERp/PjEyOI5dvFcP3ytmzMbGoLxjM4a
         9H9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795738608; x=1796343408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9nVnoKawCciJJKvofe0ViAurGqoccYhIy4wdIXnHSVE=;
        b=JprjFLCjSDUAkHmX93NQqWuWt7SWH/BrTOliu2GHpfUcJRTjaP5IfP0dPeW0bk69Wf
         xx8ijtMbzQErUukStFh6QkSJpD1/d9rqdAMB1xvj75/ZauI1mgArd23Ocs9ViFa6W2ne
         CKGt2X4FSWGglOkCoh8hsMGDDsR4BydcYEWBYZgkQuufqkidPHgUrl2plUmLMMFvd1XO
         0A7gecurHm6sD7Vvn8BEZH5W1irmArjzn2efaSZgTpsrjh/16/5wDCg2DcFlPYURqBQZ
         YXaZYvZYTPkMTBbit2xYOybdYmHXkiyKdoW4wGtZhBe83pzAy8PEQ925MWEaMFNmrrjy
         PiUw==
X-Forwarded-Encrypted: i=1; AL+hErH6Lh/Aum31N04Pppn02SRwid7/hqYsyZ9jsNpDgDF4wa1h3/UsdzUCima0k0YQQ+CIm0mXScYMEeoe/ISishs=@vger.kernel.org
X-Gm-Message-State: APuU4Z9vflezxdwlhKCxvRioEiDXDJIxpC+ES+dkqdQjdWS7RG5qq+fK
	MlCz3jHd1yHLIvXn+Spi28Vtza4dcCkJS/825nG0ovPRtTSj7An5kw4=
X-Gm-Gg: AZFdTZe0Ccv7cFKMCYcvo/oTFKMRpiLwmEl+KNXtd3Qcxswl5vxNWuyoj16w9XHpDwC
	J99JXOnrA0PxtP4sz60Z69o7KYRvJrXIaPFDxFJ67rBkZ9+kcwmgT5M7y0LF+GQoxsZdpZxH0V6
	uObLZIxEYFsbXFRApAJOaGcp3ueWtN23M43aTrFGu1FhTyqTQYrqgvKIzRLotTMwypeOWmqoOMo
	FKiPLlcbKvRm5UORnhY1it3VFX3XTwjxeJAV1J+fCrZ9SrTb+UCZrNx76as6teyE0JUyNeaSnAm
	qkhx1/6oKJsCrUzmUCMXOv2IdBIQor/SpDaxTtUqeqIaw+R8iXRVBwQWNjeOFHsFqJZNk1L/c4c
	uBS0Tuigxg4uUaE43qO6uXCORiOJxeeQ+GV3vXtXLvr5VofznXhG9XoLFqSf/f4HTVhP5IEGrWj
	hsC9Z9/fRpUgi37w/GQzMVc+64M9U31/zlUGIGuhy1SYdU+OTFU5JUNzeH/CjmkeQGw5cCesSDr
	LIFg9jJuXGGKEMYtD66EB/y0ziSCY4ljZQUyUMFGkZZcVIZ705D+xCyb0y6hforjLg/YKNgUBPv
	78lNUgd4kKVW49o=
X-Received: by 2002:a05:600c:83ca:b0:4a1:9661:14b5 with SMTP id 5b1f17b1804b1-4bb888176eamr461715755e9.29.1795738608524;
        Thu, 26 Nov 2026 16:16:48 -0800 (PST)
Received: from localhost.localdomain ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm356650865e9.3.2026.11.26.16.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 16:16:48 -0800 (PST)
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
Subject: [PATCH v2 nf 3/5] netfilter: nfnetlink_log: pin file with get_file_active before reading f_cred
Date: Fri, 27 Nov 2026 00:16:35 +0000
Message-ID: <20261127001637.1026589-4-tristmd@gmail.com>
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

__build_packet_message() reads sk->sk_socket->file->f_cred without
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
 net/netfilter/nfnetlink_log.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d923f2cb13980..d4fe9a12088f4 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -28,6 +28,7 @@
 #include <linux/spinlock.h>
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
+#include <linux/fs.h>
 #include <linux/security.h>
 #include <linux/list.h>
 #include <linux/slab.h>
@@ -632,25 +633,23 @@ __build_packet_message(struct nfnl_log_net *log,
 	/* UID */
 	sk = skb->sk;
 	if (sk && sk_fullsock(sk)) {
-		const struct socket *sock;
-		const struct file *file;
-
-		/* The sk pointer remains valid as long as the skb is.
-		 * The sk_socket and file pointer may become NULL
-		 * if the socket is closed.
-		 * Both structures (including file->cred) are RCU freed
-		 * which means they can be accessed within a RCU read section.
-		 */
+		struct socket *sock;
+		struct file *file;
+
 		sock = READ_ONCE(sk->sk_socket);
-		file = sock ? READ_ONCE(sock->file) : NULL;
-		if (file) {
-			const struct cred *cred = file->f_cred;
-			struct user_namespace *user_ns = inst->peer_user_ns;
-			__be32 uid = htonl(from_kuid_munged(user_ns, cred->fsuid));
-			__be32 gid = htonl(from_kgid_munged(user_ns, cred->fsgid));
-			if (nla_put_be32(inst->skb, NFULA_UID, uid) ||
-			    nla_put_be32(inst->skb, NFULA_GID, gid))
-				goto nla_put_failure;
+		if (sock) {
+			file = get_file_active(&sock->file);
+			if (file) {
+				const struct cred *cred = file->f_cred;
+				struct user_namespace *user_ns = inst->peer_user_ns;
+				__be32 uid = htonl(from_kuid_munged(user_ns, cred->fsuid));
+				__be32 gid = htonl(from_kgid_munged(user_ns, cred->fsgid));
+
+				fput(file);
+				if (nla_put_be32(inst->skb, NFULA_UID, uid) ||
+				    nla_put_be32(inst->skb, NFULA_GID, gid))
+					goto nla_put_failure;
+			}
 		}
 	}
 
-- 
2.47.3

