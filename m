From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libxt_sctp: Add translation to nft
Date: Wed, 2 Mar 2016 19:44:51 +0530
Message-ID: <CAKHNQQHaEwP1u0eSzjMnQ2Zc1heLLiHoSYJ+-i4-QP=qBuwzew@mail.gmail.com>
References: <20160301204056.GA18229@gmail.com> <20160302114826.GA3493@salvia> <20160302115453.GA4365@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38027 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbcCBOPd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 09:15:33 -0500
Received: by mail-wm0-f42.google.com with SMTP id l68so79765157wml.1
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Mar 2016 06:15:32 -0800 (PST)
In-Reply-To: <20160302115453.GA4365@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 2, 2016 at 5:24 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Mar 02, 2016 at 12:48:26PM +0100, Pablo Neira Ayuso wrote:
>> On Wed, Mar 02, 2016 at 02:10:56AM +0530, Shivani Bhardwaj wrote:
>> > Add translation for sctp to nftables.
>> > Full translation of this match awaits the support for --chunk-types
>> > option.
>>
>> Please, keep this documented in the wiki too so we remember there is a
>> partial translation for this.
>>
>> > Examples:
>> >
>> > $ sudo iptables-translate -A INPUT -p sctp --dport 80 -j DROP
>> > nft add rule ip filter INPUT sctp dport 80 counter drop
>> >
>> > $ sudo iptables-translate -A INPUT -p sctp ! --sport 80:100 -j ACCEPT
>> > nft add rule ip filter INPUT sctp sport != 80-100 counter accept
>>
>> Applied, thanks Shivani.
>
> Sorry, I have to keep this back.
>
> This crazy thing seems to be valid:
>
>         iptables -I INPUT -p sctp -m sctp
>
> and this will be translated as:
>
>         nft add rule filter INPUT ip protocol sctp sctp

dmesg shows me

x_tables: ip_tables: sctp match: only valid for protocol 132

means sctp match is valid for sctp protocol. There should not be an
sctp match (correct me if I am wrong here), should this be on
bugzilla?
