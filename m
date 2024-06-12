Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DE9381C4
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 19:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718221765; cv=none; b=SFPl2nF4dsifEp5ZWBoIqIX1FOiyqgnzwsv4fusrGnUF/VEh0QegNDY3Ua4jr8lS9uBBFnbh7hWXaGcoZXwkvOOjmsfG6dqC+JKarBh/Zb7fN5+kcA2BBt98n8IHQOCagrGshbH/hw+mstqoZO2fBZvWDNHtC5Dpz3LGEPHSwSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718221765; c=relaxed/simple;
	bh=/OoMkTp5gfbS/BEJWan4OgvAQhB1Hvk+pVnfWnKngwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ay0CRMK5i8owuwq/zn+Tk0PHguXrM4V7zTqj5TX9J6R6hMSz6cSPvBKpY4sV0koMe2J5x8FzZVkRI5Zm0IjirVsDx25wmyWEhCs+IuzlY9cotY0IgrCon7FWDCN4BWlHbasmPon0xy0NAh41kD1wAeXg0Sf3B1Ui0H5AHiOTfGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=R1H4QJld; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="R1H4QJld"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NTg+shRil5Tg2r/38hmekuhSa1jgmzSI7cA5JSh4EWc=; b=R1H4QJld+WM5jzjTCN9t68MELB
	HO390EspO3hThGT5QFsCzbj3DZl4eXs79h8e8+SW/gRX9ZeudUhyNg9sSkoBSkC0xnBL/usa+IXO8
	D6Kmxn2cApG57PLKm9zOmr1BTZtYobaMebu2TQdIisHcNoFGI+eDYy/bjGxNMI8CEZ/BpWiXWvILx
	6Cr4EHtn5MdPDoQ0LPsj5nEVsuF4ih9fXMMJpUVZfAmo4gNCnbfMmx2aQYU8W9Ap6adCSdDOk7UJG
	fglQ3fyFMd0KERlRDHJrLe02iExkTxdRb4jrzQd+SUEZvQmXoNj9TBDEMjqCq7DCh6NfRHmLwxpZh
	BLALNVRA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHTyC-0000000015C-31BO;
	Wed, 12 Jun 2024 21:49:20 +0200
Date: Wed, 12 Jun 2024 21:49:20 +0200
From: Phil Sutter <phil@nwl.cc>
To: Fabio Pedretti <pedretti.fabio@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH] man: recent: Adjust to changes around
 ip_pkt_list_tot parameter
Message-ID: <Zmn7wA65yWzhbB5M@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Fabio Pedretti <pedretti.fabio@gmail.com>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20240612151328.2193-1-phil@nwl.cc>
 <CA+fnjVC2vZpowThMGEvRT=vuEHW5cdzxPTHgWkjO1o+TpZo5Cg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+fnjVC2vZpowThMGEvRT=vuEHW5cdzxPTHgWkjO1o+TpZo5Cg@mail.gmail.com>

On Wed, Jun 12, 2024 at 06:00:54PM +0200, Fabio Pedretti wrote:
> Hi, thanks.
> It looks like there is still a limit of 255 for hitcount (and
> ip_pkt_list_tot), right?

Yeah, that's a kernel limitation, namely XT_RECENT_MAX_NSTAMPS. We may
lift or even drop that, but it will require a separate patch either way.

> Maybe leave:
> The maximum value for the hitcount parameter is 255.
> 
> Even better, remove the limit? :)

I see that struct recent_table::nstamps_max_mask must hold the value of
the next power of two of the given hitcount (minus one) and is currently
a u8. So there will never be no limit, but one could use a u32 in that
place and set XT_RECENT_MAX_NSTAMPS to 0xffffffff.

I'll send a patch so we have something to discuss.

Cheers, Phil
