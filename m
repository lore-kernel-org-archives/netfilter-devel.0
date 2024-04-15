Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7AC745D5;
	Mon, 15 Apr 2024 14:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191469; cv=none; b=HyHlLo8B5PTXjrcLIqyR80LxNZ4LJyy84mq9cRO0OkoDi19SJi04piAF6kzaRy1z0CkrKW3WkaVGJ/nK+9kS8SLwvAzFiqSOEG+hMJxFXRO90KhaL3JtKB0FVS/bLoKmvk1Ww4n9imu1boO13jEo9OsGYBRJXDlbEOKNSYTb4hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191469; c=relaxed/simple;
	bh=bW2Dw6kU+VfIMhwD/SgbJdX2R5Fl9uzx7u7DkFDENMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETMAt1d6Rtwq9T3uatE/EkoDINI2Nip6iqFRcsTia6NgbqjL8u/wFyPNhIWgoEiaz31mYKOujIoQaHctB1P4aBAZixcxhKFlNvXJevRYQ0piVpp3Y4d0gXeQdUZvzKInG+97B2blFIva8YwFNMvJCASt640S1DPOzNCwOsyaDpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rwNME-0007qJ-Aw; Mon, 15 Apr 2024 16:30:54 +0200
Date: Mon, 15 Apr 2024 16:30:54 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 12/12] selftests: netfilter: update makefiles
 and kernel config
Message-ID: <20240415143054.GA27869@breakpoint.cc>
References: <20240414225729.18451-1-fw@strlen.de>
 <20240414225729.18451-13-fw@strlen.de>
 <20240415070240.3d4b63c2@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240415070240.3d4b63c2@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 15 Apr 2024 00:57:24 +0200 Florian Westphal wrote:
> > --- a/tools/testing/selftests/net/netfilter/config
> > +++ b/tools/testing/selftests/net/netfilter/config
> 
> Looks like we're still missing veth, and possibly more.
> Here's more details on how we build:
> 
> https://github.com/linux-netdev/nipa/wiki/How-to-run-netdev-selftests-CI-style

Thanks for the pointer, it will take me some time to catch up and
make sure the generated build works.

You are right, at least VETH and NETFILTER_ADVANCED are missing.

If you prefer you can apply the series without the last patch
and then wait for v2 of that last one.

Thanks!
