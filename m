Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BD715E200;
	Thu, 18 Apr 2024 10:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713437269; cv=none; b=O0TO5GbnGfqAjM2GKH2mT7U5Oe3vIBtY1Xqh2PaTPci7NUFyNmnLgeOCcnQ0QY7NWcb9AX8U8lAqmD4zsQuCjOBxTRp+FBjITEQ8oQrAHC/REQuUhks6eBzANuhkQGqflr2Hfj3Bco1T+YIjXKTmBnw/rv0FMIjMaUYE0qsN9+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713437269; c=relaxed/simple;
	bh=ZI17aBFXnfNIX5gg0TIh85FQjVSnOaICYAT+dqo6FJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igLpqc9cD/y45/3sMgN1xWld4uaBkPVLcg8B3OUq14PRypuvMAUvYTb8BhntiM7PG1Yk/cbgnttJ7SSn9YwO5fueos0iZNzZdc5Gag26iFL8AD8P2TG00OCi1vCbVGlfy5ULtx2mS+JjD4biKYXPjW7gX2EGKGk9YzJQ3R8fxbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NElA4jCo; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NElA4jCo"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-418dc00a30bso5423425e9.3;
        Thu, 18 Apr 2024 03:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713437266; x=1714042066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BLXhtS7COhldJZyUQwRPNq3Lb/qi4UMCEJcdHCvY3ZI=;
        b=NElA4jCoSC8zxVFTzQp1Wp77Lps/ur8qdVehrbP1FUZplPp0+Iz7IOIyUnahe10z4p
         aQd7mOnoVwMywy4ap5MvESukRdhFNn7Ech+d/nRCTy5EiIa67iw0weXyU0aoyZjmNZ0v
         c2/3yAK6z4ncwCHV83chRhhjj6jm1mUTS9GcKf4Q/7qVdJ1HRSeExSn8g7SCekQ4wk86
         3XD26Dqc1EcjBFTUUt+F1tUIpciGUVaBz7l7pkQCG63ro8QfaqhGeT+Xa3TlS3/5lPtt
         njFnP2ZZ0Hie5j+jRfTMN5eovaArqrtqQRt75D7Lu1hjD6l1eq+jTi5Ia2vtpyPEa+dr
         J7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713437266; x=1714042066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BLXhtS7COhldJZyUQwRPNq3Lb/qi4UMCEJcdHCvY3ZI=;
        b=btvcTaOyCQUUCpT97/ZD/lVC/9ESerg5RU6SRMe+GGUp3bDEMo2Rno+LxQmwbgA+wZ
         8QEoFfSzOd7tkqJtHHMKSicN91xkGZyUYRoWM/NZjGOdLnEAEJ80FiruzOiEkfeNfO+g
         D6NDs1dfZec3SXWDgaOBmrUZ2Zn6wO1m6GjcEWl0ZTWJtAhlBZFgem59fhrgn83VrhJ8
         TRwHlJnliSXD5h3t0u2OH8I/jxhCQwNEg02unrvjoMdQB1GsmwYcON75eG07TVNBVaX/
         Jpz1G6WMaxYfAKHxOLCgb5749r0rUe6d9K14azwvSmGEZt0t5tMckNpRLNQM/JBVBWag
         eCpQ==
X-Forwarded-Encrypted: i=1; AJvYcCX05dlO5tVgdImSSa06dMyqNVzE343kI/ExiABH7Vdsu/UmW2piLqxhTDB/YaOrLYGqM6vCMih5NSe00XhUP2Zw77q6bVmzZHhmpL0aS80I
X-Gm-Message-State: AOJu0YymDEyaQhanIuwgVLTvEj86gBAoNMsx/hesmDbd3vw4KsrCfl6W
	4sJQKXLMbAknL1KNImhRi+NBrqM8FqPJmlXpf9EhBzy5+Xy7j49oi3biNM34
X-Google-Smtp-Source: AGHT+IFi/bYwZCA5l4+hI0JIZVfOkLuYFWp/RMkZCCxdNA1TRAM8oCQOXCF2s3RnKm5BL3xqgi9cmw==
X-Received: by 2002:a05:600c:1f1a:b0:418:d69e:673b with SMTP id bd26-20020a05600c1f1a00b00418d69e673bmr1586995wmb.14.1713437265795;
        Thu, 18 Apr 2024 03:47:45 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:702a:9979:dc91:f8d0])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c4e8b00b00417ee886977sm6135807wmq.4.2024.04.18.03.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 03:47:45 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v4 4/4] netfilter: nfnetlink: Handle ACK flags for batch messages
Date: Thu, 18 Apr 2024 11:47:37 +0100
Message-ID: <20240418104737.77914-5-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240418104737.77914-1-donald.hunter@gmail.com>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The NLM_F_ACK flag is ignored for nfnetlink batch begin and end
messages. This is a problem for ynl which wants to receive an ack for
every message it sends, not just the commands in between the begin/end
messages.

Add processing for ACKs for begin/end messages and provide responses
when requested.

I have checked that iproute2, pyroute2 and systemd are unaffected by
this change since none of them use NLM_F_ACK for batch begin/end.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 net/netfilter/nfnetlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index c9fbe0f707b5..4abf660c7baf 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -427,6 +427,9 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	nfnl_unlock(subsys_id);
 
+	if (nlh->nlmsg_flags & NLM_F_ACK)
+		nfnl_err_add(&err_list, nlh, 0, &extack);
+
 	while (skb->len >= nlmsg_total_size(0)) {
 		int msglen, type;
 
@@ -573,6 +576,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		} else if (err) {
 			ss->abort(net, oskb, NFNL_ABORT_NONE);
 			netlink_ack(oskb, nlmsg_hdr(oskb), err, NULL);
+		} else if (nlh->nlmsg_flags & NLM_F_ACK) {
+			nfnl_err_add(&err_list, nlh, 0, &extack);
 		}
 	} else {
 		enum nfnl_abort_action abort_action;
-- 
2.44.0

