Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E083E9292
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776943807; cv=pass; b=MYKc72l5iIwpQlp+ZZsVTm7FTsVNCbF+Ea87RVFVOpklBr9Yadbs1PMaFF+itaDn0nXoqji5LOu/1p7u53sZicHLyDSy9JVxb18N10mvd6D0Wv+U0r7EkGj4tgxhFU54FV7rEDyf6A8E5rDnqcD60r0c0dNOLG5vEqhBhpPXPEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776943807; c=relaxed/simple;
	bh=T4LShQj9jiOPwMnozdDj01/Lj+CiM23s8wcbkKMymDY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=PRKgPXXPxa123ygHRXp1PiPFbQLmk2cgXfwejYs0844EvNd0YiZg6zzcZcOObZkY9RFwFfpdSkobJIqEcUr2OqmuG5NGa2nB8FtO4IYBKfI2HNLXhBjUKifDNzj017TwecFfN9OHTh0Q+BuEDZ0Dd05nQW+u7GJYD323jh8ML+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N2lC3Pfo; arc=pass smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N2lC3Pfo"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-56dfd007d31so4015157e0c.3
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 04:30:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776943805; cv=none;
        d=google.com; s=arc-20240605;
        b=NGOzUvbZM9b544mTTwg25mjfBk2iX2wQcsh5kcU3ONHDovjf+GvuzeEueZ8l0COpSs
         LF6a0Ua45tS8byMeun4DY/2yGbXI5+191B4vugephrFHbfqZziqcLufp4rriX2oxeBwn
         WrMyVgJpY7qO2AgRLZPJKC5ZQqwJQYjwCK2Q1drn2PNddI/HkrWBmm6kP1LZzQHtIHSA
         GXGcPhJpUQxa9YP3eAyajjqS78vDgGvaq4gBePi+pfIxgh1rjvbykKZtmIF/b6UNDW5n
         os1S7JsLCwbCbVBPJZREoZFmVILGvNwGVPPjm24OjspPIZiw2yY1FJEW2QXjBAonckqL
         aCWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=x58fs5tyz9iJ+tAmsZX43STXvFZsxV8FygOoUaHevxE=;
        fh=i8nWucUDDcuJZrAc5F/lTqZ3W31vqALi8eeFadgPUj8=;
        b=APqu2UJBVXLKO8H9Uu1KlPC1L94Z/xQLwo8CD5C4/PhjpuRtJSaIVbvN7JwQhzbSfo
         Ptlw7NYBSasO8oBxL122o3wuyvxMODHWkv67iTwfCtlNuydDw97mImb+4Txc7eE7vQKG
         QmLPkR+VIMkReNrXXl4cevBUT4hK5qHbu0NKTg2+OPU563LzPpXLCR6td+izpT/wcWqw
         Je1O6gdV7suux4m/vSWYws8cCzLtLDM0On98be5V0bjw4xROImjb/LHE00GhPxaZH5s+
         8jd1QaSb47eIpwbNg7bCpjBKS9ymi8vvJFMkbXj4OYKyV0uUmRMTFI4vRt22wkamVEQC
         3lOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776943805; x=1777548605; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x58fs5tyz9iJ+tAmsZX43STXvFZsxV8FygOoUaHevxE=;
        b=N2lC3Pfo4xx3nbbMu91DbwBGdjVxaOPAMMaraYosTxO8hSsNKg6iVY/7ChgBjBCYOA
         oZwzEDS8xWkiMrjpN4f2RAqPqsp/CFALs9xcLqTjKen/1ii3nWSLCDwq2ucryFTbtzb5
         x0WmkafrJVOW5OaYWtlygTCzd69WT8dHRp8/C4HJw4bL4lp5AQh4UPzwukzYdLpt9d7u
         pHjhwvYKduq5Ux/wHh9m9xGvkiHZGEoD/lMoUGPydvBrdfutt1kDzLaHjsNmHXYWNDGD
         EADC5/H5bWUW6InLER1oUXAxvJknafp8EHFBjRpH7XIfFcwL5FksyJe5cpFINJ4YWJoN
         c3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776943805; x=1777548605;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x58fs5tyz9iJ+tAmsZX43STXvFZsxV8FygOoUaHevxE=;
        b=ck9ETxkmifhpDZeaxYweiBTK9vf7WS8WtFRBAmWzVxtCKddv2CqIcTyCBkxiNsDgK/
         Jnu7jq4sl7QQoACQbbidSZSwktdzqhrNyxloyaPy2MFeggS+RH5vtfrG8QSIvrkcaP7B
         +2wNZoJbA0BGJ2/nlOrYWRqIfw61KnknUgcN13E2prnVWKWVnv7LrTPU0QgM5wdAf1hV
         wcEKtzQknuvQPcE+NC4C4rSkaNq2zx53JmWyDdJhilCqmAtTQ1COeDKeJ95RVbB8PpeN
         bBaSsBNJbcmsGvgYwj8yAoaRMYNkjOKGS1e0TzCL5wt0noS0KBLt3HC1Md3cspGcH9Tv
         Xh1w==
