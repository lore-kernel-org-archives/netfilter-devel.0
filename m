Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795738609;
	b=ZtXwjUuUN/E1BTQmuWJ3Ff/HVvalRDgC4kJDerVB/JBFlATBzqmhUXDv0GBOySqBUl3Y
	 OahJ7tFwZgu6jVv/zCihWS+9tOOZy5GcZnHXoJsWSij4tOBHNk/SmiSDyxjNQ+0plz/h+
	 0xv9VjZ+8b99HnUqMhhwYf7u8ML03uUalBJ6QZs5jJSw7GOeND2ITVIoOkM2Chew+vFJm
	 GRmLooybE3VVAIVtrl6phOJ+HlB0kmn8bzKjz+uX3mh5XJrFZlHxmS5uLPvr6eT9wwdno
	 Q8IKbGZy/HS1DAT7A8s+jbdSwTKr9C8I0VxYxsRBmP+fpzT34g0KBhZIWSBsR1Fk6kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795738609;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=npRlcaBUGO4zBESfN/npXWj8+rVH/w1YcWRi93JmvYY=;
	b=NPaVVUarFoD+EQ9XGm9tcjeBG7pBBZHaJ3geQKfmM1kLfXuNcKi8Q9TgXggZASKFR+EQ
	 G7PjyoAipWL+Cnew1lBNC7DsQ2YU+c93MzilLs83gQVsjjo2KH9924PhJzafHy/SC6ZzR
	 1wLIzZP4jW3Jiikn3J5VCfjuDBLgLRAI4xuTfL/kfkN4kBQnuTnITxs7sBqVhY0FoVzqP
	 e2ZorYWC+qwyXu5vkQY4hFsIxFM7KtWtPzjPK5esxQHMy6kX74mH14PKl0/tl+Hb/WDQN
	 jkU2h7FJTTTB3yUdtVg7GkQmzeXfJW/d7nAXdQIL1MLc3N44GAVqCDsoTJ180LldXFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PYO8aFEt;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2075E606A32D
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2026 00:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2075E606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PYO8aFEt
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-491846221ffso6609770f8f.3
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 16:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795738607; x=1796343407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=npRlcaBUGO4zBESfN/npXWj8+rVH/w1YcWRi93JmvYY=;
        b=PYO8aFEtgcaK2RPagOerewhpmmc0ZDfIuCpod+G7twgg2sk8nOtwoVzXqiOruClPIm
         ykZa2Gxh+SbdOb03Tk7Ecox+GJjbV9l2/iELPwatOZLCW6UmJZa8NAe8B/w/TKjjd6pb
         Z8lDEzwMElZT3VuGrs7870kS2fZ5W6L3Y1LHKxricIzTODmmgHGB8yL32QZKvtgZU/Ea
         c/FH6xopP1GpfrAy773fdIGxTM8VNlJBn431gWDOYNXBHbqBmwGj7RPl1BwxdeO7uPEu
         JszKhsTKy2u/qCKbWkAQnfWQfdvyXVGBNEX4EE1GUhwSFa4Z8PJSs1cVbio6w2uoB1CD
         pzwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795738607; x=1796343407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=npRlcaBUGO4zBESfN/npXWj8+rVH/w1YcWRi93JmvYY=;
        b=Pj01DRUVq88ibv0K+pSGAApKSU5RfdChFeyupAJFlZhbeogFhEVskIVESLIxH9J8r6
         IDM5nlMsK76t9rayWUeUwj2dt6nHTJTj7//a5OpmfNRNkvgGyUOvTgl1Pmt+HCxLDYpc
         gHqsR6dZD8oFkAnGcqZ2i2lY5qJOO8WwbDcenBCLcC7stzmW1GJ/yklbQyKb13OSW6oa
         YTwEs9RyTgNueeDowf3bTtl0A8B9W2GrqYs5BNnie+gF2HydEI+dRU9z4N07ZTibufQ1
         fHDwIETjTo+VksdZXuV/oA5J4H8N8COiqqbm9OPBAK9YYJvXLCOBsfnYeKJZaDN3ITTe
         XVMQ==
X-Forwarded-Encrypted: i=1; AL+hErGP+rwmQYgAmy9/P6ZFl9YUGznIpQ6Ed9QW9rLoLo1MGlbcBs6MOqgfWzgG6+NwdckYrixeuI7s5Usurk0YKTI=@vger.kernel.org
X-Gm-Message-State: APuU4Z/ag0Z3edpK4FALunAT1BExR9wywPqDKSL8Mi5WhWxIKJyfbjx9
	VRG08jxxu+0biwhmsRjd0KqAStW4PYRu986S/pv04yqp3+JpIwtRYaY=
