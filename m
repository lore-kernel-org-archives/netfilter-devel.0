Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795738611;
	b=uKSmEaYc3Fchw5lCvl5LIA8Gyqv1XUBqthTefbplzv9qwXOZbU0Z9iYJuNdOCo9wolZ5
	 d5tfRr38VkQv5c5aOl2K32edYSkegmP4idZbbAkwMylcmU4CTFHi7Iy1pKNNy2sAAIQaN
	 ESvQ9W/A0cq5nirZb/FAbT8IeLnybcAGM1ldpMXIt59ZFMxHbSW1Nk7YZ4U9CbfanN5yC
	 V7tlg7pTmzBujXPxwa4gYZ7+KXecjDPcDViBPqMlM8TXaR1I0+k0dngkUwqWDEvQ/Ta0I
	 5bgMlRp5YXAaCX1cbgp15EyhQwIFBz1AkdlpoBYjQliLxiOPaSveRC/ZjHIbiQgJ4yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795738611;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FRTP8FO/eHZGhtNodRe4fi46UFA5HdjhjKCVqbUUh2w=;
	b=y1phObQzG9cp25uXGXB51rHUfMLCaazdQCHQ+w/ip9gnSn7Xuc5NkTtkfaQSXMkIU4p+
	 juaJfC0kQe2GZXUbjV7duNJduL4WOiHszO0d1DuI927bbnfsjtc+yVljwLK5k4P0XDB5e
	 54ML1L+b5mjxlE9SpyRce8TNlfpNHVWos93RuOk63aI5ohPBG/wrXTfSK0+ky5yMBB24F
	 X2eEiE+oh9KcSUMzCuYOL92guDgVM+N0pyO3VKnhgh+QMYpAUyvMhW/PIj/C3vzRSDnT0
	 6Lxpntp3MH5SsoYKnRiFnWT/KuvjvXuUVcCcV2DhRGpMlxKiuxQC6CWWND03C3PwQMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T34DF08R;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45571606A338
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2026 00:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45571606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T34DF08R
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48e47347279so4615291f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 16:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795738610; x=1796343410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FRTP8FO/eHZGhtNodRe4fi46UFA5HdjhjKCVqbUUh2w=;
        b=T34DF08RkclBqCp86/pbXD7dB5z9Qafib6EkPNsHvOuXnehvWwaTdcE+BsNxucSDfN
         4XsiBrWPynipFk+C/A2q8pjqaO0JWTyO/4qFJJAfxRecIRgjZE9BV2rW32JTVL3RiJs6
         CX8H0ARMJMDU09Bgr7ecaj4f9gF5bLK14MHa8L/j7a2mta74dKOEGWGJTNr5Z5Rg45jc
         QxtuHA968TZBD/zSTWXWYmeCCxeo9TL9xLdX25vtHMOHZkfSMN/htrrVL/XHzo93Rguw
         RvX3UmmWD8IhqExnbs4ia/wPAQxDcfUQY/UHDbYdYmTaujoz6Ogq5Ui17UB7WdIOWdKb
         k5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795738610; x=1796343410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FRTP8FO/eHZGhtNodRe4fi46UFA5HdjhjKCVqbUUh2w=;
        b=XBZRsCCAgGFw9eBQnEWQ5D/I/GRIX9hHE0iiwl0huj41CK9crtbieaOM+/Mb989LOu
         3Anjpr8ZBf8wljDNgpgck2uY6FnfSHzEltUrQ+xI8ZCyIqHHMAeZwaTmqCVO4L7lyjAW
         bqGjtMnhIAhCRKa+bM4UBuGFKu/7kZBRIUzPuWX7RMiQKLONIBFhs0Y6a8SoaxJtO49g
         cEHDpZxtlDPg3gM7aenXeymhbab3J16+EZ9Pgnx+dmHdiojwyjmy8iLscIQ+3nlnMi2i
         RvO+SHuTTGz+IenO4x7Umni0PAKpVro3uE4fDWirvnCHYldJCGslrbEZ2Q6Aj6Tm/r+Q
         Y1tA==
