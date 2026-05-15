Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EE2282F21
	for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2026 01:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778810080; cv=none; b=AsafFQar5QbGfg20fjIm0UBrYcuVfArc6J/brQGFXxBONZWz21wMPMgGn73UB8qDFOSeql0vEeSsMH0NAH5wWJJtWk0Y2vq0sR9qv0JRFOhgA7yUmP/vEFxOSaOrdxERtJNA8JuTHsVX4ukmTKOM7/vuY32Vl8n8aXkbZ5k/W14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778810080; c=relaxed/simple;
	bh=uayRGD18ePqNrXwbcLWwokBE6NEqZOrQ8PE3S78omQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c+XshVSUuL8NO9ZuWU+aT9HnxT/ZShtSgTw+yxZySHDwDM+b2rQzerSu5MdczcVmpwJk8a5dO3kNnrluSj2OOpCqGBYtb2NhuMDLdOUb36hDfiS+NQrJvHK0vx/SLvJjKiTCt0NPfu0GGhdiMgHcCnsTqgwx1cvUv42ioC/auqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mo2MM+w6; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mo2MM+w6"
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2b7d3ecc10dso85231525ad.2
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 18:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778810077; x=1779414877; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGsC6THnLn2BuAk7itYadra1nxwv3nHJRXXQqR51LgU=;
        b=mo2MM+w69o/MIhgbpetyuNfeaZI6XhjhJOm3UnOkCkUdmCzXLjSmAsUkn24r4CWzhj
         RHfHVgvcJAB02Fno9iyk+1W/dVW6ws2ppfcv5BXPUr/jPYgZtDP1bDeXTvctcF5Sar/d
         x8fcgJ1YqViqT7ZkjB6hnWKMgaK4/HsRK35l/wpxYqX91G+Q61GNRSr2rOFX2h9AqE6d
         Hy7K5lHx4uRMbZdXhVTtSl/hfWgamOQhgKVf3ZoOQoPBesNYQWsC5g/00uLzGfbUmzzF
         HXyXf15UwEZ5z6LzVQjm/iSCgCxo5WrlKmcjDEfv7xKxrRNeV9aQkFu9c/ZK4qzndDLh
         4WEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778810077; x=1779414877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NGsC6THnLn2BuAk7itYadra1nxwv3nHJRXXQqR51LgU=;
        b=lufZFKrLeqxJWRvb6HtzyAU/Q5oNpm4gzmGS9Nk+K3273dm28mjBMcKUy9gjCjrrcB
         FV5rbZ+ePI3Yb8sEE/jeiSr0MheahL2P6RGVrKj/Z1T+/afSlpuDHH/Htn3w6KjQqFnv
         BNd1nPJTpsqoXHqCs5sOaeJkbMsuEn0dNjm4DPT2lAOy3o0VZPThTreGk+mtKcxfr3SD
         a+Zmrwe9WJhV6X+iYQ18fTDNwWRfOutCYp8Ob7b6GFn07CnTGFVfL99ZSs+Mo0USUotY
         6l4TN5wCvFVQPoFNwXw/tWOjvxWSoJ8FxqNJGcVgA+x/avR7sLd9eqaNo9kVWwDU0PLZ
         /Kvw==
X-Gm-Message-State: AOJu0YzW+Nr1uM34Fwar4EaOi/qumm4eZHEXeEQxWOTzQWi/xcCZEktR
	aENVLqQg6S8ZE/yYGRmVmZmxlmz1SA4vc74zGzSZmGfAELr9RuSXIr/D
