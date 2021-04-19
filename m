Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA5CC433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Apr 2021 14:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD7961104
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Apr 2021 14:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239553AbhDSOhY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 10:37:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36550 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239480AbhDSOhY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 10:37:24 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id CDA0B63E49;
        Mon, 19 Apr 2021 16:36:22 +0200 (CEST)
Date:   Mon, 19 Apr 2021 16:36:50 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Firo Yang <firo.yang@suse.com>
Cc:     netfilter-devel@vger.kernel.org, sflees@suse.de, firogm@gmail.com
Subject: Re: [PATCH v2 0/2] Two fixes related to '--concurrent'
Message-ID: <20210419143650.GA989@salvia>
References: <20210416041141.27891-1-firo.yang@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210416041141.27891-1-firo.yang@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 16, 2021 at 12:11:39PM +0800, Firo Yang wrote:
> Fixed two problems related to '--concurrent'.

Series applied, thanks.
