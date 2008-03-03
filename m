From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_TARPIT update for 2.6.24
Date: Mon, 3 Mar 2008 12:25:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803031224260.27717@fbirervta.pbzchgretzou.qr>
References: <20080303112105.b6qnh5a2byk5lbq7@m.safari.iki.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel Mailing List <netfilter-devel@vger.kernel.org>
To: Sami Farin <safari-netfilter@safari.iki.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38986 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbYCCLZt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:25:49 -0500
In-Reply-To: <20080303112105.b6qnh5a2byk5lbq7@m.safari.iki.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 3 2008 13:21, Sami Farin wrote:
>
>The version of xt_TARPIT which worked in 2.6.23, panics the kernel
>with 2.6.24.  Fix below.
>
>Current version of ipt_TARPIT.c in patch-o-matic-ng svn is dated
>20070524.  I do not know of other places where TARPIT module could
>be found.

TARPIT is already fixed up,
see the Xtables and Xtables-addons package from
http://dev.computergmbh.de/files/xtables/