X-Gm-Gg: Acq92OHx5rY++B/l6yrtX6cw5IsUQhGKmhjheFUEuE/KDwCJxqpU3xKJ+5HQQqXBucq
	cx7tFmTQahFaa8RHkjr4lFGtCqFPzgYuPsXhr2UEvrFZEMAgq8+9UNRbQ1SPKzlFcs0fJk2w7jE
	v8spMcG+sRRsVmeUw6TKpFChUm/MW9P1TD00Zgk+wonEfzg5TXSsejxxjQVLLFfXEcOVzvUwd1I
	0x9pJ17QZUNoIqhcxrrtGXgPeaYDqjplSNsgZfhN57KZAugXb9YhU9Ce30bKVt1JeTjurjJRTbo
	irzRXviBRYFjXMuX/t+fQSJKFsUpeYMgCBUFqw6gBMHcleWQoYbiriZ6uGlVp0bzy/1JHHvZ83m
	yNp1gbBG8O0p587pENK/9vpfOnGo23bVM/B4H8a+9SAZ6MCwUK7/GWCozgu6/dlfctjeiS81Zay
	pAUAWMmKVoupZ+2EItFc5/aFhGoygko4RyCTgSNuPY2f5+
X-Received: by 2002:a17:903:4405:b0:2bc:f1ef:2e65 with SMTP id d9443c01a7336-2bd7e7f2ad6mr19885835ad.17.1778810077013;
        Thu, 14 May 2026 18:54:37 -0700 (PDT)
Received: from [0.0.0.0] ([2a12:bec0:16e:590:1aa:f10:c238:546f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5fc60sm41411225ad.9.2026.05.14.18.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 18:54:36 -0700 (PDT)
Message-ID: <b15744af-c026-4d35-9a23-5d4ac39e1da8@gmail.com>
Date: Fri, 15 May 2026 09:54:35 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf 1/1] netfilter: xt_IDLETIMER: scope timer reuse to the
 owning netns
To: Florian Westphal <fw@strlen.de>, Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
 luciano.coelho@nokia.com, kaber@trash.net, yuantan098@gmail.com,
 yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn,
 royenheart@gmail.com
References: <cover.1775353240.git.royenheart@gmail.com>
 <9c5661fad291777d8e998e23f3cb27cac37aa607.1775353240.git.royenheart@gmail.com>
 <agWhUUyIy4JZlVlq@strlen.de>
From: Haoze Xie <royenheart@gmail.com>
In-Reply-To: <agWhUUyIy4JZlVlq@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/14/2026 6:17 PM, Florian Westphal wrote:
> Ren Wei <n05ec@lzu.edu.cn> wrote:
>> From: Haoze Xie <royenheart@gmail.com>
>>
>> IDLETIMER keeps timers in a module-global list and reuses them
>> solely by label text.
>>
>> The existing rev0 ALARM guard avoids the panic when rev0 reuses
>> a rev1 ALARM timer from another netns, but it still lets same
>> labels in different netns share the same timer object and the
>> same sysfs entry.
> 
> Isn't that by design?

My patch was based on the premise here: I treated this as a
namespace-isolation bug and tried to enforce per-netns label ownership,
but that is not how xt_IDLETIMER is defined today.

> 
>> Track the owning netns in struct idletimer_tg and only reuse
>> timers when both the label and netns match. For non-init_net
>> timers, derive a namespace-scoped sysfs name from the netns
>> inode so non-init namespaces no longer collide in the global
>> xt_idletimer sysfs directory.
> 
> How can that work?  How would userspace daemon relize that the
> name has changed?

My proposed sysfs renaming for non-init_net users would introduce
userspace-visible semantic changes, and I did not justify how existing
userspace would discover or adapt to the renamed entries.

> 
>> This keeps init_net sysfs paths unchanged for ABI compatibility
>> and preserves same-netns label reuse, while preventing the
>> cross-netns timer-object aliasing that caused refcount, expiry,
>> and teardown interference.
> 
> I don't think there is a bug here.  Two netns using same
> files having same sysfs mount should naturally "conflict".
> 
> Maybe one could make a patch to force-detach an idletime
> in a non-init userns if init userns asks for "foo" that
> is already claimed by different userns (to avoid the "Dos"
> angle).
> 
> But I'm not sure its worth it.

Thanks for the suggestion. We may experiment it later, but for now we
decided to scratch this patch since it didn't reproduces the more
severe behavior.

