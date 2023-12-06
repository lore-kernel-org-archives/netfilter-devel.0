Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75ED12F
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 04:29:13 -0800 (PST)
Received: from [78.30.43.141] (port=47002 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAr1a-003OVg-Al; Wed, 06 Dec 2023 13:29:12 +0100
Date: Wed, 6 Dec 2023 13:29:09 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: flush ruleset with -U after feature
 probing
Message-ID: <ZXBpFds7gQ1iMmR+@calendula>
References: <20231205154306.154220-1-pablo@netfilter.org>
 <20231205192929.GB8352@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231205192929.GB8352@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Tue, Dec 05, 2023 at 08:29:29PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > feature probe script leave a ruleset in place, flush it once probing is
> > complete.
> 
> Perhaps change feature_probe() to always use 'unshare -n'?

I am currently using this to test 'nft monitor' and make sure it
survives a run-tests.sh

> Some scripts also create netdevices.

Indeed, they are leaving things in place.
