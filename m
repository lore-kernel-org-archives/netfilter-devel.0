Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F5FB644
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 00:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723681087; cv=none; b=r12HE+AwKa8xCHnt0nUVp5ndFOOOUS0zGLVAbSrRM7c6YPJfCUgJ7j0eVI9eNLTHP5LWYuWuQ4RyYKnVH2PRapBQxqnr6fP85dsmXlljM2Y1MOqWlBrDX6q4F6rtIAdm8N6bQv0YkizObp4yaIFIhtZASbxj1fRXotpqIzuNfkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723681087; c=relaxed/simple;
	bh=QCUD+NpaGDU0iTj3LxXTbYccuM+wEUt9DvEooj8jKrI=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bufIpQY2wc0/m3ztIN7whTdbmYVCarxYof8Eqjfgty2pl5FO6D3HTYGkdUuDsT7LywR9Iv5JQcH73mFr+ALhsaRp5Sn3G+JrzXyfEMzCsv0f7mvwvGk1XbLiQmCZhCoAkUtvlVEz3aXgC1NngE7ZBeqiay0mCjpJN8hkQsyNMuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fh5+u9a5; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fh5+u9a5"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70d1cbbeeaeso337986b3a.0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 17:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723681084; x=1724285884; darn=vger.kernel.org;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QCUD+NpaGDU0iTj3LxXTbYccuM+wEUt9DvEooj8jKrI=;
        b=Fh5+u9a5d8aNRC9UMInqaP53/j48i5WWwZzh+w5GS2IylbeQLkLBe60GPOgmGyerxY
         oQWhvEaTBtCu7Q/LxWjGIqcMphSPt/m1NMY+auPXE4BfFMRJol/UTn/4dfOOPTsX95CF
         fv9uGsrrTzxhuf9Z6LQ5rxeOcePCmCRA1+1xkJbQU5ZrZ1VAxRnTgZgdM8ncQtRrflVp
         XQl+iQ6q0etzk/nCAgJTDDzEsaaedqRCEtCNX0N5j6D0dhCumZ2YTMKxewvyDrOFEj6H
         yPRJRvgxebFNfxteWW/cq9PhiB28ngxUMYg/voa5/C08aWhtJfjQyRg8GLENhDgVwhbq
         S9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723681084; x=1724285884;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QCUD+NpaGDU0iTj3LxXTbYccuM+wEUt9DvEooj8jKrI=;
        b=C34o4RD8eTDp+Qk8OqWPtMLM7nWYeNTEsoCAi3ztACgpwbQcWAVLV1aEdad/i3v3tx
         mgGY6JB3Ivsl0O6/YTUTiMtk1c1qJOCuDuozkhIeNLGzdPqiodKveVvfUmwzfBXAhXmf
         8+miN57tB0RwkdkGyqWzhSkzxG2htxpVgyTVDNE2qIvcyCjErAxo2W38TtcQtWmnaiBv
         RuCdKSFyIpj16RnB2N3T49KCkyo6BqGfsEPZ34G8C7nlx//Gd+gA6EF0V9laDFqTywUS
         F3radNMEiDi2NfgsaKs2s1JWyk924ytymNXouC/S++fJKidhtUfcPVjWzBajBSUPQplU
         rcoQ==
X-Gm-Message-State: AOJu0YxjZgAdxW0nHhkrma6MtHo9aC2Up9hz7Vvw7nLYDjfe/wdJR9zu
	ZhLOD1xqvbIztlUwEMiAaWhXO51zmWOo2fuiZK6Ha2QjO4HlL2t8sXCRfQ==
X-Google-Smtp-Source: AGHT+IGGp2vHDSQuwzTa1mIDtSVxSaykVgP/8crCMw4vQwOLrZUElsCOprx9iE3bsoUivIVeW9Vzvw==
X-Received: by 2002:a05:6a21:b8a:b0:1c0:e68a:9876 with SMTP id adf61e73a8af0-1c8eaf8eb81mr5302322637.50.1723681084105;
        Wed, 14 Aug 2024 17:18:04 -0700 (PDT)
Received: from slk15.local.net (n49-190-141-216.meb1.vic.optusnet.com.au. [49.190.141.216])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3c863cef8sm237591a91.5.2024.08.14.17.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 17:18:03 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Thu, 15 Aug 2024 10:17:59 +1000
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Please comment on my libnetfilter_queue build speedup patch
Message-ID: <Zr1JN/xKIuzi9Ii+@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

I submitted
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240628040439.8501-1-duncan_roe@optusnet.com.au/
some weeks ago. You neither applied it nor requested any changes.

Are you too busy to concern yourself with libnetfilter_queue? Should I
continue to submit patches or will they just be ignored?

Cheers ... Duncan.
