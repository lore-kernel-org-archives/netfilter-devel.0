Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC3C1482F5
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 13:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741787832; cv=none; b=g5NcvYkI17nDbjk/TH6XHIlD979zMdZW9PAAgY9daR5UYJdNHKM0yvW347E9chOhSvUHygPDSeyGcNce8t3xxoHmeIKBkXo6iCPtvqGwxgeyaXP+zT9qMH+aNwwyKRTpZJod+ibIzLtLo5th/1QRqcimRd85QRLB3bNlbVhO1wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741787832; c=relaxed/simple;
	bh=OpC381GAqPVnE28HQUMPOa1a+NuNBOq9xtqAPiHdklg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=SAmJYztIQQ6JgXUzQ4HyUtvzpgfWkeTiaCmamvZboPpKrzQW7ffvCi9wL16giwIvop0L64iCeKwh7/t+rX/+sor/Lw79o+HIVbkfwhM4QxNy7gAyq9smQQmy70J1TNaXfqTvvTimrfbX7R3UcIDkQP9+eOczdoAyEaJ1I+3muR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ddz5HGoS; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ddz5HGoS"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-30613802a6bso71927841fa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 06:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741787828; x=1742392628; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OpC381GAqPVnE28HQUMPOa1a+NuNBOq9xtqAPiHdklg=;
        b=ddz5HGoS8+YNgvMC2PcNuGCV1tXVUWrnXTqAZ630bojh8cEtSjx2F89aFiw+FQnjV5
         0OkWcrK1Jm0GSHF8JJamrMrOtDIEhqo1AJ7MlSEj1NpWa9Jpp3d+dt91hgP8pnEW0vIr
         MvsikrtD7SElsfnV0x41zoE0KN2qwfn/Q3Bux/QqoU/BIMhLGYg8/9cTInnlu2r7EYIN
         fJCxp4RclNgBbCCLBHgODwxvSSd2fIz9d3g0+Gau8s56sY8nV5XdezqXCHB6gsUQUlLr
         peqGQUMuAWXfTXh7E54is5l9OX72OklGg1h8zJiV1JZ0ZeP9qPV+Y+8eqsaLjofebQCb
         pTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741787828; x=1742392628;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OpC381GAqPVnE28HQUMPOa1a+NuNBOq9xtqAPiHdklg=;
        b=HxUBIwwpS7IVOZIiVlbV/0dMYZ+kDq7a9fHYUGyYvw7SKKCqRiA1uF/GwGZYgSXp0/
         njMRhzhHjFk7s8gbxb2U+yMFMlvQhrcrpuPxmSv6nakcCTf35xPBjjXKo+pa0usdJWxs
         Q1x/im0g5/QenBIiG23QDazk4NRA2s8uERvdqeX6KNXMvRjNubpjPqd2Mvlg2iXxQTKS
         ZksBPRvSncI+LSBp/PEoyw4lryKljIEZBrLBi/r7P54UXnoc8SfZfOmGQBwBoEQS+Q2v
         iYlJu6ZYWZPZmuEsiHDg38W1GvEJaLr7CJzXtNaUMPW3EZW5L7qPZdXIwsZHZzr7Y6wx
         VEJA==
X-Gm-Message-State: AOJu0Yw2AxFKRhZWPwLmPWbH1ddMpUpbZe6cvbO0b1+xwueho1OaoGMj
	0aa6GQs2rb9k30T0ujxrknTdI9iVOsO9RpdrGwXtjbj3lGCsSdrmbh19BhHPqqI=
X-Gm-Gg: ASbGnctXzWxdzO7PPrlvrP74BCh1d+3HU/PZdYPxqe/RYbWo+HXrsDzbRNHhltQNUsk
	oKPW0gCYjT3naPrH2aqIPHxdJT1MiJvB+yz1qdg2wMfK+P/BmM8tK7957fFOCt7Fqg6Lw4yuhFN
	bGdWD/HM21qT9yIkEx5JkQw+36QHmVrwpDG43YJXqkAkT/p/8OP24zAGitrMzxFOv4ohV8wl2LT
	SM1Henqj9E1sugt+ZycI3MY2yzI9Wo0iFfUEW69PcLuy8V6dDKOlVRsJxpJJm/Iq8a86NcGdo2U
	SsUv9ojiTCMsoxwHtbISKHq/Iwa95mm76u22YGcVsVhqVEi5R1CiitILz0Zw
X-Google-Smtp-Source: AGHT+IErHefXjGOwc0iaTW2kRXT23mIdgMfmgL74ogbai/do7Y60aNmlxEQHNpFN5MuDpUP627HDXQ==
X-Received: by 2002:a05:651c:2108:b0:30c:1308:1333 with SMTP id 38308e7fff4ca-30c130814e7mr47563741fa.13.1741787828187;
        Wed, 12 Mar 2025 06:57:08 -0700 (PDT)
Received: from smtpclient.apple ([195.16.41.104])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-30c0ac7f36csm14853791fa.26.2025.03.12.06.57.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Mar 2025 06:57:07 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] netfilter: nft_exthdr: fix offset with ipv4_find_option()
From: Alexey Kashavkin <akashavkin@gmail.com>
In-Reply-To: <20250312091540.GA15366@breakpoint.cc>
Date: Wed, 12 Mar 2025 16:56:57 +0300
Cc: netfilter-devel@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Alexey Kashavkin <akashavkin@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <297363AA-9DF3-47C6-9DA8-BC60E7BC8CA8@gmail.com>
References: <20250301211436.2207-1-akashavkin@gmail.com>
 <20250312091540.GA15366@breakpoint.cc>
To: Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3776.700.51)

> This is wrong, the array should be aligned to fit struct
> requirements, so u32 is needed, or __aligned annotation is needed
> for optbuf.

This is the old common case of initialising the variable structure =
ip_options, as in ip_sockglue.c or cipso_ipv4.c. But I don't understand =
how best to do it, because if we change the optbuf type to u32, it might =
be redundant if we don't change the array size, and therefore I have no =
idea what boundary to align it on.

> Can you make a second patch that places optbuf in the
> stack frame of the calling function instead?

Into the ipv4_find_option() function?

