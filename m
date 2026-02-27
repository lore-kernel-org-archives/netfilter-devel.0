Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC9C1C7012;
	Fri, 27 Feb 2026 13:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772198264; cv=none; b=XeG++CRXMiaigL2/X36K4e4svNqOKUAi8D/24tIdG9b/oeuThdZpa5F7x6BKXoOxYUMg8YYheQXh7925nbjsjEZMFoV4BatbqovD6j3a2eOGfXe3YRCMVs+87tx8bJp07nEKFdvr6WcsX1FSef/VPk4zRampBbaX3j6LTLenKe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772198264; c=relaxed/simple;
	bh=S2Sibz6/0nDeA3rNpG7lVnE8z3GwQoWM4z58psFAnQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=REUY0OTVTm3yi+TqZr8ww2EX2A1H21fG0xkfJKZVC20Fu+p/UlmMs9ZEpwMTylIWzAJxpN3CmtN0pCV2NqX40/2co2QQ2u4lM+rXy7FivbvXqtByK7SDR30qnW6XupymsGwttniFIwdPMtiRwQLmQsQTPef2y1ZNnVSJTESoV4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uUcQxu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uUcQxu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5071DC116C6;
	Fri, 27 Feb 2026 13:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772198263;
	bh=S2Sibz6/0nDeA3rNpG7lVnE8z3GwQoWM4z58psFAnQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2uUcQxu/pKTPdmOqWSM//JAWGzm0dFO4tDdEmqktfTmiSGPRZsQoMmW63cBUZIK4d
	 0+SJpbo7SvUKdcPbEPaBrBL6WCztG4mABiFwPWDCue9lb79C/RLOImf8T97mpknxDu
	 Z8nKn8l+ys4hdD6Ai4W7UBYcm4CMmoBtvJBw9mLE=
Date: Fri, 27 Feb 2026 05:17:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Genes Lists <lists@sapience.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>,
	linux-kernel@vger.kernel.org, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, stable@vger.kernel.org,
	regressions@lists.linux.dev,
	"Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Subject: Re: [REGRESSION] 6.19.4 stable netfilter / nftables [resolved]
Message-ID: <2026022755-quail-graveyard-93e8@gregkh>
References: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
 <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
 <143e1a402ad78dd7076516a6ceb637f378310b16.camel@sapience.com>
 <10537f2b74da2b8a5cb8dc939f723291db39ff84.camel@sapience.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10537f2b74da2b8a5cb8dc939f723291db39ff84.camel@sapience.com>

On Fri, Feb 27, 2026 at 08:12:59AM -0500, Genes Lists wrote:
> On Fri, 2026-02-27 at 07:23 -0500, Genes Lists wrote:
> > On Fri, 2026-02-27 at 09:00 +0100, Thorsten Leemhuis wrote:
> > > Lo!
> > > 
> > 
> > Repeating the nft error message here for simplicity:
> > 
> >  Linux version 7.0.0-rc1-custom-1-00124-g3f4a08e64442 ...
> >   ...
> >   In file included from /etc/nftables.conf:134:2-44:
> >   ./etc/nftables.d/set_filter.conf:1746:7-21: Error:
> >   Could not process rule: File exists
> >                  xx.xxx.xxx.x/23,
> >                  ^^^^^^^^^^^^^^^
> > 
> 
> Resolved by updating userspace.
> 
> I can reproduce this error on non-production machine and found this
> error is resolved by re-bulding updated nftables, libmnl and libnftnl:
> 
> With these versions nft rules now load without error:
> 
>  - nftables commit de904e22faa2e450d0d4802e1d9bc22013044f93
>  - libmnl   commit 54dea548d796653534645c6e3c8577eaf7d77411
>  - libnftnl commit 5c5a8385dc974ea7887119963022ae988e2a16cc
> 
> All were compiled on machine running 6.19.4.

Odd, that shouldn't be an issue, as why would the kernel version you
build this on matter?

What about trying commit f175b46d9134 ("netfilter: nf_tables: add
.abort_skip_removal flag for set types")?

thanks,

greg k-h
