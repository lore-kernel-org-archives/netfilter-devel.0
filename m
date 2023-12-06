Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E919A
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 04:14:59 -0800 (PST)
Received: from [78.30.43.141] (port=34744 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAqnm-003Muf-FY; Wed, 06 Dec 2023 13:14:56 +0100
Date: Wed, 6 Dec 2023 13:14:53 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Thomas Haller <thaller@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: flush ruleset with -U after feature
 probing
Message-ID: <ZXBlvcV3jUfJCnMs@calendula>
References: <20231205154306.154220-1-pablo@netfilter.org>
 <20231205192929.GB8352@breakpoint.cc>
 <80b4cbbb54cf17a83ccbadaa3cd194790f87f67f.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <80b4cbbb54cf17a83ccbadaa3cd194790f87f67f.camel@redhat.com>
X-Spam-Score: -1.9 (-)

On Wed, Dec 06, 2023 at 07:47:44AM +0100, Thomas Haller wrote:
> On Tue, 2023-12-05 at 20:29 +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > feature probe script leave a ruleset in place, flush it once
> > > probing is
> > > complete.
> > 
> > Perhaps change feature_probe() to always use 'unshare -n'?
> 
> feature_probe already uses unshare, unless the caller opts out of it.

I am opting out with -I as the patch title specifies.

> Maybe don't do that.
>
> > Some scripts also create netdevices.
> 
> Some tests also create netdevices and may not clean them up properly.
> It's even desirable that tests don't clean them up, because it removes
> boilerplate from tests. But more importantly: not deleting those
> devices leaves a certain state after the test, that can be checked by
> `.nft`/`.json-nft` dumps.

I see, those were not a problem for me when running -U so far.

> The mode without unshare exists for historic reasons, as unshare was
> added initially. At this point, what is the use of supporting or using
> that?

This provides an easy way for me to test 'nft monitor'.

I can keep it out of tree if you prefer -U remains broken.
