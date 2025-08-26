Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452FE30CD82
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 19:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756237298; cv=none; b=NDoJkFhcF/xiCrs9z/o59WSfRB893ZKnmzjErVlXIEC+3VqiZ9Q/lvX8/aneIQCIvDnI+PjmGshlkqoG0luvYCnkUjQ/eJr+dX3/PfZ6rbkAzUS6ggcFpQZdTM/OOdUK2khmCwiEixtl80+W8rB0aYHuo0gvdtGthVHMOW79Abk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756237298; c=relaxed/simple;
	bh=4qJe6U6YI2QeK4QcxRsnDl0BKmHTWyQokGmxcFcnYNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcZicOr/QMmVuoUN0XYCd7xykvT+Xtk/FrSsfdt7PXGTalnnyr3XGERcEVFmWJcjm4K7Cm+6TkEF9oAWRHT4LvGTd3fRgLfBnzqqEfAVsO8UoDHSIS5j4QeJmrZVs/dp/NQXi4Mys0atiw5nG1++VzUaPi43co4Y32HZ8DqpGcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=As5b8FD1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fL+Sr63Z; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="As5b8FD1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fL+Sr63Z"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CF8F660264; Tue, 26 Aug 2025 21:41:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756237291;
	bh=kQO0Zlz7qucBd7XITTEqOoXQjf2DoEbntbLUl8akyo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=As5b8FD1DITFfQeLAd76ghs0XL4zPg80aDB47rkpmiSvJRIxx/Cm5P+xpsBzfu+yB
	 vNcOAvg+Bzlpt49lXT6qZdYGd5Okq9GKznr9cTz6sUdS3eXcDdNZux32oyfo+zVnoq
	 NQP7nKor8IfHYpIvFcpn2q/WmJhwtniJKiucOlrzOlCZoFN/s9lvNEtSgp+7BvjYI7
	 QNbIr8QOZ/SeOYtN9S6xQpVwrpaPj462lU+N4L7Ezh0n193E8pjsaanwFS4nORA8xg
	 ERQsVpyPV3/1krWpLyBQqapvJgP19CfaaQ3PPLuhsXI3H4pLdu0uT/3qrTUV9f+zCG
	 1hA6XAvSPIiIA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A3AA660255;
	Tue, 26 Aug 2025 21:41:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756237290;
	bh=kQO0Zlz7qucBd7XITTEqOoXQjf2DoEbntbLUl8akyo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fL+Sr63ZDiWQzdZtM8bFIEZTzc8yr+BmRAyVLMpIvI5ocvllnfW+0wL90ZvHbn9yB
	 RkkMLOL8xh1gpfFVNDDpHBRu9/jzimIGnuBES8TssmPJks+D0D/tgtvnjh8JQBTopc
	 LwRn1wbp/WlusZImhK7SD+CBmSAu196iQ4T9+LQwVyol2OnoKynu4Hkc+nm4GnFtw7
	 992+9gZx4jH7v8jQPjUmqEK0pRUSA8HjMOo/hR5U+S/kmrHu5hc1JhOiRtOmwUlLy4
	 k1SXIY8+2KN+3Fy1fkN9LvtdXhOuK6REWCbXge2N2RfNlVRk8gnO1rLJfTkKlLQv41
	 8pD/jfauquIJA==
Date: Tue, 26 Aug 2025 21:41:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] Makefile: Fix for 'make distcheck'
Message-ID: <aK4N56uzuIWgBiG5@calendula>
References: <20250826170643.3362-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250826170643.3362-1-phil@nwl.cc>

On Tue, Aug 26, 2025 at 07:06:43PM +0200, Phil Sutter wrote:
> Make sure the files in tools/ are added to the tarball and that the
> created nftables.service file is removed upon 'make clean'.
> 
> Fixes: c4b17cf830510 ("tools: add a systemd unit for static rulesets")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks
