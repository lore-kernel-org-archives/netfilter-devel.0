Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E05790
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 06:17:15 -0800 (PST)
Received: from [78.30.43.141] (port=33804 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAWEZ-000IVZ-MM; Tue, 05 Dec 2023 15:17:13 +0100
Date: Tue, 5 Dec 2023 15:17:10 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: validate family when
 identifying table via handle
Message-ID: <ZW8w5v3LISAH/NZg@calendula>
References: <20231204135444.3881-1-pablo@netfilter.org>
 <20231204140341.GC29636@breakpoint.cc>
 <ZW3cuXX5H55V3xUN@calendula>
 <ZW8hUKEizy9bNbML@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZW8hUKEizy9bNbML@orbyte.nwl.cc>
X-Spam-Score: -1.8 (-)

On Tue, Dec 05, 2023 at 02:10:40PM +0100, Phil Sutter wrote:
> On Mon, Dec 04, 2023 at 03:05:45PM +0100, Pablo Neira Ayuso wrote:
> > On Mon, Dec 04, 2023 at 03:03:41PM +0100, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Validate table family when looking up for it via NFTA_TABLE_HANDLE.
> > > > 
> > > > Reported-by: Xingyuan Mo <hdthky0@gmail.com>
> > > > Fixes: 3ecbfd65f50e ("netfilter: nf_tables: allocate handle and delete objects via handle")
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > ---
> > > >  net/netfilter/nf_tables_api.c | 5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > This changes behaviour, before this change you can do
> > > 
> > > nft delete table handle 42
> > > 
> > > and it will delete the table with handle 42.
> > 
> > Default family is 'ip' if not specified, that is inconsistent with
> > other objects?
> 
> I would say the table's handle is a complete replacement of its family
> and name, also because it's pernet-unique.

Only tables and newer kernels >= 5.15 -stable, yes.

> Though looking at the docs, we surprisingly claim to support:
> 
> | delete table [<family>] handle <handle>

For consistency with existing objects, yes.

> So either we accept user space is wrong and the family value doesn't
> matter there or we artificially limit table lookup by handle to the
> given family. IMHO either way kind of breaks user space.
>
> Off-topic here, but I would prefer for all handles to be pernet-unique
> so user space could 'nft delete <whatever> handle <handle>'. Why was a
> table-unique value chosen here?
