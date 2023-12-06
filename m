Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F6ED42
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 05:13:41 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rArie-0008Af-3t; Wed, 06 Dec 2023 14:13:40 +0100
Date: Wed, 6 Dec 2023 14:13:40 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] initial support for the afl++ (american fuzzy lop++)
 fuzzer
Message-ID: <20231206131340.GL8352@breakpoint.cc>
References: <20231201154307.13622-1-fw@strlen.de>
 <ZW/YVpeUtn5dfcmA@orbyte.nwl.cc>
 <20231206074342.GC8352@breakpoint.cc>
 <ZXBxKEhprUVUvG7m@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXBxKEhprUVUvG7m@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Hmm. Probably I miss the point regarding struct nft_afl_input. IMO, if
> save_candidate() writes data into the file despite called savebuf()
> setting use_filename = false, nft_afl_run_cmd() will try to read from
> ->buffer when it should read from ->fname.

In that case buffer should have same content as the on-disk file,
so there is no need to open/read/close.
