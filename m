Return-Path: <SRS0=cZSN=YJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42FF8FA3728
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 12:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21755205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 12:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbfJPMTg convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 08:19:36 -0400
Received: from correo.us.es ([193.147.175.20]:43364 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729662AbfJPMTg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 08:19:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0326B15AEAD
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:19:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E90E2A7E1E
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:19:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E6BC3A7E0F; Wed, 16 Oct 2019 14:19:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80F62A7E21;
        Wed, 16 Oct 2019 14:19:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 16 Oct 2019 14:19:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5E42142EE38F;
        Wed, 16 Oct 2019 14:19:28 +0200 (CEST)
Date:   Wed, 16 Oct 2019 14:19:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH nftables v2 1/2] cli: add linenoise CLI implementation.
Message-ID: <20191016121930.ufjztmd7ep4kyq4r@salvia>
References: <20190924074055.4146-1-jeremy@azazel.net>
 <20190924074055.4146-2-jeremy@azazel.net>
 <20191015083252.rm22hgssh4inezq4@salvia>
 <20191016105501.GA5825@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20191016105501.GA5825@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 16, 2019 at 11:55:02AM +0100, Jeremy Sowden wrote:
> On 2019-10-15, at 10:32:52 +0200, Pablo Neira Ayuso wrote:
> > On Tue, Sep 24, 2019 at 08:40:54AM +0100, Jeremy Sowden wrote:
> > > By default, continue to use libreadline, but if
> > > `--with-cli=linenoise` is passed to configure, build the linenoise
> > > implementation instead.
> >
> > Applied, thanks Jeremy.
> 
> Thanks, Pablo.  Don't know whether you change your mind about it, but
> there was a second patch with changes to `nft -v` that you suggested:
> 
>   https://lore.kernel.org/netfilter-devel/20190924074055.4146-3-jeremy@azazel.net/
> 
> Need to find something else to do now. :) Will go and have a poke about
> in Bugzilla.

This might be useful:

https://bugzilla.netfilter.org/show_bug.cgi?id=1374
