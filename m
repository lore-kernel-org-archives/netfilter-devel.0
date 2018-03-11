From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] net: netfilter: Replace printk() with appropriate
 pr_*() macro
Date: Sun, 11 Mar 2018 23:31:33 +0100
Message-ID: <20180311223133.GH11882@breakpoint.cc>
References: <20180311194104.GA17450@seema-Inspiron-15-3567>
 <1520797961.19456.4.camel@perches.com>
 <20180311204734.aczkhqqgtb7z2kkj@salvia>
 <CA+XqjF-HhYADuFicA1S4tmU2Hfi2bAWinO2DR4g42ORkyGMW_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Joe Perches <joe@perches.com>,
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

Arushi Singhal <arushisinghal19971997@gmail.com> wrote:
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

Both in one, it reduces code churn.

With pr_* + pr_fmt, the module name will be prefixed automatically, see
e.g. commit e016c5e43db51875c2b541b59bd217494d213174 as an example.

> > This would also probably allows us to save the line break in the error
> > message, which IIRC is not a good practise either, eg.
> >
> >                                 pr_warn("nf_queue: OOM "
> >                                         "in mangle, dropping packet\n");
> >
> > > Perhaps coalesce the formats and remove the unnecessary periods too.

The above message should be removed, its useless (on oom allocator
already warns).
