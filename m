Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B72FC76191
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14FDB2084C
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfGUSos (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 14:44:48 -0400
Received: from mail.us.es ([193.147.175.20]:43436 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbfGUSos (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 14:44:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0019AC3307
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2019 20:44:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4DCCDA732
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2019 20:44:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DA79ADA704; Sun, 21 Jul 2019 20:44:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3D22115104;
        Sun, 21 Jul 2019 20:44:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 21 Jul 2019 20:44:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.214.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8EC254265A31;
        Sun, 21 Jul 2019 20:44:43 +0200 (CEST)
Date:   Sun, 21 Jul 2019 20:44:42 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 03/12] xtables-save: Use argv[0] as program name
Message-ID: <20190721184347.vaeb4heog4it3sx2@salvia>
References: <20190720163026.15410-1-phil@nwl.cc>
 <20190720163026.15410-4-phil@nwl.cc>
 <20190720165204.GA22661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190720165204.GA22661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 20, 2019 at 06:52:04PM +0200, Phil Sutter wrote:
> On Sat, Jul 20, 2019 at 06:30:17PM +0200, Phil Sutter wrote:
> > Don't hard-code program names. This also fixes for bogus 'xtables-save'
> > name which is no longer used.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Argh, I should have pulled upstream first, this one was already
> accepted. My series rebases cleanly, should I respin?

Please, if not matching asking, please do so. Also addressing
Florian's feedback updating the comments, thanks.

I'll make a quick review tomorrow, sorry but I cannot get on these any
sooner.
