Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB432FD1D3
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 09:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760348104; cv=none; b=Z4Cp6Zv0YFOcLwnwTJZ5mMcwaKdi8BzO8Ao+L7lmsjxk/R4Juq2mgR+yW+Q1N5PRzer3dCCrLLkgVKMuZacrad96RzGWeRQBLw6OMxN/3nR4K0I14Rryq3ZXxqlBhFX/Y127V2Zd6jZ+IUlXNNZq+3vU4PloLuU9L/ykoi7lwwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760348104; c=relaxed/simple;
	bh=h/7JTy6TbprU+dCtnUq5sVaFosiidQqOxR/pPvZSvKA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=asGdjc+ShQ708BX/3kQFGJiITgAxdazQS0BLZ0xDWdJE+G6YpgOkZvtY8Fm9q1yzTZaFu3H58mJLEqnA1VjiDcqGAzlclZWWZZ4cVKB3LsptgVbryVvXK33hRnVCaVj3X9fC2iHyJawitQldvIVxmarMbDxpuV0GuJ65uBrp5WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mnx1SxTk; arc=none smtp.client-ip=209.85.210.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mnx1SxTk"
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-77f67ba775aso5726734b3a.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 02:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760348101; x=1760952901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H5bKclxFecJJ5GNJZlIb9xGDoD2UnMroqAQc+H9CWag=;
        b=mnx1SxTkrQzHYji3aeb3q4OJ91PiRt+A7UU+c/8zJExuePN2QeB0IklJwTH08iodb9
         88kDaaj4FBNqNOtBTe+OejuT3GlNCJcZwjgASUnCU4a0lR1yY7M6QZR6UMYWSiSh5+GO
         Tx9y1tJ+iZiuZITt5suiuPdQ8g+j6ane0nytRhF/zsYd6TqiinT29kbbjZ70akhtMZz1
         gFItwEi5eZMaL56EE8dNlJGvP1yNkZmlgkCw3CxS2OJ+o/H2ayhEoUVgXk9QYP8jfPEG
         9VDEIuB/nihlBX/vMp1CSrmHCqgPinTh+LVg7YqCqf5zQyg0oGEC9NUJm0Go6V+SR27i
         L8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760348101; x=1760952901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H5bKclxFecJJ5GNJZlIb9xGDoD2UnMroqAQc+H9CWag=;
        b=iCEBOf1UZLZ7FWA4CbSiUeBRqk7jM+POz6RMsl1jzVzbCaXVKaz/AV+ZrL5V9GRGX5
         TIHHEWgX8m+zaEkQNuCNZBwmV3UnwGj7TFN7z19J/ZqB4/DeUWKyeqT6F4P7J+IPuDpj
         HeDaSNCxywsaY1RJsdzTekPDIW6/Y0F9+fOtY6aArYwsVLOHwCAb2xg6ep/QzRnjvktU
         p26Sx4/rmy3XMzjMfM0GcsISTSqTFtJ2Pk332MLYNByae9bIcVkDd3vRq98Na2GOh9y9
         yBKAEWwmbGgXvSC1Z0SaY0FWOZb/nDaGW9lbn4rqiLzVVpbStcuu6qkEEiyf+5PdJs/R
         3ekA==
X-Forwarded-Encrypted: i=1; AJvYcCVk1bhmQgMmTzPPIALKQzoOmJRk7Wm6PtOjglmDGuQV6Qp2H6obg3JFMILGgirloVyWvXuhPglBaJeAcZTM6ag=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQKmTKgoHY9iFPX+Pi4o/daIenzVi1+Ch5TN0SBiP9bOEu6nKX
	8gXCFpgT4pWLuLKi6YN6tysxOrse/HlEZ6fB9/hVkWPnnQDy2b39slPn
X-Gm-Gg: ASbGncuPX0ZR4gb3REzhV3m0h8PznPnB5j37RwaScnRz1hfv4ifkACdxa9Mc/XUj/bj
	TX9/qfzKTSsl5EQ3Sydy/S7lICrjk88OWiczywtVEbdDg9WqSYuUrJhO36Gxx6o0CFxzbYH4jtQ
	0kebD3BNiAD6HAdQdJFW7fqaV5d1bwNL4Xm6L/pwbj3KiQeh0QxJvMm97NtcIcgjEoZUBUDVQsQ
	JgRYldzU+ONf2B6966m6vfbMB43vAVjQhdl1IIe0A1/CyedXWCp7BG6P4perNExavjEPxfpuVgR
	/YlifcaB+OJLa7kZOmvSRB2ufJFTX0IqjtjWl+lBbOXbnbrWe4uj613SveD6Q+7wggDGwUSIch4
	q4oRIJDJxc2aRfGVbwY6hQ3CN9a1ORwUuUheVOUKqAfKqPqbw2Ri9WEukFKoRA8hnTcuxsi/3WQ
	==
X-Google-Smtp-Source: AGHT+IGPAzAetlOptAzw9GaNxbD3zKkFT2GadJ1WyMX5hnKkmmcKAsypxbC/VTf8veeCOAjENtE2yQ==
X-Received: by 2002:a05:6a20:7291:b0:2fc:a1a1:4839 with SMTP id adf61e73a8af0-32da80da6dfmr27467709637.10.1760348101035;
        Mon, 13 Oct 2025 02:35:01 -0700 (PDT)
Received: from LAPTOP-PN4ROLEJ.localdomain ([222.191.246.242])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b678df952cbsm8693944a12.45.2025.10.13.02.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 02:35:00 -0700 (PDT)
From: Slavin Liu <slavin452@gmail.com>
To: stable@vger.kernel.org
Cc: Slavin Liu <slavin452@gmail.com>,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@verge.net.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org
Subject: Backport request for commit 134121bfd99a ("ipvs: Defer ip_vs_ftp unregister during netns cleanup")
Date: Mon, 13 Oct 2025 17:34:49 +0800
Message-Id: <20251013093449.465-1-slavin452@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I would like to request backporting 134121bfd99a ("ipvs: Defer ip_vs_ftp 
unregister during netns cleanup") to all LTS kernels.

This fixes a UAF vulnerability in IPVS that was introduced since v2.6.39, and 
the patch applies cleanly to the LTS kernels.

thanks,

Slavin Liu
