From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] manpage: fix lintian warnings
Date: Thu, 20 Aug 2009 17:14:48 +0200
Message-ID: <4A8D6868.4010106@trash.net>
References: <1250780978-14013-1-git-send-email-jengelh@medozas.de> <1250780978-14013-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48590 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZHTPOu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:14:50 -0400
In-Reply-To: <1250780978-14013-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> From: Laurence J. Lane <ljlane@debian.org>
> 
> Description: extraneous slash caused this lintian warning:
>   W: iptables: manpage-has-errors-from-man usr/share/man/man8/iptables.8.gz
>      220: cannot use newline as a starting delimiter
>   W: iptables: manpage-has-errors-from-man usr/share/man/man8/ip6tables.8.gz
>      1823: warning: `precedence'' not defined
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Applied, thanks.
