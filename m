From: Dan Carpenter <error27@gmail.com>
Subject: Re: [rfc] netfilter: copy less data to the user
Date: Thu, 15 Jul 2010 12:16:45 +0200
Message-ID: <20100715101645.GB17585@bicker>
References: <20100714210430.GB5164@bicker> <4C3ED959.4080007@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ebtables-devel@lists.sourceforge.net,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45271 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992Ab0GOKSI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jul 2010 06:18:08 -0400
Received: by eya25 with SMTP id 25so118635eya.19
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jul 2010 03:18:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4C3ED959.4080007@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 15, 2010 at 11:48:09AM +0200, Patrick McHardy wrote:
> Am 14.07.2010 23:04, schrieb Dan Carpenter:
> > Smatch complains that we copy too much data to the user in ebtables.
> > We copied EBT_FUNCTION_MAXNAMELEN (32) characters to the user here, but 
> > "m->u.match->name" has XT_EXTENSION_MAXNAMELEN (29) characters.
> > 
> > I'm not sure if this is a bug where someone got confused with m->u.name
> > which has 32 characters or if this is done for backwards compatability.
> 
> Looking at ebtables.h, ebt_entry_match->name uses
> EBT_FUNCTION_MAXNAMELEN, which is 32 bytes. Where did you get
> XT_EXTENSION_MAXNAMELEN from?
> 

Exactly.  ebt_entry_match->u.name uses EBT_FUNCTION_MAXNAMELEN but this is
from ebt_entry_match->u.match->name which is type struct xt_match.

But it looks like we're exporting struct ebt_match which also uses
EBT_FUNCTION_MAXNAMELEN.  So maybe the fix is to copy ->u.name instead
of ->u.match->name.

regards,
dan carpenter


