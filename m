Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC6920CCE5
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 13:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730986776; cv=none; b=LIsMj+OTxe6hr75YwMPNLdj1nGERPkcp5p4BzOO5WP+sMj5KqLFjZ8s6m+pIpxvOpbbORI0O2nwU8bfNAZkYaYjWczw5jCmNnh+a0G4zl5mIiPwboGmlbVR7FCclMxyZrEZH9VyDc/vi6Y1Sq21SZSmJ6jXWHty13f4PbrhVbSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730986776; c=relaxed/simple;
	bh=L/e7yXc3l0lKsmeJcfdW8zkwyrRfmF9X7N255DFUsF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DO9KCb7Q1r7H75+EyTJIlxcuq1s4ZLp4TNy3bypOqX+vhcnTg5IeCLzN+zwrK832TWtRfl1Y9Eyf9MN5NhDj1BLRMFxJYj2iHq/I952Pq6bV3+cAXYRWym+R+p7HZ/cWMzDCTSusVefkr/Z+mIUWDFFCCKWPW3bs9fyZxQVsUHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Fio4c72J; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Fio4c72J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pCyKM2QruxMC1O4tJLZUxVpougln7ZxFXwIGHTZjQiA=; b=Fio4c72JUUO26ohGr8phylUtFt
	oJMThC/YL8ZCl/ObO58oaCN5b973K+TfEOmEiIVhCRzjuRtywbW2CgWGjQD7q4BH/LKYidKeHAFow
	iiqpJDDvcn0xr00kCVpEQmTCWAYK3/FpmIqhQhkWttPU47STzvgANaELFta94r4x2UpoEjffUX5qA
	vliH5LQAFhggAhhENukfxi3NEntd1f5jUTbwkCGRMCAYPymWA97q+JJugLu6AzxKNGGKQWvgG2Poi
	vrja7NRr+5sS5CWC/cKeRjm2OmLZE2uPmypTpJ0JJ48tZpNSdFGeY7tGW7Ndg4AwsGbWNoRytxnNF
	25b/Cw2A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t92jR-000000000yX-1OlS;
	Thu, 07 Nov 2024 14:39:29 +0100
Date: Thu, 7 Nov 2024 14:39:29 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: monitor: run-tests.sh: restore cwd before
 unshare
Message-ID: <ZyzDESVObswc_WPB@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20241107125657.28339-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107125657.28339-1-fw@strlen.de>

On Thu, Nov 07, 2024 at 01:56:53PM +0100, Florian Westphal wrote:
> The monitor script no longer works if not called from tests/monitor directory:
> 
> % tests/monitor/run-tests.sh
> unshare: failed to execute tests/monitor/run-tests.sh: No such file or directory
> 
> ... because the script will change the directory.
> Stash and restore to old one so unshare $0 can work.

Still not perfect:

| % sudo ./tests/monitor/run-tests.sh ./tests/monitor/testcases/set-maps.t 
| /home/n0-1/git/nftables /home/n0-1/git/nftables
| /home/n0-1/git/nftables
| /home/n0-1/git/nftables /home/n0-1/git/nftables
| unknown option './tests/monitor/testcases/set-maps.t'
| Usage: run-tests.sh [-j|--json] [-d|--debug] [testcase ...]

AFAICT, $(dirname $0) is only needed to locate the local nft binary. Let
me send a patch which eliminates the cd call entirely.

Cheers, Phil
