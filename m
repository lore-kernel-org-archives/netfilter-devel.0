Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD84C5B57D
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59DAD21993
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfGCA2p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 20:28:45 -0400
Received: from mail.us.es ([193.147.175.20]:40490 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbfGCA2o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 20:28:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 823148076E
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:12:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 669AAFB37C
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:12:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5C2E5D1929; Wed,  3 Jul 2019 01:12:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C764DA732;
        Wed,  3 Jul 2019 01:12:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jul 2019 01:12:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 465B64265A5B;
        Wed,  3 Jul 2019 01:12:48 +0200 (CEST)
Date:   Wed, 3 Jul 2019 01:12:47 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?iso-8859-1?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables v4 1/1] add ct expectations support
Message-ID: <20190702231247.qoqcq5lynsb4xs5h@salvia>
References: <20190605092818.13844-1-sveyret@gmail.com>
 <20190605092818.13844-2-sveyret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190605092818.13844-2-sveyret@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I was going to apply this, but I just noticed a problem.

json compilation breaks:

parser_json.c: In function ‘json_parse_cmd_add_object’:
parser_json.c:2993:20: error: ‘value’ undeclared (first use in this function)
   if (!json_unpack(value, "{s:o}", "dport", &tmp))
                    ^~~~~

Please, make sure you run ./configure with --with-json.

Also run:

        tests/py# python nft-tests.py -j

to run json tests.

Would you fix this and revamp? I would like that json support is a bit
taken as a first class citizen, so Phil does not have to run after
every new patch updating the json bits to fix it :-).

Thanks.
