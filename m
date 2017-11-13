From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Request for stable 4.13.x inclusion: netfilter: nft_set_hash:
 disable fast_ops for 2-len keys
Date: Mon, 13 Nov 2017 13:03:41 +0100
Message-ID: <20171113120341.GA1994@salvia>
References: <87af2305-0fde-b326-b9d6-db22ea744099@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        anatole@rezel.net, netfilter-devel@vger.kernel.org
To: Thomas Deutschmann <whissi@gentoo.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87af2305-0fde-b326-b9d6-db22ea744099@gentoo.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Nov 10, 2017 at 12:56:46PM +0100, Thomas Deutschmann wrote:
> Hi,
> 
> please consider to add
> 
> > From 0414c78f14861cb704d6e6888efd53dd36e3bdde Mon Sep 17 00:00:00 2001
[...]
> This commit fixes a problem in 4.13+ with latest >=nftables-0.8 release.
> 
> Bug: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=880145
> Bug: https://bugs.gentoo.org/636968

Already flying into -stable 4.13.

https://marc.info/?l=netfilter-devel&m=151031414718199&w=2

Thanks.
