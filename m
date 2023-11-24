Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03F9172C
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 00:49:55 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1r6Rsl-0002RM-V1; Fri, 24 Nov 2023 09:49:51 +0100
Date: Fri, 24 Nov 2023 09:49:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: Re: [nft PATCH] tests/shell: Treat json-nft dumps as binary in git
Message-ID: <20231124084951.GA8873@breakpoint.cc>
References: <20231123143712.17341-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231123143712.17341-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> The stored JSON dumps containing a single line of a thusand characters
> in average mess up diffs in history and patches if they change. Mitigate
> this by treating them as binary files.
> 
> In order to get useable diffs back, one may undo/override the attribute
> within $GIT_DIR/info/attributes, preferrably by defining a custom diff
> driver converting the single-line dumps into something digestable by
> diff:

I'd say we convert the single-line dumps to jq format one-by-one
if they need updating.

New dumps are no longer accepted in single-line format.
