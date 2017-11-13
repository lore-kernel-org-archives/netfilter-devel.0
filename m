From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next v2] net: move decnet to staging
Date: Mon, 13 Nov 2017 12:25:53 -0800
Message-ID: <1510604753.2849.154.camel@edumazet-glaptop3.roam.corp.google.com>
References: <20171113171142.19476-1-sthemmin@microsoft.com>
         <1510601578.10883.82.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        davem@davemloft.net, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de, devel@driverdev.osuosl.org,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Stephen Hemminger <sthemmin@microsoft.com>
To: Joe Perches <joe@perches.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1510601578.10883.82.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2017-11-13 at 11:32 -0800, Joe Perches wrote:
> On Mon, 2017-11-13 at 09:11 -0800, Stephen Hemminger wrote:
> > Support for Decnet has been orphaned for some time.
> > In the interest of reducing the potential bug surface and pre-holiday
> > cleaning, move the decnet protocol into staging for eventual removal.
> []
> > diff --git a/drivers/staging/decnet/TODO b/drivers/staging/decnet/TODO
> []
> > @@ -0,0 +1,4 @@
> > +The DecNet code will be removed soon from the kernel tree as it is old,
> > +obsolete, and buggy.
> 
> Old and obsolete, well OK, but
> what's buggy about decnet?
> 
> https://bugzilla.kernel.org/buglist.cgi?quicksearch=decnet
> 
> Zarro Boogs found.
> 

Then that means nobody uses it.

And that syzkaller guys never bothered to add code to actually trigger
the bugs that are probably there. Probably they have bigger fishes to
fry at this moment.

If we leave the code there, chances are high that some hacker is
interested into exploiting the bugs.
