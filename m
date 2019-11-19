Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDAAC432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37A8122445
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKSWMl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Nov 2019 17:12:41 -0500
Received: from correo.us.es ([193.147.175.20]:37832 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfKSWMk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 17:12:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E302EE2C53
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2019 23:12:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D489FD1911
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2019 23:12:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CA3F0D2B1F; Tue, 19 Nov 2019 23:12:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C19F3B8014;
        Tue, 19 Nov 2019 23:12:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 19 Nov 2019 23:12:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9E29842EE38E;
        Tue, 19 Nov 2019 23:12:34 +0100 (CET)
Date:   Tue, 19 Nov 2019 23:12:36 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests/py: Set a fixed timezone in nft-test.py
Message-ID: <20191119221236.jfedafspmixjnivw@salvia>
References: <20191116213218.14698-1-phil@nwl.cc>
 <20191118183459.qkqztuc5pn4fezzn@salvia>
 <db71e3276085bccce877215254bbfc21@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db71e3276085bccce877215254bbfc21@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 19, 2019 at 12:06:23PM +0100, Ander Juaristi wrote:
> El 2019-11-18 19:34, Pablo Neira Ayuso escribió:
> > Hi Phil,
> > 
> > On Sat, Nov 16, 2019 at 10:32:18PM +0100, Phil Sutter wrote:
> > > Payload generated for 'meta time' matches depends on host's timezone
> > > and
> > > DST setting. To produce constant output, set a fixed timezone in
> > > nft-test.py. Choose UTC-2 since most payloads are correct then, adjust
> > > the remaining two tests.
> > 
> > This means that the ruleset listing for the user changes when daylight
> > saving occurs, right? Just like it happened to our tests.
> 
> It shouldn't, as the date is converted to a timestamp that doesn't take DST
> into account (using timegm(3), which is Linux-specific).
> 
> The problem is that payloads are hard-coded in the tests.
> 
> Correct me if I'm missing something.

I see, so it's just the _snprintf() function in the library. I
remember we found another problem with these on big endian, it would
be probably to move them to libnftables at some point.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
