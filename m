From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 06/14] MAC address handling in MySQL output	plugin.
Date: Tue, 08 Apr 2008 01:52:41 +0200
Message-ID: <47FAB3C9.4040206@netfilter.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895234125-git-send-email-eric@inl.fr> <47F79203.2040301@netfilter.org> <20080405190358.GI5333@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pchifflier@inl.fr
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43891 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753674AbYDGXwt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:52:49 -0400
In-Reply-To: <20080405190358.GI5333@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Saturday, 2008 April  5 at 16:51:47 +0200, Pablo Neira Ayuso wrote:
>> Eric Leblond wrote:
>>> This patch adds MAC address handling to the MySQL output plugin.
>> Applied. Thanks. Please, next time also include in the description that
>> you have deleted the mac_saddr field (I assume that it makes sense since
>> it does not provide any useful information for the logging purposes)
>>
>> BTW, we have to freeze changes in the databases before the final
>> release, otherwise we'll have to include upgrade scripts to convert the
>> database from version X to Y as it happens to other apps (like
>> bugzilla). I know that this would happen sooner or later if we have to
>> add features but still introducing such kind of scripts would be really
>> a pain. I don't think that we should go that way.
> 
> Pierre Chifflier and I will soon start working on improving the SQL schemas.
> Some things remind to be done on them before freezing.

Great. Wait for your news. I'll also have a look at it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
