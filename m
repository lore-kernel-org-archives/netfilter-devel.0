From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: xt_ecn, with descriptions
Date: Tue, 27 Dec 2011 20:33:53 +0100
Message-ID: <20111227193353.GA29207@1984>
References: <1325012273-11779-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49666 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab1L0Td6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 14:33:58 -0500
Content-Disposition: inline
In-Reply-To: <1325012273-11779-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 27, 2011 at 07:57:48PM +0100, Jan Engelhardt wrote:
> 
> The following changes since commit c5e1fd8ccae09f574d6f978c90c2b968ee29030c:
> 
>   Merge branch 'nf-next' of git://1984.lsi.us.es/net-next (2011-12-25 02:21:45 -0500)
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/linux xtecn
> 
> Jan Engelhardt (3):
>       netfilter: xtables: move ipt_ecn to xt_ecn
>       netfilter: xtables: give xt_ecn its own name
>       netfilter: xtables: collapse conditions in xt_ecn
> 
> Patrick McHardy (1):
>       netfilter: xtables: add an IPv6 capable version of the ECN match

Applied, thanks.

http://1984.lsi.us.es/git/net-next/

I'm compiling and testing this, I'll try to pass it to davem asap.
Let's see if we reach the merge window.
