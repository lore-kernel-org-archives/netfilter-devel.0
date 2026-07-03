Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556993793AD
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2026 09:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783070088; cv=none; b=dDJ60iGiPwLLGpoUjgDin0SFNCH/vGE+scXlFliiVDaw2pswDf6Q0FAbWkTVZYoG1pugl67PyUbndmMyJz7Is5AHj7JojlQgxeaJkm3djT7IkxKsql5phbEf5WjFSBJROTxphPt+eaOt+iF46JNBW8KK/+wWJbAkiPSs3YS+g1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783070088; c=relaxed/simple;
	bh=5dO80+DMeb5x+gAz9ge4PaVJ0AlcHfRsW75OgL8yY4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hy1CfU88G6z7Dcfp6iXhB0dat87/8XQzjKy271A3I3UaXRsgbR9Scd+vVJfjJsIkRen+9gjbk0L7tQGRYNckl9qTBiOniGstYDADaUWl5QmGM2ZIf0xjfSoLc4iYzmiYS2UGS8iiJlBv1Fs85mYmfe16XpfkSaXmzbUlDDrVpKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pSbTqjBI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pSbTqjBI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sUrmmbTO1a0QNlfRiDU8UqHITSX9AYb47Rv35w8jNvs=; b=pSbTqjBIt3TlN8rfgA/gBKF8hb
	AWQPEeFlj76BPlM9fdA8/MMNtcL4Lf7fAtxxPXS98QyUA7hcaw8Uk/BEhX/es5Bm6birU/GeK83Ea
	ix6YM1NP4r8Oytx3TWej5ACnYcjTKgMXeY27uTjL+pDXdlemniKrcdAfIlAnaufnqwQxt++xRBRDU
	pwnFfyuFACSfadeQPsgZYoOfZ/9zdbpU/+JeiCdBIseyR4iMWQVW+9JsD17HuSYbT4XWt2+W+Hi0j
	FA+rgk2SMqM+2TT12nwGMLULuxWCubIGlUE10cFVMxeFzxGV4IoySVq36kklKJVvWfifQzzosEATg
	nKiSrY8Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wfZl3-000000005rm-3hDb;
	Fri, 03 Jul 2026 11:00:25 +0200
Date: Fri, 3 Jul 2026 11:00:25 +0200
From: Phil Sutter <phil@nwl.cc>
To: Ren Wei <enjou1224z@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, yuantan098@gmail.com, dstsmallbird@foxmail.com,
	chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 1/1] netfilter: xt_time: reject pre-epoch calendar
 matching
Message-ID: <akd6KZo1lwQ719d0@orbyte.nwl.cc>
References: <cover.1782879547.git.chzhengyang2023@lzu.edu.cn>
 <779d223ad31c493cbfc3c483293e435dca89cf90.1782879547.git.chzhengyang2023@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <779d223ad31c493cbfc3c483293e435dca89cf90.1782879547.git.chzhengyang2023@lzu.edu.cn>

On Fri, Jul 03, 2026 at 03:32:43PM +0800, Ren Wei wrote:
> From: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> 
> When XT_TIME_CONTIGUOUS handles a cross-day daytime range, packets in
> the post-midnight part of the range are matched against the previous
> calendar day by subtracting SECONDS_PER_DAY from stamp.
> 
> On the first day after the epoch, this backdating can make the signed
> time64_t stamp negative. localtime_2() and localtime_3() then feed the
> value into unsigned division helpers and derive wrapped calendar fields.
> In particular, monthday can become larger than the valid 1..31 range,
> leading time_mt() to evaluate an out-of-range
> 1U << current_time.monthday shift.
> 
> The date_start/date_stop ABI is unsigned and cannot represent pre-epoch
> calendar dates. If contiguous matching backdates stamp before the epoch,
> only rules without weekday and monthday constraints can still be
> evaluated safely; reject calendar-constrained rules before converting
> the timestamp to calendar fields.
> 
> Fixes: 54eb3df3a7d0 ("netfilter: xt_time: add support to ignore day transition")
> Cc: stable@vger.kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Xin Liu <dstsmallbird@foxmail.com>
> Assisted-by: Codex:gpt-5.4
> Signed-off-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> Reviewed-by: Ren Wei <enjou1224z@gmail.com>

Reviewed-by: Phil Sutter <phil@nwl.cc>
