Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D69FA
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 04:57:45 -0800 (PST)
Received: from [78.30.43.141] (port=54336 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rArTC-003Sa2-8P; Wed, 06 Dec 2023 13:57:44 +0100
Date: Wed, 6 Dec 2023 13:57:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Thomas Haller <thaller@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: flush ruleset with -U after feature
 probing
Message-ID: <ZXBvxTSexq9PpFqt@calendula>
References: <20231205154306.154220-1-pablo@netfilter.org>
 <20231205192929.GB8352@breakpoint.cc>
 <80b4cbbb54cf17a83ccbadaa3cd194790f87f67f.camel@redhat.com>
 <ZXBlvcV3jUfJCnMs@calendula>
 <c52ceca65ed580d4dc613d3f532998ff4fd56b4a.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c52ceca65ed580d4dc613d3f532998ff4fd56b4a.camel@redhat.com>
X-Spam-Score: -1.9 (-)

On Wed, Dec 06, 2023 at 01:45:21PM +0100, Thomas Haller wrote:
> On Wed, 2023-12-06 at 13:14 +0100, Pablo Neira Ayuso wrote:
> > On Wed, Dec 06, 2023 at 07:47:44AM +0100, Thomas Haller wrote:
> > 
> > 
> > I can keep it out of tree if you prefer -U remains broken.
> 
> 
> IMO the mode definitely should be fixed, as much as possible.
> Also, I think the patch is fine. Especially if it fixes an obvious
> issue.
> 
> If -U is well supported, then tests and feature-detection should take
> special care to remove interfaces they create. Maybe they could all use
> well-known interfaces names (fwtst0, fwtst1, fwtst2). Then run-test.sh
> and test-wrapper.sh could automatically clean up those interfaces. It
> doesn't scale to let each test re-implement such cleanup.

I agree with Florian and you that removing toggles is a good idea, but
this one is useful for me at this stage, we revisit later on. There is
a specific tests infra for the monitor mode but it is rather limited.
I can also crash nft monitor with a few scenarios I am looking at to
fix it. Maybe -U can go away in the near future and monitor tests can
get better coverage.

> > This provides an easy way for me to test 'nft monitor'.
> 
> OK then.

Thanks!
