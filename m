From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_time 2007-09-22 (iptables)
Date: Sun, 23 Sep 2007 17:08:04 +0200
Message-ID: <46F68154.7070706@trash.net>
References: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709221326540.15712@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48315 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbXIWPQo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Sep 2007 11:16:44 -0400
In-Reply-To: <Pine.LNX.4.64.0709221326540.15712@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Add the libxt_time iptables match
> 
> This is libipt_time from POM-ng enhanced by the following:
> 
>  * day-of-month support (for example "match on the 15th of each month")
>  * inversion support for --weekdays and --monthdays
>  * match against UTC or local timezone
>  * a manpage
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>


Also applied, thanks Jan.
