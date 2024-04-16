Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6A7139D17;
	Tue, 16 Apr 2024 19:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295964; cv=none; b=LjJYd5tGS/0gN/gjZ07qHOrUkSbl3NCX5+lDpqU/BPBd/WynNKZ1VJ7eBCnCpI1ZU5TUkCxyiSCUrDjIwjlgAqltzGTOi/5QSULM+VLAcDJfIGUjcYQyxxQYY/pp4A0T8ccD17AHOy/BrJ1KGLkPgzizE3u8hRQkQ45PGe0TyPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295964; c=relaxed/simple;
	bh=ZI17aBFXnfNIX5gg0TIh85FQjVSnOaICYAT+dqo6FJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPnyE2vI6GE/Vk+o4fro0xMhVU1RIBxUUR/BHAi9bluINXqGpfaGBAmnbcFnNIUzD1KKu9tobvQLMu+pPpP+kHvwOMsFoiz9A6Pb+p/sSBc7opLOMz5UwkV+gYW/Ceo98FbKxuxMSvWKtiEuoMv7UTZUro5ZwQ/TMHpD1VaUw28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UD3feV0u; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UD3feV0u"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-69b16b614d7so30703656d6.0;
        Tue, 16 Apr 2024 12:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713295961; x=1713900761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BLXhtS7COhldJZyUQwRPNq3Lb/qi4UMCEJcdHCvY3ZI=;
        b=UD3feV0uYqHxmrSY9C/zeoBEhAlstkj3kCS0WOWpM9Ux2g3uK3r2TR1CeMeYVgrGCj
         7UU8+WYqJ6WHftUqMw26YVjqt5LI7aX27o8yOmhY3F99EllQ3NLKyYgHLGiL834n2tox
         78eLEC2ACOavdZmFNMSaHefxu11uP+MIqMMQSEoaeaTxsCtShbzERTgKQKdl7X7OuGB/
         26zn3vdBkFcTmIkDwi6BEtxY7O+54ITJF6sLjrCDSPwmNfLPF0DjHQEKbyg2uKsktBah
         gcVX21K6f9+MHDNXz1UV5VZEuH5cw/hk1vSoIbwPSaTEupsRps793Pi2W8Ujoyg7k9Y1
         V0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713295961; x=1713900761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BLXhtS7COhldJZyUQwRPNq3Lb/qi4UMCEJcdHCvY3ZI=;
        b=GTuKr3lGtC7/svSqqll+uKhA0RPQmCFFDDTJBXrsxeYw6e+xwJ685O9CBmSywvui4+
         Xx2qfp6e8lDScwKmzIMa8YP82ccHQv8vwbr5dpjUEC4MOdaSFDdQwGg2GnXkNpkFUqYh
         pW4xufdLm+gATakwZI5PV13gUox3M5eXx52qNeVMLnGZnX29c6PeLz8Ye5JUEI9bqpiC
         hcqq4pno0WFFse5pyA/7moOMEPX9KqYAngV1JsGmGCk5Loq/+JCfrk4Jhx/0tLE4kd3e
         1u6r+6zOvCboX6K9MTTxEAhe8cmN6TJHUv5XrsQOQkdwoLqir+KrPtvtPSR2G4chgjM7
         JcYA==
X-Forwarded-Encrypted: i=1; AJvYcCWhYKJfCRWkwfaIRyfzVHF6t0EbiBNKt8R9gCRDKnSO+7h6R8KgwBggNlH4kDal9VZvPJMgKUhVFNhnL4doaAvDtH1lPD9bQnw0OjYFSnvg
X-Gm-Message-State: AOJu0YyAgrCrOQOQHAGRVTkmicpTnWoAVWfMvSmZn037iscyHLzt56q9
	jpnvObssjx4/7MBYahEjdoMkipPYHneTvuVOAIf+C5Sdpf4i9923evpVf2nN
X-Google-Smtp-Source: AGHT+IEBZEtf19dA+qcI5ddYQsHakMQOEXKRiazZQ5RYpy01SKYNvM87N7Ll8iMHb9KvWdtYQBS92Q==
X-Received: by 2002:a05:6214:a12:b0:699:29e5:18e0 with SMTP id dw18-20020a0562140a1200b0069929e518e0mr14088439qvb.13.1713295961554;
        Tue, 16 Apr 2024 12:32:41 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id p12-20020a0cfacc000000b0069b52026a19sm6901757qvo.25.2024.04.16.12.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 12:32:41 -0700 (PDT)
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
Subject: [PATCH net-next v3 4/4] netfilter: nfnetlink: Handle ACK flags for batch messages
Date: Tue, 16 Apr 2024 20:32:15 +0100
Message-ID: <20240416193215.8259-5-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416193215.8259-1-donald.hunter@gmail.com>
References: <20240416193215.8259-1-donald.hunter@gmail.com>
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

