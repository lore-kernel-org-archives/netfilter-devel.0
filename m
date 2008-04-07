From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 02/14] Suppress ip_as_string configuration	variable.
Date: Tue, 08 Apr 2008 01:50:58 +0200
Message-ID: <47FAB362.5090803@netfilter.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895222096-git-send-email-eric@inl.fr> <47F7952C.1030005@netfilter.org> <20080405190042.GH5333@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43420 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753245AbYDGXvI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:51:08 -0400
In-Reply-To: <20080405190042.GH5333@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Saturday, 2008 April  5 at 17:05:16 +0200, Pablo Neira Ayuso wrote:
>> Eric Leblond wrote:
>>> This patch suppress a now unused option. Each database module
>>> have now to be used with a defined IP storage type.
>> As far as I can remember, this parameter was introduced because some
>> sysadmins queried the sql database directly to look for certain IPs. I
>> know that this isn't good for performance but it has some clients in
>> ulogd 1.x.
>>
>> Does mysql have something like the PgSQL's inet type? 
> 
> No, there is no advanced types in MySQL.
> 
>> Looking at the
>> database definitions, we are storing the IPs in binary format in mysql
>> and in inet type in PgSQL. Does this mean that there's no replacement
>> for the ip_as_string in mysql?
> 
> I think it could be achieved by working on a VIEW which could display
> the binary field in IP string format. An other solution could be to
> provide two database schemas (as it was before).

I prefer the view option.

> In any cases, it is not related to ulogd C code: the list of keys (with
> their associated type) is given by the content of a table. Thus, there
> is no need for the option ip_as_string.

OK. Applied, thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
