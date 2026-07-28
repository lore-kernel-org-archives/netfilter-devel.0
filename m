Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A8B39EF35
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 20:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785272125; cv=none; b=aE1YeE3mPXX22giFcc7kUCR6NzKabBYT9SdJS94itQxadVy8Ut/7IyMqgoOpy6GmVBrsTSJV6mnKp4+YQ/IIdZ7RQ0cq3b0JdzeE1mm0Gzj/JRrR75fnvmdV0+23IAmXtzcTXW11aj+IGJFfuuqE4sfR1QwOEc+0kx9TNfT4QHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785272125; c=relaxed/simple;
	bh=OTB56GxlJgOKKJd6NXh47aETIjQI69CCa5gPhkOq/o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naquGZWEfRThqm80wGV/TuvvuL8yVLhOMH2Y2tu9ND13DeZgOUyTd1+Uv8fZuktYnpSyk2Bo8bGJHYSWzWf4hrtU08YSecxo3UBYDAkoB2RupN4DCa2esB+DBywjQjs0M/xzF2iDaeSI+9O6MN5Al4phtkSpUw7GrYIzNy+m0qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B9pNmmaE; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B9pNmmaE"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c99eaa1f020so169747a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 13:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785272124; x=1785876924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OTB56GxlJgOKKJd6NXh47aETIjQI69CCa5gPhkOq/o8=;
        b=B9pNmmaEy+C/djLGWe+GqDk1O8tH+ZqS/gOnJjPX+UGDjPKUJ/3ZWqTro5z7xXOcQQ
         b34AtWLvlXsACzse/i8oGQAF4WtxKitFiSpGSvrGTcAO8upxbhJBLDH7maKWC0ywNfUA
         1eLhMmEwMF/KMV6DS9E4A76fre30NjpmfthW9hERm9XN+0+gCrVN+8uebMqUPFyVaXeZ
         sqqB77QQBSqKcGoycudqL3nryXFc0pylHtcyotXwbHCbl6gUKf0jDD/hfdZiwd2lIKFh
         2FfDKcvoub37FO7CcwlP/F3bWwghuxtI0YN35fjyv6BPDpUaN4e9Pp5lTHxCYnTO5eT/
         4uFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785272124; x=1785876924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OTB56GxlJgOKKJd6NXh47aETIjQI69CCa5gPhkOq/o8=;
        b=k7aiPB6epO2hZz6Qp6pT9vrMp+EGMaBC0Kj4qCU6jzzLZhnNMZ1d0Vnv0o32dEBRT5
         +n89NfXVKTXBD8U+ZtnYQwXUGs4Bdoc6qJe0NmxIAvYex/agT4t6Rm1OkYII/hYJbGoI
         nW49MN9vRrR35bFGdmOGi6O32y9pGgLzRwxWgi2QH4TzbErisCd3GjHLdbXXHYNpj1SW
         JZ9S0A7vhU1CtQkcJc9J9eMBt1NZl9j8nMRl8hBRjUjTzLnAK4Oc274XidixoNNE3idH
         hIZlk0cOANepnRr2mmilrcqQBRe0CteRSCjxHXwbfYqDivfgVgU1k+Fn+TgdAmAScb3S
         IeOA==
X-Forwarded-Encrypted: i=1; AHgh+RqMcrK2LVR4OKsHnveN2kYP8BKQUL/u8SwgwBgnbZ35eyv6ks89/t7COaEj4pxw10nYroRQGSAfJzfAczMXyUs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo0yWpReHVr0ef+ENJK22L0uxQwZDC4toIghlS/AbbUO3xUOn2
	MNtpmrQu7TDENy6TKoiJWyRRU6iIFZouzazCKOFsmp4o8sh9TsfRMWVJ
X-Gm-Gg: AR+sD12NYfJNUKq1XIc8BVMy3AxpDuOTjoGiI17jpfdGIlKNLbOWGTJ0aldsf0dFYjq
	iVfQ8JCrJQe0t6JTgo82d/LfaMT0pOzsBigzAl0v0yQMU7zbtKDCYwX8hPzramvngl+fsCSxmEr
	xoZx57TQGnQimVle7ejnd7z9CN8z6aO4YE0nX5bUfidEVBIQd+6M7KREKE+QNBYg/lLjZPU4FQ1
	j2s/8+1D121ddstgKUFzFZ1lLQQfmD0JAuUjCr9wW87bwjdEVFtDcQdkQsvPZ7Nsrm5SZHwd+Sd
	glNfMN+wGGZs3LFTiHK9+t4nWTd1kWB/CHw4rHtb2iHsGi2m+td43f9+3/l5Af+puMSr1gVzSG4
	HFYb5JTSaD0qfsIWyhAmAP5OJv2uMYAj2NWANLeD8/umn/BVtjKLEPlSpFne9AqMNImCwFYm4Wn
	OmHTpEu73hT4cHc2WHT73g5ysalu49VU0qmEIqdWkxGm/DcPJa
X-Received: by 2002:a05:6a21:6086:b0:3c0:9c1b:d0b3 with SMTP id adf61e73a8af0-3c8ba625a6emr5267603637.62.1785272123891;
        Tue, 28 Jul 2026 13:55:23 -0700 (PDT)
Received: from r912.tailbb6e1e.ts.net ([160.30.85.32])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7263cfd9sm3105644c88.4.2026.07.28.13.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 13:55:23 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] datatype: accept a numeric cgroupsv2 id on input
Date: Wed, 29 Jul 2026 02:25:19 +0530
Message-ID: <20260728205519.2192731-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <amkRlAy1nz2KMx5N@chamomile>
References: <20260727082427.740789-1-avinash.duduskar@gmail.com> <amjWjTkt1Dsh66Xv@orbyte.nwl.cc> <amkAJuVZmpGy7pvY@chamomile> <20260728201909.1773000-1-avinash.duduskar@gmail.com> <amkRlAy1nz2KMx5N@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Jul 28, 2026 at 10:31:16PM +0200, Pablo Neira Ayuso wrote:
> Did you consider to parse this via integer_parse() for consistency?

Yes. It covers the round trip, since the listing never
prints a sign or a leading zero. I went strict only because "-1" is
quietly stored as 1. Fine either way, your call.

Avi
