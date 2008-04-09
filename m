From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnetfilter_queue and libnetfilter_conntrack API questions
Date: Wed, 09 Apr 2008 16:52:58 +0200
Message-ID: <47FCD84A.7030400@trash.net>
References: <47FCCD6C.6050409@gmail.com> <47FCD6AA.8030205@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Mader <thezema@gmail.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49601 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYDIOxF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:53:05 -0400
In-Reply-To: <47FCD6AA.8030205@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> The events do not include the ID, this is how it goes as for now.
> Actually I'm not a big fun of the ID.
> 
> @Patrick: I don't remember exactly the reason why we decided to keep the
> ID there, and if we have decided to do so, it seems inconsistent to me
> not to include it in the events.


I agree. I guess the reason why its not sent on events is that it
was originally only introduced (IIRC, I might be confusing it with
the ordered list on second thought) for dumps.

The reason why we kept it at all is that people are already using
it as unique identifier, we only changed the uniqueness to mean
"unique at any given point in time", but not over time. I guess
the logical thing to do would be to also include it in events.
I know some people are using patches to do this already.
