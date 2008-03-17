From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [Ebtables-devel] [PATCH resend 1/2] Adds ebt_nflog watcher to
	kernel.
Date: Mon, 17 Mar 2008 23:12:05 +0100
Message-ID: <1205791925.2869.1.camel@localhost.localdomain>
References: <20080205185521.051763000@andrew.endian.com>
	 <20080205185617.732255000@andrew.endian.com>	<47BD86EF.7060809@trash.net>
	 <47C34933.8000301@endian.com>
	 <1203981841.2959.6.camel@localhost.localdomain>
	 <47DE9B79.3020502@endian.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from monty.telenet-ops.be ([195.130.132.56]:33618 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYCQWMH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:12:07 -0400
In-Reply-To: <47DE9B79.3020502@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op ma, 17-03-2008 te 17:25 +0100, schreef Peter Warasin:
> Hi
> 
> Bart De Schuymer wrote:
> > Op di, 26-02-2008 te 00:03 +0100, schreef Peter Warasin:
> >> I re-based on net-2.6.26 and changed what you mentioned.
> >> Patch is attached
> > It looks fine, I'm just wondering what the flags and the pad in struct
> > ebt_nflog_info are for...
> 
> I have not seen the submit on net-2.6.26 and in ebtables cvs. Is the 
> patch queued or is there something to do for me?

I've just committed the userspace part in cvs. Thanks for reminding me.

cheers,
Bart


