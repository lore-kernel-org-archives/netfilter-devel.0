Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DE51A5;
	Fri, 24 Nov 2023 01:55:15 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1r6Su0-0002um-Pd; Fri, 24 Nov 2023 10:55:12 +0100
Date: Fri, 24 Nov 2023 10:55:12 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	lorenzo@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/8] netfilter: make nf_flowtable lifetime differ
 from container struct
Message-ID: <20231124095512.GB13062@breakpoint.cc>
References: <20231121122800.13521-1-fw@strlen.de>
 <ZWBx4Em+8acC3JJN@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWBx4Em+8acC3JJN@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Next, a new nftables flowtable flag is introduced to mark a flowtable
> > for explicit XDP-based offload.
> 
> If XDP uses the hardware offload infrastructure, then I don't see how
> would it be possible to combine a software dataplane with hardware
> offload, ie. assuming XDP for software acceleration and hardware
> offload, because it takes a while for the flowtable hw offload
> workqueue to set up things and meanwhile that happens, the software
> path is exercised.

Lorenzo adds a kfunc that gets called from the xdp program
to do a lookup in the flowtable.

This patchset prepares for the kfunc by adding a function that
returns the flowtable based on net_device pointer.

The work queue for hw offload (or ndo ops) are not used.

> > The XDP kfunc will be added in a followup patch.
> 
> What is the plan to support for stackable device? eg. VLAN, or even
> tunneling drivers such as VxLAN. I have (incomplete) patches to use
> dev_fill_forward_path() to discover the path then configure the
> flowtable datapath forwarding.

If the xdp program can't handle it packet will be pushed up the stack,
i.e. nf ingress hook will handle it next.

> My understand is that XDP is all about programmibility, if user
> decides to go for XDP then simply fully implement the fast path is the
> XDP framework? I know of software already does so and they are
> perfectly fine with this approach.

I don't understand, you mean no integration at all?
