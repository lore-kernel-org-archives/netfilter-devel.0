From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] manpages: more fixes to minuses, hyphens, dashes
Date: Thu, 20 Aug 2009 17:15:56 +0200
Message-ID: <4A8D68AC.7050408@trash.net>
References: <1250780978-14013-1-git-send-email-jengelh@medozas.de> <1250780978-14013-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48607 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZHTPP6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:15:58 -0400
In-Reply-To: <1250780978-14013-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Debian still carries patches patches to the iptables nroff code touching
> ASCII minuses, so I thought, what's it this time.
> 
> Eventually, this patch tries to straighten things once more, per
> http://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style#Hyphens and
> http://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style#Dashes .
> 
> Titles will get the em dash; all typed commands or parameters with a
> hyphen get a minus (so that man(1) hyperlinking and copy-pasting does
> work), but other mentions get the hyphen.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Also applied, thanks a lot Jan.
