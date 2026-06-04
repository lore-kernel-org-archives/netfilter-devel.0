Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D0429898B
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 01:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780537968; cv=none; b=Rxlx57wrIPsAZNz0f5XFCBny9yN2BVm1IgReOyt5svWFJlEUV/4Mrjx8wq+c0yOs57t/rkC94iTFNLj2SMJ0IdJ+76Sv3f+Z6l4vmUXXGTh3gQ0M5WWzrDabNrw/hBfIX8/j/BEXDdZLl+nt8mS3Uo5y7FpKOS7xxrATQx7dJVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780537968; c=relaxed/simple;
	bh=5SpROYMEKxmu0HLYw0TU7p5AejWLTbuQ9iBGb3rygBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sH+1cGf0PAxTU/H3HJ9BJ9g0sKNHRoJyCKMeJAHjEiBTHdOA+O2++Sbn9VOj2yApaB8PioBFqbLuaUVqOy6nUuZYKQnQgz3rOhvS8tlX8LJu4iPu/9hjK3/tpkcSx+SoShxxqf8yXiipJxrr198dcyYApH3cTsVYJeQZGjVZ60g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wq4QkcCy; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wq4QkcCy"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2bea7176c72so1087785ad.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jun 2026 18:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780537966; x=1781142766; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R1VU/ORPdO9tKOsaR3dN6StpC2u7L99EsUXXUtJYK6E=;
        b=Wq4QkcCyFY5smMOnyFAYtOoZ8h2yCj+y2/s+yZ+LktlqcvlUK+YwqbNLgLtOVzkgLh
         xzPoVyaaUG+JVsgIZ03579kfosbaGcMyIn7VjE5y2b9LoFljGqieCEYqY2U5wBJIEsaz
         3oCQtbEkvmUcjevayhrCUXwDlFDnDy9fN/KODR8/WFNnQSWNH+gJhpXaWikIVolONMRa
         nUQTf1qdfvNX0mAQy8C+GxdPuCaXZjnbizCueall7IOZ5JnZkiBnhvsWhOiy7NOja05M
         xdRKARBLK6NhZihzP4SY1+UJl0mve+/7ip22+NYGWZyaGhXP9jY9yQk9Wm5qk7RY6/fS
         Cd2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780537966; x=1781142766;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R1VU/ORPdO9tKOsaR3dN6StpC2u7L99EsUXXUtJYK6E=;
        b=kR9cF01Rdc/mz19lsRqDyFc4Xt48o2idUL9sYLgZBSJcorPv7OHmzZCPr9j6QxKiah
         pDxL3G3ViFOm9E7HYoH3/nSP3U8nBsBsEWLjcatTZJwaepR4sX89PE+PPlYIQhO9BGDL
         m3tmW+F/HYER3hrtXGkZb61uD8HOw4U6pR/wsvg4zj9JK2YxiaAL/1C5h6nPQXrDHnBh
         UMAHcf4JbKBXCN20Sllmmbi/B7mGa7YMU6rCNEMBO4DuUWeaXJ5RAFKROMiovovzBiR7
         W15nB+0FjonSUaba1PeEmOfFV/52mjliyCyMUtLDoSbaED8BYwfuzC1zCfZ1XcaBaHQu
         ysEg==
X-Gm-Message-State: AOJu0YyLDA8wo1ylsDBdbPGXNUlOPs9f/IzUNHoAsaulGiZ9RBTzxgjd
	mu+BMz5ONpeWbnX6JWuWfeUaHs2/oE7hqWMMTNch3mJIgj/AJO8VJy9y
X-Gm-Gg: Acq92OGuFD5Op8B+Jt/aecSByT6A6y4iF9pFmQrvCao5IGQ1znAGlXOHcfGce71EBvy
	P/xPnPTpheW0H5lGjl3qvWm2oLjQOqDa3Pti9YN4NmbVZOI9mWSEZoryAYlCTwY2Pbnx9hiS2IA
	sD2ysm282ZSBEC8UNvUfqga/RZdWHbdCEx34GHMVnkacSSj+TjreG0wvMYeHo7SI8aA+BLyqdfE
	S8fTL85LSCJGPUXUjCC1sHYdsafy2o1+2k70ovrjSskMHXBrrF4rOIzOFqDdfytfXAIgJDqiLD2
	mATQ5nJj2bRRlY/844c9w0vS9hzS/cGF6pNrOlLRovNGCkJEuXesOUi7wSGijNkBawmmMbmCkpH
	U6FP4E5Ro3/Gc/32A2dd6i9HFPo+QNtCP8LEt1IVBsWMbJAv4cOaltoI8ndbPbpiCCkR3QxfUck
	ptHaTIx+ketqqGHaoULA==
X-Received: by 2002:a17:902:f549:b0:2b4:5f96:184d with SMTP id d9443c01a7336-2c1639edf72mr63819855ad.5.1780537966352;
        Wed, 03 Jun 2026 18:52:46 -0700 (PDT)
Received: from [0.0.0.0] ([64.118.136.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16629d042sm38955675ad.60.2026.06.03.18.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 18:52:46 -0700 (PDT)
Message-ID: <2bbc19cf-e098-46dd-ad76-a4862229786b@gmail.com>
Date: Thu, 4 Jun 2026 09:52:38 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2 1/1] bridge: br_netfilter: move fake rtable off
 struct net_bridge
To: Florian Westphal <fw@strlen.de>, Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
 pablo@netfilter.org, phil@nwl.cc, razor@blackwall.org, idosch@nvidia.com,
 stephen@networkplumber.org, sw@simonwunderlich.de, davem@davemloft.net,
 yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 bird@lzu.edu.cn
References: <831936f111e6e1f435f4f6247d07fe6a6624d271.1779680014.git.royenheart@gmail.com>
 <ahagS3rGl2sG0OVS@strlen.de> <aiC7dFYZpiEHZeyG@strlen.de>
From: Haoze Xie <royenheart@gmail.com>
In-Reply-To: <aiC7dFYZpiEHZeyG@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/4/2026 7:40 AM, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> Ren Wei <n05ec@lzu.edu.cn> wrote:
>>> Use rt_dst_alloc() so the fake dst reuses the core IPv4 rtable
>>> lifecycle, and release the bridge device reference during teardown via
>>> dst_dev_put() before dropping the bridge-owned dst reference.
>>
>> I think AI review is mostly correct:
>> https://sashiko.dev/#/patchset/831936f111e6e1f435f4f6247d07fe6a6624d271.1779680014.git.royenheart%40gmail.com
>>
>> - no need for constant refcount bump
>> - I don't think the ipv4 specific functions can be used safely here.
> 
> Are you going to send a new version or should this be treated as
> a bug report?
> 
> Thanks.

Sorry about the delay, we're testing and gonna to send a new
version.
