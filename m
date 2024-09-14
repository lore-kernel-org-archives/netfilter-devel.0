Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0C712C54D
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Sep 2024 09:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726307819; cv=none; b=o0q1stvOw0QVgMjeQlRfAm4Bddc/NzaKP1SAVWBRDf9vGwzAXLeBufiH2I7JpZUnwdbToMqy+JSJjvIVLJLzj8AjQZD+87rM1pORSHhYlpQQQTzzqnos1JlJIcJPDrZYfne2TqGxxmMe1PB9P1JhjW0wnFHMDVYdRLT833HV0/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726307819; c=relaxed/simple;
	bh=5/7xNgVMM5znzPlTwRdQPzrcGDt5NrLxOnLVL5Ox/kE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rQS4CazSs+ySWvqKEdhTU/JqDWN4FrRaMKaU/ZpfZAuG5LoB7p65jDUbp27y1mKZGr+ky7RQh95LgUnHufn+CW1pCdvW2tcDTNjo6Oro4FCCKPuLtiTmLbJLQ9ETnm3RxsJUBzgL6JLCqTgr+w7yq6b/0ueSvPPsL1Mb5hFicRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=R8cWZ7F+; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="R8cWZ7F+"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c42bda005eso434046a12.0
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Sep 2024 02:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726307816; x=1726912616; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZkttiUwbZSAhIQr2HB1QpBV3Ynk91TOIcc4nZQ4D7J4=;
        b=R8cWZ7F+VkvG5LxQGnbvRBxjNNGZwgSTiNCot7EAtRn3NT/CSfYnsNtRFDVthzLLXN
         yL7OCrKefDQJUmXORQqDJjhS/v4pPiKFNQ6neWpCVfDa1eOPTMilUtPMGJi8EzWyMMpN
         lkm355sn2DXTtYM0eTOcFraoP6Pw0a9597NreMz4Ea1B5qPqkHJzrLCW0Jb14ehbWeOO
         LDG8l2sZtlyWPpqGVw9JhLdjzVug944wE6EywV1Uc4Jjxv/FdaBDt5Yin+Bh1damXJcV
         AZ0cb22/ssFmhWTx018g1ByrGaaFYWcXm2SKRUOC6dwayKqrNVnhlsetb9k8b4PDZJUR
         iU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726307816; x=1726912616;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZkttiUwbZSAhIQr2HB1QpBV3Ynk91TOIcc4nZQ4D7J4=;
        b=QqXlEPunCWUkjprTmQ/ohpoY52tuYuFdx6Yml0ItlMS3C+EtbNE8/zqnZo1mTHXlfl
         /Q8PFfx69+bxW06iB1GfXNfHxMHs/KvhV6UUZWgI3kbElEp0dRtJLW/TEz7bsKjKMnD0
         rfDFzDnedGwIESvbbbhSdVwCJAYKt4bxDYUn3y7+kepqyQsTi85Ro0Mty7pewZjLn4AJ
         3P4Et7clJ+f16BOOxl41cqnh+Y/fFZump5LmFUb8wMFoao/m8ojGaOd2JxETrJ0kp+vX
         LoVWn3I3TGASywfycQT4+ruG6O1oVOm4nvK+3VQotxb0VHJ6hzclUxWvjQbTPHxkgtxc
         pWIA==
X-Forwarded-Encrypted: i=1; AJvYcCV3d1C0mPUXwJjHFEMNHh2n7OWcWL4eY9xTJAewSVKUiZ/3you7diyngeTDrQao/ZMsvdLd2XQ+Xv6ydIJDllQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLYXjlOOyLfvh1kOxlO0cYbViFPCEO+jsfYJnIo0FF0CV4zmWC
	4Pg37mS8nlI1KHKBcV6fboEEpsO5D7zn54bpaz02i5yUt/aJhLAecoMxxWK6KUg=
X-Google-Smtp-Source: AGHT+IHW72oX7a7JyqQYEvWLyhwpREGh2KNn57UUT6JYrRYTabD7lJwM/On03q66LCo0gYCNv4awyg==
X-Received: by 2002:a05:6402:5108:b0:5c3:2440:856f with SMTP id 4fb4d7f45d1cf-5c413e4bd3fmr6660928a12.27.1726307815533;
        Sat, 14 Sep 2024 02:56:55 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c42bc88d82sm497729a12.81.2024.09.14.02.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2024 02:56:54 -0700 (PDT)
Date: Sat, 14 Sep 2024 12:56:51 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH net] netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in
 nft_socket_cgroup_subtree_level()
Message-ID: <bbc0c4e0-05cc-4f44-8797-2f4b3920a820@stanley.mountain>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The cgroup_get_from_path() function never returns NULL, it returns error
pointers.  Update the error handling to match.

Fixes: 7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 net/netfilter/nft_socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index ac3c9e9cf0f3..f5da0c1775f2 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -61,8 +61,8 @@ static noinline int nft_socket_cgroup_subtree_level(void)
 	struct cgroup *cgrp = cgroup_get_from_path("/");
 	int level;
 
-	if (!cgrp)
-		return -ENOENT;
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
 
 	level = cgrp->level;
 
-- 
2.45.2

