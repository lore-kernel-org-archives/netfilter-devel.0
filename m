Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEABF3
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 08:45:58 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rDSMs-0001Q6-2q; Wed, 13 Dec 2023 17:45:54 +0100
Date: Wed, 13 Dec 2023 17:45:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Thomas Haller <thaller@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Support updating table's
 owner flag
Message-ID: <20231213164554.GE27081@breakpoint.cc>
References: <20231208130103.26931-1-phil@nwl.cc>
 <ZXhbYs4vQMWX/q+d@calendula>
 <ZXiI58QCVek1rWiF@orbyte.nwl.cc>
 <ZXji-iRbse7yiGte@egarver-mac>
 <ZXmgAu3u2w+Xjh8+@orbyte.nwl.cc>
 <ZXnKpoMQnsoTK6sA@calendula>
 <17fbf1879c790d2dd59ec6367d01002b5d3b5f3a.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17fbf1879c790d2dd59ec6367d01002b5d3b5f3a.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Thomas Haller <thaller@redhat.com> wrote:
> Isn't the problem to solve that `nft flush ruleset` deletes tables
> owned by somebody else (firewalld)?

If they are 'owned', then no, they are not flushed, thats one of the
points of the owner thing.

> A "persist" flag sounds like a good solution. It would just have
> informational value (for user space) to be skipped by `nft flush
> ruleset`.

'flush' doesn't pass the to-be deleted tables to the kernel, so
this cannot be implemented via informational tags in userspace.
