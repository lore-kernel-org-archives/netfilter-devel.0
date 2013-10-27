From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] nft: nft_set_attr_get_u32 null pointer deref
Date: Sun, 27 Oct 2013 16:29:42 -0700
Message-ID: <20131027232941.GA20909@home>
References: <20131025165531.GA18336@home>
 <20131027203426.GA9466@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61828 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab3J0X3n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 19:29:43 -0400
Received: by mail-pa0-f51.google.com with SMTP id ld10so6340250pab.38
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2013 16:29:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131027203426.GA9466@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 27, 2013 at 09:34:26PM +0100, Pablo Neira Ayuso wrote:
> I have mangled this patch to include possible null dereferences in get
> operations with rule objects (similar case). Let me know if you see
> any issue with my change.

Looks good, thanks.

Phil
