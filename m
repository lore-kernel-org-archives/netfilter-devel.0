From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter] 00/29 third try; git-format-patch|git-send-email
 sucks
Date: Wed, 26 Mar 2008 20:55:32 +0100
Message-ID: <47EAAA34.8060901@trash.net>
References: <alpine.LNX.1.10.0803251914060.2240@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38915 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbYCZTze (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 15:55:34 -0400
In-Reply-To: <alpine.LNX.1.10.0803251914060.2240@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> git@ cc'd for justice.
> 
> <rants>
> 
>  * `git-format-patch --stdout | git-send-email` does not fly,
>    files need to be exported first, it's a bit inconvenient
> 
>  * git-send-email should really default to --no-chain
> 
>  * git-send-email should stop if it cannot find the headers
>    it is looking for (esp. Subject), even if I dared to forget --dry-run
>    (point in case:  git log -1 mycommit >x.diff; git-send-email x.diff)
> 
> </rants>
> 
> And now some apology to the mailbomb caused by that program.


That was three failed attempts (last one went to netfilter instead
of netfilter-devel). Please try this on yourself or someone you
don't like next time :)


