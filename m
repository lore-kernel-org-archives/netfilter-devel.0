From: Patrick McHardy <kaber@trash.net>
Subject: Re: pull request
Date: Thu, 12 Feb 2009 06:46:28 +0100
Message-ID: <4993B7B4.70901@trash.net>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de> <4993B3AC.1060707@trash.net> <alpine.LSU.2.00.0902120632140.32504@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40395 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZBLFqd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:46:33 -0500
In-Reply-To: <alpine.LSU.2.00.0902120632140.32504@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-02-12 06:29, Patrick McHardy wrote:
>> jengelh@medozas.de wrote:
>>> 13 files changed, 108 insertions(+), 182 deletions(-)
>> This diffstat I get looks quite different:
>>
>> 11 files changed, 73 insertions(+), 67 deletions(-)
>>
>> Any idea whats going on there?
>>
> 
> I used git diff --stat instead of whatever merge outputs.

That gives the same (different) output for me.

> $ git diff --stat nf/master..mdz/master
> [13 files, 108+, 182-]
> $ git rev-parse nf/master
> 8b7baebc93989106fd5d26b262d0ce191f8ef7c0
> $ git rev-parse mdz/master
> 47a6fd9ec9891a8040eb8fd6db3c5012c1056061

Well, it doesn't add up at all, even in those changelogs you posted
f.i. the xtables.c lines amount to something in the order of 30, not
over 100. The tree looks fine from a quick look, but I want to make
sure that what I'm pulling is indeed what you intended to send me.

I'll skip this pull, please send a new request (with or without Jamal's
patches, as you like) once you figured out where those differences are
coming from.
