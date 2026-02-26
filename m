Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783533ACA6D;
	Thu, 26 Feb 2026 14:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772115246; cv=none; b=o+WwVLBi6ZzU77EtbcOsv4WfpiK/g161gRVQoQW5AhAkaFjrS9q/i+4DRsCpw17Qji1qds8ytm1YLubdsUSE0//EFyi21vUkH5ZUeRgEQSgr+FXd6vXItbU0XR4vObBSXlKJV3+bW5clBWftAAPXAqABK6qFtQUSsQ/uBBH8wsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772115246; c=relaxed/simple;
	bh=bJGXITfP42DOu8udfbDXthtAZv/RrpkS0akQ+3aYjPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hITGyBoioTsVDkYXZsTByHQpPL7XrBr2rlyf4juNWgyHi2NhkkmssA2mP3uvuYrbgaJzN1YdksfuM68+J9jmacOXg9D9SmR3NAw0q0EyNy8gp1hWTrz4XLspns/y18FTs71RaeoQKrbrOQM5Ne/lejKERw12G8UkMVGtxojOpXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 38BFB60336; Thu, 26 Feb 2026 15:14:02 +0100 (CET)
Date: Thu, 26 Feb 2026 15:14:01 +0100
From: Florian Westphal <fw@strlen.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] netfilter: nf_conntrack_h323: fix OOB read in
 decode_choice()
Message-ID: <aaBVKVXk5T7j7jvU@strlen.de>
References: <20260225130619.1248-1-fw@strlen.de>
 <20260225130619.1248-2-fw@strlen.de>
 <aaAOFygrzyyp2a_z@strlen.de>
 <61b18149-17e4-439a-97d3-74f0dc20a78f@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61b18149-17e4-439a-97d3-74f0dc20a78f@redhat.com>

Paolo Abeni <pabeni@redhat.com> wrote:
> On 2/26/26 10:10 AM, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> >> From: Vahagn Vardanian <vahagn@redrays.io>
> >>
> >> In decode_choice(), the boundary check before get_len() uses the
> >> variable `len`, which is still 0 from its initialization at the top of
> >> the function:
> >>
> > 
> > @net maintainers: would you mind applying this patch directly?
> > 
> > I don't know when Pablo can re-spin his fix, and I don't want
> > to hold up the H323 patch.
> 
> Makes sense. Note that I'll apply the patch (as opposed to pull it),
> meaning it will get a new hash.

Yes, thats fine.

At the moment both nf and nf-next stictly follow net/net-next, i.e.
nf:main and nf-next:main might be behind the corresponding net
tree, but are never ahead.

Patches are queued up in :testing.  This allows me to rebase and
if necessary drop patches again.

Then, for pull request, last "good" testing branch gets tagged,
then that tag is used in the pull request.

After you pull changes, I re-sync the nf tree the net one and
push to main.
