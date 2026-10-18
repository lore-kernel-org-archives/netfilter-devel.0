Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7204A18859B
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 02:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792289009; cv=pass; b=YzxQkuXI+FdUzk8wvLkWYiGEQDN3vXOX4KRagU0//FqYBrWbPMHMlFxbRkT6sxxOOYBX/A1DmXoCzBTqVFQ94CGxIvWpw54eyp83EKFA4yo+R1xuV23qe1tOooZcmBOXj55t4LEf53+R1DW1Fp3KkaQEMrKEikp/RHRuIu3KAxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792289009; c=relaxed/simple;
	bh=OFvFUXE9xCFsK6/kBrpheywoSYe93LHItZLxp7xrWHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aysHINSqO2AKjDULQOKgEn3HI3NcJx40wgSRIP2iodl/vxQo12uSs1hwUv/rzeJ//oU87ltuSTCiHLsz4ZeyoMA51HUsZtP3Y+UGDqCecd0GoNNxRYC+9fqucW7KRlVDnlr4HUZekR1W7yJFG4VXT49PrEHAi1GPVhe4uaVY0oU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=Nr0pP7vV; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="Nr0pP7vV"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-677d35fd1d2so1102734d50.1
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 19:03:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792289007; cv=none;
        d=google.com; s=arc-20260327;
        b=biMYPHM+nMF8y406bdH6plLLpF4cFbNqEEE/C4gMvU2pKpdKuOflMtTTGkh90TDlPB
         HArsej1PPgrDcijUOJB/9FC6CsKDVL/CUL0oYYH1RIsMJOG6iZ62t4RpEuP6OUBXvzoI
         4KHCOZVXTctsyPqgm7zorPdw3m7ohtC3RFT+ierohohVWtrVnmChdZ17txzlnJEMLDOc
         rcQtOPou2OouFKDaeRt4IFaCyMDGXbIIjaOuXZjY28oN1gD6eczGEsu70da/l05UdiGB
         zO2lOEaFvOIlPFGMyzWHQIeDEZaiLNcGo6VOe9E/UIpe0F4wwquCi7+sheC5BR07cG4F
         HZuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OFvFUXE9xCFsK6/kBrpheywoSYe93LHItZLxp7xrWHk=;
        fh=uVUDoKkNpB83kVLigihf/miKfM7HcQcYj7ldrmD2CSY=;
        b=iqA4dd36BYApgM9DjD5LlRqhJUFqTGcrfKL3y8iECSyfIl12I+vXX+tz5CayTy1ouh
         sUHu9tM3BDRHXLvBofloYnK5RI3KextMLsNzh76mDDXm2QhOixR5sL53zxx0IQOQTnGu
         3SxSX4mmzCEkCpMdbLOmB+HluIsoCyI5wJpvL1sd4ScdPqDc/ObQU1lIZ7nDXUD3jXdY
         F2gxq4zVTltSIQVCu25/eNMkIeL1zy//htpLj3e211G7G/721cPFwyByduRiZ53+BFv7
         PNlHIpjpXFd46wvS16PIp1ff+jxIim8hYg/O/I3SDPi/nKC0OprQNtzut/PfHXcXuf7k
         99Hw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792289007; x=1792893807; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OFvFUXE9xCFsK6/kBrpheywoSYe93LHItZLxp7xrWHk=;
        b=Nr0pP7vVL4KeAR6PNJUeqzMXTnHsB97OF6gWi7jtNwt0qBvNOE0UvtQk1UniP2sCJg
         5M/VJIGIjHq+HPOlyRCYGgFq4+hcpvO/Gh7ouWmtqrJ8cOL5UppFYGMlGuMVnyz1Snlw
         JBLVKi3sWjDJ5dn9+KjaPSyVf1n8233GRJLMELG8kbFMKdotnD+w9Bt+04wTuA+d4t8A
         NRkR4oB9cTTtFiV1C3NDR9W40SApTrVU9m6y/4wWZMiNOOTTd3y+aJ/lOH4Z6k2+WrMr
         NsNwbLmjdsJ+PBiQl+QLvuUd2q63FglcqUflYsp2CgrbeXe5k3TQDgUUSxzMjniDk+xl
         XfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792289007; x=1792893807;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OFvFUXE9xCFsK6/kBrpheywoSYe93LHItZLxp7xrWHk=;
        b=CHyxJ54knwymdIajL/a6nMerpYDR+rXmsf5zw5pErt8B03dVe5l3EJaB83UwJ6OL6P
         kPDoWL3qxGTqe/POSlKK5WLTwpirrbGQbZ+8d2TwE+KCn8NPg+sOE9CuKPV1/lxuUlm7
         VLeQ0rmIVCIo1mwx+YFoBZuvdWafJ15PBu4SL0FiZ4iD8IZUrFbZVgKGwg8NZXIl5uR9
         ovv/o+5doHqEBEZU+hJ7jW9QpRFpk9QqfJ16pAd1zGnMVTNXWsmnl2Gjl2DNsLUp+H6Q
         xCAdUSeBe8b6y0AaCEoCwe6LMf6LZPNUMi6XLhPfE+Wux9IfQkikq9I8jsibud8n+wLN
         VIvA==
