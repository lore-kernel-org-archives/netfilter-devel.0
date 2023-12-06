Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A25181
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 04:47:43 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rArJV-00080a-I8; Wed, 06 Dec 2023 13:47:41 +0100
Date: Wed, 6 Dec 2023 13:47:41 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft] evaluate: reject set definition with no key
Message-ID: <20231206124741.GJ8352@breakpoint.cc>
References: <20231206124230.521196-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206124230.521196-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>  tests/shell/testcases/bogons/nft-f/set_definition_with_no_key_assert
>  BUG: unhandled key type 2
>  nft: src/intervals.c:59: setelem_expr_to_range: Assertion `0' failed.
> 
> This patch adds a new unit tests/shell courtesy of Florian Westphal.
> 
> Fixes: 3975430b12d9 ("src: expand table command before evaluation")
> Reported-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Looks saner than what I did, thanks Pablo.
