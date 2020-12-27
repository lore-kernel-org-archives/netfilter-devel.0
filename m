Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1332BC433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Dec 2020 10:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2D5A217A0
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Dec 2020 10:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgL0KbA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Dec 2020 05:31:00 -0500
Received: from correo.us.es ([193.147.175.20]:58898 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgL0KbA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Dec 2020 05:31:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ACB46D28C7
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Dec 2020 11:29:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E6EADA730
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Dec 2020 11:29:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 94034DA7E4; Sun, 27 Dec 2020 11:29:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5DE6DDA72F;
        Sun, 27 Dec 2020 11:29:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 27 Dec 2020 11:29:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 400C0426CC84;
        Sun, 27 Dec 2020 11:29:48 +0100 (CET)
Date:   Sun, 27 Dec 2020 11:30:15 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] conntrackd: add ip netns test script
Message-ID: <20201227103015.GA2981@salvia>
References: <20201224130713.17517-1-pablo@netfilter.org>
 <5a5f2bd5-6069-ad2c-3a63-c23e0a40991d@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5a5f2bd5-6069-ad2c-3a63-c23e0a40991d@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 25, 2020 at 09:00:09PM +0100, Arturo Borrero Gonzalez wrote:
> On 12/24/20 2:07 PM, Pablo Neira Ayuso wrote:
> > This patch adds a script that creates a ip netns testbed. The network
> > topology looks like this:
> > 
> 
> You can probably drop all those comments in the config file.

I'll do before applying, thanks.
