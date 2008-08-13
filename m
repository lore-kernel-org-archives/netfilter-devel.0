From: Patrick McHardy <kaber@trash.net>
Subject: Re: physdev: remove extra space in output
Date: Wed, 13 Aug 2008 14:40:48 +0200
Message-ID: <48A2D650.4090008@trash.net>
References: <alpine.LNX.1.10.0808061732050.3527@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41262 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYHMMk5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:40:57 -0400
In-Reply-To: <alpine.LNX.1.10.0808061732050.3527@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> physdev: remove extra space in output
> 
> Just a cosmetic fix for `iptables -S` and `iptables-save` printing
> two spaces between arguments in the physdev match.

Applied, thanks.
