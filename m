From: Bob Tracy <rct@gherkin.frus.com>
Subject: Re: [BUG] 4.18-rcX iptables regression
Date: Mon, 13 Aug 2018 18:35:31 -0500
Message-ID: <20180813233531.GA1138@gherkin.frus.com>
References: <20180807010049.GA1345@gherkin.frus.com>
 <20180807134230.2b20d73e@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180807134230.2b20d73e@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Aug 07, 2018 at 01:42:30PM +1000, Stephen Rothwell wrote:
> Hi Bob,
> 
> [Juts cc'ing the netfilter and netdev mailing lists]
> 
> On Mon, 6 Aug 2018 20:00:49 -0500 Bob Tracy <rct@gherkin.frus.com> wrote:
> >
> > With iptables v1.6.0 and kernel version 4.18-rc7, "iptables [-t table] -L"
> > produces diagnostic output to the effect of not being able to find the table.
> > Kernel version 4.17.0 and earlier work fine.

Problem fixed no later than 4.18.0: running on that kernel as I type
this.  Thanks for the quick repair.  Apologies for the "linux-net"
noise: a list by that name hasn't existed for a while, and I missed that
somehow.

--Bob
