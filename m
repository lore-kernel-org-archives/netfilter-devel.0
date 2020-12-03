Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B88C1B0D9
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 21:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60407222B6
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 21:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502097AbgLCVrg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:47:36 -0500
Received: from correo.us.es ([193.147.175.20]:46824 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501986AbgLCVrf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 16:47:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 824D0160A20
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 22:46:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7243FDA8F4
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 22:46:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 67EDEDA72F; Thu,  3 Dec 2020 22:46:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1718CDA8F3;
        Thu,  3 Dec 2020 22:46:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 03 Dec 2020 22:46:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EDF1642EF42A;
        Thu,  3 Dec 2020 22:46:47 +0100 (CET)
Date:   Thu, 3 Dec 2020 22:46:51 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libftnl,RFC] src: add infrastructure to infer byteorder
 from keys
Message-ID: <20201203214651.GA30926@salvia>
References: <20201126104850.30953-1-pablo@netfilter.org>
 <20201203162217.GB4647@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201203162217.GB4647@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Thu, Dec 03, 2020 at 05:22:17PM +0100, Phil Sutter wrote:
[...]
> On Thu, Nov 26, 2020 at 11:48:50AM +0100, Pablo Neira Ayuso wrote:
> > This patch adds a new .byteorder callback to expressions to allow infer
> > the data byteorder that is placed in registers. Given that keys have a
> > fixed datatype, this patch tracks register operations to obtain the data
> > byteorder. This new infrastructure is internal and it is only used by
> > the nftnl_rule_snprintf() function to make it portable regardless the
> > endianess.
> > 
> > A few examples after this patch running on x86_64:
> > 
> > netdev
> >   [ meta load protocol => reg 1 ]
> >   [ cmp eq reg 1 0x00000008 ]
> >   [ immediate reg 1 0x01020304 ]
> >   [ payload write reg 1 => 4b @ network header + 12 csum_type 1 csum_off 10 csum_flags 0x1 ]
> > 
> > root@salvia:/home/pablo/devel/scm/git-netfilter/libnftnl# nft --debug=netlink add rule netdev x z ip saddr 1.2.3.4
> > netdev
> >   [ meta load protocol => reg 1 ]
> >   [ cmp eq reg 1 0x00000008 ]
> >   [ payload load 4b @ network header + 12 => reg 1 ]
> >   [ cmp eq reg 1 0x01020304 ]
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > Hi Phil,
> > 
> > This patch is incomplete. Many expressions are still missing the byteorder.
> > This is adding minimal infrastructure to "delinearize" expression for printing
> > on the debug information.
> > 
> > The set infrastructure is also missing, this requires to move the TYPE_
> > definitions to libnftnl (this is part of existing technical debt) and
> > add minimal code to "delinearize" the set element again from snprintf
> > based in the NFTNL_SET_DATATYPE / userdata information of the set
> > definition.
> 
> Thanks for this initial implementation, I think it's a good start and I
> would like to complete it.

Thanks.

> Currently I'm running into roadblocks with anonymous sets, though (I
> didn't even test named ones yet). The anonymous ones are what I hit
> first when trying to fix tests/py/ payload files.
>
> The simple example is:
> | nft --debug=netlink add rule ip t c ip saddr { 10.0.0.1, 1.2.3.4 }
> 
> I tried to extract NFTNL_UDATA_SET_KEYBYTEORDER and
> NFTNL_UDATA_SET_DATABYTEORDER from set's udata in
> nftnl_set_snprintf_default() but those are not present. Also set's
> 'key_type' and 'data_type' fields are zero, probably because the set
> doesn't have a formal definition.
> 
> I added some debug printing to nftnl_rule_snprintf_default() and
> apparently debug output prints the set content before it is called,
> therefore I can't use your infrastructure to deduce the set elements'
> byteorder from the lookup expression's sreg.
> 
> Any ideas how this could be solved?

netlink_get_setelem() calls netlink_dump_set() to display the debug
information. There the nls object key_type and data_type are not set.
The set object that was obtained from the evaluation phase is already
in place, it contains the key_type and data_type. You have to use it
to set the missing bits in nls accordingly.

Let me know if this works for you.

> 
> Thanks, Phil
