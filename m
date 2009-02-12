From: Patrick McHardy <kaber@trash.net>
Subject: Re: 'nother pull request
Date: Thu, 12 Feb 2009 07:21:49 +0100
Message-ID: <4993BFFD.1040400@trash.net>
References: <1234419553-4147-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41039 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZBLGVz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:21:55 -0500
In-Reply-To: <1234419553-4147-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> And pull again (wasnot sure if you had seen the patches already),
> to receive some bugfixes I cooked in response
> to ljlane's request to peek at Debian bugs.
> 
> Jan Engelhardt (3):
>       libxtables: use const for vars holding literals
>       libxt_string: fix undefined behavior/incorrect patlen calculation
>       libxtables: flush before fork
> 
>  extensions/libxt_string.c |    4 +++-
>  include/xtables.h.in      |    3 +--
>  xtables.c                 |    6 ++++++
>  3 files changed, 10 insertions(+), 3 deletions(-)

Also pulled and pushed out, thanks.
