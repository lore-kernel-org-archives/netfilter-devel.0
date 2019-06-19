Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3DBC31E5E
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 12:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9492321530
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 12:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560947519;
	bh=OnbpzWSgbraukgT2WoGR2Gyjd60rQpN+yZ6T+ic5ujc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dbDHRouPSkgtFTHBduffYzBXXicD8Z4CcWyKul8F8BVzmcEOl7A93Un4mv/+5TnNt
	 fG5YOBaxc4dX2UUQT9cK18aHlrpqQ8Wzcw4NB/Upf1oufSZA17WAH0O6wQS+Gh59Ag
	 0L9SYv9mIIUE0unQCxHzJbbwz7XGJQvLbky4oJDs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731678AbfFSMb6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 08:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731774AbfFSMb5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 08:31:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3B52147A;
        Wed, 19 Jun 2019 12:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560947516;
        bh=OnbpzWSgbraukgT2WoGR2Gyjd60rQpN+yZ6T+ic5ujc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zv8Mic1rNULY8bj79jLtlD4hcUl8X9Lh7UHxN718zgaALK/zJzX91ZxyrIYiScybT
         W/5VlBtXzdsSgsgYx25sjcTWgk70Vi+djEnh/iEV1fjvy6IAZFE4gFghXanocIN6fz
         s6yO5YdWJP1MpegP9oCJ+ZSHwGErVPAC4ZTqXfGo=
Date:   Wed, 19 Jun 2019 14:31:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: netfilter fix for -stable 5.1.x
Message-ID: <20190619123154.GB23334@kroah.com>
References: <20190618085900.gkq2omywmrduawia@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618085900.gkq2omywmrduawia@salvia>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 10:59:00AM +0200, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> Could you cherry-pick this fix into -stable 5.1.x?
> 
> commit 6bac76db1da3cb162c425d58ae421486f8e43955
> Author: Florian Westphal <fw@strlen.de>
> Date:   Mon May 20 13:48:10 2019 +0200
> 
>     netfilter: nat: fix udp checksum corruption

Now applied, thanks.

greg k-h