X-Gm-Message-State: AOJu0YxxwWpqjNYV14ZkE7pA5gTzH5Mb9k7Gjw7WfYSq0Wwn6sLvnnLq
	5GR/1j60o/XoGgCsRWN0wZkPOqRLykZXymVuzavFPQK7DAnePofrAOi+ovEFje7VCy77skMgAdf
	dkSsKrbfqKMiQsvM4g1ZbhmnpX4zjpz75Spo=
X-Gm-Gg: AeBDiev6tgn8JZFYb+kbuh8bKd29hfC7ng55raXu1pHyU2bvoD+0nqFHQdShurHfh92
	yPQUbLsKLpJStppciYAgKCxh0HAHEmS6DaiBAD7QFRIpUtbhgWZM+3gt7C+AYUs5UUgCko/Vlzp
	1qhSgbQieQD5JtLLAyZ9Pp8XQjRCxcIvE5PkyhOQai6hq49J3N3zkjnb5SVYo5MaQRfbVippEH9
	Czh5LRb8nq+rZTj05t/vF6SR96R8XF+RDs/7QWJzIn44yLbIiTYmibwQzb/nFVCuOiT9dRS+7LC
	tZCK6T8itaEMB3ccmsLozMWHG9vl+s7S33JJ7xcIQWUie8C5
X-Received: by 2002:a05:6122:d95:b0:56c:db9e:7d04 with SMTP id
 71dfb90a1353d-56fa59b54cfmr13938953e0c.10.1776943804949; Thu, 23 Apr 2026
 04:30:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ramesh Adhikari <adhikari.resume@gmail.com>
Date: Thu, 23 Apr 2026 16:59:52 +0530
X-Gm-Features: AQROBzBgelQotVXV1c8ciDn0tPpiuCL74qxlCARfkOd-_4vqr4e8nowfr2krRa0
Message-ID: <CAC-THR-m=VEy9N=xc_gBSySxESamwsLNWy4tBuuCXxZQ7qJfMw@mail.gmail.com>
Subject: [PATCH 0/1] netfilter: nfnetlink_queue: fix missing padding in
 NFQA_PAYLOAD attribute
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

Hi Netfilter developers,

I found a netlink attribute construction bug in nfnetlink_queue similar
to the one recently fixed in nfnetlink_log (commit 52025ebaa29).

ISSUE:
In net/netfilter/nfnetlink_queue.c lines 894-899, the NFQA_PAYLOAD
attribute is manually constructed without allocating padding bytes:

    nla = skb_put(skb, sizeof(*nla));
    nla->nla_type = NFQA_PAYLOAD;
    nla->nla_len = nla_attr_size(data_len);
    if (skb_zerocopy(skb, entskb, data_len, hlen))
        goto nla_put_failure;

This allocates only (4 + data_len) bytes. For data_len=5, this is 9 bytes.

However, nla_next() expects padding:
    totlen = NLA_ALIGN(nla->nla_len);  // NLA_ALIGN(9) = 12

The netlink message is 3 bytes short of what the parser expects.

PROOF:
With copy_range=5, captured netlink messages are 73 bytes (should be 76).
The message ends immediately after the 5th data byte with no padding.

FIX:
Replace manual construction with __nla_reserve(), like all other
attributes in the file:

    nla = __nla_reserve(skb, NFQA_PAYLOAD, data_len);
    if (!nla)
        goto nla_put_failure;
    if (skb_zerocopy(skb, entskb, data_len, hlen))
        goto nla_put_failure;

IMPACT:
Correctness issue - violates netlink protocol. Could cause userspace
parsers to misparse or crash if they don't check message boundaries.

I can submit a formal patch if needed.

Best regards,
Ramesh Adhikari
Security Researcher
https://iotsec.in
