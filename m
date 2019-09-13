Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5BFC49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 10:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A2342084F
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 10:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387828AbfIMK5c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 06:57:32 -0400
Received: from correo.us.es ([193.147.175.20]:46708 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387424AbfIMK5b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 06:57:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2AC351878AD
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 12:57:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1BDAFFB362
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 12:57:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1AD24A7D54; Fri, 13 Sep 2019 12:57:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 547B7A7D6A;
        Fri, 13 Sep 2019 12:57:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 12:57:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 23E1E42EE38F;
        Fri, 13 Sep 2019 12:57:25 +0200 (CEST)
Date:   Fri, 13 Sep 2019 12:57:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v3 00/18] Remove config option checks from
 netfilter headers.
Message-ID: <20190913105726.k2z7g25lkkxhbqnr@salvia>
References: <20190913081318.16071-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190913081318.16071-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 13, 2019 at 09:13:00AM +0100, Jeremy Sowden wrote:
> In a previous patch-series [0], I removed all netfilter headers from the
> blacklist of headers which could not be compiled standalone.  I did so
> by fixing the specific compilation failures of the headers in the list,
> usually by adding a preprocessor conditional to check whether a particu-
> lar config option was enabled and disable some function definition or
> struct member which depended on that option.  While this was effective,
> it was not wholly satisfactory since it left a scattering of seemingly
> random ifdefs throughout the headers.
> 
> 0 - https://lore.kernel.org/netfilter-devel/20190813113657.GB4840@azazel.net/T/
> 
> The reason why these ad-hoc conditionals were necessary is that there
> were inconsistencies in how existing checks were used to disable code
> when particular options were turned off.  For example, a header A.h
> might define a struct S which was only available if a particular config
> option C was enabled, but A.h might be included by header B.h, which
> defined a struct T with a struct S member without checking for C.  If
> A.h and B.h were included in X.c, which was only compiled if C was
> enabled, everything worked as expected; however, trying to compile B.h
> standalone when C was disabled would result in a compilation failure.
> 
> In the previous versions of this patch-series, I attempted to provide a
> more comprehensive solution by identifying the config options relevant
> to each header and adding the appropriate conditionals to it where they
> do not already exist.  However, based on feedback and looking at some
> other examples, it became apparent that a better approach was to
> endeavour to fix the inconsistencies that made the new config checks
> necessary, with a view to removing as many of them as possible.

Series applied, thanks.
