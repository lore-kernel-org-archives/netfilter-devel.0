Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1D0C3A59D
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 10:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E80E20843
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 10:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfHSKT6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 06:19:58 -0400
Received: from correo.us.es ([193.147.175.20]:49248 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbfHSKT6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 06:19:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 58A96A8212
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 12:19:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A84CB8005
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 12:19:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3FF9FB7FF9; Mon, 19 Aug 2019 12:19:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4AC1DDA72F;
        Mon, 19 Aug 2019 12:19:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 19 Aug 2019 12:19:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.181.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F11244265A2F;
        Mon, 19 Aug 2019 12:19:52 +0200 (CEST)
Date:   Mon, 19 Aug 2019 12:19:51 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Denis Efremov <efremov@linux.com>
Cc:     joe@perches.com, linux-kernel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove IP MASQUERADING record
Message-ID: <20190819101951.yoc73dhyzpt6hxd2@salvia>
References: <20190813085818.4yfcaxfk2xqy32fx@salvia>
 <20190814123502.12863-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814123502.12863-1-efremov@linux.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 14, 2019 at 03:35:02PM +0300, Denis Efremov wrote:
> This entry is in MAINTAINERS for historical purpose.
> It doesn't match current sources since the commit
> adf82accc5f5 ("netfilter: x_tables: merge ip and
> ipv6 masquerade modules") moved the module.
> The net/netfilter/xt_MASQUERADE.c module is already under
> the netfilter section. Thus, there is no purpose to keep this
> separate entry in MAINTAINERS.

Applied, thanks.
