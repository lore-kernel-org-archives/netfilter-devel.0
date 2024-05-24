Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FA284E02
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529086; cv=none; b=c35wuR8fEnZNR+HqtGYX2ogreAd0SRGB//W8+D0NSLw1zgCXMRd1T4MMVzFG2r0EoK0ov3BCpBSn0zEaTFiaHX7nOvDDTs5Buyys1iOK8nbTfhwXL4qI2cmpXHqq6kvXgvB6oCi/gTcFTDnZ/JsfglxieAJYwryN0UjaXBa7wGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529086; c=relaxed/simple;
	bh=D0VDJEyij7ePHpf5ohoiVg/KmobyoBDtXG1yht4FR+s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SxiXXrdRdLRwtLAP6nFbBhpFRtpMtkq6bdAMZ8BxUYEQ8WbFn2gNB9Audq4htagSvWSTXLy0gcOF/Sr+pew1b8Urb0bpIMemSd+aQLZW3q0hSl8HxQ/ZziJC9/DF0lZUUvFwFFFUWBhp9EWHUmIyrK9ixD5Udzbl1CTQnzJufLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iLAMcDEH; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iLAMcDEH"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-24ca03ad307so269441fac.3
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529083; x=1717133883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FgvhyBys4YdWXEx4RzbFqenso3uhtcnanQW9EPUf10=;
        b=iLAMcDEHm8W6+d+KOz5xwg+BKUaEyNp/jgNhyrdGIxzu3vndoyH8bopjn/IpJToQ5D
         OdDf1uOJwxNQ2QGDYukP7O6LpxHxpNwunXjfSaSBCSzYIhPxHJH85JZrvFwb1dhysZS7
         wV0x6Ia0GMR3kthdBuwOwVjPNK4XKxRsFmPdsbbx2KzGQ16OKyC+RDUiq7t9KnBcGi0m
         Lj1NRn3HE/GZaIXeweqW4AxzDrw6uu9UhdY+SK/alwHsCvSNvTL46if5DKDIUZrUDpp5
         VHmoi87gYiJpL6kXT0LI5vp0wfhXrjVFsF4H41ekzAmWVw+F13G9Ytel8vejkTmXW1id
         8RWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529083; x=1717133883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2FgvhyBys4YdWXEx4RzbFqenso3uhtcnanQW9EPUf10=;
        b=YadusZkWEBW3NNjL/koAyRw3FWJ0dH5h+yL/dM6NKA/poFvmg0uCvBPI/A66lKQANH
         nbKNKbTlOApkLQsGazOMgEDOtjwxR3yBIM+cWivQqP4ry08S+Iw1KSl9cQguy1MugGNW
         rPIkR1okRHUnzXTbZnkwYK8odn8YZBXZCvbaRQ+4olxr6FNxFbSZvAAr/CgXsrFru4im
         8p20mLiRvXHQbdoRwE18o4qUl79/+po/xPwGYTexj3pTSH4bUlNOkF5KSxasU/uz3ibS
         a2w2q9oEOnAqpazw+6NGpxnUj06fBcnqDLULvR8nRngXEMm/NW4yUCUNdv1f7gYra/cm
         5CNw==
X-Gm-Message-State: AOJu0YwgsQMDHEQ4qL+WBj9EKiRY4d6MV5mHc+SX2HUYD4nwvhr4i9Og
	erjSyLJ8GHSNUL7m78/Yx7ovGra25r65EjrmHv3xVw57rbGrxVILdZFnKA==
X-Google-Smtp-Source: AGHT+IHqZUhhEcRKrwNn3BOowjJCdVqHGlPd/IlS+GMFaYvs8AZTVd2MtCPue2MwLwtF5ffnLuc2xw==
X-Received: by 2002:a05:6870:1716:b0:245:4e2d:5d8e with SMTP id 586e51a60fabf-24ca116f89fmr1557284fac.6.1716529083658;
        Thu, 23 May 2024 22:38:03 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:38:03 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 09/15] src: Convert nfq_fd() to use libmnl
Date: Fri, 24 May 2024 15:37:36 +1000
Message-Id: <20240524053742.27294-10-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20240524053742.27294-1-duncan_roe@optusnet.com.au>
References: <20240524053742.27294-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct nfq_handle has a struct mnl_socket * now, use that.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 v2: rebase to account for updated patches

 src/libnetfilter_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index f26b65f..8a11f41 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -384,7 +384,7 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 EXPORT_SYMBOL
 int nfq_fd(struct nfq_handle *h)
 {
-	return nfnl_fd(nfq_nfnlh(h));
+	return mnl_socket_get_fd(h->nl);
 }
 /**
  * @}
-- 
2.35.8

