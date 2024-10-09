Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF7F18FDCC
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 11:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472135; cv=none; b=rnfu3RUPlJaPm0k+IVYuyx3efAxvvwXFjPrW2u/6lC1t3QGLdsxQMckWVoqoBHJeJ9afoiDjG2PyGcdIeGYqwyAMiCtMW3nFXs0dvnKTbs8RjMM6i81jvNoHlXqn2QOZzCnwZSppSbJjiM4iMYNBTsYQozicRXIMOLP2IR1wl3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472135; c=relaxed/simple;
	bh=w9Ubzi5H6dSB9Gxwr1cE0GI2SN6YCReDdFJed36YT4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGCc+fOck80fqNjXkWPTepiuHCPTSYI4Y7bd2j6ELyi1+klZ4o7Z1MHdB+0es26MZOlCzBKTkv2NcFudi1rd2VD5FR/M86xum3RqFE7tCtfznyYyRRAXcEreQShqcIPSpBbhTZvSkykWDm5ED1DThOcDkWnO2cMoQZTYNS4DXEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YDM+zjpn; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YDM+zjpn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mDsiUs+OsUHKFoEoVcqmTmGutiWwv+mUdno1Q89YdH4=; b=YDM+zjpn+fByKwQetkAOVqQbt6
	nZ6NsEwCBAmFrrVuyPPUXsY2U0vKdfb4cWVX4DERhQULFBnoKRuAsButA1em0rr+GUBrbDcVNeSMn
	Nu2UgWN9sNXWHExZjGPntFPBk0C2bD4sqz1cYMiCq97GZwKKb8EeI7CmZrtkO1x3Uk9SxQbfZYSfx
	7o5ALdAfJE1yP1K2jx+NhHLLjNwch3I1gux7UitLKdjiogWANhnrQmLHKtVG2i9XG8GdF05HbxENk
	F372LL5i15VCLMnOIV6htwSADalc4mFfGdKsVMYxu0sjWby0GNrnszQq8ime0ivpplqXZhc2xeif3
	tGprzkRA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syUYl-000000007mm-3n0N;
	Wed, 09 Oct 2024 13:08:52 +0200
Date: Wed, 9 Oct 2024 13:08:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Nicola Serafini <n.serafini@tutanota.com>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: Argument -S (--list-rules) in ebtables
Message-ID: <ZwZkQ0vngLf_ZaiZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Nicola Serafini <n.serafini@tutanota.com>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <O8kMltx--B-9@tutanota.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <O8kMltx--B-9@tutanota.com>

Hi Nicola,

On Wed, Oct 09, 2024 at 10:22:16AM +0200, Nicola Serafini wrote:
> Hi list, I noticed that ebtables command line utility has not a "-S (--list-rules)" argument which is widely adopted by the other command line tools (arptables, iptables).
> 
> I think it can be useful for many reasons, so I'm here to ask whether it was deliberately omitted or not and why.

Ebtables' UI is different in so many aspects, I find it rather
interesting that there are shared options with iptables. ;)

In iptables.git, ebtables-nft already has support for -S option
(although undocumented), so next release will enable this feature for
you (unless you stick to ebtables-legacy).

Cheers, Phil
