From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] net: netfilter: Replace printk() with appropriate
 pr_*() macro
Date: Sun, 11 Mar 2018 23:28:46 +0100
Message-ID: <20180311222846.av3tui5nkuximoqk@salvia>
References: <20180311194104.GA17450@seema-Inspiron-15-3567>
 <1520797961.19456.4.camel@perches.com>
 <20180311204734.aczkhqqgtb7z2kkj@salvia>
 <CA+XqjF-HhYADuFicA1S4tmU2Hfi2bAWinO2DR4g42ORkyGMW_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joe Perches <joe@perches.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Arushi Singhal <arushisinghal19971997@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+XqjF-HhYADuFicA1S4tmU2Hfi2bAWinO2DR4g42ORkyGMW_A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Mar 12, 2018 at 03:56:15AM +0530, Arushi Singhal wrote:
> On Mon, Mar 12, 2018 at 2:17 AM, Pablo Neira Ayuso <pablo@netfilter.org>
> wrote:
> 
> > Hi Joe,
> >
> > On Sun, Mar 11, 2018 at 12:52:41PM -0700, Joe Perches wrote:
> > > On Mon, 2018-03-12 at 01:11 +0530, Arushi Singhal wrote:
> > > > Using pr_<loglevel>() is more concise than
> > > > printk(KERN_<LOGLEVEL>).
> > > > Replace printks having a log level with the appropriate
> > > > pr_*() macros.
> > > >
> > > > Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
> > > > ---
> > > > changes in v2
> > > > *in v1 printk() were replaced with netdev_*()
> > >
> > > >  net/netfilter/nf_conntrack_acct.c      | 2 +-
> > > >  net/netfilter/nf_conntrack_ecache.c    | 2 +-
> > > >  net/netfilter/nf_conntrack_timestamp.c | 2 +-
> > > >  net/netfilter/nf_nat_core.c            | 2 +-
> > > >  net/netfilter/nfnetlink_queue.c        | 4 ++--
> > > >  5 files changed, 6 insertions(+), 6 deletions(-)
> > >
> > > None of these files have a #define for pr_fmt so this
> > > should be OK.
> >
> > I think Arushi could add pr_fmt in the same go, so we skip another
> > follow up patch for this. @Arushi: I suggested this in my previous
> > email, please have a look.
> >
> > Hello Pablo
> 
> Should I send two patches, one with the conversion of printk() to pr_() and
> another for defining pr_fmt().
> 
> Or
> 
> only one patch with all the changes?

I think adding pr_fmt and use pr_() belongs to the same logical
change, so one patch for this is fine.

Thanks Arushi.

P.S: Please, just send your patch netfilter-devel@vger.kernel.org
next time, no need to Cc every list. Thanks!
