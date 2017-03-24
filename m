From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v3 1/1] netfilter: snmp: Fix one possible panic when
 snmp_trap_helper fail to register
Date: Fri, 24 Mar 2017 13:23:01 +0100
Message-ID: <20170324122301.GA3160@salvia>
References: <1490055749-52357-1-git-send-email-fgao@ikuai8.com>
 <20170324122130.GA3080@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, jolsa@redhat.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170324122130.GA3080@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Mar 24, 2017 at 01:21:30PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 21, 2017 at 08:22:29AM +0800, fgao@ikuai8.com wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> > 
> > In the commit 93557f53e1fb ("netfilter: nf_conntrack: nf_conntrack snmp
> > helper"), the snmp_helper is replaced by nf_nat_snmp_hook. So the
> > snmp_helper is never registered. But it still tries to unregister the
> > snmp_helper, it could cause the panic.
> 
> This patch looks correct to me.
> 
> But probably for some reason I don't manage to trigger, how do you
> reproduce this?

I'm refering to the panic.
