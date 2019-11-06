Return-Path: <SRS0=uVIa=Y6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD1CC5DF62
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 09:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2C932173E
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 09:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfKFJY6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Nov 2019 04:24:58 -0500
Received: from correo.us.es ([193.147.175.20]:54272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbfKFJY6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Nov 2019 04:24:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 63B499ED62
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 10:24:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54F43DA3A9
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 10:24:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5455ADA4D0; Wed,  6 Nov 2019 10:24:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0046CDA801;
        Wed,  6 Nov 2019 10:24:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Nov 2019 10:24:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C8AEF4251480;
        Wed,  6 Nov 2019 10:24:50 +0100 (CET)
Date:   Wed, 6 Nov 2019 10:24:52 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 0/7] Improve xtables-restore performance
Message-ID: <20191106092452.2witubxzularwbn2@salvia>
References: <20191024163712.22405-1-phil@nwl.cc>
 <20191031150234.osfnsa2emuvhocrc@salvia>
 <20191031171947.GF8531@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031171947.GF8531@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Thu, Oct 31, 2019 at 06:19:47PM +0100, Phil Sutter wrote:
> On Thu, Oct 31, 2019 at 04:02:34PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Oct 24, 2019 at 06:37:05PM +0200, Phil Sutter wrote:
> > > This series speeds up xtables-restore calls with --noflush (typically
> > > used to batch a few commands for faster execution) by preliminary input
> > > inspection.
> > > 
> > > Before, setting --noflush flag would inevitably lead to full cache
> > > population. With this series in place, if input can be fully buffered
> > > and no commands requiring full cache is contained, no initial cache
> > > population happens and each rule parsed will cause fetching of cache
> > > bits as required.
> > > 
> > > The input buffer size is arbitrarily chosen to be 64KB.
> > > 
> > > Patches one and two prepare code for patch three which moves the loop
> > > content parsing each line of input into a separate function. The
> > > reduction of code indenting is used by patch four which deals with
> > > needless line breaks.
> > 
> > For patches from 1 to 4 in this batch:
> > 
> > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > > Patch five deals with another requirement of input buffering, namely
> > > stripping newline characters from each line. This is not a problem by
> > > itself, but add_param_to_argv() replaces them by nul-chars and so
> > > strings stop being consistently terminated (some by a single, some by
> > > two nul-chars).
> > > 
> > > Patch six then finally adds the buffering and caching decision code.
> > > 
> > > Patch seven is pretty unrelated but tests a specific behaviour of
> > > *tables-restore I wasn't sure of at first.
> > 
> > Do you have any number?
> 
> Yes, I wrote a small benchmark based on some Kubernetes use-case. It
> measures loading of dumps like:
> 
> | *nat
> | :KUBE-SVC-23 - [0:0]
> | :KUBE-SEP-23 - [0:0]
> | -A KUBE-HOOK ! -s 10.128.0.0/14 -d 172.30.108.136/32 -p tcp -m comment --comment \"openshift-controller-manager/controller-manager:https cluster IP\" -m tcp --dport 443 -j KUBE-MARK-MASQ
> | -A KUBE-HOOK -d 172.30.108.136/32 -p tcp -m comment --comment \"openshift-controller-manager/controller-manager:https cluster IP\" -m tcp --dport 443 -j KUBE-SVC-23
> | -A KUBE-SVC-23 -j KUBE-SEP-23
> | -A KUBE-SEP-23 -s 10.128.0.38/32 -j KUBE-MARK-MASQ
> | -A KUBE-SEP-23 -p tcp -m tcp -j DNAT --to-destination 10.128.0.38:8443
> | COMMIT
> 
> Into a ruleset with increasing size (created by repeating the snippet above):
> 
> size (*100) |	legacy     |   nft-pre	   |   nft-post
> ---------------------------------------------------------
> 1             .0040366426     .0079313714     .0025598650
> 10            .0146918664     .0459193868     .0025134858
> 25            .0361553334     .1195503778     .0024202904
> 50            .0699177362     .2547542626     .0024351612
> 75            .1062593206     .4078182120     .0024362044
> 100           .1614045514     .5636617378     .0024195190

Thanks, this is nice.

I can see this function:

        static bool cmd_needs_full_cache(char *cmd)

the pre-parsing of the input to calculate the cache, which is good.

One thing: why do you need the conversion from \n to \0. The idea is
to read once from the file and keep it in a buffer, then pass it to
the original parsing function after this pre-parsing to calculate the
cache.

Please, add this to the remaining patches of this series.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
