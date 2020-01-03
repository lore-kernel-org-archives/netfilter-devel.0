Return-Path: <SRS0=aqP0=2Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C9CC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 12:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8200F2085B
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 12:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgACMZp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jan 2020 07:25:45 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:55594 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727436AbgACMZp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jan 2020 07:25:45 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1inM1N-0005UE-86; Fri, 03 Jan 2020 13:25:41 +0100
Date:   Fri, 3 Jan 2020 13:25:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] src: checksum.c: remove redundant
 0xFFFF mask of uint16_t
Message-ID: <20200103122541.GM795@breakpoint.cc>
References: <20191230113345.olr3yifqqmytv3ce@salvia>
 <20191231010607.14313-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231010607.14313-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duncan Roe <duncan_roe@optusnet.com.au> wrote:

Applied.
