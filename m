Return-Path: <SRS0=NOIG=XP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB64FC49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C88EE20882
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438046AbfITKP2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:15:28 -0400
Received: from correo.us.es ([193.147.175.20]:35568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438044AbfITKP2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:15:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8922F15C108
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 12:15:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77184B7FF9
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 12:15:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6CAEF3532; Fri, 20 Sep 2019 12:15:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED86EDA72F;
        Fri, 20 Sep 2019 12:15:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Sep 2019 12:15:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [5.182.56.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 99E3842EE38E;
        Fri, 20 Sep 2019 12:15:21 +0200 (CEST)
Date:   Fri, 20 Sep 2019 12:15:20 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH RFC nftables 0/4] Add Linenoise support to the CLI.
Message-ID: <20190920101520.kwwns3v7nma646bv@salvia>
References: <4df20614cd10434b9f91080d0862dd0c@de.sii.group>
 <20190916124203.31380-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916124203.31380-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 16, 2019 at 01:41:59PM +0100, Jeremy Sowden wrote:
> Sebastian Priebe [0] requested Linenoise support for the CLI as an
> alternative to Readline, so I thought I'd have a go at providing it.
> Linenoise is a minimal, zero-config, BSD licensed, Readline replacement
> used in Redis, MongoDB, and Android [1].
> 
>  0 - https://lore.kernel.org/netfilter-devel/4df20614cd10434b9f91080d0862dd0c@de.sii.group/
>  1 - https://github.com/antirez/linenoise/
> 
> The upstream repo doesn't contain the infrastructure for building or
> installing libraries.  I've taken a look at how Redis and MongoDB handle
> this, and they both include the upstream sources in their trees (MongoDB
> actually uses a C++ fork, Linenoise NG [2]), so I've done the same.
> 
>  2 - https://github.com/arangodb/linenoise-ng
> 
> Initially, I added the Linenoise header to include/ and the source to
> src/, but the compiler warning flags used by upstream differ from those
> used by nftables, which meant that the compiler emitted warnings when
> compiling the Linenoise source and I had to edit it to fix them.

Could you silent these warnings via CFLAGS just like we do with
mini-gmp.{c,h}? We already cache a copy of mini-gmp.c in the tree,
this would follow the same approach, just the source under src/ and
the header in include/.

> Since they were benign and editing the source would make it more
> complicated to update from upstream in the future, I have, instead,
> chosen to put everything in a separate linenoise/ directory with its
> own Makefile.am and the same warning flags as upstream.
> 
> By default, the CLI continues to be build using Readline, but passing
> `with-cli=linenoise` instead causes Linenoise to be used instead.

Probably good if you can also update 'nft -v' to display that nft is
compiled with/without mini-gmp and also with either
libreadline/linenoise.

> The first two patches do a bit of tidying; the third patch adds the
> Linenoise sources; the last adds Linenoise support to the CLI.

No objections, please update tests/build/ to check for this new
./configure option.

Thanks.
