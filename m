Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61738F9CF
	for <netfilter-devel@vger.kernel.org>; Sun, 26 May 2024 09:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716717038; cv=none; b=JqhaOP5Rwri/LmzgzVAnxJZyqzVcXQtiKvSUt9QRq8F07JWeyIZan9YjiYm3vqHPdvLRiqdWCE5YXS2uNrrNHveZQp94+igs91RT+oDiMcwGl9MScSZuI+HG0XfWYi8uXq7GioQqb002vAaLgF3Qf40RG77M+DgGAz593ffGQYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716717038; c=relaxed/simple;
	bh=rXbpqmMDnGuocFM6NZnEGK4YEMiXhIVn4VcadNZPMBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B11m4Y+fJtHzB/S6S0x8qiOIBVKuZlFTDNTMXZBlJo33aMBSg/oBXfE0jpAFfycJvGjg39vPU4e5JfLjzCRfT8NR0gGsQLDS33ZHOJW/qsAqdgSZ6Rwb3d2e9ps+pC9QQim3S041a82Q2+BMe2Q8WhCzPV7W4cB67iNNbHjYzx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aEG9JZlg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aEG9JZlg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rXbpqmMDnGuocFM6NZnEGK4YEMiXhIVn4VcadNZPMBc=; b=aEG9JZlg0uXkwg3tmqUMFUwyqM
	olMupCegU3VIsL7Wllhrs8wrKhMndzyh8Aiq3gzZQQvvErk0APoj9H02OF4Bb5kjf+fZrmCNNosmp
	2kstPO4D/aVGIfBgHTy4EXZMBmn17Su3TlkykDJcFM0zCUCroC5nhO2bV3XbSY3CyK/3b8sp1zhOJ
	dSNFMqdfHIjh1A0iY3WmgV9hV0f+Tw9P2hq1LcwjrIT61sY3ns8fkzs3+06WfpLI5rRv1oGhzyUfk
	jCd3tktnCiBY5EDGYvsO+ClGbpqcidBaX4c6i6jALwnzjFdy05ehodniq+EwRMkBUKLyiHScnQ/Hd
	z21D2K4w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sBAWJ-000000008SA-14Xg;
	Sun, 26 May 2024 11:50:27 +0200
Date: Sun, 26 May 2024 11:50:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Michael Estner <michaelestner@web.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] iptables: cleanup FIXME
Message-ID: <ZlMF49DdO0aoiJkL@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Michael Estner <michaelestner@web.de>,
	netfilter-devel@vger.kernel.org
References: <Zk9yrd8Ji1xAcblw>
 <20240524132452.84195-1-michaelestner@web.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524132452.84195-1-michaelestner@web.de>

Hi Michael,

On Fri, May 24, 2024 at 03:24:51PM +0200, Michael Estner wrote:
> I checked bitmask in the ebt_entry struct in iptables/xshared.h
> Should be compared here since bitmask needs to be the first
> field in the struct ebt_entry.

The reason why 'bitmask' has to be the first field is that in kernel
space, the first bit in it is used to distinguish list element types
between 'struct ebt_entries' and 'struct ebt_entry'. See
EBT_ENTRY_OR_ENTRIES define and the related comment in
include/uapi/linux/netfilter_bridge/ebtables.h for reference.

While it seems sensible to do, I wonder why things seem to work fine
even without it. Do we find a corner-case which makes it necessary to
compare 'bitmask'? Or the other way round, is there a case which breaks
if we do?

Cheers, Phil
