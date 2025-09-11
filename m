Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD178F7D
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 11:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757588577; cv=none; b=LNZM48DIDrRLdMVJxPsvKyEqP8+IAFjBvhgOD/yw7qqJ9Wb7httA4LIQ/i8A/8f5DNP7olPqRMuul043q2aBiRL2cPU2Uyjuw40bdIc+hI17EWZLVmSZq9qfDkTI86C4vlr3HSKaqUybazAQc3XuUQVg2yAlLBiad3ZYRnVrx4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757588577; c=relaxed/simple;
	bh=eb1Z+f3Rhom1M9/pmdlOOzsLzYMUOfVwBNfqxQ9MzTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2cduko3aUFhZkpTLef6drUtkvkl3VGG/KBN8SHAFbTuodzd+81YgF1rf57gJdtXKt6KK1oH5+8TichSTpqfNOHCeFSRyvEMX1EDiowQ9/zqBS3iHLfC4+yuizbmdfyXYgPvFDnRz+bI5p3MrroRQcL1cUgq+jJG1nmEyErwWXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F264660324; Thu, 11 Sep 2025 13:02:51 +0200 (CEST)
Date: Thu, 11 Sep 2025 13:02:51 +0200
From: Florian Westphal <fw@strlen.de>
To: Gabriel Goller <g.goller@proxmox.com>
Cc: netfilter-devel@vger.kernel.org, s.hanreich@proxmox.com
Subject: Re: [PATCH nf 0/5] netfilter: nf_tables: fix false negative lookups
 with ongoing transaction
Message-ID: <aMKsW_EURxAiBAOB@strlen.de>
References: <20250910080227.11174-1-fw@strlen.de>
 <v3tlcx4h44yh2a4lac5lx643o6a7cvneyokojx5y7znll4nfmj@xmw57s4u3hnt>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <v3tlcx4h44yh2a4lac5lx643o6a7cvneyokojx5y7znll4nfmj@xmw57s4u3hnt>

Gabriel Goller <g.goller@proxmox.com> wrote:
> I tested this fix using Stefan Hanreich’s reproducer on the latest
> master branch. The bug was resolved, and I didn't see anything out
> of the ordinary.

Thanks for testing!
