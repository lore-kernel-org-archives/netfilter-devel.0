Return-Path: <SRS0=Tpyl=XZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6367C4360C
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 09:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 971C52086A
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 09:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbfI3JKR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Sep 2019 05:10:17 -0400
Received: from correo.us.es ([193.147.175.20]:58214 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730160AbfI3JKR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 05:10:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 280492A2BBB
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 11:10:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 171BBDA840
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 11:10:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0CBB3DA7B6; Mon, 30 Sep 2019 11:10:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E8C1B8001;
        Mon, 30 Sep 2019 11:10:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Sep 2019 11:10:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F0DE041E4800;
        Mon, 30 Sep 2019 11:10:10 +0200 (CEST)
Date:   Mon, 30 Sep 2019 11:10:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Jallot <ejallot@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: obj: fix memleak in handle_free()
Message-ID: <20190930091012.jixfyvbx3w4774sr@salvia>
References: <20190930083823.43094-1-ejallot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930083823.43094-1-ejallot@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 30, 2019 at 10:38:23AM +0200, Eric Jallot wrote:
> Using limit object as example:
> 
>  # valgrind --leak-check=full nft list ruleset
>  ==9937== Memcheck, a memory error detector
>  ==9937== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
>  ==9937== Using Valgrind-3.14.0 and LibVEX; rerun with -h for copyright info
>  ==9937== Command: nft list ruleset
>  ==9937==
>  table inet raw {
>          limit lim1 {
>                  rate 1/second
>          }
>  }

Applied, thanks.
