Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F57C4435;
	Sat, 25 Nov 2023 08:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uWO1yBW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAE0C433C7;
	Sat, 25 Nov 2023 08:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700900765;
	bh=UmvJtQeVyTEfjGE1mQII1hztZYXgnO19cdovN/4Ks2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uWO1yBW5T11Ah5soLyxJte9xozXYqraPHIBk6049mz0Eu810D3PqvCTtr2wUZ4O6L
	 2A9aqEhPqpkauHRngkRJMGWceLmFWLyHYmlivn5441RZ1d9cgfCSOG4vuB+0FLIeKe
	 ZaXIQH49kMOGURs7zQUhMNEnnwb7LLz6pEKrHPTLshORUvWlLU62ip3mAvcb45jA1z
	 fyMJMooh3oikTR2ikUYstmMjtgIZs8WOEna13fuIboPlp/ccrNtWudRL3s91/aELUy
	 xZfUIWFeLozAOn+zujQVTBtmkeK/xYjVkXrvAyTbzzhnF8zuM1kXIINal+CsxUvrAj
	 NEb9mSLw69+LQ==
Date: Sat, 25 Nov 2023 08:26:01 +0000
From: Simon Horman <horms@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, lorenzo@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 1/8] netfilter: flowtable: move nf_flowtable out
 of container structures
Message-ID: <20231125082601.GA84723@kernel.org>
References: <20231121122800.13521-1-fw@strlen.de>
 <20231121122800.13521-2-fw@strlen.de>
 <20231123135213.GE6339@kernel.org>
 <20231123141051.GA13062@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231123141051.GA13062@breakpoint.cc>

On Thu, Nov 23, 2023 at 03:10:51PM +0100, Florian Westphal wrote:
> Simon Horman <horms@kernel.org> wrote:
> > > -	err = nf_flow_table_init(&ct_ft->nf_ft);
> > > +	ct_ft->nf_ft = kzalloc(sizeof(*ct_ft->nf_ft), GFP_KERNEL);
> > > +	if (!ct_ft->nf_ft)
> > > +		goto err_alloc;
> > 
> > Hi Florian,
> > 
> > This branch will cause the function to return err, but err is 0 here.
> > Perhaps it should be set to a negative error value instead?
> 
> Yes, this should fail with -ENOMEM.

Thanks, I will send a patch.
