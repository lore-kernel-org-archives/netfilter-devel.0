Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C12E35948;
	Mon, 28 Apr 2025 09:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745833620; cv=none; b=VDjOV4xGT8kYiswxsYbJZYG37jLhmMoTnzGUujCY2qOe6hG0nOG+VrBvoKL6+2RYVt2TUuhKwf/rTmDXtLBUvXyTvtYeGW3TeNkEBP6SeDV0qtgrjUDjcO3g9W3nWUWo+ZYlheVp2xZRcycZaf2U9qXRva4bmPjRAuVZZrOrjXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745833620; c=relaxed/simple;
	bh=C8iPtrd8fB52Gd1GyUrGYVxOaqvoL/bDk0LqRSLid5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gfK+zu3le5qmZpZsbrOfWz+ajaCxJcc77gojZrimvpOHwTw4nvJBgHtCK/YEAG3WaRH49KTlpE3AFjm7BHjwvWnlU1w4td63mDSrm8hyRGAhlk7j5OHOAnAAz4FoLsP2kTK7xuCVIQfrYSRd5WsAN3Y8NmSXQ46ZKvT1QvFTOJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OVY4Cl7m; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=r4XAPYlg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OVY4Cl7m";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="r4XAPYlg"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 968C6603AD; Mon, 28 Apr 2025 11:40:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745833232;
	bh=IfY/Hyz4Uq5w4aafjWmTBVFETfIHLFXDrW7Dref7PfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OVY4Cl7mrYr9QAaz1+/xqfXx6t5Qz4MMOEYSoIjYRzNYvkCXf0DH3NtFsmYosJQNX
	 HQXhDp3T7ErmwfRVPVwe0SniZDspGlbj69A/i89kftCma/okQgV+dOboCZ3btFnAoF
	 +lWEsFmXY/Gnr91whID7pcFAzWdzXTWS2q7Wv+x05+2dtF31pBlFExA+ZFXuyGYPYF
	 P2Yp55dy/HKyuPgaWqR2270xQfAFYeZH5voaEVRXp4Ld11As+VrS+WLhTAk2V6ppKb
	 N5vz87vIhMVqURGBzJaiYGfEqSlIAc2xfhwhsU+esSIe1n9X90F5WEnbiLqxtTfMQ9
	 G8FQli3fab/Cg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5B84260353;
	Mon, 28 Apr 2025 11:40:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745833229;
	bh=IfY/Hyz4Uq5w4aafjWmTBVFETfIHLFXDrW7Dref7PfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r4XAPYlgSMBXm6fsZ4DI1Z0s71BvbqUn+FMx2x9w1gTCVvWYzldUnf4l5UCWYfwQ4
	 TRFtBGLRBQZ8dO5z1rWL0LocbDeYNydfj0fYPsNq6wKi5y0h07BmQjpEf9ubShNDNz
	 EW8htwAq+kfD6gFcunGrRQF73LcteOJ8sJUGwcOB1tLQGnYoFj9nFPwIkpbSYOjjO6
	 sdTLbB5n843nZI4I9StQzfGuI7ml6zv2e8TA3sD/4ITgr/nqbAeKbXzXemcAvTRlgI
	 vWnoLoyjrPqsMEhH+bpvLHQBrxXCr5qJBx2mZWUA01PoG5f8peh64P7+mjJZZK8c8l
	 n6F5BbnVYb8MA==
Date: Mon, 28 Apr 2025 11:40:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: lvxiafei <xiafei_xupt@163.com>
Cc: fw@strlen.de, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH V6] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <aA9NCkhJrLeeig9X@calendula>
References: <20250415090834.24882-1-xiafei_xupt@163.com>
 <20250427081420.34163-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250427081420.34163-1-xiafei_xupt@163.com>

Hi!

On Sun, Apr 27, 2025 at 04:14:20PM +0800, lvxiafei wrote:
> Hello!
> 
> My name is Xiafei Lv, and I sent patch v6 on April 15, 2025. As of today, it
> has been nearly two weeks, and I have not received any feedback. However, the
> patch has been tested successfully, and you can view the details at this link:
> https://patchwork.kernel.org/project/netdevbpf/patch/20250415090834.24882-1-xiafei_xupt@163.com/
>
> I understand that kernel development is busy, and maintainers may have many
> things to deal with and may not have time to review my patch. With this in mind,
> I would like to politely ask what steps I should take next? If you have any
> questions about my patch or need additional information from me, please feel
> free to let me know and I will cooperate as soon as possible.

You just have to wait. We will get back to you with more questions if
needed.

> Thank you very much for taking the time to deal with my request, and I look
> forward to your response.

Thanks.
