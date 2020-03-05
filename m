Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E57C3F2CD
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 11:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CB242073B
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 11:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgCELr3 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 06:47:29 -0500
Received: from correo.us.es ([193.147.175.20]:34564 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgCELr3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 06:47:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 75C21FFB64
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2020 12:47:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C5EBFC5EF
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2020 12:47:11 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1A3F8FC5F3; Thu,  5 Mar 2020 12:46:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01618FC5F2;
        Thu,  5 Mar 2020 12:46:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Mar 2020 12:46:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DA07942EF4E2;
        Thu,  5 Mar 2020 12:46:51 +0100 (CET)
Date:   Thu, 5 Mar 2020 12:47:07 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] main: add more information to `nft -V`.
Message-ID: <20200305114707.jvofthwfvt2tdkkh@salvia>
References: <20200303232341.25786-1-pablo@netfilter.org>
 <20200304085735.GA19243@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200304085735.GA19243@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 04, 2020 at 08:57:35AM +0000, Jeremy Sowden wrote:
> On 2020-03-04, at 00:23:41 +0100, Pablo Neira Ayuso wrote:
> > From: Jeremy Sowden <jeremy@azazel.net>
> >
> > In addition to the package-version and release-name, output the CLI
> > implementation (if any) and whether mini-gmp was used, e.g.:
> >
> >     $ ./src/nft -V
> >     nftables v0.9.3 (Topsy)
> >       cli:          linenoise
> >       minigmp:      no
> >
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > Hi Jeremy et al.
> >
> > I'm revisiting this one, it's basically your patch with a few
> > mangling.
> >
> > I wonder if it's probably a good idea to introduce a long version
> > mode.  I have seen other tools providing more verbose information
> > about all build information.
> >
> > The idea would be to leave -v/--version as it is, and introduce -V
> > which would be more verbose.
> >
> > Thanks.
> 
> Fine by me.  Btw, I notice that OPTSTRING contains a couple of
> duplicates.  I've attached a patch to remove them.  It applies on top of
> this one.

Thanks, I have applied these two patches.
