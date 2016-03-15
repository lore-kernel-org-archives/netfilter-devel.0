From: Weongyo Jeong <weongyo.linux@gmail.com>
Subject: Re: [PATCH] Shows proper function name for pr_debug() messages.
Date: Tue, 15 Mar 2016 10:59:11 -0700
Message-ID: <20160315175910.GA11907@jwg>
References: <20160314200733.GA8907@jwg>
 <20160315001501.GA27056@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36646 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815AbcCOR7O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 13:59:14 -0400
Received: by mail-pf0-f174.google.com with SMTP id u190so38056088pfb.3
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 10:59:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160315001501.GA27056@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 15, 2016 at 01:15:01AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Mar 14, 2016 at 01:07:36PM -0700, Weongyo Jeong wrote:
> > It seems pr_debug() calls didn't be updated while code was refactoring.
> 
> Better add:
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> at the top of the file.
> 
> Have a look at beacd3e8ef23 ("netfilter: nfnetlink_log: Make use of
> pr_fmt where applicable") for instance.

Thank you for review.  I'd submitted a patch again following your
suggestion.

Regards,
Weongyo Jeong
