From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next v2] net: move decnet to staging
Date: Mon, 13 Nov 2017 11:32:58 -0800
Message-ID: <1510601578.10883.82.camel@perches.com>
References: <20171113171142.19476-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Stephen Hemminger <sthemmin@microsoft.com>
To: Stephen Hemminger <stephen@networkplumber.org>,
        davem@davemloft.net, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171113171142.19476-1-sthemmin@microsoft.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2017-11-13 at 09:11 -0800, Stephen Hemminger wrote:
> Support for Decnet has been orphaned for some time.
> In the interest of reducing the potential bug surface and pre-holiday
> cleaning, move the decnet protocol into staging for eventual removal.
[]
> diff --git a/drivers/staging/decnet/TODO b/drivers/staging/decnet/TODO
[]
> @@ -0,0 +1,4 @@
> +The DecNet code will be removed soon from the kernel tree as it is old,
> +obsolete, and buggy.

Old and obsolete, well OK, but
what's buggy about decnet?

https://bugzilla.kernel.org/buglist.cgi?quicksearch=decnet

Zarro Boogs found.
