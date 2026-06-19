Received: from mail-yx1-f98.google.com (mail-yx1-f98.google.com [74.125.224.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B27369D4F
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 09:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781863089; cv=none; b=GCL3uTHEKytpNe6V3FJLJ7Tmm6YMKKHN2Jx3T2Ckdo0X15mcKTN5kUJqDvhwOVigFtipn/h9ZuqHPZwarCRuyslflmIpW2LIsHy3wi+Tg1Yx+fIJrh6Zrm1ld3Z0GlkjeENRMG+OPALfPJRhK+PvUsSqUrdYE1A5gh9VA8iRB/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781863089; c=relaxed/simple;
	bh=gnqYplrvnOKhysmkaWxCDnkGO5zvC2BvTJjxuHPuzak=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YPkkdol6109Ujr37MBmJppQLgYNPC27WxNkGc0h2JmSVyTrjKqhHAmKqoZSy1mIn0q5+Xnghq2BwZpNeirDMeBmlC+uxz9xM7ZffkFO1K+jLVZeDo9nMzQomPo2P6QA6imu6ulCImu8uqHI15IseBIiKDnuLo9Z2kf5V/1H8ZHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=WCtI4nRV; arc=none smtp.client-ip=74.125.224.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WCtI4nRV"
Received: by mail-yx1-f98.google.com with SMTP id 956f58d0204a3-662b76dabfcso2242262d50.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 02:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781863084; x=1782467884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RMj6/kEzjl1ru5UHUZhZ/YyeC10jEp1W8ogblv+QKRE=;
        b=YewB4XITCXtpVQIcKFTFK49OBvNmnPrvSJm9aTRPao+16rCGk/3TGuPB5gjmSnpo2b
         PF9y7c0i6DtxBwl84S+Xy4XfDk6oGSC7JUtO7sl3YzfBDTnYrcdXzCAevi3/hPNIuwRd
         lBSVMa8XiB5SIy1b4pop/fsjySVOf8GrDPj0Hi0b7B0gAmKHfcozjG3SAH0RjjBxN7TP
         klTZod2PJG/3fuu6oX1ibR0krCUAW4V8GWriBO5VPwZEWeeNB1KD9NthiAJhK086jz6L
         whWIjJRa3srlgHgtjK4Rcae7E3prYXzriZ3L59G4+rYShInGLxLHBgJrjZesJrMgcqBK
         WQaA==
X-Forwarded-Encrypted: i=1; AFNElJ/HoWrtmH1L0oamvmky/OnNCQmcX/s9PaoFs51t/Pj00HNbzIevAK5K3l9AOhRSog1xIOToB/3QZ3uKzTk1sZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDUPz2tBMvgTVXGIu84sxDlkjaFZ48jomQjDIctvkXsneQZz8J
	2vf5h6Dw4FyydmsMnIKsCj4a2/eTYmI5GE2G5hkxT8ryD952KAluXSouOP3nPViOgI6ZVMs4PON
	BAaKxLFTd5P14NyCeWX3sR1Mxh9N1++opWRA77xZi+E995dnAwNdzftOxPP5c0zi6DchauKekcN
	lv+ZZ8fDG/j8UVE1Ul9OjoRw0nTxAwGOImvWCJMnid5hFi/HfzdlpcJ0UUz2sEv/vFBxk2RN6+p
	+PiLqeZHJ0gsD/YXJz6SColnhkiAA==
X-Gm-Gg: AfdE7cnlaNbRnsW0LDOO6EqJ//iEGEN7o25y0yjT/bEXUFwDh3YtlZyelKINmtUezMU
	IadGUUx3XXIZH6MEdcyReK1b722EfDPxCuQROM4dI4eQuOfb55FjSBqLy8oAHvd4OKZWze3lFqD
	7HtO4vIoaTipZBE0Pncya/JncBkyjWkOgPrQiNvjfXNPmVHL4RTW4ld589maLI2jDU25zCW7IWf
	quP1MvsLn9TiyGUuWL76xdnGhUu99oWOl8rnc41zuyuz+JicbvF/44xbGAT26B9NW/lqfpQCPKy
	RlUNBjCDtPafAPyho9Y8xVaLRE4/SJASzBbP8uXyjwyzz1SMHcj6EJSj+XWM6edGuyRSyDaxGZh
	ZXUCMM86eqDXnZh3pi4dsChcMgWQSVwtG++7S1hoPZiXnnzXx4yAgDQsQ4NvZMoWrzOPDLG5df0
	cPjguxBIlAePAp2v/OwJG3guX0c5323NOMcoNzJzEMNtBW5IrP0Q==
X-Received: by 2002:a05:690e:d53:b0:660:77b5:5342 with SMTP id 956f58d0204a3-662fc659de9mr3039418d50.2.1781863084296;
        Fri, 19 Jun 2026 02:58:04 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-662fde48dd4sm138076d50.14.2026.06.19.02.58.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jun 2026 02:58:04 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30beab99453so3155726eec.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 02:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781863083; x=1782467883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RMj6/kEzjl1ru5UHUZhZ/YyeC10jEp1W8ogblv+QKRE=;
        b=WCtI4nRVRHE+sflh9YeAaN74he+ZXuZaJvY5HUjbJtJlqv+PUhtodFVxLqL2N53z51
         Q2HDeIwK7YTQeoSY/EtijfweP/J3Giq1GqWybrdnhnsDE9IpG7XQ34fmoAC+a0wFwDKY
         XjYcsXKwXq1oyyyfGhbpRrTHKbvQ+xj8wQGpA=
X-Forwarded-Encrypted: i=1; AFNElJ/hogIfOKrHr6U4iHC142/5cHcGGL4pHgRO9eqCwZwLnnAv1+L4LMUVAJwIC4g9rfs7ilA2ky8G/+7IljLWGxk=@vger.kernel.org
X-Received: by 2002:a05:7300:cd8d:b0:30b:bda8:a70b with SMTP id 5a478bee46e88-30c06fb6c08mr1706533eec.4.1781863082607;
        Fri, 19 Jun 2026 02:58:02 -0700 (PDT)
X-Received: by 2002:a05:7300:cd8d:b0:30b:bda8:a70b with SMTP id 5a478bee46e88-30c06fb6c08mr1706518eec.4.1781863082047;
        Fri, 19 Jun 2026 02:58:02 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c06d5bec5sm1851910eec.26.2026.06.19.02.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 02:58:01 -0700 (PDT)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH v6.1 1/3] netfilter: nf_tables: always increment set element count
Date: Fri, 19 Jun 2026 02:28:48 -0700
Message-Id: <20260619092850.1274076-2-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260619092850.1274076-1-shivani.agarwal@broadcom.com>
References: <20260619092850.1274076-1-shivani.agarwal@broadcom.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d4b7f29eb85c93893bc27388b37709efbc3c9a0e ]

At this time, set->nelems counter only increments when the set has
a maximum size.

All set elements decrement the counter unconditionally, this is
confusing.

Increment the counter unconditionally to make this symmetrical.
This would also allow changing the set maximum size after set creation
in a later patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
[ Shivani: Modified to apply on 6.1.y ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 net/netfilter/nf_tables_api.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0c4224282..ec4bfe53b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6670,10 +6670,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL) && set->size &&
-	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
-		err = -ENFILE;
-		goto err_set_full;
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
+
+		if (!atomic_add_unless(&set->nelems, 1, max)) {
+			err = -ENFILE;
+			goto err_set_full;
+		}
 	}
 
 	nft_trans_elem(trans) = elem;
-- 
2.53.0

