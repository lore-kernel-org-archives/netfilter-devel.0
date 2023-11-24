Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3118170F;
	Fri, 24 Nov 2023 01:50:29 -0800 (PST)
Received: from [78.30.43.141] (port=40806 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1r6SpN-004JMX-NX; Fri, 24 Nov 2023 10:50:27 +0100
Date: Fri, 24 Nov 2023 10:50:24 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, lorenzo@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/8] netfilter: make nf_flowtable lifetime differ
 from container struct
Message-ID: <ZWBx4Em+8acC3JJN@calendula>
References: <20231121122800.13521-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231121122800.13521-1-fw@strlen.de>
X-Spam-Score: -1.8 (-)

Hi Florian,

Sorry for taking a long while.

On Tue, Nov 21, 2023 at 01:27:43PM +0100, Florian Westphal wrote:
> This series detaches nf_flowtable from the two existing container
> structures.
> 
> Allocation and freeing is moved to the flowtable core.
> Then, memory release is changed so it passes through another
> synchronize_rcu() call.
> 
> Next, a new nftables flowtable flag is introduced to mark a flowtable
> for explicit XDP-based offload.

If XDP uses the hardware offload infrastructure, then I don't see how
would it be possible to combine a software dataplane with hardware
offload, ie. assuming XDP for software acceleration and hardware
offload, because it takes a while for the flowtable hw offload
workqueue to set up things and meanwhile that happens, the software
path is exercised.

> Such flowtables have more restrictions, in particular, if two
> flowtables are tagged as 'xdp offloaded', they cannot share any net
> devices.
> 
> It would be possible to avoid such new 'xdp flag', but I see no way
> to do so without breaking backwards compatbility: at this time the same
> net_device can be part of any number of flowtables, this is very
> inefficient from an XDP point of view: it would have to perform lookups
> in all associated flowtables in a loop until a match is found.
> 
> This is hardly desirable.
> 
> Last two patches expose the hash table mapping and make utility
> function available for XDP.
> 
> The XDP kfunc will be added in a followup patch.

What is the plan to support for stackable device? eg. VLAN, or even
tunneling drivers such as VxLAN. I have (incomplete) patches to use
dev_fill_forward_path() to discover the path then configure the
flowtable datapath forwarding.

My understand is that XDP is all about programmibility, if user
decides to go for XDP then simply fully implement the fast path is the
XDP framework? I know of software already does so and they are
perfectly fine with this approach.
