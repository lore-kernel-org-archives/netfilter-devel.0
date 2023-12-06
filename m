Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19D0135
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 04:33:26 -0800 (PST)
Received: from [78.30.43.141] (port=42534 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAr5f-003PSa-0Q; Wed, 06 Dec 2023 13:33:25 +0100
Date: Wed, 6 Dec 2023 13:33:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Thomas Haller <thaller@redhat.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: flush ruleset with -U after feature
 probing
Message-ID: <ZXBqEh4rV64PzhLH@calendula>
References: <20231205154306.154220-1-pablo@netfilter.org>
 <20231205192929.GB8352@breakpoint.cc>
 <80b4cbbb54cf17a83ccbadaa3cd194790f87f67f.camel@redhat.com>
 <ZXBlvcV3jUfJCnMs@calendula>
 <20231206121828.GI8352@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231206121828.GI8352@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Wed, Dec 06, 2023 at 01:18:28PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > The mode without unshare exists for historic reasons, as unshare was
> > > added initially. At this point, what is the use of supporting or using
> > > that?
> > 
> > This provides an easy way for me to test 'nft monitor'.
> > 
> > I can keep it out of tree if you prefer -U remains broken.
> 
> No no no, I was just asking if '-U' should still run the
> feature probes without a netns, which is what its doing right
> now.
> 
> Perhaps -U should just disable the unshare for the actual shell
> tests, not for the feature probe scripts.

Ah, I understand. Fine with me.
