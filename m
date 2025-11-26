Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20F133BBD5
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 16:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764172820; cv=none; b=soxiZGeIfR5DAYRhsdPb41F/9XLbaPth/a6QTS5xMuvAIBoge7jVQEMWm3V/7ygZ1NzgkmszgUIOvefMR9q7l/INt4GLVsJ3NElhSjwC3NEiYJxfR9HGCpI9WNMpgIhb9lgmvtEy4+TQskoFYZkW01GhZbnhQMhfw4Q1PsGcGMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764172820; c=relaxed/simple;
	bh=4dgOQdSFe09BlSpQ0D1vPz7WGtU4dRgFVV4sE/+Zdqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aua/FEQoTcPVDXJCLuRfabQW63m+v0g/FAOfNuitt0Z/CrFSZ0SyOQNGmfq3kgnZTXtq874bnBrp73p70oBkzFzK6CVeNKX2JQe53TSV+FHWFgZqYNiuNDdiYMNBZwax3qcR73yPG8GAAQlfTEyogREg4EZt1LpRTmbFt125IvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HAlYW5Lh; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAlYW5Lh"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-299d40b0845so110624135ad.3
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 08:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764172818; x=1764777618; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4dgOQdSFe09BlSpQ0D1vPz7WGtU4dRgFVV4sE/+Zdqs=;
        b=HAlYW5Lhcboo78KItzOwz+aTvGc5Xq9JLJZyN8W0i9VWBNHSfJwIfh5vHPd61ALkkv
         K6SUDzMW/ZuqSiqru/JyI+mKFAtSc89cx+6cWPLk0lRu8HvRxvybPz8cIJDOVUOROqfP
         dLwZfBf72FsOMZ6IRi13oc4Z9kMFtaNHBZuiPq+W/wIRk0jTO8k4fOcBEh81Qmi+68LQ
         1efMOZlj0RqNGRDNSIxvmkWDIdaJVbZ8jYVb+KuEk5+XxvoSEulhI6fNLSo0navcUge+
         hLYCcat74ouESqp+n7wjxO8gi4vLkrvJZAMsUXhV+A0CU28qV+R4ebCh1+WCP5yanwZf
         cNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764172818; x=1764777618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4dgOQdSFe09BlSpQ0D1vPz7WGtU4dRgFVV4sE/+Zdqs=;
        b=QzDbjFhZVfq9MW6D5QSJfafdlPEbFhGp9aFeylrvKyZPhi9xqcpg4thjOXR9J+u8/W
         o6CDrOypi8t40q0QuOcgfGKJv1eoS2faYovPM/HzKrEb35hE56Jlo/EOuF7IX7d2u+oX
         noFyALTZ36X0KTXvreWjrfUFl/7BDflYI7ToZZwf38bU+NAUVx2FHw44rSuMwGjAgHnv
         O4Su2DZz2VQp0Wxlc0GSrbhvFKDpL5R8FaW8RPf/my7vdXsPgRdoItBQFzzmwLWnd50u
         YY7EvOcSANCoBf6cP182hpf/CaluVCOtsmksIz2WgzuQoI/onKdTCh+cj7rdpREy/q/M
         dlXA==
X-Forwarded-Encrypted: i=1; AJvYcCWHugfpYg55KU4JReWWMZQ/KNkAYU6QckyQGO5MPfE/K4CWT1nNNVZy6ihY6qoFEE9QbtLzVH3Qe+nLrF8u/Jo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+C2qDg4n7NHXadVyPpqhGw6/x9hfPQ3pVa5jzwxz8O2ACsp59
	ypPm9s+7lTQnLK1JGVrOHQlCvUPoA8tPddED7eQPVV787ETce1v65cJn
X-Gm-Gg: ASbGncv9recM8SZu7UCiWA57QXBa7vw3i57T3Nuv80/x9RIAuCXiS+pLEesWZLJDhIl
	pyhKiN9yvASAqR5PCMt9syPljZriWDUJ8aIDFJXA2wBiUwo2oFWfT88uBol85vdqmXmLImvNrLY
	NrNamASe0wcNhKWckdAHAf6MKSIhvQCE/2AOSoHk4f1KNt2pxvAAw8oBA8MqMXk3shqH+XZ4pKy
	mXxCS52n4pSNy3qg1G1ymszmB6JpI1boCo8jq9DocrfZtN+cMYAbUCvB6Z+qcxguSr+BuvlPVlA
	IuvDN//TDnGSFfxFPAdo0TsYPOq2LaZ7m4ClvT278nMxKxlTh4/b46CQPcvw3AveRPnMor4csAU
	2rJyPgbk3h/XqH0dqmYnzHBJygnNpl/fm0pbYqwcQ/NuON0opCBGfWq27precy9SZNitAJz3czp
	QpsFEtB2Jc8B8=
X-Google-Smtp-Source: AGHT+IEN1dnseFjkRSCWJHAPzUAmJSqbWO1TSqAeJU/WodrPxU70FYq+iY4Tb9PGAoya/kU9IBj2tw==
X-Received: by 2002:a17:903:b07:b0:297:e231:f40c with SMTP id d9443c01a7336-29baaf75e00mr80206245ad.19.1764172816526;
        Wed, 26 Nov 2025 08:00:16 -0800 (PST)
Received: from fedora ([2401:4900:1f33:7df3:345:fd38:cbe7:7234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b29d706sm199432785ad.80.2025.11.26.08.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 08:00:16 -0800 (PST)
Date: Wed, 26 Nov 2025 21:30:09 +0530
From: ShiHao <i.shihao.999@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
	pabeni@redhat.com, horms@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v2] net: ipv4: fix spelling typos in commentsending
 commands without the SCSI layer which eventually helped me understand Linux
 USB subsystem
Message-ID: <aSckCffx4DnQlGtz@fedora>
References: <20251121104425.44527-1-i.shihao.999@gmail.com>
 <20251124193121.6f9eab3d@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251124193121.6f9eab3d@kernel.org>

On Mon, Nov 24, 2025 at 07:31:21PM -0800, Jakub Kicinski wrote:
> Please don't add any more files.
> But in the files you touch you should fix _all_ the typos.
> --

Hi

I have not added any more files in the v2 patch. I will send a new
patch for ipv6 directory.As for the v2 patch if There is anything wrong
or need some improvment please let me know.

thank you all
