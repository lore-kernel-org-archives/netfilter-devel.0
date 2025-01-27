Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B264C1607A4
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jan 2025 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738001137; cv=none; b=PMkA13vWAXvIGCzP+eHop974NvX5wMvTw33CbL5fA+TJAWcTYuvCNv+9jBfmbMh4S2a0CNle4z8J8gwXiE8UjmSKzEuoK80svqWrKhRBOtgs5i+nzXN3mXEZwvNRz8Een4rBWFB6wuM1TKXRejAnmBCAxVeFgOI9eBEvIh1GN18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738001137; c=relaxed/simple;
	bh=BEsb6n9siTaP4x7qFV/R66om8n+Tzywea90SydC5C44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B6R0wF4gUauK13IuTOnuxhv7s+gNI2n1jezY67ICjJyyzhGihT5jW9R6UChmpUt/Ryv9rCXfz7kB3wHNdWn857xMUgo6Rny5aPhJI+RlVciR7L5ZvYKAcViRlKhkpCewG9X5rlP7zfMkEW7bMW+zv5qpGIGWI6KmAPSlYAKkReo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fastly.com; spf=pass smtp.mailfrom=fastly.com; dkim=pass (1024-bit key) header.d=fastly.com header.i=@fastly.com header.b=DjcEO86d; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fastly.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastly.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fastly.com header.i=@fastly.com header.b="DjcEO86d"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7b6fc3e9e4aso414780885a.2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jan 2025 10:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1738001134; x=1738605934; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AMDn01SWIjmfdhQcwUIs75izjTf9Hnbhitqkx9MGjr8=;
        b=DjcEO86dDG+nK02pcFEjZRpNhTXqYRYWF0R0TQ/xldO+P9mKnndPEHX1lF4mM471Cr
         89gAabhK0KjKTQ0xTiekmEGyzVanbzJ9dlJp/gw3ihgSc7Gj79H/Xt1xdF/mHon29PYF
         OypBAZm2MH7hOXpHogXOIZS6oEm7YoA0j+iBc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738001134; x=1738605934;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AMDn01SWIjmfdhQcwUIs75izjTf9Hnbhitqkx9MGjr8=;
        b=II4UQ3JC6Lo8D7zSxVdTbhVlZhXjvAhQ4SJGDKTTT5aJdU+VrvNJDUatqRl1OFN1aP
         /WqaPbJlWdoGuXTIg7Wc9s+yp1AJQ0EJYRpZ+7iXjC5hSRADkp0trGFunmxR4lnCeI9U
         Ws9ab5zteYKOZkmgyoU15VojNtmPaEEEMAYmufoPk8nyu1A+mP0FZXPzXX3gQYyHKGIF
         eVNXj0hPfoIuRjbPV60coFAdfpk8yLv3PbB72oX45vU55AKd0ElQVi0Y9kqYpTALfiUn
         4bxciy7IUz3NsfxgJH0LG6nH+J+EYCLG97O3Fv1mlyLr73ZA9ZbZW9mR2RfqQmUaDb8S
         WmdA==
X-Forwarded-Encrypted: i=1; AJvYcCVh8kuC0BLyN+Z8zFIDe2cm3/EvKUqIuz9fdu6Njehs9mWoD9JMrRPqq6UIj07BzB2xr6EFourabnjhAEDnOnI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi6HG4n2B0SL4wE+GBTyTuAQt052gDV1wahnLv/HESVHzqKbOo
	mPx7DnTuqZkSe+jSRYTFvTDTPsVNotBHRVMmdZIdD33UsZu3BvBUszCxrEzg9jw=
X-Gm-Gg: ASbGncvhd/hAh2hC5x1SAMLlvL08c7ExkhHeZfXU8d2Q8LBLDc5ey/YfZSJiA98R09G
	WbZxIbuJIuVRH5CnFJw5PCdZjHyxm2S31L+AGVJgQgN1YAROOq8Y1EqcpVw6h0K2/URqcA8G8sv
	ZuzVLod82cn+HVZyxUUG1Vh/V6rQ4ZxyvL8c6fIsQjIY4WyAsJjlfgygEk/LrLSVOZixU3C6/VS
	V15Pm1SrMg8HXEL5uRWu6GRuFPVdPzftAiO1Kp+fJyxh+3D1cd4agEpe8eOESNdr0wrIaY5CAPn
	4BsA2EKPYq9jPvIAsaAmjzbwCr6lgil5KU2dWxVSbbosjQqv
X-Google-Smtp-Source: AGHT+IGyYeeR4TsA+WdrCQYCr/8+qk1j+5VwubRGe5d2pC8iYUgJlAW0YwezLbYdTJ+RcwEWCyf2Yg==
X-Received: by 2002:a05:620a:14e:b0:7be:6eb1:f4dc with SMTP id af79cd13be357-7be6eb1f594mr4305704785a.51.1738001134568;
        Mon, 27 Jan 2025 10:05:34 -0800 (PST)
Received: from LQ3V64L9R2 (ip-185-104-139-70.ptr.icomera.net. [185.104.139.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be9aeefd88sm414259285a.77.2025.01.27.10.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 10:05:34 -0800 (PST)
Date: Mon, 27 Jan 2025 13:05:30 -0500
From: Joe Damato <jdamato@fastly.com>
To: nicolas.bouchinet@clip-os.org
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Joel Granados <j.granados@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v1 0/9] Fixes multiple sysctl bound checks
Message-ID: <Z5fK6jnrjMBDrDJg@LQ3V64L9R2>
Mail-Followup-To: Joe Damato <jdamato@fastly.com>,
	nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
	codalist@coda.cs.cmu.edu, linux-nfs@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Joel Granados <j.granados@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
References: <20250127142014.37834-1-nicolas.bouchinet@clip-os.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127142014.37834-1-nicolas.bouchinet@clip-os.org>

On Mon, Jan 27, 2025 at 03:19:57PM +0100, nicolas.bouchinet@clip-os.org wrote:
> From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
> 
> Hi,
> 
> This patchset adds some bound checks to sysctls to avoid negative
> value writes.
> 
> The patched sysctls were storing the result of the proc_dointvec
> proc_handler into an unsigned int data. proc_dointvec being able to
> parse negative value, and it return value being a signed int, this could
> lead to undefined behaviors.
> This has led to kernel crash in the past as described in commit
> 3b3376f222e3 ("sysctl.c: fix underflow value setting risk in vm_table")
> 
> Most of them are now bounded between SYSCTL_ZERO and SYSCTL_INT_MAX.
> nf_conntrack_expect_max is bounded between SYSCTL_ONE and SYSCTL_INT_MAX
> as defined by its documentation.

I noticed that none of the patches have a Fixes tags. Do any of
these fix existing crashes or is this just cleanup?

I am asking because if this is cleanup then it would be "net-next"
material instead of "net" and would need to be resubmit when then
merge window has passed [1].

FWIW, I submit a similar change some time ago and it was submit to
net-next as cleanup [2].

[1]: https://lore.kernel.org/netdev/20250117182059.7ce1196f@kernel.org/
[2]: https://lore.kernel.org/netdev/CANn89i+=HiffVo9iv2NKMC2LFT15xFLG16h7wN3MCrTiKT3zQQ@mail.gmail.com/T/
