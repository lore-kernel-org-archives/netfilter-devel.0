Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B81E43E496
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 14:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768921014; cv=none; b=hldaXtOLb2vOpULHMxSVXjC9aoQq+25gL+rlFDtHRIN8sA0mX05RlqceuxEUBvun0splLpIEy7RqD7c0rZ6E5Jj5T8EDZ5Xj0g2Fft1Yi+gdcbXaz1mmCfb69MN7+MsTkWqsCJI7qzv7uTvw4qrHzwbcrsLysz2DftIb2V2VmWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768921014; c=relaxed/simple;
	bh=XVX2ipQpgEWC+e+rtcAFUrhjiIrVjQK2wNe006V/sPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPPm2SSgJmvbbWikROgzkXVDyur91qHf6d+xgHmu3dV56AcIiK3BBWgN7Mx+kn/mMlJTOrJHbiZ0w8H14e+L2Zxd+eyyhrj5OTpBZLysuqqWjN9Gs0XAgi5i7ERH8ajs/xcYqdAlAUIi5OSwSj4R1Reh73MeNEvEVdBTm1b77bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nh0MObYu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nh0MObYu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=V4ayC4DY8gV2odPhv3kFpPlNJ0syd61K8cB5cQ3PhWk=; b=nh0MObYuAgf69fjDRmGDFvT4eX
	61rl7OLSJ0mlO3KiVIl/DHHMMJT/8Ou2uK6eN1CFKYMZ1BAdtcHz9kVk0NW5Dp3mEIMUFtCe7FR1O
	pX3BkLBnKVf11wbBF022LZvLtaPJSmLx+LxeY5bsWrUS21gLwnfSjVX0jZQpdn9K0A4ta9Xq9OAXP
	x649GbdN5IoRgkbk42J2eyDNEyT0/Lqmua1nYzEhQXuYLVuVBoIYkhkUJPPkIsdUbvzhjeg7M8d2x
	Sw3XDYbv6zQf0od3mjvJGGAzZh9qsIHo1rNEVJ7iaug3W4yHxVyE6iNUnDRwC7i+2RROdjy/RFrL1
	BzEJ/0iw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1viDA1-000000008Uw-4AZb;
	Tue, 20 Jan 2026 15:56:50 +0100
Date: Tue, 20 Jan 2026 15:56:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v5 1/3] parser_json: support handle for rule positioning
 in explicit JSON format
Message-ID: <aW-XscWfRRhMJaUh@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20260119140813.536515-1-knecht.alexandre@gmail.com>
 <20260119140813.536515-2-knecht.alexandre@gmail.com>
 <aW-MY7iZLC-iVuht@orbyte.nwl.cc>
 <CAHAB8WzhVzdiSQ47Pf79A-3O9F3cHek6euq=vWEP1rMcpbuixA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHAB8WzhVzdiSQ47Pf79A-3O9F3cHek6euq=vWEP1rMcpbuixA@mail.gmail.com>

Hi Alexandre,

On Tue, Jan 20, 2026 at 03:27:58PM +0100, Alexandre Knecht wrote:
> Hi Phil,
> 
> Thanks for the comment, that's pretty straightforward to fix, I'm
> afraid to do a lot of spamming if I post again a new series, so can
> you confirm this is what you expect ?
> 
> Merged nested if-conditionals (cheap to expensive):
> - if (!(ctx->flags & CTX_F_IMPLICIT) &&
> - !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
> - if (op == CMD_INSERT || op == CMD_ADD || op == CMD_CREATE) {
> - h.position.id = h.handle.id;
> - h.handle.id = 0;
> - }
> - }
> + if (!(ctx->flags & CTX_F_IMPLICIT) &&
> +   (op == CMD_INSERT || op == CMD_ADD || op == CMD_CREATE) &&
> +   !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
> +     h.position.id = h.handle.id;
> +     h.handle.id = 0;
> + }

Yes, this looks correct!

> Reverse Christmas Tree variable declarations:
> - unsigned int i;
> - json_t *tmp;
> uint32_t old_flags;
> struct cmd *cmd;
> + unsigned int i;
> + json_t *tmp;

Also correct AFAICT.

> Or maybe there's a solution to amend this series, not kinda used to
> work with git send-email, so if I can resubmit without a new whole
> series, could be good ! Otherwise, I'll just create a new one once you
> confirm.

I can apply trivial changes to patches when applying them. With some
projects, people also just resubmit parts of the series - this causes a
bit of a mess for maintainers (and reviewers) though so it's not usually
done. With a small series like this, I would just resubmit the whole
thing. After all, becoming more familiar with git-send-email and the
whole process of amending changes and submitting a new version is very
good practice for contributing to OSS projects! And please don't forget,
we're here to help if you get stuck or don't know how to get started
with something.

> Maybe I'll wait for review on tests too before submitting everything again.

Just finished, only one more change in second patch requested.

Thanks, Phil
