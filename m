Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C413B279798
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 01:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779759458; cv=none; b=IOx5LxqjFH80FR2EN8jwEQTz9SKX8eVmLqVjUqA3FX29PmpWUq/uoaQC7E5cwNhzjZ5t3cd2PI5lR1wd/M3WiIU6A+AO+166qnSTuWeLcg7YtQLZzMrx7mSbP3mf+VIrihvvhKqQPi2gbNOvqktb8PxHgjBwEXwvRjuICXZXyVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779759458; c=relaxed/simple;
	bh=BWKCvt6HRmgWze8IpIsTe5xreQIsSX7X9eb2z1DNGnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYRPXYKBFNCDGYNkWflKciT2pRku2QgkM6/7FSFBLR4fIL7P+KwfFWlXX1VUlQhD91dxutTPO3KdT6YGIZuGul2BQIQENbuTZawKfJGLitSjG06FvSPI1ls5yVHGhVmfAOSy5x5K58lT1uy+xEQySZYRol7oYM36CjrjdYnbXn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MkMsKgdM; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MkMsKgdM"
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-3665a90bcd3so10966270a91.1
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 18:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779759456; x=1780364256; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/fKHZpFYcaaYSyTuT6n/F6PsnCS6G44pjbUMI/9Wfs=;
        b=MkMsKgdMrQolKdDNh74Xw04FyEWm07DWaVW0MPTqVkE80kdUYShTRJu15d3j3k8+Iv
         VHmWqZtAbTm+IaXWLasktsVpU8S0s2AfXlkowgzP7UyIFUspQQoyVQ9oYCPYf3M3YjQj
         7r+I8FMXtv/Zm4ntVv0xeAGQ5P4U87QCGdeEhxSIZwjYcMRqGqM3YuPCZb+IgezTIrlz
         s7kaWYUXVFltZ7cdkHV+0zw/D1CJD6kyojAqLSs8/DPXkE41leYTVjk1wjifMyfCqqmT
         hjeHUkJaqqucYmKKhrVFLQW7zHGc1sBE+Uwve3RWL2DarmvAKDNFpYqNgXIw+3nhZsR7
         bndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779759456; x=1780364256;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H/fKHZpFYcaaYSyTuT6n/F6PsnCS6G44pjbUMI/9Wfs=;
        b=mh9MgJ9lriB41KEbviNYKtvLhpWaEmBs3AJFxh+zNnenJDMU4rV/0LwXEm0WD6gJ7O
         acubsi1leZFZGuBCw3ldlKQnzBj5/FLXoWfsAsG/q+CjAiMsSbaaKiLzDRq4jEFKMiw8
         /ROIs8RlABZxW+WdSj51XSeIqOTuKZlaqNzjzC4j5ePHe2Do92gSi4PEOp0Hg3gJEp3I
         8JGmEYgNqaP+SfubglHmnkzylfE4YtDfTpENm3GUjQ+/i3vZuIsrmnxthgpFIZ35ejdH
         /NjoiFxKQ3MErWt8DUHf82gAaj0x/5ifiu+u6R5u6nnucmWG3JJB+F+NjVITR4rsLyUh
         KBOA==
X-Gm-Message-State: AOJu0Yz4yM3BDt5b6gf5/uA10jTbBCW1wAc+aGMdLubbKJv8CN7QWm/+
	M7qix+/A+3DbwuDEeqPYcUNTbKiLpiyaKZmLulCrV4KQbYQJN4oIoxi5
X-Gm-Gg: Acq92OFerwBplK6kd8/xqiQ5yoL1jgldvmmFOMI69NCxObB/fMdFeKOv0otCPm57Wfe
	0PDbx9u0tDbrrRNfQokRu1udz4jOrockpM+OP1hdPe7S4QkZsb5isLQPtAURMNrLIcyy0U/etLl
	595fiNd1wZtDw5jKe0pBocc/uM2r/UYyBUt76p9TzaJXkLweVsGi619syBOP0MMOBFDUkTSC4aI
	gV9yic62qDU37FYgUiMqTRAj6h0MgVuHkIfV2LKOPg5ppTkqlGBX0cUPdQylkeV8yzpKWABg4y7
	dVmEOLG46lcrIjkOkXSNNJWziUv2TnQpR3sDHanAeQWvG0oLZjHyapjaBkRmdF+6r4d6j3aAOh+
	DUcMhbg3Q0tLwi4uY+ahSDFQKH9UL5BcZHh76q4kBGGtX5aYEMwTTsAKdbCTa06R3OYVH0o/QWS
	Xv33rwqhOiSTXRBs80yA==
