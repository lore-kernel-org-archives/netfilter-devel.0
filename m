Return-Path: <SRS0=/pLU=RP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4B5C10F00
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 09:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23A322147C
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 09:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfCLJt1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 05:49:27 -0400
Received: from mail.us.es ([193.147.175.20]:40804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfCLJt1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 05:49:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 843401EC2DF
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2019 10:49:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BE97BAAC4
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2019 10:49:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53A65DA57A; Tue, 12 Mar 2019 10:48:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F38CAFEFB9;
        Tue, 12 Mar 2019 10:48:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Mar 2019 10:48:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C122E4265A4E;
        Tue, 12 Mar 2019 10:48:46 +0100 (CET)
Date:   Tue, 12 Mar 2019 10:48:46 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Florian Westphal <fw@strlen.de>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net] netfilter: set skb transport_header before calling
 sctp_compute_cksum
Message-ID: <20190312094846.r2pgi3pevvmdv33l@salvia>
References: <740683890e28e93c1b2e940a28089ca10f006b7f.1551601041.git.lucien.xin@gmail.com>
 <20190308155049.by7f4uzjxqnf3xu7@salvia>
 <CADvbK_djd5ckv3nTROsmHNdr0Z5ULt7MF3MXtNYAO58mo+po7Q@mail.gmail.com>
 <20190309092434.oflik6j57yrhpkh5@breakpoint.cc>
 <20190311110752.GA30241@hmswarspite.think-freely.org>
 <CADvbK_dUUyECm57EPmqHyQnh-mkVNz5u-0MCrhtpo80PCr51fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_dUUyECm57EPmqHyQnh-mkVNz5u-0MCrhtpo80PCr51fA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 12, 2019 at 04:39:46PM +0800, Xin Long wrote:
> On Mon, Mar 11, 2019 at 7:08 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Sat, Mar 09, 2019 at 10:24:34AM +0100, Florian Westphal wrote:
> > > Xin Long <lucien.xin@gmail.com> wrote:
> > > >   https://marc.info/?l=linux-netdev&m=155109395226858&w=2
> > > > But from sctp side, Neil preferred sctp_hdr().
> > > >
> > > > We need to either add skb_set_transport_header() in sctp_s/dnat_handler()
> > > > and sctp_manip_pkt(), or bring that patch back?
> > > >
> > > > Now it seems not good to set skb->transport_header in netfilter code.
> > >
> > > I think its fine, but I wonder why we need to do it.
> > >
> > > Since 21d1196a35f5686c4323e42a62fdb4b23b0ab4a3 ipv4 input path sets
> > > transport header before netfilter.  The only problem is that linear
> > > access is illegal without may_pull checks, but in this case the
> > > make_writable call takes care of this already.
> > >
> > Yes, this.  It seems to me we should be setting the transport header prior to
> > ever getting into the netfilter code, which does imply that we need the may_pull
> > check to linearize enough of the packet to do so, just like tcp and udp do.
> >
> > > So, why was this patch needed?
> 
> The issue was reported when going to nf_conntrack by br_netfilter's
> bridge-nf-call-iptables, which could be:
> 
> br_prerouting->inet_prerouting->
> br_forward->inet_forward->
> br_postrouting->inet_postrouting

Can you fix this from br_netfilter then? ie. set the transport header
before prerouting to emulate the IP stack behaviour.
