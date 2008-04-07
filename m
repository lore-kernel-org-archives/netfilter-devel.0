From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 08/14] Add state option to NFLOG input plugin.
Date: Tue, 08 Apr 2008 01:56:52 +0200
Message-ID: <47FAB4C4.8050908@netfilter.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895233806-git-send-email-eric@inl.fr> <47F79683.8070801@netfilter.org> <20080405191512.GJ5333@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45196 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752167AbYDGX5J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:57:09 -0400
In-Reply-To: <20080405191512.GJ5333@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> On Saturday, 2008 April  5 at 17:10:59 +0200, Pablo Neira Ayuso wrote:
>> Eric Leblond wrote:
>>> This patch adds support for "state" option to the NFLOG plugin. For example, it
>>> can be used by another module to determine if the packet has been dropped,
>>> rejected or accepted.
>> What is the exact purpose of the "state" option? The use of the term
>> "state" for this seems to me a bit confusing as users may think that it
>>  is related with "stateful filtering". Please, develop the idea a bit more.
> 
> Hmm, you are quiet right, 'state' may be a bad choice. In fact, the idea is to
> be able to give a context relative to the logging. For example, I
> planned to use it with:
>  if state = 0 then packet has been dropped (typical -j NFLOG followed by -j DROP)
>  if state = 1 then this is -j NFLOG followed by -j ACCEPT
> With that usage choice, the word 'decision' would be better than 'state'.
> 
> I think other people may think to other usage. For example, it could be
> used to indicate the severity of the logged "attack". In this case, the
> 'decision' keyword is not really a good choice.

I see, however, why isn't --nflog-prefix enough to label the logs from
iptables?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
