Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEBAC35671
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1C4A206E2
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgBWWhK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 17:37:10 -0500
Received: from correo.us.es ([193.147.175.20]:35660 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgBWWhK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 17:37:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9BDD0ED5C0
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2020 23:37:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E826DA736
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2020 23:37:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8417ADA8E6; Sun, 23 Feb 2020 23:37:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF9E0DA736;
        Sun, 23 Feb 2020 23:37:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 23 Feb 2020 23:37:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 91AE542EF4E0;
        Sun, 23 Feb 2020 23:37:01 +0100 (CET)
Date:   Sun, 23 Feb 2020 23:37:06 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Duncan Roe <duncan_roe@optusnet.com.au>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] build: doc: "make" builds & installs
 a full set of man pages
Message-ID: <20200223223706.543ya6xumtuk3l7b@salvia>
References: <20200208012844.30481-1-duncan_roe@optusnet.com.au>
 <20200223222733.rc4mhtvxgxiihlij@salvia>
 <20200223223514.GA19559@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223223514.GA19559@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Feb 23, 2020 at 11:35:14PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Feb 08, 2020 at 12:28:44PM +1100, Duncan Roe wrote:
> > > This enables one to enter "man <any nfq function>" and get the appropriate
> > > group man page created by doxygen.
> > > 
> > >  - New makefile in doxygen directory. Rebuilds documentation if any sources
> > >    change that contain doxygen comments, or if fixmanpages.sh changes
> > >  - New shell script fixmanpages.sh which
> > >    - Renames each group man page to the first function listed therein
> > >    - Creates symlinks for subsequently listed functions (if any)
> > >    - Deletes _* temp files
> > >  - Update top-level makefile to visit new subdir doxygen
> > >  - Update top-level configure to only build documentation if doxygen installed
> > 
> > I'd prefer people to keep this infrastructure out of tree. Thanks.
> 
> Hmm, why?

Would you like to allow to generate manpage per function in the
library? We never had this so far.

Probably a single manpage in the style of libnftables(3)?
