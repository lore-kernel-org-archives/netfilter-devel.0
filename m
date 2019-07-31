Return-Path: <SRS0=6+Vk=V4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0EDC433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 12:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED070206B8
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 12:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfGaMlS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 08:41:18 -0400
Received: from correo.us.es ([193.147.175.20]:46752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbfGaMlS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 08:41:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D1F4153AA0
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2019 14:41:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C171DA708
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2019 14:41:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 51E10DA704; Wed, 31 Jul 2019 14:41:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BF79DA708;
        Wed, 31 Jul 2019 14:41:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 31 Jul 2019 14:41:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.32.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1672C4265A2F;
        Wed, 31 Jul 2019 14:41:13 +0200 (CEST)
Date:   Wed, 31 Jul 2019 14:41:11 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     michael-dev@fami-braun.de
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCHv2] Fix dumping vlan rules
Message-ID: <20190731124111.ysigwdzw6qiveeaa@salvia>
References: <20190715165901.14441-1-michael-dev@fami-braun.de>
 <20190715180639.5osmyxjg6b2r7db3@salvia>
 <9B7A6B88-AA54-4F0C-8078-AEF49AA80EC5@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9B7A6B88-AA54-4F0C-8078-AEF49AA80EC5@fami-braun.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 27, 2019 at 07:24:24PM +0200, michael-dev@fami-braun.de wrote:
[...]
> I used nft list ruleset to generate /etc/nftables.conf. In case too
> few statements are killed, nftables.conf becomes a bit longer but it
> is still correct and parseable although not minimal. In case too
> many statements are killed, the semantic changes on next reboot or
> for review with all kinds of implications.  Therefore killing to
> many statements seems critical too many, kill too few only like a
> minor issue. I'd therefore prefer to take the risk of being overly
> broad here rathen than having incorrect information and thus not
> restrict this to vlan.
> 
> Stacked protocols like ipsec, ipip tunnel or vlan tend to have the
> same upper layer payload protocol, e.g. udp in ip, udp in ipip or
> udp in esp/ah. Therefore killing protocol type statements for
> stacked protocols generally does not look safe to me, as the upper
> layer will not imply any stacked protocol.

OK. We may have to revisit the stacked protocol logic at some point
though.

Patch is applied. Thanks.

BTW, would you follow up with a fix for json tests?

If I run here:

        nft-tests.py -j

it complains here:

ERROR: did not find JSON equivalent for rule 'ether type vlan ip
protocol 1 accept'

Thanks!
