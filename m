Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7FB14BF8F;
	Thu, 27 Feb 2025 23:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740697207; cv=none; b=BDMAMJgGF3cmEFAhOaSQkFwabbSSUhTa2d0VNLQL+w6jO5Y+h/DT/CvxRITrs1hE4M5xbgIZ6IpKMaKxT40EhcM6HuWInTSkZGoRQHrq1VzaoVJ62phBiV+iw+c9SFNreMEGidzTTq13QSFSMTlO6CetTsvZURR4Td9t1lnIZdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740697207; c=relaxed/simple;
	bh=plZB6nttI4h15XHAy2tUctm4vCwJqkaepq/yarLTXjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eKUFsFCMlLd50p4El9t2u+cgYlFmB+bqOlrBskT7oI15xDe3ZHkLbH1BDBWReeqYs5yJlGDC5/gGa+LVon2NyJ2RgKuP+aY25KIGqFE0YEZvUZkyx4siy6+2/O3j6I/UO97+t7wdZpL2ddphDqRFS/m+gYopvWW/4az8u658WP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKduXEHU; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKduXEHU"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso15822765e9.1;
        Thu, 27 Feb 2025 15:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740697204; x=1741302004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CSTTn8dgXr2XP2qmQgDysPC6clyA8S5gqjElXgR2Us8=;
        b=LKduXEHU1CqRvnehJVWcwbJcUFxNEC3VQFbL+v5v2XtDzb/rksH56YRf/dHDK4zntc
         9MBAeAqb60PRNftWi+S/DbXIExz5w7Ga9ZYi/Ow6ccSaLZH1fvjnYjfzGPg6LHMjiviD
         V67wDfIU30VpjSLZYwkl4tY6K081ZKbcp5nm7m7ugrWid/GAOcpKH2h7bmqwcygIH0CL
         v3k0XtqNG5+c6RDRW87srxLuFT04pUAB62Y5Sqz3DFHceYDFyj7jME24XdaKq8oXeLim
         gByevqnedG+Xy61P9N+1Vati2a63g42bCgIpMKyGyglvfQVGVCU/7U2u02jzQr3Xw54G
         e71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740697204; x=1741302004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CSTTn8dgXr2XP2qmQgDysPC6clyA8S5gqjElXgR2Us8=;
        b=KuzZKxkkdaUrudaxzYfGER7laffosE42F+8xQxa3mn/NPnWQqHk1wLC4BuN5TbxAdL
         IorJKaFQUheK1HmywBGbhZZ9lz3NaUx2TBFE84PYXnvr0zIgNMS8xhrnLOwnSSFRnPtJ
         JYjMKIimaxWKeiAWXA8LfkS0pY9wN5ijCGynz79AZISJpMCHL9wOeuG2Eeb6FR3vDF8U
         lb+KPCuJ4foyDZx5Q/o+2JriXo3LbuxFLdkzqkx0Q4lKazBtPA7UMO84OXHKsEh7uAT0
         tsGhK3nUwkaUjPVFDJYYGAJrmp6+GkTpPeh6ngKPjH2RtvnV8vU+QaqOhlom/Is4tQ+y
         qJCQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8CakssYPCB0bYfW/ct9DNjeieMIE02vrK71rAvl8g78COaINBNYch12UQ3LunHYXgFwIhzmZ5/oaf6JE=@vger.kernel.org, AJvYcCWAWwwPbWDF/QtS8WD2o5LPXOGldBQYKgfy/3Mer8OtIYfbfu6WI2rcxRCWlYUYwz2TNpicUSUI2JrqagLosCD1@vger.kernel.org, AJvYcCWn77oQYH6WlpylL2ZK4Y8cedkVzl2aZytm+9ctXYDnYHm3LQMS/IhtfIqg2l3KPn5Px4O7Ehq7@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9EkL8gdg3D8yaP2msAOFscEbzNOxEMaB5deYBtWtX3fvqcn5q
	No6Hft2MI04K1qJaev3h7VY2tgZG3fI0MON3hpweYPqKKj+vbf2S
X-Gm-Gg: ASbGncv+3o5lvfEXNYVudJODvGCNhrYk1+jXdfJ7B9/hQjLNwWBM1C41TD88icO+xgq
	C9d4gPXHcx9uYlhxk6z/auec2+4WCrU5GIZilQ7ItHvjYhAHOOEniWFX+WunQ+xXbX6UBKs2h+y
	NT9BVR5Ppcv5BKaQ/ipOQTn9HQ85fxfT1wKLym20ADfunbaepoFymHyqs5ZOPtrFlTp+c/e/nMT
	xPF/4Q65p0OUc1YNNwJ9WFKnKvOOQGnfvPbZ1xq4Vp0GDDhAwpKoZohmSSQYzM53HGK7btoW8Py
	4LtGUnToL/wcKyn1GBlHnVvD9DE=
X-Google-Smtp-Source: AGHT+IGhA9c+hj1Gic7ekykbUYYS9qnUrSWSLFMiD7OZScDPu+zoBa4VJZ5UI8HQ4/XW0j7pZUBIHg==
X-Received: by 2002:a05:600c:46d1:b0:439:8544:1903 with SMTP id 5b1f17b1804b1-43ba674c80fmr7864085e9.20.1740697203440;
        Thu, 27 Feb 2025 15:00:03 -0800 (PST)
Received: from localhost ([194.120.133.72])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43b73718abcsm36327565e9.22.2025.02.27.15.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 15:00:03 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] [NETFILTER]: nf_conntrack_h323: Fix spelling mistake "authenticaton" -> "authentication"
Date: Thu, 27 Feb 2025 22:59:28 +0000
Message-ID: <20250227225928.661471-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a literal string. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/netfilter/nf_conntrack_h323_types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_types.c b/net/netfilter/nf_conntrack_h323_types.c
index fb1cb67a5a71..4f6433998418 100644
--- a/net/netfilter/nf_conntrack_h323_types.c
+++ b/net/netfilter/nf_conntrack_h323_types.c
@@ -1108,7 +1108,7 @@ static const struct field_t _SecurityCapabilities[] = {	/* SEQUENCE */
 	 _NonStandardParameter},
 	{FNAME("encryption") CHOICE, 2, 3, 3, SKIP | EXT, 0,
 	 _SecurityServiceMode},
-	{FNAME("authenticaton") CHOICE, 2, 3, 3, SKIP | EXT, 0,
+	{FNAME("authentication") CHOICE, 2, 3, 3, SKIP | EXT, 0,
 	 _SecurityServiceMode},
 	{FNAME("integrity") CHOICE, 2, 3, 3, SKIP | EXT, 0,
 	 _SecurityServiceMode},
-- 
2.47.2

