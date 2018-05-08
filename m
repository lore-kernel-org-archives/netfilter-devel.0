From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] bridge: netfilter stp fix reference to uninitialized
 data
Date: Tue, 8 May 2018 14:17:10 +0200
Message-ID: <20180508121710.ivzfhxggbajyo4zr@salvia>
References: <20180427181609.3103-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180427181609.3103-1-sthemmin@microsoft.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Apr 27, 2018 at 11:16:09AM -0700, Stephen Hemminger wrote:
> The destination mac (destmac) is only valid if EBT_DESTMAC flag
> is set. Fix by changing the order of the comparison to look for
> the flag first.

Applied, thanks Stephen.
