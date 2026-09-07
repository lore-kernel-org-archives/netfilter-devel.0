Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5EA4028F7
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 06:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763379; cv=none; b=QUQvdQ5QOnZKzOhCWyIR4HLGXnrIVfqvP+J9h1kuyfL0ITIpfAv3Q1nd3SCs6CVvSZ407RXSJR/doI99JHdZsY1wVGe/GMb7xDnhwmqWZX2l/C7jSbUdLfRMCg/ZFlF6aNDCfQhDIQoL6QByADVQf5gPKppt6bO4uo7KsqyKmA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763379; c=relaxed/simple;
	bh=URjImYvwUo6GJY/4SMaDXRkABXbfZnxjL5UNdIWEpzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7Mt/2GJ040rWu/+4p2c3ZJZlSatDKWgfqnKt71uaW8FaH3/MfI4JALZN4xX+uREpuoMjqPOJoKSPxQsj+TMuvuSG4bR7nIf9v8vrK5aRcdCyoBn0h8eyTGVl94BvHTuuO4374peUos+5jxv2uoDE9dQh+7+R8ex+BM9tSp0K68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kDz09KVT; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kDz09KVT"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so3099997a12.2
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Sep 2026 23:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788763376; x=1789368176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8buCyWHJwnSvJxUalxpFaEqlYKtodLWXFfQyVtc5eyY=;
        b=kDz09KVTSzXxDFw1JuBl0Kn8QhnkNdQJZ9FOKciUsN878XBHqDFnDn+YyQcCHAK68j
         7Ibyh17KnycV2OWixMVciVz2sGtfrMyMUssmNfC7l1ZFit5fgmEBysh0eY5m3nRLxL2W
         f+g40JKy5ew4fxF2y67qye+xVwB7aE4t9wV3+OCLzqKAkWNnhZnfeauM4rQKcrF0GHG8
         n9/1skK49XOr+Kowxp9s3Xv3jagLVg5UOqxMQLmhdaOr8OsbPa+G7WvWyyikaoycgflM
         fKp7k1SaFunTcnzoYhzTr0Zqfc//2MzgoYY2n85VaNhiil5LOXHRlZGSTo6d6SgURQjo
         tNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763376; x=1789368176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8buCyWHJwnSvJxUalxpFaEqlYKtodLWXFfQyVtc5eyY=;
        b=LNB9UpRszf1dTXwUXWOZO1fuvaXhvI1YMoOdWStUHFmopRKF3CMQ8arVx0bTVDatTg
         YIXAvX82lghazczd2/ZfH3ExB8pmhcNW5v3eTylazEyprYKTUXSBUskADDZ7tmUP0yCf
         WFIJ7iLOPj2aHqhZVeq0NZ7VacEmZktuy/GNxgsJtbn0r5hxW9mfySfvk7t4lm6Gf6lZ
         0qOd5O+XmZMYPisW9RMZXmYXJcY/HAQzjMqv9Woqyrum5SfPwtW/ki5KzQm80ft8joN9
         L2hLTJ+QQoxq2SXiHdbR79ZcZu8NPXhQ7zycNjrlG27UwNMQ0VD/LAQ5WfcNtz7MS/c7
         1JmA==
X-Gm-Message-State: AFuF++mSRocnZB0hlID0WxIWsP/gt52gne58iF4+wrpHiDh+olDOe05a
	+wkpZ/3KZf5etw0DSyeSEfTLwkV20Ds2A+ZGw5V6yhDZr4MzSVDNVmGo
X-Gm-Gg: AYBFou38Z98rgzXSFMs0gw7M+4571StcZyL2HJIbhlpt/qP8J1DZw4Rqg/ib0vK8fjj
	hB03ENirBfEUwb+xdysvug/C8x+wdx+sgHGrYD8WCWqsuOHb+mcC20fj8mo7pJMhkfvOhWiwNT8
	wBkP6YlWBwwm+3ZqWNYOvGKOkM1MSgz9mCVpd98xrZo/BMDsVjv/0efnZCf+SRRT2rM3PVzorTe
	DVpbi2GaCqkkte4OYbX0+2utL+chBYHYONaqAS9Fi8yfY9gUboBhIJKOX5eILpg/+IFgYP7/9oH
	GJ1a19GoQ/A42q+1121eqNv4xdliS0dycJv81IO0CEc25EGPGzA2Nlx8Rysieo9qbOd72rSgIDc
	lZ2Q0q/CzK5MzZs7p1q7+5VCzBvzAQ8aTicpk7y2A0Z1PENNdawt511e1FUvq2df4ucKC+gDIoi
	R9oebbxZ8gL3A0K0pK1u683U5NNrlJA6S9E1FJOhTbnJwa4Nym3v9SRChecRG7Ac5eo6T51rCsE
	V2qNBcJ8pcLTok=
X-Received: by 2002:a05:6a21:a38b:b0:3d0:9164:98a7 with SMTP id adf61e73a8af0-3da39e830b7mr33671183637.11.1788763376216;
        Sun, 06 Sep 2026 23:42:56 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3356dc5c04dsm14377817eec.8.2026.09.06.23.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:42:55 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 2/3] net: netfilter: fix typo "artifical" in comment
Date: Mon,  7 Sep 2026 12:12:37 +0530
Message-ID: <20260907064239.39910-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907064239.39910-1-hemanth.selam@gmail.com>
References: <20260907064239.39910-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "artifical" to "artificial", reported by scripts/checkpatch.pl
using the misspelling list in scripts/spelling.txt.  Only touches comments,
no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 net/netfilter/ipset/ip_set_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 0a86a170ba90..4aeb767088cf 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1426,7 +1426,7 @@ static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
 		return -IPSET_ERR_EXIST_SETNAME2;
 
 	/* Features must not change.
-	 * Not an artifical restriction anymore, as we must prevent
+	 * Not an artificial restriction anymore, as we must prevent
 	 * possible loops created by swapping in setlist type of sets.
 	 */
 	if (!(from->type->features == to->type->features &&
-- 
2.48.1

