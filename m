Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA69328DB
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2024 12:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724849258; cv=none; b=VGSyL2VDGCFgFmjnO2Fu0AF1bzhfqe3GXXykVyoNIDToaqoG1RZrEMGxibnCuLiQGefXJWljXMuZF7iTMkJjW5qyp7fmP9gSiSQUvypkjNnck0nm+4jRQUqJ/YeiemKX/S4PuUb8SFHGTV9wesoh91ecLL/dQRTu0ywtLm3Qo/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724849258; c=relaxed/simple;
	bh=YO5nEXB5aTN20PPbQ77clDotHNqzxK4Ts6E+Tu3xfNo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YABqBHogdkmWIlCN5k7CeY9qame7J+HSowetIJfPcUsSVj+3zC17JM/FWAtM5/LeTGRTJz3GbAw3bUAa3QLflptoJKz2rBbVW531GROXUqhYm65/eTNjB2Ejc3L/99DB+fBHnDxqwfaZmoO3TeWzNC2C48gJ+8MONimejSe5/3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=OTiUTwan; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="OTiUTwan"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-371b098e699so5442309f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2024 05:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1724849255; x=1725454055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5iLofNFhaqYBBlXfcdbMIjK8SePu//vPrew5aKhTAGQ=;
        b=OTiUTwanW5R+m63gsdl/mijrumyktAfsBTIHyouuyhz8aFtDf5kT8Xd506Hojqk2zP
         mTQbJy8Qt53wnpGQWelgq+PsNYDgr5vHGm5d1f2I0y/dSAhXK1arYjPS+IHqd76FMrV2
         s7rzVxy1954qqytJxBjb40t00H687e42tL4iiq1Nl44lSVGtNLvj3n9xDTkb/KTAYZwx
         aggkpEypWqbWR2rbsmz0+YboKsLAWeUBnJkRBr6xke3OIVEZiYwHqsaytieJOhoXaGPi
         7b8wDBtSWGpU0cCoeABmlbJWMLoxstxrz2f2TFKevlxsx8hyNGiB0IbU2Cx8nZ/X4PB5
         HOSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724849255; x=1725454055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5iLofNFhaqYBBlXfcdbMIjK8SePu//vPrew5aKhTAGQ=;
        b=VdBglA1ba+5Iz4dTfbuwmd8CulU8392Jl7cVLGyC9ywFwUZsbgdeyfrLsGG3NFoagW
         J/0gm19/41UGF8WkPcNBtGixJvdpNwi8kYctFORgMs1Xt0aNewxXwPL4lnEVSpxPlowV
         L0qE/ZsLZlgKjQdOu5k2w+W9VptVNP1WP2MmYlV22t0eBVG1LTTmpw6WG3pSY0FbvAl7
         vtygUl7Yza3BS2lLg3bkfmz+T3myAXXWxv3CkjT2k9WREOgBDVBLGs27f+AzcqZJat1E
         gLp7Vn5zreiXQj+fK2v0UTkedzXNNeH+htvRm97gfUbIHF+TekdO/mUqVWXXx6pt873K
         Vnyg==
X-Gm-Message-State: AOJu0YyhdgVWBclsaBGwrcsMrWhmLxhJPlBcfDg1OFiDYWCEF4r9DsjY
	x/pEJJbcR1eJA6//LdzimUjgNDjM3OYzboQ0g55TBEXVkNRh2n9eWwJ4yw==
X-Google-Smtp-Source: AGHT+IFxUr08dq4fdcQcLyZXhhZgai3J+VeQ0YunNPFNyum2AX6ufcNs8c+Xlj1OtWNsEO5JvplZqg==
X-Received: by 2002:a5d:60c7:0:b0:371:a92d:8673 with SMTP id ffacd0b85a97d-373118c852fmr12878855f8f.44.1724849254395;
        Wed, 28 Aug 2024 05:47:34 -0700 (PDT)
Received: from thinkpc.. (shef-16-b2-v4wan-169484-cust5160.vm3.cable.virginm.net. [92.236.212.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a86e5486264sm242777966b.39.2024.08.28.05.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 05:47:34 -0700 (PDT)
From: Joshua Lant <joshualant@googlemail.com>
X-Google-Original-From: Joshua Lant <joshualant@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Joshua Lant <joshualant@gmail.com>
Subject: [PATCH iptables 0/1] configure: Determine if musl is used for build
Date: Wed, 28 Aug 2024 13:47:30 +0100
Message-Id: <20240828124731.553911-1-joshualant@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As per discussions regarding prior patch adding an option for
building with musl, this patch automatically detects when building with
musl in the configure.ac:

https://marc.info/?l=netfilter-devel&m=172426460502909&w=2
https://marc.info/?l=netfilter-devel&m=172086278122266&w=2

Joshua Lant (1):
  configure: Determine if musl is used for build

 configure.ac | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

-- 
2.34.1

