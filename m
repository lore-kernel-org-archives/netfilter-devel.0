Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E77110EF
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 01:33:55 -0800 (PST)
Received: from [78.30.43.141] (port=55008 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1r6SZL-004FPZ-DX; Fri, 24 Nov 2023 10:33:53 +0100
Date: Fri, 24 Nov 2023 10:33:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Thomas Haller <thaller@redhat.com>
Subject: Re: [nft PATCH] tests/shell: Treat json-nft dumps as binary in git
Message-ID: <ZWBt/seCFvaAdvcO@calendula>
References: <20231123143712.17341-1-phil@nwl.cc>
 <20231124084951.GA8873@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231124084951.GA8873@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Fri, Nov 24, 2023 at 09:49:51AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > The stored JSON dumps containing a single line of a thusand characters
> > in average mess up diffs in history and patches if they change. Mitigate
> > this by treating them as binary files.
> > 
> > In order to get useable diffs back, one may undo/override the attribute
> > within $GIT_DIR/info/attributes, preferrably by defining a custom diff
> > driver converting the single-line dumps into something digestable by
> > diff:
> 
> I'd say we convert the single-line dumps to jq format one-by-one
> if they need updating.

I am also fine with .json-nft dumps in pretty format too, which is
friendlier to git diff.
