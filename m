Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50001C25B0E
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Aug 2022 21:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbiHPVqK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Aug 2022 17:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbiHPVqI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Aug 2022 17:46:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69964696CD
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Aug 2022 14:46:07 -0700 (PDT)
Date:   Tue, 16 Aug 2022 23:46:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: [PATCH libmnl v3 2/2] libmnl: add support for signed types
Message-ID: <YvwQGbtindrKWr0s@salvia>
References: <20220808175020.2983706-1-jacob.e.keller@intel.com>
 <20220808175020.2983706-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220808175020.2983706-2-jacob.e.keller@intel.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 08, 2022 at 10:50:20AM -0700, Jacob Keller wrote:
> libmnl has get and put functions for unsigned integer types. It lacks
> support for the signed variations. On some level this is technically
> sufficient. A user could use the unsigned variations and then cast to a
> signed value at use. However, this makes resulting code in the application
> more difficult to follow. Introduce signed variations of the integer get
> and put functions.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> Changes since v2
> * Fixed the ABI breakage (oops!)
> 
>  include/libmnl/libmnl.h |  16 ++++
>  src/attr.c              | 194 +++++++++++++++++++++++++++++++++++++++-

I'm missing one more update for src/libmnl.map.

BTW, how does the library size increase after these new symbols?