X-Received: by 2002:a17:90b:4c87:b0:369:7421:75c3 with SMTP id 98e67ed59e1d1-36a67602377mr15566466a91.16.1779759456109;
        Mon, 25 May 2026 18:37:36 -0700 (PDT)
Received: from [0.0.0.0] ([64.118.136.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36ac1fe6df3sm5388404a91.2.2026.05.25.18.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 18:37:35 -0700 (PDT)
Message-ID: <05392cd8-a4b6-4087-b038-fcf8dfe73b36@gmail.com>
Date: Tue, 26 May 2026 09:37:28 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf 1/1] bridge: br_netfilter: give fake rtable its own
 lifetime
To: Florian Westphal <fw@strlen.de>, Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
 pablo@netfilter.org, phil@nwl.cc, razor@blackwall.org, idosch@nvidia.com,
 stephen@networkplumber.org, sw@simonwunderlich.de, davem@davemloft.net,
 yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 bird@lzu.edu.cn
References: <cover.1778687139.git.royenheart@gmail.com>
 <783d76ac83917b7302c1ec647794bd773bb1875a.1778687139.git.royenheart@gmail.com>
 <agy4FOL639LtWbU5@strlen.de>
From: Haoze Xie <royenheart@gmail.com>
In-Reply-To: <agy4FOL639LtWbU5@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/20/2026 3:20 AM, Florian Westphal wrote:
> Ren Wei <n05ec@lzu.edu.cn> wrote:
>> From: Haoze Xie <royenheart@gmail.com>
>>
>> The bridge netfilter fake rtable is currently embedded in struct
>> net_bridge even though packets can keep using it after bridge teardown.
> 
> How?  Please elaborate a bit, it is unexpected.
> 

The fake rtable is attached to bridged skbs in the br_netfilter
prerouting restore path via bridge_parent_rtable() +
skb_dst_set_noref().

If such a packet is queued to NFQUEUE, __nf_queue() upgrades that fake
dst with skb_dst_force(). From that point on, the queued skb can hold a
real dst reference even after bridge teardown starts freeing the
backing struct net_bridge storage. When the verdict path later drops or
reinjects the skb, dst_release() can still touch that freed fake dst.

>> Give the fake rtable its own allocated lifetime and make
>> bridge_parent_rtable() return a referenced dst. This way the bridge and
>> any packets that still carry the fake dst each hold their own reference,
>> so bridge teardown no longer leaves a dangling fake dst behind.
> 
> If we have to do this it would be better to move this kludge into
> br_netfilter.c completely and get rid of the fake rtable hack in bridge
> for good.
> 

I reworked the patch for v2 to keep the lifetime handling in
br_netfilter and to address the issues from the previous version.

Instead of adding a separate br_netfilter-private dst lifetime scheme,
v2 moves the fake rtable out of struct net_bridge, makes
bridge_parent_rtable() return a held dst reference, and switches the
callers to skb_dst_set().

To avoid the extra lifetime issues in the previous version, the new
fake dst is allocated with rt_dst_alloc(), so it reuses the core IPv4
rtable lifecycle instead of custom br_netfilter dst_ops state. During
teardown, br_netfilter first detaches the fake rtable from the bridge,
then calls dst_dev_put() before dropping the bridge-owned dst
reference.

> Please also see various AI comments at
> https://sashiko.dev/#/patchset/783d76ac83917b7302c1ec647794bd773bb1875a.1778687139.git.royenheart%40gmail.com
> 

I also went through the Sashiko comments you pointed out. The v2 change
is specifically meant to avoid both the bridge-private storage UAF and
the follow-up lifetime problems from the previous approach.

I will send v2.

Thanks,
Haoze

> [ I would like to zap bridge_netfilter but it seems its too popular ... ]

