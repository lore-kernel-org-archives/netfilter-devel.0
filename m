From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next v3] netfilter: xt_hashlimit: Fix link error in
 32bit arch because of 64bit division
Date: Fri, 30 Sep 2016 19:46:50 +0200
Message-ID: <20160930174650.GE1176@salvia>
References: <20160929173950.GA27689@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: johunt@akamai.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        pai.vishwain@gmail.com, kaber@trash.net, kadlec@blackhole.kfki.hu,
        zlpnobody@gmail.com, hannes@stressinduktion.org, maze@google.com,
        eric.dumazet@gmail.com, akpm@linux-foundation.org
To: Vishwanath Pai <vpai@akamai.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160929173950.GA27689@akamai.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 29, 2016 at 01:39:50PM -0400, Vishwanath Pai wrote:
> v2:
> Remove unnecessary div64_u64 around constants
> 
> v3:
> remove backslashes
> 
> --
> 
> Fix link error in 32bit arch because of 64bit division
> 
> Division of 64bit integers will cause linker error undefined reference
> to `__udivdi3'. Fix this by replacing divisions with div64_64

Applied, thanks Pai.

> Signed-off-by: Vishwanath Pai <vpai@akamai.com>
> Fixes: 11d5f15723c9 ("netfilter: xt_hashlimit: Create revision 2 to ...")
> 
> ---

Please, next time place the versioning information here, otherwise git
am takes the wrong description here.
