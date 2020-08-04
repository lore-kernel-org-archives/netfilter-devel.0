Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5551C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 19:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B49032086A
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 19:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHDTJN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 15:09:13 -0400
Received: from correo.us.es ([193.147.175.20]:34228 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbgHDTJN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 15:09:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3F1AC11EB23
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 21:09:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36ED9DA84D
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 21:09:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2CA29DA84B; Tue,  4 Aug 2020 21:09:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E20DDDA722;
        Tue,  4 Aug 2020 21:09:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 21:09:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 60F9D4265A32;
        Tue,  4 Aug 2020 21:09:08 +0200 (CEST)
Date:   Tue, 4 Aug 2020 21:09:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
        phil@nwl.cc
Subject: Re: [PATCH nft] src: add cookie support for rules
Message-ID: <20200804190903.GA8820@salvia>
References: <20200804142412.7409-1-pablo@netfilter.org>
 <20200804173805.52fw6m3f5pb4zeh5@egarver>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804173805.52fw6m3f5pb4zeh5@egarver>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 04, 2020 at 01:38:05PM -0400, Eric Garver wrote:
> On Tue, Aug 04, 2020 at 04:24:12PM +0200, Pablo Neira Ayuso wrote:
> > This patch allows users to specify a unsigned 64-bit cookie for rules.
> > The userspace application assigns the cookie number for tracking the rule.
> > The cookie needs to be non-zero. This cookie value is only relevant to
> > userspace since this resides in the user data area.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > Phil, you suggested a cookie to track rules, here it is. A few notes:
> > 
> > - This patch is missing json support.
> > - No need for kernel update since the cookie is stored in the user data area.
> 
> It's also missing the ability to delete a rule using the cookie. I guess
> this means userspace will have to fetch the ruleset and map a cookie to
> rule handle in order to perform the delete.

This cookie idea provides an alternative to skip the input and output
json string comparison, you have to combine it with --echo.

You will still need to use the handle to uniquely identify the rule by
processing the echo message (compare the cookie you set in the rule
that is sent to the kernel, instead of comparing strings).

The input and output json string comparison might be a problem in the
midterm. New netlink attributes and old kernels might result in
different input and output json string.

This is not aiming to provide a mechanism to delete rules by other
than the rule handle.
