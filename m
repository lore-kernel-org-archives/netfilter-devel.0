Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD81E2EAB75
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2025 14:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752245591; cv=none; b=k3mQMklwKPBDaWACij2gad2DOpmHP+zG8ti9JefUBPhpD0PnMN4Fda1SVOO3xvMfCYG/wBdlBBhgmJezw8t9m31IlaHxG03muc8mAVCHQ7jOCdRDuwwTq8kAYEvcZqEmRQTFcZYG/ZELYEsCdOwmb24kd7/Fj0rcM8kf4+e4TCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752245591; c=relaxed/simple;
	bh=aoayK+d7FaYLuiApZZ6pRIG3bGSfp+rtGpe2r3EX3b4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P7dEuEyl+soP42Obd/9C4YAMIq2gXr+PlYqlFuD/NgJkeiLnYHVyc/qlMfPHx0BgIXNYrkXnV9RXbldUEcaTSG1nfskvLc7g4p1v10hH7RjPffUJbzmEXlaYLEPYBhckHj5Nj7ijZbNhOf2of2Ujjv/zKsjmZs7gzA5OsVzdC2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=id4PHTRO; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tnKOQT7n; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="id4PHTRO";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tnKOQT7n"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6509F60264; Fri, 11 Jul 2025 16:52:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752245579;
	bh=ktCjFepDI20F80TDAX26kNGt5l6U5hULJcoiUwCKY/Q=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=id4PHTROBex333hpEXhgoeZHjGPa4VdYAm8/hlNu5LIuizqxPNZOex3qB6L+ihYp5
	 sqfC4+bU9pnk5Vp9hJP5fT3P1JV1tujQ/CW5B2o/aAie2Y30bBbV5nq/NHeniUOqUl
	 1Sv+11rYm/JMH+iqIkwcWdkOQKRQD8EjX2jkDEW4dAfsbDOEb3th+HYmDGmlkbFkZI
	 gSUIIEQ0t7z+S5lclbU9nltIE+0DEsiStSYyMdo3WURv/7XGdmTmT65xuh5M7HFbns
	 jjhlQ4ZrIo3OtSZcshImN1XA9ka8xr+doRS/hqWeTY3LIoPOSq1iu/X3/r7ARTnX/O
	 F90sA6WtQpTVw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8D0D260253;
	Fri, 11 Jul 2025 16:52:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752245578;
	bh=ktCjFepDI20F80TDAX26kNGt5l6U5hULJcoiUwCKY/Q=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=tnKOQT7nAQ9UrmNVQNaW5SduaIsWU/lJm01EYeNWM5dIVXJ/95XiK+gkfHCaWtBvR
	 tQ/++Dhp+12GhFTgL1Shy68CvxlHbQ5EZ/odgMnhD7EoWxr6oXe4/x1Vrw6i1GwE+T
	 ogD0/FxUOtNaDwWhQmfykqC3NgUDPpawJ5bruOjeYz376lPMJ2c6dsKyyKXhdhHaEX
	 oxIBnIptGoZACqjMrMTtesBJ8PGNMnOoF38b11zWHy/4F6voqWH6I1S5SqgfYYjWT1
	 1XvXwtrcf74dMTNjwxZVv3bvb3X5lriQoLtiJcldqg4kuCmGcZvHAtsuyRpqeaJZ5l
	 zrwcyxhdjZEXw==
Date: Fri, 11 Jul 2025 16:52:55 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aHElR53iOsae5qK3@calendula>
References: <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
 <aGwfPqpymU17BFHw@calendula>
 <aG0tdPnwKitQWYA6@orbyte.nwl.cc>
 <aG7wd6ALR7kXb1fl@calendula>
 <aHEBOFfIk3B2bxxr@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aHEBOFfIk3B2bxxr@orbyte.nwl.cc>

On Fri, Jul 11, 2025 at 02:19:04PM +0200, Phil Sutter wrote:
> Pablo,
> 
> On Thu, Jul 10, 2025 at 12:43:03AM +0200, Pablo Neira Ayuso wrote:
> [...]
> > If you accept this suggestion, it is a matter of:
> > 
> > #1 revert the patch in nf.git for the incomplete event notification
> >    (you have three more patches pending for nf-next to complete this
> >     for control plane notifications).
> > #2 add event notifications to net/netfilter/core.c and nfnetlink_hook.
> 
> Since Florian wondered whether I am wasting my time with a quick attempt
> at #2, could you please confirm/deny whether this is a requirement for
> the default to name-based interface hooks or does the 'list hooks'
> extension satisfy the need for user space traceability?

For me, listing is just fine for debugging.

If there is a need to track hook updates via events, then
nfnetlink_hook can be extended later.

So I am not asking for this, I thought you needed both listing and
events, that is why I suggest to add events to nfnetlink_hook.
