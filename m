Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29367C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 18:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E111920700
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 18:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfDCSVM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 14:21:12 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:36293 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfDCSVM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 14:21:12 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hBkVZ-0003K9-54; Wed, 03 Apr 2019 20:21:11 +0200
Date:   Wed, 3 Apr 2019 20:21:08 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alban Vidal <alban.vidal@zordhak.fr>
Cc:     netfilter-devel@vger.kernel.org, ao2@ao2.it
Subject: Re: [PATCH v4 1/2] iptables-save: add option to show zeroed counters
 when saving rulesets
Message-ID: <20190403182108.dhfo54lhosmm7373@salvia>
References: <20190217235554.4647-1-alban.vidal@zordhak.fr>
 <9179b69f-3253-97a8-2dd1-f88c745068d3@zordhak.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9179b69f-3253-97a8-2dd1-f88c745068d3@zordhak.fr>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Alban,

On Sun, Mar 03, 2019 at 02:31:30PM +0100, Alban Vidal wrote:
> From: Alban VIDAL <alban.vidal@zordhak.fr>
> 
> Add a new '-Z' (or '--zero') option to iptables-save to show zeroed
> counters for chains when saving rulesets.
> 
> This option is particularly useful when using a version control system
> (like git) to track the saved iptables rules, to minimize the delta
> between different ruleset versions.
> 
> The option is also added to xtables-save to keep compatibility on the
> command line, however the functionality is not implemented yet.

This patch does not apply, it seems your mail client has mangled the
attachment.

I wonder if this -Z semantics for iptables-save might be confusing.
Telling this because iptables -L -z makes an atomic list and reset, so
first time shows the existing counter values, so next time you call
iptables -L shows zeroed counters.

Probably you can use -z (lowercase) --print-zero-counters, so we
reserve -Z in case we ever need something similar in the future for
iptables-save that matches the exact behaviour of iptables -L -Z.

Thanks.
