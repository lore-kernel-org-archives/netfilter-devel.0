Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD371F63CD
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 13:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770298158; cv=none; b=U6VPjwfq0/uoTPzx6WV+6Ll9soY3BSpJUrfm+dmxXPhHnZXNO3UA8fAOT0oKU4FI3wx0o4LIYdaAXkCDCTUerSNcB+JE+YetrfZKAR787P0rmPVnwhIzkSFTbxGy5mgHiBxVhEP8MFiOkPGMMBvIXhloljtsZnwh8DX1TuWm/XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770298158; c=relaxed/simple;
	bh=hVtPSZ2KAUlA8bEQgcxDigsx8DDBO4zgQIpcFC062/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iS1N7ErlChg1nduNuOpCVOyzFsUnkyvNcAq2iqXeWlEUm5ZloP1re+S/hsdBTpRF/lSsVEJ0fddxV+BUA2a0bYN4tSR2MXtuE83JiHv/QcYz+Ca4g57WHutq7Ph2YJ9hWDDpE9O0heAcN7LcO6ci9otuJXEkEUKMS4hrP3tovGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=OkdwSvJc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OkdwSvJc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DAIMKY1lZHvV0ISGYArrBWMSqJs7zzsoPxn1TazBMak=; b=OkdwSvJc31mWn9pBgdx9RD8oIQ
	9vXnVnwgvfHhChquhBBpPkHrN2o4B1YeWqBiWRN+PmlLS2TaTzgNM2mwdT9/QInqn4lzp0XdjKduh
	IP9SvxojBPfzW/U375TbMyAN1Tg2Fwr0filXqfqFXwkS57RwsCy+/vLVDfzkYoqek0s4zV9OSuRLt
	cMFLOe9YI20QHWZSJhJyKftttjafsRkt7GcclaG29NTDaWUKHloiYaaummlc8JnlNIw6GfeqgJE3I
	f+QTiNftRpx+F1dFjc/ofpvMyagUHv++UTaSeEHw+Qtjt1Ln1cEQkt3ip9jFrwr10vWTGTakdxB8p
	wD44/kfA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vnzQ3-000000001YA-0l11;
	Thu, 05 Feb 2026 14:29:15 +0100
Date: Thu, 5 Feb 2026 14:29:15 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] xt: Print comment match data as well
Message-ID: <aYSbK7MjK9grK96K@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20260127222916.31806-1-phil@nwl.cc>
 <20260127222916.31806-4-phil@nwl.cc>
 <aYPz4TwVBQm3Fb0k@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYPz4TwVBQm3Fb0k@chamomile>

On Thu, Feb 05, 2026 at 02:35:29AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 27, 2026 at 11:29:15PM +0100, Phil Sutter wrote:
> > In order to translate comment matches into the single nftables rule
> > comment, libxtables does not immediately (maybe mid-rule) print a
> > comment match's string but instead stores it into struct
> > xt_xlate::comment array for later.
> > 
> > Since xt_stmt_xlate() is called by a statement's .print callback which
> > can't communicate data back to caller, nftables has to print it right
> > away.
> 
> This is a bugfix, correct?

I'd vote for feature. A side-effect of this patch is that translated
rules containing a comment match can't be restored anymore because of:

> > Since parser_bison accepts rule comments only at end of line though, the
> > output from above can't be restored anymore. Which is a bad idea to
> > begin with so accept this quirk and avoid refactoring the statement
> > printing API.

IMHO, bug fixes should not have such side-effects.

Cheers, Phil