X-Forwarded-Encrypted: i=1; AL+hErGP8taCwK3qO4Hk1Y2yTN1sXhLfrc1GEk5QcuULSAOLUPdiJjbL/HqkJW3o4gHfqQtPb5MqLzmXjhoAf9XpAPw=@vger.kernel.org
X-Gm-Message-State: APuU4Z8801xgujxRi0FlY6nOS8RB/vHOxusu+2ITL5uCtThpDM94941J
	0MKlZK88TtymTItr/RLBp66PAAlBczWtEha5ik4q2mEeT+zlALQDIDM=
X-Gm-Gg: AZFdTZehbJf6dbXxS3Y/g/0A206RUPKHVLwzOwDujyjjhInPe6FThhRVx3Kg8u5OZKp
	bNAuEWxUuPfjKcwdIDRakgjiWTpZdZylD3eeWi5qDJFtfQPx9PkmntGSRI9By/PwHRpnKw17WxC
	SEE+qm93BFJYlP8Kta6JsrqZx+IAZuZMt4TbR9JzkOOL7fbZhYr9YGipMXSq97plxodezITlab6
	0/Un8gMdO7xE0Wzq+mTlku0zpK9RDhLG7X4/yFmkn5eCVhT5zvS9fIgtNdqHI6j2lN+QjZjw82j
	tnd+VzbuNKppurDaolL6dwVOIt7URkUz7F4qBmNX/Ye2q/PEnMGCcczY+vgAqbF/o3LAFMotCYr
	6jrqBeIw4Jo4apA621b84e/mUx7eapWmlGpkUeqxeWscAOCCSzVOtGhXji8K+vwxa6fSLvestYd
	/g0Orbxwn53fzFbSKwGECUrvKCWHVriIIRhNH4dz7XQdXTeDh4bgp+Ibn70uCNBrUlop/k7or0x
	aqCg5taBd90NBYOWM38MV/aIZzTyb5zlz2fVFjMtbxGyeVsqCntxaCw6NomYatGEo0m3PMjyfU1
	pLqTZSE/2XPTmeU=
X-Received: by 2002:a05:600c:6298:b0:4bb:6375:aa41 with SMTP id 5b1f17b1804b1-4bb88934652mr434988635e9.27.1795738609584;
        Thu, 26 Nov 2026 16:16:49 -0800 (PST)
Received: from localhost.localdomain ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm356650865e9.3.2026.11.26.16.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 16:16:49 -0800 (PST)
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
Subject: [PATCH v2 nf 5/5] netfilter: nf_log_syslog: pin file with get_file_active before reading f_cred
Date: Fri, 27 Nov 2026 00:16:37 +0000
Message-ID: <20261127001637.1026589-6-tristmd@gmail.com>
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

nf_log_dump_sk_uid_gid() reads sk->sk_socket->file->f_cred without
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
 net/netfilter/nf_log_syslog.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index c3fd398ffcd77..dd15409100eba 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -6,6 +6,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
@@ -168,25 +169,24 @@ static struct nf_logger nf_arp_logger __read_mostly = {
 static void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
 				   struct sock *sk)
 {
-	const struct socket *sock;
-	const struct file *file;
+	struct socket *sock;
+	struct file *file;
 
 	if (!sk || !sk_fullsock(sk) || !net_eq(net, sock_net(sk)))
 		return;
 
-	/* The sk pointer remains valid as long as the skb is. The sk_socket and
-	 * file pointer may become NULL if the socket is closed. Both structures
-	 * (including file->cred) are RCU freed which means they can be accessed
-	 * within a RCU read section.
-	 */
 	sock = READ_ONCE(sk->sk_socket);
-	file = sock ? READ_ONCE(sock->file) : NULL;
-	if (file) {
-		const struct cred *cred = file->f_cred;
-
-		nf_log_buf_add(m, "UID=%u GID=%u ",
-			       from_kuid_munged(&init_user_ns, cred->fsuid),
-			       from_kgid_munged(&init_user_ns, cred->fsgid));
+	if (sock) {
+		file = get_file_active(&sock->file);
+		if (file) {
+			uid_t uid = from_kuid_munged(&init_user_ns,
+						    file->f_cred->fsuid);
+			gid_t gid = from_kgid_munged(&init_user_ns,
+						    file->f_cred->fsgid);
+
+			fput(file);
+			nf_log_buf_add(m, "UID=%u GID=%u ", uid, gid);
+		}
 	}
 }
 
-- 
2.47.3

