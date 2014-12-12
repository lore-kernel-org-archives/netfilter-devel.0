From: Patrick McHardy <kaber@trash.net>
Subject: Re: src: add redirect support
Date: Fri, 12 Dec 2014 17:27:03 +0000
Message-ID: <DB870481-09D6-4A54-BC23-1D0045ADEB5C@trash.net>
References: <20141212152929.GJ8013@acer.localdomain> <CAOkSjBg6GomwWz1z-9GK_Lw8ELTfXwrXkDTc7XsLrCwGSTAvRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63678 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbaLLR1M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:27:12 -0500
In-Reply-To: <CAOkSjBg6GomwWz1z-9GK_Lw8ELTfXwrXkDTc7XsLrCwGSTAvRQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 12. Dezember 2014 17:02:04 GMT+00:00, schrieb Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>:
>On 12 December 2014 at 16:29, Patrick McHardy <kaber@trash.net> wrote:
>> Looking at the redir bug report on netfilter-devel, I noticed some
>> odd syntax for the redir statement.
>>
>> The changelog states:
>>
>>   The syntax is:
>>
>>   % nft add rule nat prerouting redirect [port] [nat_flags]
>>
>> The actual syntax though is:
>>
>> redir_stmt_arg          :       COLON   expr
>>
>> What do we need that colon for? redirect by definition redirects to
>> the local host, the argument is always only a port expression.
>
>Yes, there is a inconsistency between the commit message and the code.
>My fault.
>
>I don't exactly remember where that syntax came from. I guess the
>colon was used in consistency with other nat-like expressions.
>Actually, I don't have a particular preference (the colon or not).
>
>Do you want me to change the syntax? I can do it this weekend. Just
>let me know :-)

Well, I don't think the colon is really bad, however it suggests an address can be put in front of it. I guess the reason is an ambiguity in the grammar with following expressions otherwise. Even though redirect is terminal the grammar so far doesn't know about it. From a readability POV I like a simple "to".

>If you are going to change it yourself, I would suggest to also update
>regression tests [0], which BTW seems broken due to the
>random-fully/fully-random change.

I missed that, will fix it up later.

>
>best regards.
>
>[0]
>http://git.netfilter.org/nftables/tree/tests/regression/ip/redirect.t



