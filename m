From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: NF [PATCH 1/6] (borked it!) Use lowercase names for matches
Date: Tue, 27 Nov 2007 00:51:44 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711270050260.22369@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51471 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbXKZXvp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:51:45 -0500
In-Reply-To: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 27 2007 00:42, Jan Engelhardt wrote:
>@@ -63,17 +63,8 @@ config IP_NF_MATCH_IPRANGE
> 
> 	  To compile it as a module, choose M here.  If unsure, say N.
> 
>-config IP_NF_MATCH_TOS
>-	tristate "TOS match support"
>-	depends on IP_NF_IPTABLES
>-	help
>-	  TOS matching allows you to match packets based on the Type Of
>-	  Service fields of the IP packet.
>-
>-	  To compile it as a module, choose M here.  If unsure, say N.
>-

(quilt or pebkac, that is the question.)