X-Gm-Message-State: AFq9FYJrehinv8OoA1MSvBHjhO7RZnqYSrZRwCLy2cBW4xWCny7dCmPo
	im2CXB+/6fP0h9LRPFwqkuPd+b3rzPslhKAzMbVhepG2Z38xQmqnIia5fE1wXopNEE1eBePCs5b
	YmAjmUcq0zzNr0aMgGLGK6qgGlWNIJ5GWjI4lI1vR
X-Gm-Gg: AYBFou1O2dy+khS9QsnPM9hlHvmLhsfN9bP1DdTKc9QanBrWT6BuVpMkzhaUP6xMSfy
	H78ktmM1qBVz2oseZxJIHWwYzBnaeLGaIypDTBAmz9gm8wSRgtvq+4flmYuDIgy25fPqTs6u7Y0
	6kW/8CsqWaBNzof6DbGoOZXT25erBHDZy92MUBkZFjE8KyTg6/nd8m918IqKCgu8G7DLq1UlKAW
	oKHVaLKjtrmaH9U32x/p8lZiQ3Y/M1LXN7rz62QEKFYjHKursZhFHzXhGiNvxn7SOMZu/1bkRJx
	sVWXt25Jv45Md5t54fmnYh8U+HCu+JVWxxFEpywcmmElmA37dprWJ8WesNEMQ69jEBoBcTPsEc2
	bKaNzxax0trRXzX99X+sadD4Q6qcJCB9m8bH2YO+c+r9DNbhMOJtKr51bwy7MsKOScydR/7dtJO
	C5HSoB3AY4jVkERp19b1w7ZJUhGZDkj1vmaxlyiq10OP3IWT0oFYjTQ+oia7ZHTzbBIQV0sbW6I
	GLvcE7fV1Fde5OkB2m2GhHgk5vsi2Wmq8xWa5IecsskGJ/6sjxsMfJFWy8OMGBUEmpQp8YxYtPB
	9MFWjat+krBk9A==
X-Received: by 2002:a05:690c:c4e9:b0:8b0:f04a:3132 with SMTP id
 00721157ae682-8b0f2163601mr11361017b3.27.1792289007350; Sat, 17 Oct 2026
 19:03:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261004171628.3544978-1-julius@bairaktaris.de>
 <20261018015434.3326758-1-julius@bairaktaris.de> <atQoL7WUM3BvDwbI@chamomile>
In-Reply-To: <atQoL7WUM3BvDwbI@chamomile>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Sun, 18 Oct 2026 02:02:49 +0000
X-Gm-Features: AclHuK8LcA_x4fXjqJQJo4qGB6xwiKVubMehR2hBrYfUz8uLAdhaaMXVC05SGRY
Message-ID: <CAC1t37JX5HnbU4gPxAE-PkNz=6e_pr2p6ujgEB-3gRi0HjXybg@mail.gmail.com>
Subject: Re: [PATCH nf-next v2 0/4] netfilter: offload a TCP flow whose reply
 is never seen
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de, 
	coreteam@netfilter.org, netdev@vger.kernel.org, geldot@protonmail.com, 
	shuah@kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

That would be awesome.

I will continue the development downstream and send the items upstream
after a merge one by one.

Thanks for your time!
