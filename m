Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288251AA
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 09:20:10 -0800 (PST)
Received: from [78.30.43.141] (port=54294 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAZ5X-000jN4-S0; Tue, 05 Dec 2023 18:20:06 +0100
Date: Tue, 5 Dec 2023 18:20:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Thomas Haller <thaller@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: fix double free on dtype release
Message-ID: <ZW9bwmBg1erhWwWv@calendula>
References: <20231205120820.20346-1-fw@strlen.de>
 <ZW8xd0KXzA3SiM6L@calendula>
 <2256864bab0e4834db0e2e69c8843fe8832212ee.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2256864bab0e4834db0e2e69c8843fe8832212ee.camel@redhat.com>
X-Spam-Score: -1.9 (-)

On Tue, Dec 05, 2023 at 05:53:06PM +0100, Thomas Haller wrote:
> On Tue, 2023-12-05 at 15:19 +0100, Pablo Neira Ayuso wrote:
> > On Tue, Dec 05, 2023 at 01:08:17PM +0100, Florian Westphal wrote:
> > >  
> > > -	prefix->dtype	  = base->dtype;
> > > +	prefix->dtype	  = datatype_get(base->dtype);
> > 
> > I prefer datatype_clone() just in case base->dtype gets updated for
> > whatever reason.
> 
> Hi,
> 
> That seems unnecessary.
> 
> `struct datatype` is a ref-counted, immutable data structure. That is a
> great feature and callers should rely on it.
> 
> In "[PATCH nft 0/5] more various cleanups related to struct datatype"
> all modifications move inside "datatype.c". This makes it clearer that
> modifications happen during initialization only. Regardless, also on
> `master` the instance is never mutated, after passing around the
> pointer.

datatype_get() is perfectly fine for this case as you point out.
No update of prefix->prefix datatype is done indeed.

Thanks.
