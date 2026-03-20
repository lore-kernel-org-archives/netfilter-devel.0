Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6291A3A640F
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 12:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774008562; cv=none; b=M0bh7y1qUGCbNERmf/QOex4wf8rQ4uEBLpgTPveudSCZRu5xxqkpg/9aQp8+UhI5q3y2p4yZyNn6efneu8cIx545P/L3mk+SfEM9a0yj0/JcWqactpSXrhgqvjoFHePHyHlT1yE9UPEjl/mT3vbxMEJJFLXYeCo7/yVunVJTzAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774008562; c=relaxed/simple;
	bh=ELy52UnyNSf992OmFEK7letQ3JtxfHhsFHRZNtZUcG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=so45kyd+TXpbTMQuCDYyMQT6++isPGRm4OSETEK2K3icmF17uT+A5t6IyThkvyYGNumYPC6Q5bRrGBccwB0gKHroG3yLzoBhhg2yE7wiP+IonVsWHVVj44qeGM83cb3HVdJBD7f3aiHXg1RS8t1lvPxx1TAaG2zuk8JCSbRPZLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OwiOajOK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OwiOajOK"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 78D7D60178;
	Fri, 20 Mar 2026 13:09:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774008559;
	bh=ESHx3gXs6F4yeNYgl2my/pQJpC/5WWoUrhPXOK8xsag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OwiOajOKCphE/HdB4AIMje2a52sw8VVqAuesBkc9XScYzElSyZmRjthq9GHmuM+QW
	 bWJk3Zu7c2UZOhnhN54JMSzBS2icBMRgG5BBDTeiSMyeMd/VWEBTz+T7x+uewdQ6++
	 ABJJR2wd708tp3Rt0lvn6jxchezHGk+DiuZbTQ9ZI8jTaZIDw3YtE7jUd8AAas7mwX
	 ywM4gu9eJbNauJLuYD5e14IPwkvAybsFU3ycCYXYG/dfwhf2G1cm1WVVZuWn9X41Hs
	 CUcoR9iBVCRx45gD6DJbQZXXnbhDYYGo4lGcguFtdHNT3e0fy/tqQ9cCyUq6P/TP0a
	 oFcV27E3OIJmA==
Date: Fri, 20 Mar 2026 13:09:16 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <ab047FS3MijyN_Ik@chamomile>
References: <abwraHUuxizN4krg@orbyte.nwl.cc>
 <abwtAkSF8-SmH684@strlen.de>
 <abxlzn7lymOxWUFa@orbyte.nwl.cc>
 <abyTyJBv47f3v9gd@chamomile>
 <ab0enMtOAFiG0mSN@orbyte.nwl.cc>
 <ab0rbTfE7LWIk7f-@orbyte.nwl.cc>
 <ab0tB2o90FukwQxU@strlen.de>
 <ab0u4JS4Z7THrP6B@orbyte.nwl.cc>
 <ab0xNu8tKdWigNQ1@orbyte.nwl.cc>
 <ab0zy4fOLraYqVPJ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ab0zy4fOLraYqVPJ@strlen.de>

On Fri, Mar 20, 2026 at 12:47:23PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > Sure, but <=nftables-1.1.6 will still get it wrong. Can we tolerate
> > > that?
> > 
> > The kernel could dump them in reverse. :D
> 
> WTF, no no no.
> 
> The kernel is fine, this is a userspace bug.

I think so too.

One of the main use-cases for 'list hooks' is to display the order in
which hooks are run.
