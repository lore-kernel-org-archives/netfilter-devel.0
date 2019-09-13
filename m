Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA83C49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB1220830
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbfIMLtS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 07:49:18 -0400
Received: from correo.us.es ([193.147.175.20]:54060 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfIMLtS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 07:49:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4EBFDA397
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:42:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D735EA7E1E
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:42:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CD053A7E19; Fri, 13 Sep 2019 13:42:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3B8DA7E25;
        Fri, 13 Sep 2019 13:42:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:42:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B1DF342EE38E;
        Fri, 13 Sep 2019 13:42:28 +0200 (CEST)
Date:   Fri, 13 Sep 2019 13:42:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v5] src: add synproxy stateful object support
Message-ID: <20190913114230.r3witepgqwqnkgrc@salvia>
References: <20190912230705.4299-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912230705.4299-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 13, 2019 at 01:07:05AM +0200, Fernando Fernandez Mancera wrote:
> Add support for "synproxy" stateful object. For example (for TCP port 80 and
> using maps with saddr):
> 
> table ip foo {
> 	synproxy https-synproxy {
> 		mss 1460
> 		wscale 7
> 		timestamp sack-perm
> 	}
> 
> 	synproxy other-synproxy {
> 		mss 1460
> 		wscale 5
> 	}
> 
> 	chain bar {
> 		tcp dport 80 synproxy name "https-synproxy"
> 		synproxy name ip saddr map { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
> 	}
> }

Applied, thanks.
