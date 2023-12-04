Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C6590
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 06:05:51 -0800 (PST)
Received: from [78.30.43.141] (port=43960 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rA9Zy-00EPKo-8k; Mon, 04 Dec 2023 15:05:48 +0100
Date: Mon, 4 Dec 2023 15:05:45 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: validate family when
 identifying table via handle
Message-ID: <ZW3cuXX5H55V3xUN@calendula>
References: <20231204135444.3881-1-pablo@netfilter.org>
 <20231204140341.GC29636@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231204140341.GC29636@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Mon, Dec 04, 2023 at 03:03:41PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Validate table family when looking up for it via NFTA_TABLE_HANDLE.
> > 
> > Reported-by: Xingyuan Mo <hdthky0@gmail.com>
> > Fixes: 3ecbfd65f50e ("netfilter: nf_tables: allocate handle and delete objects via handle")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_tables_api.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> This changes behaviour, before this change you can do
> 
> nft delete table handle 42
> 
> and it will delete the table with handle 42.

Default family is 'ip' if not specified, that is inconsistent with
other objects?

> After this change, the command will only work if this table happens
> to be in 'ip' family.
> 
> > -		table = nft_table_lookup_byhandle(net, attr, genmask,
> > +		table = nft_table_lookup_byhandle(net, attr, family, genmask,
> >  						  NETLINK_CB(skb).portid);
> 
> Perhaps leave as-is and:
> 	if (!IS_ERR(table))
> 		family = table->family?
> 
> (or ctx.family =, but then the strange ctx.family assignment at end
>  of function needs to go).
