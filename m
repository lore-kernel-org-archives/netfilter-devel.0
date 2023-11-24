Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A794F10F4;
	Fri, 24 Nov 2023 02:10:59 -0800 (PST)
Received: from [78.30.43.141] (port=42126 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1r6T9D-004NfM-OL; Fri, 24 Nov 2023 11:10:57 +0100
Date: Fri, 24 Nov 2023 11:10:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, lorenzo@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/8] netfilter: make nf_flowtable lifetime differ
 from container struct
Message-ID: <ZWB2rxcMmoKUPLPb@calendula>
References: <20231121122800.13521-1-fw@strlen.de>
 <ZWBx4Em+8acC3JJN@calendula>
 <20231124095512.GB13062@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231124095512.GB13062@breakpoint.cc>
X-Spam-Score: -1.7 (-)

On Fri, Nov 24, 2023 at 10:55:12AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Next, a new nftables flowtable flag is introduced to mark a flowtable
> > > for explicit XDP-based offload.
> > 
> > If XDP uses the hardware offload infrastructure, then I don't see how
> > would it be possible to combine a software dataplane with hardware
> > offload, ie. assuming XDP for software acceleration and hardware
> > offload, because it takes a while for the flowtable hw offload
> > workqueue to set up things and meanwhile that happens, the software
> > path is exercised.
> 
> Lorenzo adds a kfunc that gets called from the xdp program
> to do a lookup in the flowtable.
> 
> This patchset prepares for the kfunc by adding a function that
> returns the flowtable based on net_device pointer.
> 
> The work queue for hw offload (or ndo ops) are not used.

OK, but is it possible to combine this XDP approach with hardware
offload?

> > > The XDP kfunc will be added in a followup patch.
> > 
> > What is the plan to support for stackable device? eg. VLAN, or even
> > tunneling drivers such as VxLAN. I have (incomplete) patches to use
> > dev_fill_forward_path() to discover the path then configure the
> > flowtable datapath forwarding.
> 
> If the xdp program can't handle it packet will be pushed up the stack,
> i.e. nf ingress hook will handle it next.

Then, only very simple scenarios will benefit from this acceleration.

> > My understand is that XDP is all about programmibility, if user
> > decides to go for XDP then simply fully implement the fast path is the
> > XDP framework? I know of software already does so and they are
> > perfectly fine with this approach.
> 
> I don't understand, you mean no integration at all?

I mean, fully implement a fastpath in XDP/BPF using the datastructures
that it provides.
