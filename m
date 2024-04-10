Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56E9184137;
	Wed, 10 Apr 2024 22:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712787079; cv=none; b=hD8KedmJx3GE6HZRKgUtALSrGlScGK9rXGJ2FEl9ffA6xdIO/vGnEFy7W3nH0K87+gvTEbtY6GvznYrf5Q5RxvvWIyzmSE3W+eVGdqA0upzMJqohlvZwsdvOpAxcS0Lpeaq1fAHnTA9zlew6Eivl7CtIgjAxelCsJt65wZAsqdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712787079; c=relaxed/simple;
	bh=GWIjog+gH1zlnOSSbeVSDQ0xZs9MPYgLU9Y4IeL2NKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAe19LIHYL3kLPAQz3/Aq9SeruI2Kk7V6o/H/F5/SSkPcI41NlQflepsVMAFHz4uS8ToLYXlnaTvT/SnP7Bt3hbJGsEec9XnpeaLBKpB0F0xqcChzMQv2G4Pgvu8TsdQL6dA94yjyp94hzhQgd+ezBp9KBKNhWLVN63uNWZLyqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ik5j6vx6; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ik5j6vx6"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d8b2389e73so24964811fa.3;
        Wed, 10 Apr 2024 15:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712787075; x=1713391875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dnBh/LiyVyJxwwk9H6Q2k9K/wsnmkVk9P5ieAwm+LcY=;
        b=ik5j6vx6Yjc8K/v7XMGYnpydCXbrZGgbEcLVH9RsLwHItPuaaJu7W5Rvc02oBlUODB
         4zAWgZBUkneyHgTzDGvD/Wi6R5XycdEmHzWT9RbDhg27AMv59wrSgGeLhQftfYXPG+hC
         ZRXnEuiz8bjijhnC6/w6TxDayvSldNmaHa292LpXK55KpG7ymlV2rFepNsT8G1zEfc/9
         +QJBL4Z+yf47+Lh0s3tRWhcoeabKxBrJRHV2I/wLxTgCbsPy+C4NfUfP+0ezHUDUj+zE
         +6zxm0ZM+7W+fKL4d44Y/477VsCh7dIbgmu7kyvzHwBR877ZBCjm4oKNjhoJpBgjZGSd
         +ZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712787075; x=1713391875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dnBh/LiyVyJxwwk9H6Q2k9K/wsnmkVk9P5ieAwm+LcY=;
        b=E2g7iZImKo9UC+g164kMsvktxujgghVQGC9EZyXgR/9AxhtZ7UjyPmAnWxWrOAMtTN
         DnZZ9H1jLOqMBfClXrSCZ7KERzZwE6mmVRtGqSniuQjhcnHW7k+cfHcnjRG0HWx3/mdm
         ix61L/zMKcpM0u3K+Cqh67+BfBgc1eQalmsm2TuO7zBjfIUh4TqEa9fo/GhcJOGYz5se
         bdbH9y8DxCe6ba3uuGSfcWHmd6/nlKXA2X4GdB83TgQrckcF5sOEzvTDn92lN/unu0rN
         HwKRAMesOUF1Ro8i0aIbu56D247f/rTNhBdZgLkQ+AkUNtKOvKkp2ud2ruD+lmKEGBye
         UvjA==
X-Forwarded-Encrypted: i=1; AJvYcCW9k/sy+wgxC98H9zESlXZtBcx+xqtaBFz0I0QVGhMeUN5fRCR7hO+zJItV7jwi8jf+4W0qqtfA60jMipilRp2oxtnJHPVHHRh51RcZLetu
X-Gm-Message-State: AOJu0YyMYWOWSAoLTy7X4jPFjV9Tnp0+I6bKbnz8PmILOF7RhLRHNcY6
	7yZXb1rN33Xx589dwZuZBcgTL6ETAy/q1jKb1dJWDHY4TjpdWmqHATgzdOrB
X-Google-Smtp-Source: AGHT+IGcbKKkJvcFcd7QjKXjZdgcCc91dtGpgzgHmrf6aOSLZfy+FJ8HFJyXxUkpNlmc7+NQsjBkiQ==
X-Received: by 2002:a05:651c:383:b0:2d8:3646:551b with SMTP id e3-20020a05651c038300b002d83646551bmr2340812ljp.50.1712787075236;
        Wed, 10 Apr 2024 15:11:15 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:2cff:b314:57ee:c426])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c470700b00416b2cbad06sm3531244wmo.41.2024.04.10.15.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 15:11:14 -0700 (PDT)
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
Subject: [PATCH net-next v2 2/3] netfilter: nfnetlink: Handle ACK flags for batch messages
Date: Wed, 10 Apr 2024 23:11:07 +0100
Message-ID: <20240410221108.37414-3-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240410221108.37414-1-donald.hunter@gmail.com>
References: <20240410221108.37414-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The NLM_F_ACK flag is not processed for nfnetlink batch messages. This
is a problem for ynl which wants to receive an ack for every message it
sends. Add processing for ACK and provide responses when requested.

I have checked that iproute2, pyroute2 and systemd are unaffected by
this change since none of them use NLM_F_ACK for batch begin/end. I also
ran a search on github and did not spot any usage that would break.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 net/netfilter/nfnetlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index c9fbe0f707b5..37762941c288 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -427,6 +427,9 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	nfnl_unlock(subsys_id);
 
+	if (nlh->nlmsg_flags & NLM_F_ACK)
+		nfnl_err_add(&err_list, nlh, 0, &extack);
+
 	while (skb->len >= nlmsg_total_size(0)) {
 		int msglen, type;
 
@@ -463,6 +466,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			goto done;
 		} else if (type == NFNL_MSG_BATCH_END) {
 			status |= NFNL_BATCH_DONE;
+			if (nlh->nlmsg_flags & NLM_F_ACK)
+				nfnl_err_add(&err_list, nlh, 0, &extack);
 			goto done;
 		} else if (type < NLMSG_MIN_TYPE) {
 			err = -EINVAL;
-- 
2.43.0

