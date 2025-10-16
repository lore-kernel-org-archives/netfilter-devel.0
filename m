Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79251255F57
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 10:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760611691; cv=none; b=G9xeCVPiu5+2tY2zXXH7+AL4NxKRuKqlYjYLooQN9CidEMSfE9I7MXu1Y/ytnRtfHMdm+cRDR04VbXZ5Kb/s3BnLpmJOwddlwZ1zB4Ve+csWm0MtEn3Y4VfMGXmeNy0kEZ14IWogz5lxE0JRiSGHfzVZZqFLzaCtv/41JTtk+1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760611691; c=relaxed/simple;
	bh=Vai3/5mXUk3m0FpPR7C5HtKBEkwbvUE6m2tIfTpywf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEb2H5Ui6gDJE67EyU1HbuqR1XhpIfGEd6mWkjSbQPzhVJgaeiiU5GEx/UBoqWaWf9lF5rJI9yrhtmJPLXA26RNpIZ0CN7VGMN/4hJE/C9DSoNEMTtonzoijQzcpEaxGXYfopG4x1dTTH0knZpIPFV3+yjNTDa7j8BdieMK+uJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=cvE60C3D; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="cvE60C3D"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e6a689bd0so5503115e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 03:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1760611688; x=1761216488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GSPV9AzBq9pw4Fv1WhOpeCc+InkklHxwfYwRGxtUKjs=;
        b=cvE60C3DFX4y7L9IC3YnW3PHe0dKXP2BmldViINck+3iqtEKFUGZx4dYKGyh3wT+Qe
         lCDMh48KaO1P1NMM3Jp1eoR+8pILH5eT6w0TUWaADBPP8QArL1dpqLHrcs+5BunfRIFP
         4Lpg9GZi8ocsK4M4YM4Csap5Gaa+Uis0gj5hKsOdu4JuNZVxP5Z/Ni9rmlAXfuBqf6jp
         DsK7ZxFIbX4FcjvI4VZUHChiUBaG7WidRJjtrkGqxLkacpm7a0bLqtythGvsIzEJ2+Te
         aKacVT4fXjco4HzBZ3nd3bG/yPc6wDZb8IjPcTOFRrt+0cfk5Ywa7ACKcsZRQW3QrCMG
         I2qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760611688; x=1761216488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GSPV9AzBq9pw4Fv1WhOpeCc+InkklHxwfYwRGxtUKjs=;
        b=xJrXLGbZ0JFcmqqA3HE9tWJVNHUDL867ozbxRvTDzCSOB/pCxHFL2DUOhrj7/ljCq4
         s8lWRQNmx751kznTWQh0Fss6NKOin3dvqwJ5oHyys+OPTtg4J9VC7gcReGDVDVixEcXt
         wE2uQvMw4Fo0eBxlH3Jv+cu3J1H38soji7ts4ccy/xpe564VNIAgqamzTMUkjT+N83jf
         QyYv6FBJWVLO8RJVjliy4sx0SdGX4MhI/pLDKUDOWEqSr70NA+eYd01ji6ICyTZ763Fv
         0bD6JWIAaVBiBARhNfiAUlUT5n6H5vt7l3Hotx/STPUATjKXIgVGxdWQqGrKtMeOm/jB
         hjTQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3A3AbETt+HpnbL8MmpzCRYZTlxhqu3nPVTaiiAB3soh8sHHGHG6HFbOU+LoXvICAmfUSJAtgX1HPww6BUgiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZY3wscZlsgfTOFA2wIK/R36jRFu2ZOEtZxL93UjUh4XITDsBP
	2E9sfS9ZkFI2D4d6EzgWwtF+gNkFH4j6PpULcS9xCIgpVNUYZIc60LokD4TzD1zJl5A=
X-Gm-Gg: ASbGnct08Q5nUr3K5MR/OFcIEdNQE7+CYaJ/FutK5PNYdLyann1vXZuwnElgSZWBtxI
	VlNnq1uCLs9wX3pqPTZ+Sm5ijnoL1nUlFvegFUgkcYERWbN0ETeI610gXhMdF0UAzWX1gJbpn1w
	VzigKK8IOJ947EPpCWkWjpkMYCNW5lP2jdVAw/4As5UTnBhWcV3SAWD3FKW0BeyEkH1hTH55+eD
	6ZlpzRdVdCuNDQBIJ9PsjMhNwmFNm57vArhlqOXYJbHg/rjFVRWB76YmsUObUTonDX3vjM3YLOX
	IioPuGBieXOfwCjit2jJ3xAGsHRK0jQ5YlPRRnFIb/Z5U7IkxctAOln/ytogT5fyEMIZJmj+Xsh
	ZeuIliwV/KHG7VqN2fHUdKo16K8SdHnWT8IodqDgQtrbVLVOcQsAdG7ERUDPWETyQ1I8enyo22O
	+CmwJOREhqbDls2VHhgWt7ANcmIxWP4C9iYpVuuH/Rin48dGDb
X-Google-Smtp-Source: AGHT+IFqjy8uQiCs0gAcUHUVVI+lGBAyvoChddSQYZFbSWwhwHhgv7ATDM7DOPjRfdHKUNXdqdAqVg==
X-Received: by 2002:a05:600c:3e87:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-46fa9b17df1mr270864595e9.34.1760611687717;
        Thu, 16 Oct 2025 03:48:07 -0700 (PDT)
Received: from VyOS.. (089144196114.atnat0005.highway.a1.net. [89.144.196.114])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ff84cbb7sm2729374f8f.23.2025.10.16.03.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 03:48:07 -0700 (PDT)
From: Andrii Melnychenko <a.melnychenko@vyos.io>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] nf_conntrack_ftp: Added nfct_seqadj_ext_add() for ftp's conntrack.
Date: Thu, 16 Oct 2025 12:48:01 +0200
Message-ID: <20251016104802.567812-2-a.melnychenko@vyos.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251016104802.567812-1-a.melnychenko@vyos.io>
References: <20251016104802.567812-1-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There was an issue with NAT'ed ftp and replaced messages
for PASV/EPSV mode. "New" IP in the message may have a
different length that would require sequence adjustment.

Signed-off-by: Andrii Melnychenko <a.melnychenko@vyos.io>
---
 net/netfilter/nf_conntrack_ftp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 617f744a2..0216bc099 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -25,6 +25,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_ftp.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 
 #define HELPER_NAME "ftp"
 
@@ -390,6 +391,8 @@ static int help(struct sk_buff *skb,
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED &&
 	    ctinfo != IP_CT_ESTABLISHED_REPLY) {
+		if (!nf_ct_is_confirmed(ct))
+			nfct_seqadj_ext_add(ct);
 		pr_debug("ftp: Conntrackinfo = %u\n", ctinfo);
 		return NF_ACCEPT;
 	}
-- 
2.43.0

