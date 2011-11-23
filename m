From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RAW netfilter - "advanced netfilter setting" or not?
Date: Wed, 23 Nov 2011 12:17:38 -0800
Message-ID: <CA+55aFxy5iojY8AZfK+fK_OURLPsD_8Y6z9FXnHt88jYFMrimg@mail.gmail.com>
References: <CA+55aFxtSgLppJQ8EbQEovdXsCNxQ1gT31FyP2cpyuvoBLajZw@mail.gmail.com>
 <4ECD5069.4090106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: David Miller <davem@davemloft.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62139 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1KWU0J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:26:09 -0500
In-Reply-To: <4ECD5069.4090106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 23, 2011 at 11:58 AM, Patrick McHardy <kaber@trash.net> wrote:
>
> Most likely they're using NOTRACK to avoid connection tracking for
> some traffic. Could you post the output of "iptables -t raw -vxnL"?

Hmm. That's actually empty for me. I only went by some error messages
during bootup. Or maybe I should boot the distro kernel to see that
there isn't something else I'm missing that makes the user setup
unhappy.

                     Linus
