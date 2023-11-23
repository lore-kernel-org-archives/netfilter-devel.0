Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7E3D40;
	Thu, 23 Nov 2023 06:10:53 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1r6APr-0005Nx-Ab; Thu, 23 Nov 2023 15:10:51 +0100
Date: Thu, 23 Nov 2023 15:10:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Simon Horman <horms@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	lorenzo@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 1/8] netfilter: flowtable: move nf_flowtable out
 of container structures
Message-ID: <20231123141051.GA13062@breakpoint.cc>
References: <20231121122800.13521-1-fw@strlen.de>
 <20231121122800.13521-2-fw@strlen.de>
 <20231123135213.GE6339@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231123135213.GE6339@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Simon Horman <horms@kernel.org> wrote:
> > -	err = nf_flow_table_init(&ct_ft->nf_ft);
> > +	ct_ft->nf_ft = kzalloc(sizeof(*ct_ft->nf_ft), GFP_KERNEL);
> > +	if (!ct_ft->nf_ft)
> > +		goto err_alloc;
> 
> Hi Florian,
> 
> This branch will cause the function to return err, but err is 0 here.
> Perhaps it should be set to a negative error value instead?

Yes, this should fail with -ENOMEM.
