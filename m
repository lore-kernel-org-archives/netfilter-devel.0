From: Patrick Schaaf <bof@bof.de>
Subject: Re: Layer-7 HTTP Matching Module
Date: Wed, 5 Feb 2003 21:02:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030205200235.GA28378@oknodo.bof.de>
References: <Pine.LNX.4.44.0302040925160.12235-100000@kaybee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kirk Bauer <kirk@kaybee.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0302040925160.12235-100000@kaybee.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> But I think it might be nice to have a true layer 7 matching module.
[...]
> Does such a module exist or is it being developed?

No.

> If not, I may write
> one when I have time if other people think it would be useful.

It would be useful if it had significantly better performance
than an application level gateway, and would be just as compliant
WRT the protocol. A half-baked solution useful only for opportunistic
marking, would not be good: people would try to use it in other
situations, and be surprised when they find their security compromised.

A proper implementation WRT the protocol, will need to implement
both TCP, and HTTP.

Good luck with your endeavour. We did not hear back from the last
10 people who posted the equivalent of your query.

best regards
  Patrick
