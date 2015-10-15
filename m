From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH lnf-log 3/3] utils: nf-log: attaching a conntrack
 information
Date: Thu, 15 Oct 2015 13:35:44 +0900
Message-ID: <20151015043544.GA18814@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
 <20150911031535.GG7380@gmail.com>
 <20151012152630.GC21781@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35001 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbJOEft (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Oct 2015 00:35:49 -0400
Received: by pacao1 with SMTP id ao1so10248437pac.2
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2015 21:35:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20151012152630.GC21781@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 12, 2015 at 05:26:30PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Sep 11, 2015 at 12:15:35PM +0900, Ken-ichirou MATSUZAWA wrote:
> > -#include <linux/netfilter/nfnetlink_log.h>
> > +/* #include <linux/netfilter/nfnetlink_log.h> */
> 
> Do you remember why you had to comment out this line?

I think I intended to use linux_nfnetlink_log.h synched previous
and made this mistake.

> > +	switch (ntohl(mnl_attr_get_u32(attr))) {
> > +	case IP_CT_ESTABLISHED:
> > +		s = "IP_CT_ESTABLISHED";
> 
> For this example, you can probably simplify this with.
> 
>         case IP_CT_ESTABLISHED:
>         case IP_CT_ESTABLISHED_REPLY:
>                 s = "ESTABLISHED";
[...]
> IP_CT_IS_REPLY is never used alone, it's is always combined with NEW,
> ESTABLISHED, RELATED states.
[...]
> IP_CT_NUMBER should never happen. Please remove this code.

I try to fix aboves and would you review the following again?
Thanks,
