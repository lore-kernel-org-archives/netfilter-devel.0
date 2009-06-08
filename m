From: Patrick McHardy <kaber@trash.net>
Subject: Re: rfc: split libiptc linkage
Date: Mon, 08 Jun 2009 15:48:03 +0200
Message-ID: <4A2D1693.5020202@trash.net>
References: <alpine.LSU.2.00.0906052127170.28126@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36058 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbZFHNsB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:48:01 -0400
In-Reply-To: <alpine.LSU.2.00.0906052127170.28126@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> as a result of a user inquiry thread posted to nf-dev earlier I 
> produced this patch, but I am looking for some more justification to 
> merge it. With it, ip(4)tables would only load ip4tc, and ip6tables 
> only load ip6tc instead of both tools loading the current combined 
> file libiptc.so. Since the combo file is just 47 KB I wonder whether the 
> split is really worth the trouble.
> Opinions please.

I'd say let the user who requested it justify it :)

