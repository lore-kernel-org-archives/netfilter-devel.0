From: Patrick McHardy <kaber@trash.net>
Subject: Re: multi-icmp-type extension, similar to multiport
Date: Mon, 25 Oct 2010 22:41:41 +0200
Message-ID: <4CC5EB85.4040908@trash.net>
References: <COL119-W40BEB1A4ECA9AE06A64289F55D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Regid Ichira <regid.i@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53560 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab0JYUlo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:41:44 -0400
In-Reply-To: <COL119-W40BEB1A4ECA9AE06A64289F55D0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 21.10.2010 17:51, schrieb Regid Ichira:
> 
>   Is there an extension to allow the specification of multiple ICMP type,
> similar to multiport?  If not, is it just because no one wrote it?

Nothing like this exists currently, however if you write something like
this, please add it as a new revision to the existing ICMP match.
