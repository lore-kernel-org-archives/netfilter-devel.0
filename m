Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A634E56C7
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2026 23:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791935020; cv=none; b=D7eVtcehNj+y9HgIWwGh/oOto/dsUVq2yFGHYWX+SH1X/y6GJntQdaBaJhfW+mvq3sHpkA0nyoSWfkvaWp0g/Td3VvcYBcDIWxChJ0pUwJTiHUTUz9NsbNln/uDj5uy/goVnM0PhzjARNVv/PzWcSIkei+yN6bRI7jHlQiWceIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791935020; c=relaxed/simple;
	bh=5jdOROMNUHVO4P/XHZZp6UpoiUjluiQa0QfEWuTjMEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wi0kQvjB6D7Z1K9yO54V/pIGXpv7+F8dvdkYjeYTUvVQB/mECdMgVpyfirGjM+g/twL2tIt1g6G+L+rBcwjJpS+HWflQ9dvnX9fK6HTlgizKmKX78Ns37U7OZusYvbWKF1T8Ch18xRqLQVN6xpdgQwvN8S6eJEBv3/CusGSWUy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KWDbdg3T; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KWDbdg3T"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a0e1b0681bso25265845e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2026 16:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791935016; x=1792539816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fzq/x4mddpbPm3Ds57DNlSCPWkulDVxUviBcc2SD7NI=;
        b=KWDbdg3T+ybtsvARg3GOaK1CNyJ+QSbEVuDuVVyHwQTPypNjluQXXZ5nrioYUug8EC
         z6hmKhWL7ip0lV2+t9jdfB3lenkEdzVsnxXh/2yz8Kc/Jf9JmjzcEHDxO2Vo1xfJjDYb
         MgMLBSuh5OOnWYxu+3Kc2jgNaXQbIcOvIbRPjFCpsSMDoMDd1OH6z+agAeQZzqv/EcUx
         qsvQrJPdLpLSU7fy+MokCSZM6NvTrkcRo4SDV7R48F8RBiHhhNpeTwzW7cJr9kfjc+9/
         ZvjjFZrbVn3YtGrW+4ix8vCY8n+aubrvh9kwtgDaoXIsdCcDcZMrOT1iOQYq1sxS3bGR
         tDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791935016; x=1792539816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fzq/x4mddpbPm3Ds57DNlSCPWkulDVxUviBcc2SD7NI=;
        b=sZCOGrhOoxSEHJttqXogt1R7w/ROV/jPH+/X9oOjZIg14G4/dN/LHAMJk2bM0IPoHF
         wBunqNWRJgzezEJF3zbXFgHmLmA04xieqvm5XvpjOCIAxT4Fi6rMyUsICGc4AZ0L8ybo
         RNnG6WVgFGMGdhh+exsDcNJOqM0W/8WKfIg+cBtUilBXqADa8MXCRCskBhJgv6KYfN6I
         c/dEF/w3WYxMtlwyiCJKmLLgNiMyGXFKG0nkF5gqgBg8RMcVVc4fgnSCCHMyitOtdKAS
         6vTXAIK0OBD6RrZHaVZFr1E/7iB5M3F9kUFb+J8weaLWbZG1xDnjEQ7e+NPBPmR7MkiK
         kXdw==
X-Forwarded-Encrypted: i=1; AKwUvBwOgdUcspYlpO40u/w9d5a6D5ZZQD92HXFEtk810xxKBe6Ahscp9wfYB40/rFwspU/fe8XK6xHvcrCALyCO2ag=@vger.kernel.org
X-Gm-Message-State: AFq9FYK4TQrtxsOhyQtu7pdP25tL8J0feIaPA0vutR8v6xbw9OuHstMr
	/GXaCxD8/Kj5BWJcgPo0aaymvChn5JnSjqGcx/qle+suTTFQ+UcnpIE=
