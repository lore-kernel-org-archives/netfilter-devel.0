Received: from gosford.compton.nu (gosford.compton.nu [217.169.17.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8144625;
	Tue,  6 Aug 2024 11:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.17.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722944314; cv=none; b=EOe/oU+TRl3SWLjXd62o4uiH0HKcjF1HvOHh0erTsOrUuEl1YKzuf0Xye5f13iO4z6/qu//DGsSI/cjcUAenwDA4Gwgeg0+tsfZQ6hXeRkF106yNHA/zwNqd6PNNTkj4qYrz4ALeEAD4v5PdU/FXwcYqxuwvOyoQRYwFr3dHVAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722944314; c=relaxed/simple;
	bh=pm4JFSyDy8zqS9Or7RgTyDhT+SDGy98biBRByZDnRAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yw1XAbeAsCmjm70qOOTFHCvTvlmO7HcOxSSx4lnhUBN7pmnmGKzlP13mv2exOVzelb/EsgduoXn0eqf10sUgAYDGWAHA4z+9xK9V+T8pzvAq+A2MWWmEquoOaebA8nyZELeAU8EyJLg32jMdCszVuxjx1uczieL1Ba1y5G5PDV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=compton.nu; spf=pass smtp.mailfrom=compton.nu; dkim=pass (2048-bit key) header.d=compton.nu header.i=tom@compton.nu header.b=SaQC5y6d; arc=none smtp.client-ip=217.169.17.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=compton.nu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=compton.nu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=compton.nu header.i=tom@compton.nu header.b="SaQC5y6d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=compton.nu;
	s=20200130; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=R6yxVzeq23fh0HSZdboeKeNfWBbrVfqTYYfGlFQu6EI=; i=tom@compton.nu;
	t=1722944312; x=1724153912; b=SaQC5y6dbYq16DXyazkQk1SlHxAaVOwc0dGjHNBWVBdnCYn
	BVxDd/aXrCFD3WrkR+4D4Xz4BFqlim8cco0RtRIs2zWt/B7Yb8ZvXvcH2V4Ya2XypsV2+xsUtEJjP
	E2pdLyRPwd12s0/o+th0aG/cpv/ZIW24WSpDc6+u6Lh9mAKxqoxshMmPo74QU4cjoCMNz2TFEVElR
	dHYrDcNXQeO0cTJAZhBG28a97MpeqJPwh0k5A18/v5pB50P4CA2Iv79fc+DqbaOykkC5o8AaHqDN4
	McYyMLxq7G4FphmJUIh8Ks18W7Cmpn0QOdvCTVBv/lEQfrYaUtVmiWtqKF8P+fuA==;
Authentication-Results: gosford.compton.nu;
	iprev=pass (bericote.compton.nu) smtp.remote-ip=2001:8b0:bd:1:1881:14ff:fe46:3cc7
Received: from bericote.compton.nu ([2001:8b0:bd:1:1881:14ff:fe46:3cc7]:37996)
	by gosford.compton.nu with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98)
	(envelope-from <tom@compton.nu>)
	id 1sbIWI-0000000GbHn-3bau;
	Tue, 06 Aug 2024 12:38:30 +0100
Received: from bristol.uk.cyberscience.com ([2001:8b0:ff84:1:5cba:2dff:fe82:71af]:58176)
	by bericote.compton.nu with esmtps  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <tom@compton.nu>)
	id 1sbIWI-0000000Dt0S-2O7j;
	Tue, 06 Aug 2024 12:38:26 +0100
Message-ID: <ccb00a3e-4f73-4354-a94a-920d7b29c9df@compton.nu>
Date: Tue, 6 Aug 2024 12:38:25 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: allow ipv6 fragments to arrive on different
 devices
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <20240806105751.3291225-1-tom@compton.nu>
 <20240806112843.GB32447@breakpoint.cc>
Content-Language: en-GB
From: Tom Hughes <tom@compton.nu>
In-Reply-To: <20240806112843.GB32447@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/08/2024 12:28, Florian Westphal wrote:
> Tom Hughes <tom@compton.nu> wrote:
>> Commit 264640fc2c5f4 ("ipv6: distinguish frag queues by device
>> for multicast and link-local packets") modified the ipv6 fragment
>> reassembly logic to distinguish frag queues by device for multicast
>> and link-local packets but in fact only the main reassembly code
>> limits the use of the device to those address types and the netfilter
>> reassembly code uses the device for all packets.
>>
>> This means that if fragments of a packet arrive on different interfaces
>> then netfilter will fail to reassemble them and the fragments will be
>> expired without going any further through the filters.
>>
>> Signed-off-by: Tom Hughes <tom@compton.nu>
> 
> Probably:
> Fixes: 648700f76b03 ("inet: frags: use rhashtables for reassembly units")
> 
> ?
> 
> Before this nf ipv6 reasm called ip6_frag_match() which ignored ifindex
> for types other than mcast/linklocal.

Ah yes... I had found that change and knew it changed how the main
reassembly code implemented the exception but hadn't realised that
before that netfilter shared the comparison routine.

I'll update the patch to add that.

Tom

-- 
Tom Hughes (tom@compton.nu)
http://compton.nu/

