Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F76D47
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 04:52:26 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rArO4-00082V-Cb; Wed, 06 Dec 2023 13:52:24 +0100
Date: Wed, 6 Dec 2023 13:52:24 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: flush ruleset with -U after feature
 probing
Message-ID: <20231206125224.GK8352@breakpoint.cc>
References: <20231205154306.154220-1-pablo@netfilter.org>
 <20231205192929.GB8352@breakpoint.cc>
 <80b4cbbb54cf17a83ccbadaa3cd194790f87f67f.camel@redhat.com>
 <ZXBlvcV3jUfJCnMs@calendula>
 <20231206121828.GI8352@breakpoint.cc>
 <ZXBqEh4rV64PzhLH@calendula>
 <ZXBt4iQxfPocp0V/@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXBt4iQxfPocp0V/@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Dec 06, 2023 at 01:33:25PM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Dec 06, 2023 at 01:18:28PM +0100, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > The mode without unshare exists for historic reasons, as unshare was
> > > > > added initially. At this point, what is the use of supporting or using
> > > > > that?
> > > > 
> > > > This provides an easy way for me to test 'nft monitor'.
> > > > 
> > > > I can keep it out of tree if you prefer -U remains broken.
> > > 
> > > No no no, I was just asking if '-U' should still run the
> > > feature probes without a netns, which is what its doing right
> > > now.
> > > 
> > > Perhaps -U should just disable the unshare for the actual shell
> > > tests, not for the feature probe scripts.
> > 
> > Ah, I understand. Fine with me.
> 
> Maybe this?

Fine with me.
