From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/47] Netfilter/IPVS updates for net-next
Date: Fri, 30 Mar 2018 11:43:33 -0400 (EDT)
Message-ID: <20180330.114333.26040889472683940.davem@davemloft.net>
References: <20180330113729.18335-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113729.18335-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 30 Mar 2018 13:36:42 +0200

> The following patchset contains Netfilter/IPVS updates for your net-next
> tree. This batch comes with more input sanitization for xtables to
> address bug reports from fuzzers, preparation works to the flowtable
> infrastructure and assorted updates. In no particular order, they are:

Pulled, but I have to ask you not to handle things this way next time.

The other week when I pushed back on your pull request, I asked for
some explanations about the flow table situation.

When I was satisfied with the explanation I explicitly asked you to
resend _exactly_ the original pull request.

I asked you to do this because I didn't want to see a huge pull
request like this one show up later.

And this is exactly what happend. :-/

Please, next time I ask you to resend a pull request I have a very
good reason for doing so, so please do it.

Thanks.
