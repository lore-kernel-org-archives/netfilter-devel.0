From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ipv6: Preserve link scope traffic original oif
Date: Fri, 3 Mar 2017 13:12:25 +0100
Message-ID: <20170303121225.GA14320@salvia>
References: <1488376043-31976-1-git-send-email-alin.nastac@gmail.com>
 <20170303113918.GA13435@salvia>
 <CAF1oqRD9sahqwj0u1k44x6EqnjD7czLFDM32nO1o6am4gnprtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Alin =?utf-8?Q?N=C4=83stac?= <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56150 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751735AbdCCMtl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 07:49:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1512019D8B8
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 13:12:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06149DA809
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 13:12:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90B35DA817
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 13:12:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAF1oqRD9sahqwj0u1k44x6EqnjD7czLFDM32nO1o6am4gnprtw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 03, 2017 at 12:56:50PM +0100, Alin Năstac wrote:
> On Fri, Mar 3, 2017 at 12:39 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Mar 01, 2017 at 02:47:23PM +0100, Alin Nastac wrote:
> >> Link-local and multicast packets must keep their original oif after
> >> ip6_route_me_harder is called.
> >
> > Out of curiosity, how does the setup you use look like to trigger this
> > problem?
> 
> ICMPv6 RA/NS/NA are marked by a -j MARK iptables rule (the mark value
> is used to set the QoS queue).
> Because skb->mark value changed, ip6t_mangle_out will call ip6_route_me_harder.

That sounds quite standard. Did this broke after kernel upgrade? I'm
trying to guess if the problem is somewhere else...
