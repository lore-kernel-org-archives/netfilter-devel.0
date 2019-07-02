Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEA0C06511
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 930BD218AD
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfGCAio (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 20:38:44 -0400
Received: from mail.us.es ([193.147.175.20]:42482 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfGCAin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 20:38:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E7A2680778
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:19:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9263DA801
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:19:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CECA5DA7B6; Wed,  3 Jul 2019 01:19:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD05CDA732;
        Wed,  3 Jul 2019 01:19:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jul 2019 01:19:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BD7334265A2F;
        Wed,  3 Jul 2019 01:19:13 +0200 (CEST)
Date:   Wed, 3 Jul 2019 01:19:13 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] meta: Parse 'time' type with timegm()
Message-ID: <20190702231913.bmq22osaoj3birgi@salvia>
References: <20190701201646.7040-1-a@juaristi.eus>
 <20190701201646.7040-2-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701201646.7040-2-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 01, 2019 at 10:16:44PM +0200, Ander Juaristi wrote:
> Use timegm() to parse the 'time' time. The timegm() function is only
> available on Linux, but overwriting the TZ environment variable seems to
> be a much worse solution.
> 
> The problem is that we need to convert an ISO date to a timestamp
> without taking into account the time zone offset, since comparison will
> be done in kernel space and there is no time zone information there.
> 
> Overwriting TZ is portable, but will cause problems when parsing a
> ruleset that has 'time' and 'hour' rules. Parsing an 'hour' type must
> not do time zone conversion, but that will be automatically done if TZ has
> been overwritten to UTC.
> 
> We could record the initial setting of the
> TZ variable on start, but there's no reliable way to do that (we'd have
> to store the initial TZ in a global variable at program start and re-set
> it every time we parse an 'hour' value).
> 
> Hence it's better idea to use timegm(), even though it's non-portable.
> Netfilter is a Linux program after all.

Please, squash this patch into 1/4 in your next batch. Thanks.
