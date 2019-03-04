Return-Path: <SRS0=Cmqr=RH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998BAC43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 13:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71B552075B
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 13:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfCDNIA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 08:08:00 -0500
Received: from mail.us.es ([193.147.175.20]:58970 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfCDNH7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 08:07:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7F9B24DA724
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Mar 2019 14:07:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C0FDDA864
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Mar 2019 14:07:57 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6B29FDA856; Mon,  4 Mar 2019 14:07:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82008DA85E;
        Mon,  4 Mar 2019 14:07:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 04 Mar 2019 14:07:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5E7024265A2F;
        Mon,  4 Mar 2019 14:07:55 +0100 (CET)
Date:   Mon, 4 Mar 2019 14:07:55 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 5/5] iptables-test: Make use of sample
 connlabel.conf
Message-ID: <20190304130754.dbevsm56grewxxh2@salvia>
References: <20190219193953.29066-1-phil@nwl.cc>
 <20190219193953.29066-6-phil@nwl.cc>
 <20190303210302.r6sppucmnrwg66gg@breakpoint.cc>
 <20190304124311.GM2478@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304124311.GM2478@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 04, 2019 at 01:43:11PM +0100, Phil Sutter wrote:
> Hi,
> 
> On Sun, Mar 03, 2019 at 10:03:02PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > 
> > Sorry for being late.
> 
> No worries, it is not urgent.
> 
> > > +@cp -f extensions/libxt_connlabel.conf.test extensions/libxt_connlabel.conf.tmp
> > >  -m connlabel --label "bit40";=;OK
> > >  -m connlabel ! --label "bit40";=;OK
> > >  -m connlabel --label "bit41" --set;=;OK
> > >  -m connlabel ! --label "bit41" --set;=;OK
> > >  -m connlabel --label "bit128";;FAIL
> > 
> > Maybe we should forget about the label names and just tests
> > -m connlabel --label 127
> > 
> > i.e., parse the numeric value instead of providing a fake
> > one.  I agree that temporary replace of hosts one is bad.
> 
> Fine with me as well. Obviously this would reduce code coverage of
> tests, although not much since libnetfilter_conntrack is used for label
> map lookup.

We can probably place some mapping lookup tests for this in
libnetfilter_conntrack.
