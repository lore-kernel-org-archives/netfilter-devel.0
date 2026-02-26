Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BF037473D
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 11:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772106467; cv=none; b=Vue98EPa/1vyoRNcitqTJVhKh1zOkNMoRUYrrEkyzjrt0neC4xyzlO/UJY7fpGTnvJpEQ0s6hBm1WERol7ay0X6vOxPHKv7r2Eamsw92JNJqzNHp0UYm+b71eSBt3/qa1E7iCqN9j7K3nwpz2QcG/Lc4kqOxwf/020FIst2830M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772106467; c=relaxed/simple;
	bh=63IqKXaFIPctdLWlMHfkf8YFp98sS+E/eEbEi7A8Pqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X0KTx5GFYrBTqHeZySXTb/kXjwngUbAnfeoeADpE94z0SYNp+BH2ruyOONGRUL4rY5/oKIt+o2jiuUgoXxrE5vbzKzObHo1iocuPUP6mq5NsnmcYSFDdUz9Z/CpNJTzUty4IF00ohmKGOR5+/mLdH0Ti2aRzJI/DzwX50eeTzSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dos3UwN1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qwJw0HvI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dos3UwN1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qwJw0HvI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772106465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UFuOLzcif/PTmhkzbfcWeKLXkT4K/BM6Lfore69nCbE=;
	b=dos3UwN1x1Pd0J89R82VcE3Lj2ml+jU9tFofbo2r1yT9z7kbcQhCnOpJB/YFmemq9i51ww
	MT6JSawJHDFsfmdES+Z3Tr16cbgEF2MnyqaY5HMVd+0QZOF2bLV9bSYCHzjyFiKiuH5lqI
	xusUVy53JA3aHgUobe8Tw41dmV6EQSU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-XMs7BrX-MwiYq2Z7_NQzXQ-1; Thu, 26 Feb 2026 06:47:43 -0500
X-MC-Unique: XMs7BrX-MwiYq2Z7_NQzXQ-1
X-Mimecast-MFC-AGG-ID: XMs7BrX-MwiYq2Z7_NQzXQ_1772106463
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43991543a3dso562912f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 03:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772106462; x=1772711262; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:fcc:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UFuOLzcif/PTmhkzbfcWeKLXkT4K/BM6Lfore69nCbE=;
        b=qwJw0HvIOxhNd5bDPRSmrWgCcTjaeLyWWMt8KFLM+3YelbZDxoRopA5ROojlo0h1Il
         Ou+KB3QAv7jgAcULWUC4SaOBBdUr/K6pHVf+WDTpHjAWrTKLeHdfFtgsmG+3OBQqHSZa
         W4HZ/a1CPZGEvXFOSglhVZSFgbS8H9BHGn3qYwy6RGF+mp7U1F51seJ36lF3z8sZMk3P
         AqSUs3E2F4tFWfDgav91Vm/QxDmMZ5nvvtPdDLsk6f1Psr+Cp/c7euQTV7EttrqGd9Xa
         Y070sQBNCtJDsljP53qD9PfmpP0Lh1CM6lGMR7fNwhYJ1IqQZlcj3dK+nxTAhU43lI26
         nL4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772106462; x=1772711262;
        h=content-transfer-encoding:in-reply-to:fcc:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UFuOLzcif/PTmhkzbfcWeKLXkT4K/BM6Lfore69nCbE=;
        b=gUs2gNcjWqRHc54XWCQ3PvzlYs3upRI6CTLB4pRlBLVa7MOomCqu2pcc88JosunnPa
         VbzxDhw16VpV3ySu6qrx1g3eJcS6IC+vo5uVJ+SjaCzDGnfKPZiSapTq1St893+V8Abu
         MmCCHQHFqDMdrFBPPejP2TVJbfm2zb6UoYdgEA2ro3y9OcNA4UND9g1M8vaJCiBK3oTo
         DIXKuzzIelqmwJoT5VbEFANJiJSDYjz+j5a2gTUF6cC7VJi1CmhRlfkO61HG/357d8Q1
         He4dKpRsACnVsMY1CQllzX3ISZIYqs6sWzTGC2lBplr2QDtFbwSv+cFyykK4WcXSU32q
         KU5A==
