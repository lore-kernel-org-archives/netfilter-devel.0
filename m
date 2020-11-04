Return-Path: <SRS0=dzjG=EK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DE5C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 13:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2085E21556
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 13:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgKDN4K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Nov 2020 08:56:10 -0500
Received: from correo.us.es ([193.147.175.20]:54778 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgKDN4K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Nov 2020 08:56:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1567CC4008
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 14:56:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04880DA78F
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 14:56:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EDFEDDA78E; Wed,  4 Nov 2020 14:56:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CADBBDA730;
        Wed,  4 Nov 2020 14:56:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 14:56:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9FB5A42EF9E1;
        Wed,  4 Nov 2020 14:56:06 +0100 (CET)
Date:   Wed, 4 Nov 2020 14:56:06 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 3/8] conntrack: accept parameters from stdin
Message-ID: <20201104135606.GA29027@salvia>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
 <20200925124919.9389-4-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200925124919.9389-4-mikhail.sennikovskii@cloud.ionos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Mikhail,

On Fri, Sep 25, 2020 at 02:49:14PM +0200, Mikhail Sennikovsky wrote:
> This commit allows accepting multiple sets of ct entry-related
> parameters on stdin.
> This is useful when one needs to add/update/delete a large
> set of ct entries with a single conntrack tool invocation.
> 
> Expected syntax is "conntrack [-I|-D|-U] [table] -".
> When invoked like that, conntrack expects ct entry parameters
> to be passed to the stdin, each line presenting a separate parameter
> set.

We have to follow a slightly different approach.

For the batch mode, we have to do similar to iptables, see
do_parse() there.

This parser will create a list of command objects, something like:

struct ct_cmd {
        struct list_head        list;
        ...
        /* attributes that result from parser that describe this command */
};

Once we have the list of commands, iterate over this list of commands
and send the netlink commands.

Thanks.
