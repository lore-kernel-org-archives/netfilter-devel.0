From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the netfilter-next
 tree
Date: Mon, 20 Mar 2017 19:44:55 +1100
Message-ID: <20170320194455.4352d15e@canb.auug.org.au>
References: <20170320111236.77c5a05a@canb.auug.org.au>
        <2236FBA76BA1254E88B949DDB74E612B41C5B0DC@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans Liljestrand" <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C5B0DC@IRSMSX102.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Elena,

On Mon, 20 Mar 2017 07:00:13 +0000 "Reshetova, Elena" <elena.reshetova@intel.com> wrote:
>
> > After merging the netfilter-next tree, today's linux-next build (x86_64
> > allmodconfig) produced this warning:
> > 
> > net/netfilter/nfnetlink_acct.c: In function 'nfnl_acct_try_del':
> > net/netfilter/nfnetlink_acct.c:329:15: warning: unused variable 'refcount' [-
> > Wunused-variable]
> >   unsigned int refcount;
> >                ^
> > 
> > Introduced by commit  
> 
> Ups, sorry about this, slipped through. Should I submit a fix or how do you want to handle this?

That's up to Pablo, but presumably you should send him a followup patch.

-- 
Cheers,
Stephen Rothwell
