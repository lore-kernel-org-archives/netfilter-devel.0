Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991AC188A03;
	Wed,  4 Sep 2024 09:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725441038; cv=none; b=AMJauE8GmduAqfvxgct9QA2j4rFmA/G0AC9YUJY24OYk0KsV4dyy3mcUYZiYAJcUJPSrzhC89kL/QBCIKwpCRsy0wjl0LfbRb48kwRuGdwUPbc6yVl76Er7VwYgzCUES2s3I5ITP4+WhlkRmoCvaQS2uuhfg4eT39Z7og5bCr8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725441038; c=relaxed/simple;
	bh=Q6WGPNw7RQaaHYkJwNc2C25Vjs9exFExzqzAPTxqncE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QFYH+HDP5ORbMZ00U+4+1DZqURjM2Q5myrJEa9ckbjUMJ2XWS6voBG21uxHcPq9MxshRoS1CgTSU3RPt2jxJMFIhhKvjdzF0oihknopjdaBM7Ekl4KpvJRLAhkmjQkGGxAtZF7fRj6zUVHb8ntx26Gbfj0/clQwHEyS4hrVr3GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gVDEMbWK; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gVDEMbWK"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c09fd20eddso5983262a12.3;
        Wed, 04 Sep 2024 02:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725441034; x=1726045834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fld4WWEOxHgqV+Bo4EmZLzS4GnG7axraRTucYAZq/Zc=;
        b=gVDEMbWKU+I44FRcZv4xflURpPuZiEAeaHH8uBqbYBc/IhsGW1hfWm/Xvr31hpjaoz
         2Ej6PuRK8EFGBo7LC/RcT3/WFbbnFTTpILRZbN8ai68l8D7XR4sv60w/BW2OB9JWC/iU
         Pk4L13J5zDRjoBWpCToxdkIt/qtQosBG+xCMIEsuc7OvXLIVrANa+iJlZQQwuchsjw9D
         TgU797V8fxXcYcSybWa1TV8YgVABYbqTz/oHeIg+unzcPlWQgIOcOFlxYylTCZyEi1kR
         IXu42WiS+YlVDuhwVZf3GpC+KQAuP4mG3BvKErKY1wBbtETMbsarrBf54HKXsuaFX4r4
         Yk7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725441034; x=1726045834;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fld4WWEOxHgqV+Bo4EmZLzS4GnG7axraRTucYAZq/Zc=;
        b=xTBvNGC+I/SOZy/ah1IW3FL7C5aPb0XTbi922WIoME49UQZRhMadNNQROhKmI50nLF
         kuabqNfZQx+CUBWICKxgQ4f3UPPgV4B3AELbMo/rWxYudpSaVOD+SaOyKs9ZUHmeDzU/
         JD7IOT0LGN2S4b2JKZusH5paavKhOOJXBHCm1bauN80f16PzLBN195OUJ8f8Xp62JAB/
         Mwbz6UXknEz8BCXNWPiNS3HbzdYIKmQhcI2WxtxlHr4K2yz8mXbAfN1pQ6R7QIajRn8a
         H5tonDnfbdzzWViCIxz+ejn4om/71qijShdIHvDt7sRFmcG2j4bPFFjtQd6VaY5g1wT1
         D6Yw==
X-Forwarded-Encrypted: i=1; AJvYcCWu17DdLPHLAOB6GOghGOQ1JSRbDkEfQw0iibanVWi8E52lbzjQnLM7QSqtHdcgsd+gZtKcz9r1OTb+vYX+KEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL1LMVEH1blFbYjzyKbLE2pbu+2gvipP/jHwRgJJATK2CUTJmS
	H7OvbisGeqppveij5oGvZfm2KXZWspf1CLnezM2QOViwdOuFPp8Edt4RJ7cC
X-Google-Smtp-Source: AGHT+IHbvyBc2M52ePFyEZAJ8uSwKHbsup2EvbIuiPG8lKWDtb4Q63Mf0T8nKb8OyLLTmjy2Uj3TBQ==
X-Received: by 2002:a50:c8cc:0:b0:5be:fc1d:fd38 with SMTP id 4fb4d7f45d1cf-5c21ed9fe6amr11325485a12.36.1725441033295;
        Wed, 04 Sep 2024 02:10:33 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:49d3:395:ee1a:6076])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c226c6a399sm7321093a12.8.2024.09.04.02.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 02:10:32 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1] netlink: specs: nftables: allow decode of tailscale ruleset
Date: Wed,  4 Sep 2024 10:10:24 +0100
Message-ID: <20240904091024.3138-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fill another small gap in the nftables spec so that it is possible to
dump a tailscale ruleset with:

  tools/net/ynl/cli.py --spec \
     Documentation/netlink/specs/nftables.yaml --dump getrule

This adds support for the 'target' expression.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/specs/nftables.yaml | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netlink/specs/nftables.yaml
index 4acf30cf8385..bd938bd01b6b 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -1027,6 +1027,19 @@ attribute-sets:
       -
         name: icmp-code
         type: u8
+  -
+    name: expr-target-attrs
+    attributes:
+      -
+        name: name
+        type: string
+      -
+        name: rev
+        type: u32
+        byte-order: big-endian
+      -
+        name: info
+        type: binary
   -
     name: expr-tproxy-attrs
     attributes:
@@ -1113,6 +1126,9 @@ sub-messages:
       -
         value: reject
         attribute-set: expr-reject-attrs
+      -
+        value: target
+        attribute-set: expr-target-attrs
       -
         value: tproxy
         attribute-set: expr-tproxy-attrs
-- 
2.45.2

