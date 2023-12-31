Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36380184C
	for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2023 09:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJlHQwn5"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3bbb4806f67so4025907b6e.3
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2023 01:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704014345; x=1704619145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=RGsmiILdEoX/G0y4NlUV96ZepTlUb5kGckq4pt9sPWs=;
        b=TJlHQwn5VVvrOZ/kLN1kIuixgDhQxUqhVoXG45E43jG6MtAa/aF0fKRAcmU3zg2uKk
         mppF+D2tqduW7rcCobJvPZSxppyHQytpR13jZOo2IfVcxOmcerWYcTTygE759mD/+521
         xVOUDPEFqzp84CIKNE0O+sqSwcHmjilYIPIgS30rAE5Be6TeQoXLfzq3fmeMHu3uqdPQ
         fFR3dQqXWsGEdS2LILccHX5vESKxZj2lXfjC/j7E0yqmgi9A2LqUOd3Fpi3H3huM2fAT
         5FTGDq462/Xg8fL7yxp+8y/wQllw9qDPz5yhk6z6EsVfatWatIwG+PWcriJpuM8/rEWa
         ndBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704014345; x=1704619145;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGsmiILdEoX/G0y4NlUV96ZepTlUb5kGckq4pt9sPWs=;
        b=hRloC3PN4Cij1/fRmrLM3QDl3l4pCqZT/SNO7OrFsAujSy8EgIKSLJcxZMX5NycV8p
         bV4VRzsycGXTSQMYPmGYjSIRtO0SwN0CZnMWtm8wnBals0315qyD+RSEKVrmRA1SDjVQ
         1pdOz7yF89SN7ctPE/6tWwqBVrDs3Plq7D/fFEgBq02gJqCNGSl/zzwZ8iKk01FodfSD
         iPoYzop9vKOthFZwhm1yzyp+EINIgkC+e8OwU+6KYirJJ/gp/cuMMLtSWH8I1CJdKEE7
         3fW/+vvA32eavN5kn3lYKzMrSh2UU0/BL5cFeGT9wpskCKZKgQpmoPdrCYywr3ZzS/8b
         NUzQ==
X-Gm-Message-State: AOJu0Yww+odu/RtDgi1tzivTO14+a+FTUwt9KhTBEbYGOyrbprPtWFzR
	ylkvqaWYF3q1Je2pNc5BcvNF2B3xDQ8=
X-Google-Smtp-Source: AGHT+IHhtUf5GPGP6WW0EQlzp+wsV4lsNFLbtf49mHsLu6NXtM46X7i9HNQuVw2jBVXU1PagBJk6gQ==
X-Received: by 2002:a05:6808:189d:b0:3b8:b063:9b52 with SMTP id bi29-20020a056808189d00b003b8b0639b52mr17646015oib.68.1704014345075;
        Sun, 31 Dec 2023 01:19:05 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id l66-20020a633e45000000b005cd86cd9055sm14284999pga.1.2023.12.31.01.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Dec 2023 01:19:04 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH RFC libnetfilter_queue 0/1] libnfnetlink dependency elimination
Date: Sun, 31 Dec 2023 20:18:59 +1100
Message-Id: <20231231091900.27714-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo (and everybody else),

This patch replaces most of the libnfnetlink calls with libmnl calls in
libnetfilter_queue.
Please comment on all aspects of this patch that you think could be
improved.

Do you agree the libmnl is the right place for nfnl_build_nfa_iovec and
nfnl_sendiov replacement functions?

This patch does not include an updated main page - I'm still working on
that.

Cheers ... Duncan.

Duncan Roe (1):
  utils/nfqnl_test runs without libnfnetlink

 Make_global.am                                |   2 +-
 configure.ac                                  |   1 -
 doxygen/doxygen.cfg.in                        |   1 +
 .../libnetfilter_queue/libnetfilter_queue.h   |  12 +-
 libnetfilter_queue.pc.in                      |   1 -
 src/Makefile.am                               |   2 +-
 src/libnetfilter_queue.c                      | 453 ++++++++++--------
 utils/Makefile.am                             |   2 +-
 8 files changed, 271 insertions(+), 203 deletions(-)

-- 
2.35.8

