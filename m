From: Patrick McHardy <kaber@trash.net>
Subject: Re: libiptc: remove typedef indirection
Date: Mon, 10 Nov 2008 17:00:00 +0100
Message-ID: <49185A80.5040108@trash.net>
References: <alpine.LNX.1.10.0811060933060.26551@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52044 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbYKJQAL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:00:11 -0500
In-Reply-To: <alpine.LNX.1.10.0811060933060.26551@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit ede2c549d4c8b35cec6b7eb5bbbaf95b40168ab0
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Nov 6 05:35:33 2008 +0100
> 
> libiptc: remove typedef indirection
> 
> Don't you hate it when iptc_handle_t *x actually is a double-indirection
> struct iptc_handle **? This also shows the broken constness model, since
> "const iptc_handle_t x" = "iptc_handle_t const x" =
> "struct iptc_handle *const x", which is like no const at all.
> Lots of things to do then.

Applied, thanks.
