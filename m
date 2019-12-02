Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5847EC432C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 18:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A60C20717
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 18:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfLBSUN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 13:20:13 -0500
Received: from correo.us.es ([193.147.175.20]:56430 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727671AbfLBSUM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 13:20:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 84973E34CB
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 19:20:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76C1ADA70A
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 19:20:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6C7BADA702; Mon,  2 Dec 2019 19:20:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7BC65DA70A;
        Mon,  2 Dec 2019 19:20:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 19:20:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 58D2B42EE38E;
        Mon,  2 Dec 2019 19:20:07 +0100 (CET)
Date:   Mon, 2 Dec 2019 19:20:08 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Jallot <ejallot@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nft] scanner: fix out-of-bound memory write in
 include_file()
Message-ID: <20191202182008.hjqdeuztzedascpd@salvia>
References: <20191129143039.880-1-ejallot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129143039.880-1-ejallot@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 29, 2019 at 03:30:39PM +0100, Eric Jallot wrote:
> Before patch:
>  # echo 'include "/tmp/rules.nft"' > /tmp/rules.nft
>  # nft -f /tmp/rules.nft
>  In file included from /tmp/rules.nft:1:1-25:
>                   from /tmp/rules.nft:1:1-25:
>  [snip]
>                   from /tmp/rules.nft:1:1-25:
>  /tmp/rules.nft:1:1-25: Error: Include nested too deeply, max 16 levels
>  include "/tmp/rules.nft"
>  ^^^^^^^^^^^^^^^^^^^^^^^^^
>  double free or corruption (out)
>  Aborted (core dumped)

Applied, thanks.
