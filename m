Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B223026C
	for <netfilter-devel@vger.kernel.org>; Sat, 31 May 2025 03:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748661983; cv=none; b=FRVaWLOIhOiCZtxmnFt1i5gr8bpCRbztDRay49giKX9Hd0vurYR3xeQAoRebl4yLkzt6WfnomLJaF5ZXw0MT3Jg7wUZ9yZRLds1Mxovd5tRcrHhoNL6AlvUOdDVxsjfuXRGc2aHTb2biluLKTcy1YZ82bwrk/di758RCgZyrwzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748661983; c=relaxed/simple;
	bh=g/l199fBIYvSiLjjTeOMOwke9vBvPOqYFwJeA3XzGCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r4FZHzgDJEdpblqBYiDv/W+wjVROP7x4q8Ah4UgYl2kpsDOT/eXOfHx3OAiWZfD+DOSR25fZQNNoTCgs8Cx9YgewSrYmUBGxBah9WuVix6cNR1QikZ6Bkr4Hn1PdT+GGqxS51aO67B2Fw1xESyqBnRNcZlygKHTuQMHyZReaQEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ayT1ehAe; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ayT1ehAe"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-736ef1ccb85so90124a34.1
        for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2025 20:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748661981; x=1749266781; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5doY/KepSaWp1A3MhIVOb739kMWn0hJzAjySV6R7CBA=;
        b=ayT1ehAexgVw497wc5CpN8OK1bu5eAL6OadoaHPJ9KmqZ/hv2WMwAZsS3VmnoOK+EG
         cOjhyQ4rewoufbXLPLjrMS74YivK1igf50IiKp0rBlNQ3QDyJeMVhpkRBKtKJquqzG7+
         aVTEuhk0583l0Ci/Xsf57HyNaJaJSK6RX1cxnLEM84p4iI6YXJgezh6WZalI4VmZjsy6
         napWPiT8Evx9fWicOAn7qMzUvGiwx70QjFTSztT2ymWggIRTj3uIW0fjC2WW1wmUIYIl
         g0XvcrooSEQcRTmpjpxRBkCod6wHU3sMTmViRTve8bAcWlzjYeZPrgEGLUdWxuOnroK0
         GnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748661981; x=1749266781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5doY/KepSaWp1A3MhIVOb739kMWn0hJzAjySV6R7CBA=;
        b=KGnZjIA2d5Y3D3wTz9xkzWF0EjLtkhubtWj6BgNs3ixlzS/jOWJ5wgrSk1H//4wML6
         yCI/Gm/sGjocjMIWMwK9kJz8GY0wurRjGYNzwdnhow2GCfo/fAn1sT/XsM+0iqjl6D8k
         INBdu1voNORXNXkcbA4fwjvDbJMX4pwHXPWBE0Y7ZfuA6doNsEFPLt0roLISRzxnb0j9
         01D/nDaxXTJjLu1KEdPJp8jmDceaOi0gwY4z5joQa1YhhtzeMRbHiYgcuf5rHLsWmfqt
         mZx1/ZQImM+8Y/uYTpGAaM800Za21r4/bMGfywLyYED0uBiRKU7d649pB+iDo6NKOzky
         EvNw==
X-Gm-Message-State: AOJu0YwQFS/yY2OjjC0ywZyUL5O1dmh54iIQtOvnaOR9mOc9+FXmqXnA
	J1lhHKkzcfVXt628KXS1hcKxVJITwku83IIwdX3Fn+9+OAMBVQ4oGdv+E8abPRxj
X-Gm-Gg: ASbGncso6qXXnGkrXAloXvf6EpzSjwu7qQnSG+Bq9HcJm9UXybMCSIM/mkCkSyNT1sa
	Ob7Iaq+5k7/oneloF/KbbIlHxrUBdgHA1o0azcR3bFf88gz7S9Lhs0PdC0/5tecBWlNn0wYFsGv
	FVhJIGVP97mx6tZEqZd32p35fw//SdcovIwwlByGZoprCNrOeJaMVtbJ8yJ7rsFPnRrP1ldDauD
	xkFeSQWjuqVCv7egDG5rYEbuM32BOeBC/NBTT53+PS57eImnI/W2e9BqnBSFEFMPut8irXEgekr
	iLxx6a8EpzMQ2QdqMdbsXboWG4KP4B2cJ8c+hBaAVD5Qx8fTdDQnE0zmfOBKRrPc4CrOGr6tdBN
	6KXDjTCH6
X-Google-Smtp-Source: AGHT+IFh0d35Z/hLYYhwSnYczZztRL5B7nYGVq2+tlghelQmlFqODGkw0LzpW9AvhS3kcTwBsmM7hQ==
X-Received: by 2002:a05:622a:59cf:b0:4a4:4bdc:8b1 with SMTP id d75a77b69052e-4a4a5eb4808mr12619231cf.19.1748661970773;
        Fri, 30 May 2025 20:26:10 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a435772cc9sm29183461cf.15.2025.05.30.20.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 20:26:10 -0700 (PDT)
Date: Fri, 30 May 2025 23:26:08 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 2/2] selftests: netfilter: nft_nat.sh: add test for
 reverse clash with nat
Message-ID: <aDp20A1E5x-h-aNn@fedora>
References: <20250530103408.3767-1-fw@strlen.de>
 <20250530103408.3767-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250530103408.3767-2-fw@strlen.de>

On Fri, May 30, 2025 at 12:34:03PM +0200, Florian Westphal wrote:
> This will fail without the previous bug fix because we erronously
> diff --git a/tools/testing/selftests/net/netfilter/nft_nat.sh b/tools/testing/selftests/net/netfilter/nft_nat.sh
...>8...
> +	test $lret -eq 0 && echo "PASS: IP dnat clash $ns1:$ns2"
> 
# PASS: IP dnat clash ns1-Mx4scW:ns2-wDqp2o
ok 21 selftests: net/netfilter: nft_nat.sh

Tested-by: Shaun Brady <brady.1345@gmail.com>

