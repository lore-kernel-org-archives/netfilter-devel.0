Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EA563CB
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751635133; cv=none; b=NbVC1NKlhz/FzwW8xHuo2KiQD6/pakgumFJruVLlAnBdm9xqKO4L6oxw3OQWis4QV0f4V8xjkFJjDkM+FFinyeuORqckMushihj3/ziD1qLKSpaIsI215A9zJ4t1WPZX/8M9gQ2TQxfLUxeRUHdDK5xH2gwaszlnWdg5MlEYsa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751635133; c=relaxed/simple;
	bh=07O1Pi3RgTZNT8N4a90EIo5IaC0IjcasCq0IPu172p0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZURcFCSfHNFt2yqP0OkTnyQgL9ZhwebDQ6ufklmBBf+5r9D6SVEmSUzrznaZtGNNfPUJ4DjdLrcilCUOMfJWFqcI5hMa7x3wGSkA5FT/ZX43RSsrPjqYAkMEQ6mreV2FDWG/FOQv5PCZi9wsCpu1x47AA+Gkpmu9JiuQDxesa8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fsWJXiZg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fsWJXiZg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Tky4MWd68eUazbG/fUqVLLMcnx5sSCF3FwGq+dgQz9Q=; b=fsWJXiZgpcbG3IQ4LIJ3Uq/ia0
	bb0ct+hmhzCDbXzJKXoaR94Ex+d/OjWmT+NNM7Ft+U3VfpzVSMsmvDvJxXHYQAb4bGAtpxC2z92n8
	0YOM53HdnH0/r7uhTSuYD34K8DpBjmlXl8Vmcj9l2cflvXbw/x5G7mzueoaoFhfbL5p0KTVGFWR2u
	JFxMmiewpMCSXH7DLmo0iHKdAccFQKbcf7rVI0wLGX1j0iy+SgZVkJzlhgIAN1eLFYvV0rm3lH7b0
	N4zi5Qu/2tdKFDk7+HPHoLkqGcH6jrS8Ta7KiECmEwT7vUDgyEEZDmEpim3q2K2z45/zILDCwhFiW
	0T5o3PMw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uXgJV-000000001eF-3nW1;
	Fri, 04 Jul 2025 15:18:49 +0200
Date: Fri, 4 Jul 2025 15:18:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 0/3] netfilter: nf_tables: Report found devices
 when creating a netdev hook
Message-ID: <aGfUuYq6bl38KT9S@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250612133416.18133-1-phil@nwl.cc>
 <aGeKKXVmGjS2YVMu@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGeKKXVmGjS2YVMu@calendula>

On Fri, Jul 04, 2025 at 10:00:41AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 12, 2025 at 03:34:13PM +0200, Phil Sutter wrote:
> > Previously, NEWDEV/DELDEV notifications were emitted for new/renamed
> > devices added to a chain or flowtable only. For user space to fully
> > comprehend which interfaces a hook binds to, these notifications have to
> > be sent for matching devices at hook creation time, too.
> > 
> > This series extends the notify list to support messages for varying
> > groups so it may be reused by the NFNLGRP_NFT_DEV messages (patch 1),
> > adjusts the device_notify routines to support enqueueing the message
> > instead of sending it right away (patch 2) and finally adds extra notify
> > calls to nf_tables_commit() (patch 3).
> 
> Fine with these series, I am preparing a nf-next pull request, I plan
> to include them.
> 
> As this goes ahead in providing NEWDEV/DELDEV events for ruleset
> updates, I think GETDEV is needed to complete things.
> 
> Regarding userspace, I think there only one item remaining to be
> discussed, which is how to expose device notifications.
> 
> I would suggest to add a separated:
> 
>         monitor devices

My local tree has "monitor hooks", but it's a trivial change and
"devices" is probably a more intuitive name for something that enables
NEWDEV/DELDEV messages. :)

Thanks, Phil
