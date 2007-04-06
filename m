From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH 2.6.21-rc6] [netfilter] early_drop imrovement
Date: Fri, 6 Apr 2007 10:24:33 +0200
Message-ID: <20070406102433.d3a670a5.dada1@cosmosbay.com>
References: <4615FE1D.80206@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org
To: Vasily Averin <vvs@sw.ru>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1767550AbXDFIYi@vger.kernel.org>
In-Reply-To: <4615FE1D.80206@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 06 Apr 2007 12:00:29 +0400
Vasily Averin <vvs@sw.ru> wrote:

> When the number of conntracks is reached ip_conntrack_max limit, early_drop() is
> called and tries to free one of already used conntracks in one of the hash
> buckets. If it does not find any conntracks that may be freed, it
> leads to transmission errors.
> However it is not fair because of current hash bucket may be empty but the
> neighbour ones can have the number of conntracks that can be freed. With the
> following patch early_drop() will search conntracks in all hash buckets.

Have you tested your patch in a DOS situation ?
Some machines have a huge ip_conntrack_max.
A single scan of the whole table might take 1000 ms or even more.
