From: Patrick McHardy <kaber@trash.net>
Subject: Re: 1/7 [NETFILTER]: Use unsigned types for hooknum and pf vars
Date: Thu, 04 Sep 2008 16:34:18 +0200
Message-ID: <48BFF1EA.2030702@trash.net>
References: <alpine.LNX.1.10.0808131925160.13154@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62980 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYIDOeU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:34:20 -0400
In-Reply-To: <alpine.LNX.1.10.0808131925160.13154@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> [NETFILTER]: Use unsigned types for hooknum and pf vars
> 
> and (try to) consistently use u_int8_t for the L3 family.

Applied, thanks.