X-Forwarded-Encrypted: i=1; AJvYcCVkgu3RomTNsupbhcrkWNxdSF8B1wNWrSmgEIkvmP3WMhO/sJ7MoqW3EyZ6vSt8k3fBP18gr0ez4F0qjciQ184=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFvkg4Fn2+5/A/fpdlnYLgiIea9DcHaOezXUOtaXJloIOWQb/h
	EsiOn3soLWyKHzcBGGqlGhbCK4guC0knYYVejzVSq4riZ8JqrNRKxNRT0KzPlxBj7MNLXUpIIrd
	9iAXhxxJ4Ojg3IK65Mi2ABtSyoe596n8qxY767bHkj0p7GUYBZTD2P5p+MSn/eTYvVWSFdg==
X-Gm-Gg: ATEYQzx6AtUDdY2fNsOrxBjVGe9PBMTYMuYhYVRTo5Wm8kdnQ7W5HrM9yrEec1/npJE
	TMj8UevJnIZOMk5GqvcBha4rp66ZDbZVy1f2p6RibVmChBUJI9JSb3u06fwhCRPmm0hFBXHIeET
	neEJuTO9hK6+RU5qZEPZ9f8GdzfubkjGucUk16wjl9fjjcnxKoXmsiY762pxTHcQaHBh8baOC95
	qA4VNAwZsLlnqRn6J9I2q44Ov/a5yyQ0myUGXKshFz0WkpwiTOaJtSnzWgPcfz/yrC9L/lIdjD3
	uL0AoHkqapWC/H3Gt/NVndtOrZaDuJPLXs8zgc6btQFShP5qtyYVBlOl55YeOVS/TquZLD1hyv0
	V9WGBlRaL7DDlAsVdHqJVnsOngw==
X-Received: by 2002:a05:6000:2283:b0:437:6629:9b82 with SMTP id ffacd0b85a97d-439943060camr6730303f8f.52.1772106462546;
        Thu, 26 Feb 2026 03:47:42 -0800 (PST)
X-Received: by 2002:a05:6000:2283:b0:437:6629:9b82 with SMTP id ffacd0b85a97d-439943060camr6730260f8f.52.1772106462086;
        Thu, 26 Feb 2026 03:47:42 -0800 (PST)
Received: from [192.168.88.32] ([212.105.149.227])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43992ced321sm8566709f8f.35.2026.02.26.03.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 03:47:41 -0800 (PST)
Message-ID: <61b18149-17e4-439a-97d3-74f0dc20a78f@redhat.com>
Date: Thu, 26 Feb 2026 12:47:40 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/2] netfilter: nf_conntrack_h323: fix OOB read in
 decode_choice()
To: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
References: <20260225130619.1248-1-fw@strlen.de>
 <20260225130619.1248-2-fw@strlen.de> <aaAOFygrzyyp2a_z@strlen.de>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; DSN=0; uuencode=0;
 attachmentreminder=0; deliveryformat=1
X-Identity-Key: id1
Fcc: imap://pabeni%40redhat.com@imap.gmail.com/[Gmail]/Sent Mail
In-Reply-To: <aaAOFygrzyyp2a_z@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/26 10:10 AM, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> From: Vahagn Vardanian <vahagn@redrays.io>
>>
>> In decode_choice(), the boundary check before get_len() uses the
>> variable `len`, which is still 0 from its initialization at the top of
>> the function:
>>
> 
> @net maintainers: would you mind applying this patch directly?
> 
> I don't know when Pablo can re-spin his fix, and I don't want
> to hold up the H323 patch.

Makes sense. Note that I'll apply the patch (as opposed to pull it),
meaning it will get a new hash.

Please scream very loudly, very soon if you prefer otherwise!

/P

