Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2011CC352A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 10:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiK3K2A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiK3K17 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 05:27:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 490EDBDD
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 02:27:57 -0800 (PST)
Date:   Wed, 30 Nov 2022 11:27:50 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2 v2 v2 00/34] Refactor of the DB output plug-ins
Message-ID: <Y4cwJm/ped79pJ/p@salvia>
References: <20221129214749.247878-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221129214749.247878-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 29, 2022 at 09:47:15PM +0000, Jeremy Sowden wrote:
> In his feedback to my last series of clean-up patches at the beginning
> of the year, Pablo suggested consolidating some parallel implementations
> of the same functionality in the SQL output plug-ins.  I already had
> some patches in the works aimed at tidying up the DB API.  This
> patch-set is the result.  In addition to the suggested de-duping and
> other tidy-ups, I have added prep & exec support in order to convert the
> sqlite3 plug-in to the DB API, and updated the MySQL and PostgreSQL 
> plug-ins to use it as well (DBI doesn't do prep & exec).
> 
> This patch-set is structured as follows.
> 
>   * Patches 1-4 are bug-fixes.
>   * Patches 5-13 are miscellaneous tidying.
>   * Patch 14 does the consolidation Pablo suggested.
>   * Patches 15-26 refactor and clean up the common DB API.
>   * Patches 27-28 add prep & exec support to the common DB API.
>   * Patch 29 converts the MySQL plug-in to use prep & exec.
>   * Patch 30-33 tidy up and convert the PostgreSQL plug-in to use prep &
>     exec.
>   * Patch 34 converts the SQLite plug-in to use the common DB API.

It's great that ulogd2 is getting updates, thanks a lot.

But would it be possible to start with a smaller batch? We review
integrate and then you follow up with more updates.

I'll aim at being swift on it.

I'd suggest 10-15 patches in each round.
