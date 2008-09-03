From: David Miller <davem@davemloft.net>
Subject: Re: Request: Remove duplicate file names in the kernel source
Date: Wed, 03 Sep 2008 04:48:14 -0700 (PDT)
Message-ID: <20080903.044814.91341122.davem@davemloft.net>
References: <BLU122-W19B435CA307A7ED8A80E18DA5F0@phx.gbl>
	<20080902.160601.109446139.davem@davemloft.net>
	<BLU122-W261AA0AFBCAB6F13BD5D7CDA5E0@phx.gbl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: hallberg68@hotmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39657
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751199AbYICLsV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:48:21 -0400
In-Reply-To: <BLU122-W261AA0AFBCAB6F13BD5D7CDA5E0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Peter Hallberg <hallberg68@hotmail.com>
Date: Wed, 3 Sep 2008 13:24:43 +0200

> > We can't change these, especially the ones under include/linux,
> > without breaking userspace as userspace includes these files.
> 
> At least you can change the other files.

Why bother if it's impossible to make the full transition?

> > I find it strange that you want to study an advanced OS using such a
> > primitive filesystem :-)
>
> That kind of comment is plain stupid unless you accept a patch to
> remove FAT, NTFS and a few more from Linux.

Those are there for "compatibility" to help users transition onto what
we believe is a better and more sane system.

Here's a nickel, go buy yourself real filesystem.

