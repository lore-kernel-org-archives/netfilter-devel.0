Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6983E1DEFD7
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730901169; cv=none; b=Pf8QOKFnk2oBjZ41al6aA+eJgVO2F0mOMMiv93FQCoQAQXqv3UkvK8A1fMQsdB0UUv080OCtoL77bgSGyOwH+w3WEfpcys3D5/VlT1z/uJkG/6XAB5/FYNE2Y5/UeRobo6UieHAZ8MgJ6C+UKLLRPnSYRhV+NTU49QbQQVRDBrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730901169; c=relaxed/simple;
	bh=51sIYHFmxkCJqoIw7CkXwXCuWjM2i8XV+fq0rMeDu+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZEPrLLop0Gsm9g53tb4gRcJ7pXDDd5agenL5rZB5gzu5ksZeA+uC7saz8Hhnq44j/3phwn29MDn4g01YvcaNtaw7iOEMVsGHEeYRdYnLSSvmJfT3L/pHGVTCDFoxtr7wK5fjQsOcXeeBjJdgqAk6PmEXiIqSpc2bUyuGE44ua0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8gSi-00032h-IW; Wed, 06 Nov 2024 14:52:44 +0100
Date: Wed, 6 Nov 2024 14:52:44 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: allow to map key to nfqueue number
Message-ID: <20241106135244.GA11098@breakpoint.cc>
References: <20241025074729.12412-1-fw@strlen.de>
 <Zytu_YJeGyF-RaxI@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zytu_YJeGyF-RaxI@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > @@ -447,6 +457,9 @@ extern struct expr *relational_expr_alloc(const struct location *loc, enum ops o
> >  extern void relational_expr_pctx_update(struct proto_ctx *ctx,
> >  					const struct expr *expr);
> >  
> > +extern struct expr *typeof_expr_alloc(const struct location *loc,
> > +				      enum expr_typeof_key key);
> 
> I think it should be possible to follow an alternative path to achieve
> this, that is, use integer_expr and attach a new internal datatype,
> ie. queue_type, for this queue number.
> 
> No need for new TYPE_* in enum, that is only required by
> concatenations and this datatype will not ever be used in that case.
> 
> For reference, there is also use of this alias datatypes such as
> xinteger_type which is used to print integers in hexadecimal.
> 
> From userdata path it should be possible to check for this special
> internal queue_datatype then encode the queue number type in the TLV.

I have no idea how to do any of this.  I don't even know what a "queue number
type" is.

How on earth do i flip the data type on postprocessing without any idea
what "2 octets worth of data" is?
