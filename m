Return-Path: <SRS0=LaOm=Z3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3B4C43603
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 10:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD70E2464D
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 10:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfLEKqx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 05:46:53 -0500
Received: from correo.us.es ([193.147.175.20]:34146 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729041AbfLEKqx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 05:46:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4BA14130E20
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 11:46:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D9CCDA449
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 11:46:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1BE49DA573; Thu,  5 Dec 2019 11:46:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FE51DA846;
        Thu,  5 Dec 2019 11:46:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Dec 2019 11:46:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3A14242EE38F;
        Thu,  5 Dec 2019 11:46:31 +0100 (CET)
Date:   Thu, 5 Dec 2019 11:46:32 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/7] iptables: install iptables-apply script and
 manpage
Message-ID: <20191205104632.u4icrxjhqsgb22kv@salvia>
References: <157548347377.125234.12163057581146113349.stgit@endurance>
 <20191204190541.GV795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204190541.GV795@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 04, 2019 at 08:05:41PM +0100, Florian Westphal wrote:
> Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:
> > From: Laurence J. Lane <ljlane@debian.org>
> > 
> > We have the iptables-apply script in the tree (and in the release tarball), but
> > is not being installed anywhere. Same for the manpage.
> > 
> > Arturo says:
> >  I'm not a strong supporter of this script, but there are many users of it, so
> >  better do things right and do a proper installation.
> >  This patch is forwarded from the iptables Debian package, where it has been
> >  around for many years now.
> 
> Series looks good to me, thanks Arturo.  Feel free to push this out.

Just pushed this out.
