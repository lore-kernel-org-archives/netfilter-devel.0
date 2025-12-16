Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BC429BD87
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 16:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765901133; cv=none; b=K2ztUpvzom0mBhMGfJqwwdtMuw1TF3GKxNSr37xl83P2uCpDZKlpnoa0ftUQwvHouC5WgMQozB6XWgitezbedojRnayg0NoFvEnrLK6xHMWg8FWsX2p+699RcirZjClKanv2diDG9gCuuJfcV8yCFWKtqQ4Vqotc4SwWZPhNrhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765901133; c=relaxed/simple;
	bh=YQ2swpBxoWz+iFGovXWzORIextmA8UaBwmHyuju/Tw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwvTeaPeuPVzrxNsM5w8V4PsXBJDzDX+8fSDMNZcVwL+0OokM7f6jEvrwXHHIjQgnNskxot++iHI1UKlEctl60JGgrFq7ONlWc1q0FUuW8m9KfnDhyq85EmQGzaMdQvoKJfbz8j4M1RE6oFm7jlzPVqFAQX/9B1wf3WbJYcBBag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W5y3p78p; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5y3p78p"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7c76f65feb5so3959068a34.0
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 08:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765901128; x=1766505928; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h3uWK/Nvv1h5ImCTrsHJdI+WYTs8ZaZZI9x9uA5zrhc=;
        b=W5y3p78pgcoOkVq+yMtU8/4a0gV+4+G3mwwuSX0DfzwKmZ/+ctFs+Dzq0dB7lvUx8K
         3LINZX0wvJZdXKVKpHVpx/9lkdN/U6c2o53LHIaywsJR7qbixCCd5f3CwG4MDgP188jk
         PbmZ/+X8wVmNcjHwVshJg2tJZlROX1L2YYHngG1r2gvl1JpC8u4L/sUc1TsnnbDRs0uZ
         hI7i8ytz9loCac1BVCiOlRtjibMjOcqtJklTVjuDkP2pg5IiyUl3By5NXEvmosnTqc3d
         NmfU7dw4rKyhL7p9zfn2/9dnxkjMEABIUOBjekiJ4H1RhAc4IMHwg9HvuxZIwFUhsrI2
         8WjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765901128; x=1766505928;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h3uWK/Nvv1h5ImCTrsHJdI+WYTs8ZaZZI9x9uA5zrhc=;
        b=YoXrB86L4QdB1v2XATiOEJIVRJnRvDY6qXClg3QuLVvdRDdpUPxsyX9vFXRKYPyi3o
         sGI62Gl/0ifeG8BZkh878qfA2QgCMQ0Dpd1xHOV8NIF4Tu/xtiPwdr71TBMkayj8kReo
         mXLZNTcoIiuVBZFTHBYOh1Ti3oCZjawWYk9O0mx8ronoDB8KcTSxbiKHrO/N7xcpsW2J
         ypcaCuXcgddnwgN0H4webCQAA9vOUhrIO8fubwQ5QO+vZdVDCKwhIl3g63xPFdNPnxe2
         5rJuAkJ1CK+lbbwZStu+g8UMw6LynxmCe80QRa9oAnZjLQZ6ahD06kM9BVm9a5XBA5WG
         R6vg==
X-Gm-Message-State: AOJu0YyxD2LHM/l5BVgJ5EKbQj0QZd7iVPJI/e/imLeuL2VD7FFWFOq5
	5SyhS7uCjKprgrGHNl6SEVG+idjSxchZUf+i3wprwD8O+ZngOPPxOdEJvO3qag==
X-Gm-Gg: AY/fxX6U49hwSRHBnJ1IBrDcFkdE3J5pts/oNtpt7Jx5lUy+3ZmoSbgO0PVTibhQeG3
	BylpijgOJzwarqEid1AuNuaG3GKeetduhBcRu3u7QyGo4jf1VEp1yjfGcb1KSLHq/HwXhqeAYaA
	npavhnMzhh7jGTRsKuEPMQxJ7itc2Q1d0xBEPLtXYwyP2166Ypm3L2cyLcoXrb5G7AA1XhkVjUI
	frNl6emXiiUgt6o9UIZeKBsqX8MO9GDHCovxniBZh7Vep1WPsYuXS24/S3MZaWjWWhSIfPPEIIa
	TBlYok0WcZOUNWZT1w08XELhpEbZGTqaQ6iYmcbHzERo5+bEJcQjPuu+LqfRCoAQTfgIXOD9Ykg
	2X+S5F2RXNzXcLqJNAXBgcrg4r2DyOsz4K7L8zP8kt0VwRzXZJ9rDh/8MMnthKQ9Rvyd5+YfqID
	xErluMYagarOaBrqT6Yp2XV1kn6DfbfJlJaNYwVsvbgi2yHhdoaqajforDi0OoGjEhmf0=
X-Google-Smtp-Source: AGHT+IHlEBuH1YaInwF8lg7i1a2YyMUz+KIZnXwHErvet21MX4NRl/1XgnBvALl4cFzkTibsFAPV4g==
X-Received: by 2002:a05:6830:2690:b0:748:8b42:77ab with SMTP id 46e09a7af769-7cae81d5dd6mr7516380a34.0.1765901127851;
        Tue, 16 Dec 2025 08:05:27 -0800 (PST)
Received: from [172.31.250.1] (47-162-126-134.bng01.plan.tx.frontiernet.net. [47.162.126.134])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cadb325094sm12181513a34.23.2025.12.16.08.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 08:05:27 -0800 (PST)
Message-ID: <75e0de0a-14da-415b-b336-ae84fc896be1@gmail.com>
Date: Tue, 16 Dec 2025 10:05:25 -0600
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RFD - Exposing netfilter types?
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <1944a019-39af-46e6-b489-96715dd2dd01@gmail.com>
 <aUCBAau7DREw8YmD@strlen.de>
Content-Language: en-US
From: Ian Pilcher <arequipeno@gmail.com>
In-Reply-To: <aUCBAau7DREw8YmD@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/25 3:43 PM, Florian Westphal wrote:
> Ian Pilcher <arequipeno@gmail.com> wrote:
>> Recently, I asked what I thought would be a simple question.  How should
>> Presumably, this is why the NFTA_SET_KEY_TYPE values that correspond to
>> simple types aren't in any public header.  Instead, those values, along
>> with all of the logic associated with complex types seem to exist solely
>> within the nftables user-space utility (nft).
> 
> Yes.  Note that the type info is only used for formatting the data.
> Its not used by the kernel and its not relevant for matching.

Yup.  I understand that this is totally a user-space/informational
thing.

>> Is there any reason that the type-related stuff that's currently in nft
>> shouldn't be broken out into a separate library that other applications
>> could also use?
> 
> Whats the use case?

My immediate use case is really simple.  I just want to verify that a
set (identified type table & name) holds either IPv4 or IPv6 addresses.
Obviously, there's no need for a library for this, as I only need the
values of TYPE_IPADDR and TYPE_IP6ADDR.

For more complicated uses, it actually looks like libnftables can be
used.  (I was not aware that the nftables package actually includes a
shared library until I stumbled on it just now.)  I will say that it
might be nice to have an API that doesn't require using the JSON
interface, for programs that are using the netlink inteface more
directly (e.g. via libnftnl).

Overall, however, it looks like libnftables basically addresses the use
cases that I was thinking of.

Thanks!

-- 
========================================================================
If your user interface is intuitive in retrospect ... it isn't intuitive
========================================================================
