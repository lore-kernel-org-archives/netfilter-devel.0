Received: from mail-wr2-f11.google.com (mail-wr2-f11.google.com [74.125.225.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A723C489879
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 22:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787781902; cv=none; b=VAX2gB9j7Wk/TVcovZtRE3BHTXuu5tERxxzT0gzbF+3UVp1i5syVzZC74oTSMTzez/GyAG/S99qZi8KlsjRHNgLLBG8Nds4LpEm2/KJjF67vwET58tKuFA9+NLkHmgjj7Hf1EYz4oLov5UqQD9iUlrKRhR1Km6QTbHCY2UwO1A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787781902; c=relaxed/simple;
	bh=mUOu4prFbH3IaF5Zx3eYa4vcy/qKSL+mXorCQl1XPlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDoKocjSLgPetac4k8poBnzcUsN7FEnpeN6aVKiqIfIvqJy5xZCCy6ZIkbQGV3jBLr4vQFUlOzgPtDWqRm1prelHXTbPB/bYFuy8eRE7ppURw6ry5/2HS/ey0BbFPdTJfaoQDWY1FW6LzzpmwGLxsbdqP1JN1NV6iIZk9VhhhE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr2-f11.google.com with SMTP id ffacd0b85a97d-482e61db882so165753f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 15:05:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787781899; x=1788386699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YabbSQ2ZCljuR5SzDy1HfG5T6nOzAXlSelOf65B5pQ4=;
        b=NbLI3l8Sv0AX82odkmFcBRdZfZ+YgIK97G7A2u8U/YmGv9zZ+xkEjXLS4MXegnairm
         ZWFBtweWLsdXt41wKB+x8b2DZDGIXlXaKieA6y6OyPYwqab5xPrFzlmLfSj7Rdhf8Snd
         XeP8SdhkLBmIJyA+/h2N8qXI7wquHX3vGzVzMvZIcZjxtKtU/ToLJ9dTAmeCGRLa/2ni
         Qcno99PyYaOvw8BCWGY3pUMRHswVEH1NpJUrTjUtqDF8H1tBrc/aAtXzf2edN0guuOld
         Tcga7BnqZCw4RGaaR0Rm1HixX4BGJKbPCI95U1ilrHj+ctCcpRyQ+1ASGexTxwuKTKxs
         PISQ==
X-Forwarded-Encrypted: i=1; AHgh+RqwHbe7yWGPtcMvcKXJKN70sdxWydg76yXWRQJImhpHnnM7ElKt32VeEEoHXDjUwaBtRHHBLk69m1S8i+hOevw=@vger.kernel.org
X-Gm-Message-State: AFuF++kLx9WOkjZGE9TRXhYRcTyv2v6Wqs++Fa0WDBA73Ta+R/bExBHc
	frua1Ei7Ys4V1nemeWNee9jskkayuOxPZ7UUpjFjg5cNkXTHw+yAki97
X-Gm-Gg: AR+sD11tcvNSCddsceRwCk+4plTyQ8Z7ZJqs1BjCSAvNJsIixGeZ9YxQ5tpY4uMOsbq
	ubYkxnBU1Ljv1ZRtjK6eXbPwG/bJDpXnifqt7i+hz2yJDol5JP+iHOCNieYPVAkXzSCI39k0GJB
	1N0DHxh2j8S/aTXZeba4aPmLixkr3ZOOTfqfaeCg4GVfwV+EAM0UqbQJlxMXnKmTyxaH7x++wGQ
	8JYhY3dob2DC+sU9RI1sVZa2cWbD6ykNdb4WcSom0S46l2ygYlgw2+zZPuYLjsA5uJpw1B1Rnxk
	BHsdehv5jXAh+hbeoRGSZnO1Qgwl+lMY5nQsZCR4akWqwRUxARTo3XMZvKh/mA66K0fp1fxx23y
	8XClS2F/5Cnmfc2Ve7rpsMHE76/ioS5k3IlIj0Z7CeuAybxWs1FHvdxVyT1rr8AZudlW5/CzklK
	F82qPKVSAdSm2m1yURYzMtFwICQJqweGMkiDHJy8Zop+Ze9IbCnWezu0oj5MuLFTczFGdJ51+Sj
	elRULPicCc1LxTpPA==
X-Received: by 2002:a05:6000:40e0:b0:482:ee81:f0ca with SMTP id ffacd0b85a97d-482ee81f321mr819706f8f.12.1787781898817;
        Wed, 26 Aug 2026 15:04:58 -0700 (PDT)
Received: from im-t490s.redhat.com (37-48-53-4.nat.epc.tmcz.cz. [37.48.53.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e27a9f0esm4446370f8f.10.2026.08.26.15.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 15:04:58 -0700 (PDT)
From: Ilya Maximets <i.maximets@ovn.org>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	"Remy D. Farley" <one-d-wide@protonmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Ilya Maximets <i.maximets@ovn.org>,
	stable@vger.kernel.org
Subject: [PATCH net v2 2/2] netlink: specs: add missing mask attributes for conntrack dump
Date: Thu, 27 Aug 2026 00:01:12 +0200
Message-ID: <20260826220444.4054714-3-i.maximets@ovn.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826220444.4054714-1-i.maximets@ovn.org>
References: <20260826220444.4054714-1-i.maximets@ovn.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'mark-mask' and 'status-mask' are defined and supported by the
conntrack dump, but missing from the list of arguments.

While at it, the order of the arguments should follow the order of
their definition in the enum ctattr_type.  That appears to be a common
convention for other spec files.

Fixes: 23fc9311a526 ("netlink: specs: add conntrack dump and stats dump support")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---
 Documentation/netlink/specs/conntrack.yaml | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index 6ba28cb1c2ab..b1eb102ab843 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -604,10 +604,12 @@ operations:
           attributes:
             - tuple-orig
             - tuple-reply
-            - mark
-            - filter
             - status
+            - mark
             - zone
+            - mark-mask
+            - filter
+            - status-mask
         reply:
           value: 0x100
           attributes:
-- 
2.55.0

