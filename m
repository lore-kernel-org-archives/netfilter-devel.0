From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix Kconfig dependencies for nft_dup_ipv{4,6}
Date: Sat, 17 Oct 2015 13:35:16 +0200
Message-ID: <20151017113516.GA3002@salvia>
References: <5041322.FiDa5XtNuO@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5041322.FiDa5XtNuO@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Oct 16, 2015 at 10:10:04PM +0200, Arnd Bergmann wrote:
> nft_dup_ipv4 and nft_dup_ipv6 select the respective nf_dup_ipv{4,6}
> drivers, which must not be built-in if nf_conntrack is a loadable
> module, otherwise we get a link error:
> 
> net/built-in.o: In function `nf_dup_ipv6':
> (.text+0xdef20): undefined reference to `nf_conntrack_untracked'
> 
> The dependency was fixed for the nf_dup_* modules recently, but this
> patch adds the same dependency to the nft_dup_* modules for
> the (hopefully) complete fix.

Already have this patch for this enqueued here:

http://git.kernel.org/cgit/linux/kernel/git/pablo/nf.git/commit/?id=6ece90f9a13e2592cbd6634f74bcb306169b5ab6

Will be submitting this to David asap. Thanks anyway.
