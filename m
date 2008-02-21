From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Adds ebt_nflog watcher to kernel.
Date: Thu, 21 Feb 2008 15:13:03 +0100
Message-ID: <47BD86EF.7060809@trash.net>
References: <20080205185521.051763000@andrew.endian.com> <20080205185617.732255000@andrew.endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net,
	Bart De Schuymer <bdschuym@pandora.be>
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:9904 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757617AbYBUONX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2008 09:13:23 -0500
In-Reply-To: <20080205185617.732255000@andrew.endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Warasin wrote:

 > This patch adds the ebtables nflog watcher to the
 > kernel in order to allow ebtables log through the
 > nfnetlink_log backend.

This seems mostly fine to me. A few minor comments:

 > +#define EBT_NFLOG_PREFIX_SIZE 30

People found the 30 character limit to small for iptables,
which is why I increased it to 64 in NFLOG. For consistency
it would be better to use the same value here in my opinion.

 > +static struct ebt_watcher nflog = {

This could be __read_mostly.

If you'll resend the patch based on net-2.6.26 I'll queue it
if Bart has no objections.

