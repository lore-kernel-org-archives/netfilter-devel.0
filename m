From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [RFC nftables PATCH] nft: add bash completion script
Date: Tue, 16 Feb 2016 14:00:17 +0100
Message-ID: <CAFpD06Q_eVk6xPeQH6GVrsHVNQCdXKvuCh-5T3Wi_sHK3tmQrQ@mail.gmail.com>
References: <1454691182-6573-1-git-send-email-giuseppelng@gmail.com>
	<20160215195601.GA8938@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:33216 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbcBPNAT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 08:00:19 -0500
Received: by mail-wm0-f49.google.com with SMTP id g62so190501348wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 05:00:18 -0800 (PST)
In-Reply-To: <20160215195601.GA8938@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2016-02-15 20:56 GMT+01:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> Hi Giuseppe,
>
> On Fri, Feb 05, 2016 at 05:53:02PM +0100, Giuseppe Longo wrote:
>> The following patch adds a bash completion script
>> which permits to complete nft commands.
>>
>> To install it:
>> - cp files/nft-completion /etc/bash_completion.d/
>> - . /etc/bash_completion.d/nft-completion
>>
>> The following commands are supported:
>> - nft add table <family> <name>
>> - nft list table <family> <name>
>> - nft list tables
>> - nft list sets
>> - nft list chains
>> - nft list ruleset
>> - nft list set <table> <name>
>> - nft add set <table> <name>
>> - nft add element <table> <set>
>> - nft add map <table>
>> - nft flush table <family> <table>
>>
>> Most probably this won't work with sudo, since there
>> are some nft commands into the script.
>>
>> A second patch to add completion in interactive mode
>> will come.
>>
>> This is only a draft,
>> any feedback is appreciated.
>
> Could you explore adding code to inquire the parser on the next
> possible tokens ahead? That would greatly simplify the shell script
> for bash autocompletion. We should be able to reuse this from
> libreadline too.
>
> I know what I'm asking is a bit more difficult, but it would help us
> reduce the amount of code duplication and will reduce the maintainance
> burden.
>
> Let us know, thanks!

Sure, I've looked quickly at bison doc and thought the following idea:
We can add a new nft command like "nft complete" to inquire the parser,
which will print all the possible word since we have a parse tree.

in that way, the bash script will be able to complete the command.

Also, do you confirm that we will skip objects like tables name, chain
name, and so on?

Thanks.