X-Gm-Gg: AZFdTZe1yjFEKmwbhK44EYqwxsZoeLixGE60IyFn1MF4cDZFonmrxmJqfa085XrtR4x
	CzZmqwJBpmdUlfjqaV0Fk1hvuwFBAq7dQiltNFEssmCICHwnfpEDOIP6eI77w0ePd5o6AfZdO5A
	RUGoc6Ewo3pdjhLsgf6bdzg6An4bksTZbY4MUXuSStpFgCgQfgnuIUpRDcb4T4ksWIGxprB0Qtv
	lPeIHhg4LcQiCCWNY1GQSsbX2pIT/vudYlpdZhCJaz7uQqnfvp85mYS5CZMgSmRttrDWlv8ycca
	OmxytknTz0bevYU0nnhQ88UFQsGMkWtx+g1vgqP+Q9LgXXSFN7VvRz0bNXmGYd1VGwvR8zfLkOK
	PU2jba6bDM91UByoY8mFin4aOdu154qRK9VmoQcPB9Yafz9ehi0yrCnz/23T8cdxFA9uD0sfZSM
	eITm9GcFh0yh4ZZUcUZd+KPGzwTRw65EzPGRecrOp+DZ4Dm3BvPdw5SMMCGVFX7KcmnfHbAZeJM
	E9Pg7hLC+uI2Sr7+wLmfRt6QSias9T1zEocT2DGP0Qm8hsZkTTqlJbsyPTCpTsZ/zxy2OEMrLqJ
	ytxiLPYFQ3xme58=
X-Received: by 2002:a05:600c:5306:b0:4b7:6aac:7406 with SMTP id 5b1f17b1804b1-4bb887ca0bamr418564775e9.3.1795738607398;
        Thu, 26 Nov 2026 16:16:47 -0800 (PST)
Received: from localhost.localdomain ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm356650865e9.3.2026.11.26.16.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 16:16:46 -0800 (PST)
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
Subject: [PATCH v2 nf 1/5] netfilter: xt_owner: pin file with get_file_active before reading f_cred
Date: Fri, 27 Nov 2026 00:16:33 +0000
Message-ID: <20261127001637.1026589-2-tristmd@gmail.com>
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

owner_mt() reads sk->sk_socket->file->f_cred without holding a
reference to the file. Since the file slab uses SLAB_TYPESAFE_BY_RCU,
a concurrent close() may free and recycle the file object, causing
stale credential data to be read through f_cred.

Pin the file with get_file_active() before accessing its credentials
and release with fput() afterwards.

Found by manual code inspection; not triggered at runtime.

Fixes: 0ede61d8589c ("file: convert to SLAB_TYPESAFE_BY_RCU")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 net/netfilter/xt_owner.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 8f2e57b2a5868..75fcff0ce21aa 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/file.h>
+#include <linux/fs.h>
 #include <linux/cred.h>
 
 #include <net/sock.h>
@@ -65,8 +66,8 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct xt_owner_match_info *info = par->matchinfo;
 	struct sock *sk = skb_to_full_sk(skb);
 	struct net *net = xt_net(par);
-	const struct socket *sock;
-	const struct file *filp;
+	struct socket *sock;
+	struct file *filp;
 
 	if (!sk || !READ_ONCE(sk->sk_socket) || !net_eq(net, sock_net(sk)))
 		return (info->match ^ info->invert) == 0;
@@ -77,14 +78,13 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		 */
 		return false;
 
-	/* The sk pointer remains valid as long as the skb is. The sk_socket and
-	 * file pointer may become NULL if the socket is closed. Both structures
-	 * (including file->cred) are RCU freed which means they can be accessed
-	 * within a RCU read section.
-	 */
 	sock = READ_ONCE(sk->sk_socket);
-	filp = sock ? READ_ONCE(sock->file) : NULL;
-	if (filp == NULL)
+	if (!sock)
+		return ((info->match ^ info->invert) &
+		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
+
+	filp = get_file_active(&sock->file);
+	if (!filp)
 		return ((info->match ^ info->invert) &
 		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
 
@@ -94,8 +94,10 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 		if ((uid_gte(filp->f_cred->fsuid, uid_min) &&
 		     uid_lte(filp->f_cred->fsuid, uid_max)) ^
-		    !(info->invert & XT_OWNER_UID))
+		    !(info->invert & XT_OWNER_UID)) {
+			fput(filp);
 			return false;
+		}
 	}
 
 	if (info->match & XT_OWNER_GID) {
@@ -120,10 +122,13 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			}
 		}
 
-		if (match ^ !(info->invert & XT_OWNER_GID))
+		if (match ^ !(info->invert & XT_OWNER_GID)) {
+			fput(filp);
 			return false;
+		}
 	}
 
+	fput(filp);
 	return true;
 }
 
-- 
2.47.3

