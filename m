Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A481247F51
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jan 2024 21:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705958795; cv=none; b=DlWKGvejDJTKDNRmoGSxCLM86w0jH5BhZSDp0mtlTDLdU1U+2umvPf97A8r1O80DLU/WpuxN6JHBkrFiROIx+l4qWkb4+3eijA6suwwUl2hrEnaWIyAelgiL8gpGiPQpDX+0wxyzb2RxsSWD48qay/ZDmgowmyP1vOOyYo72HPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705958795; c=relaxed/simple;
	bh=ePMb1kPWbxb69gZ4l+AZe0gKoTUAkRVgQTXxwc8017U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=faSrcNbF1qRRJqrDwpV9YxDVAMbx4NnS7Zb5mdlALRPBZQr+nKDnfgO8+lTQMPp+GzbbCEMBFJ5KNSpDFq6Jlwu4+gm6Hn0DnF2fehscekM6qCEOZC/lkWSJ767FnC2JcEUEcT89L/Ood66F18BF7CdftMIh7nlHx/dFLBCo40w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rS1oF-0003SS-Nu; Mon, 22 Jan 2024 22:26:23 +0100
Date: Mon, 22 Jan 2024 22:26:23 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: yiche@redhat.com, netfilter-devel@vger.kernel.org, fw@netfilter.org
Subject: Re: [PATCH] tests: shell: add test to cover ct offload by using nft
 flowtables To cover kernel patch ("netfilter: nf_tables: set transport
 offset from mac header for netdev/egress").
Message-ID: <20240122212623.GA29630@breakpoint.cc>
References: <20240122162640.6374-1-yiche@redhat.com>
 <Za6vFpJZCHVw1LrV@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za6vFpJZCHVw1LrV@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi,
> 
> This test reports:
> 
> I: [OK]         1/1 testcases/packetpath/flowtables
> 
> or did you see any issue on your end?

Yes, this scenario got broken in the past, e.g.
via 41f2c7c342d3 ("net/sched: act_ct: Fix promotion of offloaded
unreplied tuple").

nf.git is fine, but I think its good to have a test case to prevent
obvious breakage in the future.