X-Gm-Gg: AYBFou2r1z4yP0gjqY7LD5SHlDxFWOVHXJ0QW0qn+LSlrwXMvDNB84eAzUHRZcSzfzf
	IX/uOHw4iGzSrWDGAdjVbJj7giyMcdoFRDtjOVXAv4gKuDwbYblU+yseWtMgGRI+LrRYY+acKlg
	vGOu4qZ6Wmr2vXa4qUO9wq3ME6rcKiOrg5nih/7clQ2KQlDIbfJ73G9ZdRXiPWf96WYcsqd+B0G
	U6iFn21JSDggkNSWO0aXwuQiwvUIUjtp9DYLeVs6Y0PnKi7vtjvjTlPOYaJDRkBf9E3OvVbyuK/
	H1jaZMDhb2N5QjMPJwR16k0GbcP04OjY7H9XES9lrTKWVl4qGVA5Kfxw2IQw9hlQc8duCl7WMQx
	LtQjZyRQC2j5D2C4L4DWCeFfdcN0oPSNyrSo9/IvnJniAXU1lSY+Oj3qkrTDLNIU1j0tRLFinDb
	m7BYfLe1KttipRsvI8tY5YNT3oP54pm0qBa/oLEH0jvyjfsKyv/Q==
X-Received: by 2002:a05:600c:3f1a:b0:4a1:ac66:6ac6 with SMTP id 5b1f17b1804b1-4a1ac667160mr77160605e9.26.1791935016224;
        Tue, 13 Oct 2026 16:43:36 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf35930sm390372155e9.13.2026.10.13.16.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 16:43:35 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	Christian Brauner <brauner@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>,
	stable@vger.kernel.org
Subject: [PATCH nf 1/5] netfilter: xt_owner: pin file with get_file_rcu() before reading f_cred
Date: Tue, 13 Oct 2026 23:43:24 +0000
Message-ID: <20261013234329.2797868-2-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261013234329.2797868-1-tristmd@gmail.com>
References: <20261013234329.2797868-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

Since commit 0ede61d8589cc ("file: convert to SLAB_TYPESAFE_BY_RCU"),
struct file objects can have their slab slot reused while RCU readers
still hold pointers to them. The xt_owner match reads file->f_cred to
check fsuid/fsgid/group_info in the packet path without pinning the
file. If the file is freed and the slab slot is reused between reading
sock->file and dereferencing f_cred, the credential check will operate
on stale or unrelated credential data.

Use get_file_rcu() to take a reference on the file before accessing its
credentials, and fput() to release it on all return paths.

Fixes: 0ede61d8589cc ("file: convert to SLAB_TYPESAFE_BY_RCU")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 net/netfilter/xt_owner.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 8f2e57b2a5868..6386b52147d87 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -65,8 +65,8 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct xt_owner_match_info *info = par->matchinfo;
 	struct sock *sk = skb_to_full_sk(skb);
 	struct net *net = xt_net(par);
-	const struct socket *sock;
-	const struct file *filp;
+	struct socket *sock;
+	struct file *filp;
 
 	if (!sk || !READ_ONCE(sk->sk_socket) || !net_eq(net, sock_net(sk)))
 		return (info->match ^ info->invert) == 0;
@@ -77,13 +77,17 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		 */
 		return false;
 
-	/* The sk pointer remains valid as long as the skb is. The sk_socket and
-	 * file pointer may become NULL if the socket is closed. Both structures
-	 * (including file->cred) are RCU freed which means they can be accessed
-	 * within a RCU read section.
+	/* The sk pointer remains valid as long as the skb is. The
+	 * sk_socket and file pointer may become NULL if the socket is
+	 * closed. Since struct file uses SLAB_TYPESAFE_BY_RCU, pin the
+	 * file with get_file_rcu() to ensure f_cred is not from a
+	 * reused slab slot.
 	 */
 	sock = READ_ONCE(sk->sk_socket);
-	filp = sock ? READ_ONCE(sock->file) : NULL;
+	if (sock)
+		filp = get_file_rcu(&sock->file);
+	else
+		filp = NULL;
 	if (filp == NULL)
 		return ((info->match ^ info->invert) &
 		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
@@ -94,8 +98,10 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 		if ((uid_gte(filp->f_cred->fsuid, uid_min) &&
 		     uid_lte(filp->f_cred->fsuid, uid_max)) ^
-		    !(info->invert & XT_OWNER_UID))
+		    !(info->invert & XT_OWNER_UID)) {
+			fput(filp);
 			return false;
+		}
 	}
 
 	if (info->match & XT_OWNER_GID) {
@@ -120,10 +126,13 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
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

