From: Jay Schulist <jschlst@linux-sna.org>
Subject: Re: [PATCH] multiple devices with ranges match support
Date: Wed, 18 Sep 2002 03:35:49 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44L.0209180334100.10390-100000@hunger.screamingdaemon.com>
References: <20020918221212.GG10465@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020918221212.GG10465@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 19 Sep 2002, Patrick Schaaf wrote:

> However, in general, I'm not so sure that it makes sense to expand
> all kinds of match options into multidimensional specification
> languages for arbitrary subsets of their keyspaces, with all kinds
> of option specific shortcut forms for how ranges and patterns are
> written. Each option becomes its own mini-language. I don't like.
>
> What's wrong with the good old subchain, and several "-i dev" lines
> branching off to there?
>

The reason I did the mdev ranges was to support 100s of virtual
interfaces/devices. In this case having a rule for each interface will
slow things down greatly compared to the efficient mdev match operation.

> P.S.: My deepest apologies, Jay, for you receiving so many rants from
> me this evening. Please, don't take them personally. I hope to help.
>

no problem, the feed-back/comments is great.

jay-s.
