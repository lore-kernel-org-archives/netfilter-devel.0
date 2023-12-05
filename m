Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="A+vK4fF9"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BD3129
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 05:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=k3Q07HRREuSwnAeuO3NfHfI+Sbzy1RiGdj/sxaN9Aiw=; b=A+vK4fF9R8utQvIjuiFSfNpuWI
	fxAPXCAjDlmK6LHcAiyHi87soKDayp60V+/6Ay/UXidTWYABEnvuA9hadSPl/lZs5uISIrakfn8in
	huftAXJsUxuqKFRua+v6WFBKm4fZaYtlJg4hhuuhFXALskHDFSueYq+e+HTQKNPhiI/C/C5O0E9F5
	AtLp2gFE4ZBOE8KtOnjvW2CmMfyHDkgeWZKXHARxx3G8O4yACob0AJPnydCBOoeq/biam2GAIuWxh
	QU3UajYOwxwBXtjjlXp7gXNr12p23NdRvII6Ga8oT6FnPPbDLDGYY1y56Y5vcO7i3ZV62z9XRUw6d
	hQfYFIDw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rAVCC-000234-Qs; Tue, 05 Dec 2023 14:10:40 +0100
Date: Tue, 5 Dec 2023 14:10:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: validate family when
 identifying table via handle
Message-ID: <ZW8hUKEizy9bNbML@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231204135444.3881-1-pablo@netfilter.org>
 <20231204140341.GC29636@breakpoint.cc>
 <ZW3cuXX5H55V3xUN@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW3cuXX5H55V3xUN@calendula>

On Mon, Dec 04, 2023 at 03:05:45PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Dec 04, 2023 at 03:03:41PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Validate table family when looking up for it via NFTA_TABLE_HANDLE.
> > > 
> > > Reported-by: Xingyuan Mo <hdthky0@gmail.com>
> > > Fixes: 3ecbfd65f50e ("netfilter: nf_tables: allocate handle and delete objects via handle")
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > >  net/netfilter/nf_tables_api.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > This changes behaviour, before this change you can do
> > 
> > nft delete table handle 42
> > 
> > and it will delete the table with handle 42.
> 
> Default family is 'ip' if not specified, that is inconsistent with
> other objects?

I would say the table's handle is a complete replacement of its family
and name, also because it's pernet-unique. Though looking at the docs,
we surprisingly claim to support:

| delete table [<family>] handle <handle>

So either we accept user space is wrong and the family value doesn't
matter there or we artificially limit table lookup by handle to the
given family. IMHO either way kind of breaks user space.

Off-topic here, but I would prefer for all handles to be pernet-unique
so user space could 'nft delete <whatever> handle <handle>'. Why was a
table-unique value chosen here?

Cheers, Phil
