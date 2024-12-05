Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A650B221461
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2024 18:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733424137; cv=none; b=aIfm/DC0jg4pU93PuU4IU6mZLrE/eHUu4Z2Uai7GPBrqwMo1rWldrYIIMh2MWnwfH6oCHIXmmOYYa4vvIAsMgJSzLEf6AWds0JK21kkz+tjF+Wk+9KyDeamaSudnmz/yr3YB4ZwX3hvG9ah6ASNyOtQqeb2kJ0SJcJOHdUYMohU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733424137; c=relaxed/simple;
	bh=gA/VeNm6V5/8b09vX/49ut5uvV/G8q+I9tBmKj7pctU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MoFRRyvdRa7gQaVPB5FExqo+wOo1XZBtVEAYE28ZTLYTPUYkZZOIOID0LCJoZtbvAhwO2AezJxRf0eRBOY8ZDoSZdQbwFI3cwy/PQXkD+VKVMlKS5jFtuPL6QWJmjJ6MvHNT9iyLGnf5nsAPiH3vdxOon4oLVxDj/jGBEQFCtdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xQyidbrw; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xQyidbrw"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-4afa753c6d6so378985137.2
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Dec 2024 10:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733424134; x=1734028934; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tR8Gx4YF+iGaCMV6DuY+XQYSDcjVdzyIfn9PDc6LDOM=;
        b=xQyidbrwCeNXzAF1X+SB1F06/dklL8Z590ib2CdIKxi0mHRFXyNX8hgL3ZpkSGfk3o
         y+R+P7JO9cKow9s69jpcuRNL43GmI/BFfxNP9JBrHTtvPFkKmNV31QMzFtSnLO+Ku7j0
         vJZEHIvxB6qxPFW9Suo8TEzzebVPYnZj0jBHzKr2fV4a/6+7ZIiXOOh5Z3FO/rEjo7a5
         asLxtoXvKN324R57hkQ7Ej95nDiSAeFOOM8a80Sr5Mp1+nVnAcbKVcGCpMGgRTQHPVg2
         Oxjrea5NtO7TfWJv7uQiKtCmlrGXFBBZcd6QbEc5OXgHCt0etnyB6NSEjbk7R+uW0Esf
         XmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733424134; x=1734028934;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tR8Gx4YF+iGaCMV6DuY+XQYSDcjVdzyIfn9PDc6LDOM=;
        b=LSrFRvkwOjLqmQU/MOtdh1at7LMAgKy+TWBJkYZH8Zc+Qn1srmOUycF6yi/8nbocSi
         wlYuZ3ZH9KEIryMvpkWeq1Y5e5ga90qQeM94JXX+EGo7gSYNKpCP2Nagh0Vcihd3mm6r
         Ho05s2yy158srm6Y03tT593YQtSH8SYKHUa84B1BpNXG1EyrPu7GwK0hiTKUB9eIqjv2
         rulScNOax6rX/2qBnJPYtp5pqgTVfVHX4edPeHbvU8Zap2wkpzNgc6ySUAVkYGYmEIzo
         882f0CfAMUyC+XyOCPRhaTl38uyTFNNsasWYZ2Mj5Dlb3PeW4do63sPfrz3HvDbAA4SV
         fgzA==
X-Forwarded-Encrypted: i=1; AJvYcCUk3qUQHvkZAfH9H7uSu2kdnz2s+H9+4gd6P6nCSvRFIkUtTJrow0V/HGY9t6kHkG1hgwFBdbFRbSzo2rzNNfg=@vger.kernel.org
X-Gm-Message-State: AOJu0YywfKuEHPge5It0bMn8tD+6cTgkDaHxtDy++BUBqfFdPeuaHpu9
	VZJI6j5d32oP3NlUu/4/MY22XFj72FasESVXXiAajBZD18PZQ9/nTK1kMbCpyp0o1VLPbbT15L5
	bYL+qwIZPVi9gQ6nXb9qyNm/8PbkpvyFqdzbS8w==
X-Gm-Gg: ASbGncvpqQWCbS9QOamptxxQQIKHn86pY9CVO4Wj2HxWbM+eJAEsFgB89bKi8stxEhL
	ZJET/NIZDPFJX+Leut0TpxdQDxOSJpF0h
X-Google-Smtp-Source: AGHT+IG269PkgdVPpsUfRMnNfyCTRw+6b9s1FqQamygLLFlRX39CxuzaR647OcbZrJKkKII8mvW1s/GWCnxsPXgxkTM=
X-Received: by 2002:a05:6102:3909:b0:4af:bf45:39a8 with SMTP id
 ada2fe7eead31-4afcaa4f74cmr835447137.16.1733424134670; Thu, 05 Dec 2024
 10:42:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+G9fYsT34UkGFKxus63H6UVpYi5GRZkezT9MRLfAbM3f6ke0g@mail.gmail.com>
 <8dde5a62-4ce6-4954-86c9-54d961aed6df@stanley.mountain>
In-Reply-To: <8dde5a62-4ce6-4954-86c9-54d961aed6df@stanley.mountain>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 6 Dec 2024 00:12:03 +0530
Message-ID: <CA+G9fYv5gW1gByakU1yyQ__BoAKWkCcg=vGGyNep7+5p9_2uJA@mail.gmail.com>
Subject: Re: arm64: include/linux/compiler_types.h:542:38: error: call to
 '__compiletime_assert_1050' declared with attribute error: clamp() low limit
 min greater than high limit max_avail
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: David Laight <David.Laight@aculab.com>, open list <linux-kernel@vger.kernel.org>, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, netfilter-devel@vger.kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Johannes Berg <johannes.berg@intel.com>, toke@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, kernel@jfarr.cc, kees@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Dec 2024 at 20:46, Dan Carpenter <dan.carpenter@linaro.org> wrote:
>
> Add David to the CC list.

Anders bisected this reported issue and found the first bad commit as,

# first bad commit:
  [ef32b92ac605ba1b7692827330b9c60259f0af49]
  minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()


 - Naresh
