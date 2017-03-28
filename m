From: Gargi Sharma <gs051095@gmail.com>
Subject: Re: [RFC] extensions: libxt_TOS: Add translation to nft
Date: Tue, 28 Mar 2017 22:53:05 +0530
Message-ID: <CAOCi2DFLTJ=UvnsWep7c4vtMtBJZB=iZQzUJ35iVVX+CBaD2GQ@mail.gmail.com>
References: <1490715972-30517-1-git-send-email-gs051095@gmail.com> <20170328155207.GA18679@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: gsoc2013@lists.netfilter.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:35486 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753290AbdC1RYB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 13:24:01 -0400
Received: by mail-it0-f46.google.com with SMTP id y18so121944787itc.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 10:23:55 -0700 (PDT)
In-Reply-To: <20170328155207.GA18679@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 28, 2017 at 9:22 PM, Florian Westphal <fw@strlen.de> wrote:
> Gargi Sharma <gs051095@gmail.com> wrote:
>> Add translation for TOS to nftables.
>>
>> Examples:
>>
>> $ iptables-translate -t mangle -A PREROUTING -p TCP --dport 22 -j TOS --set-tos 0x10
>> nft add rule ip mangle PREROUTING tcp dport 22 counter --set-tos 0x10/0xff
>>
>> $ iptables-translate -A PREROUTING -t mangle -p tcp --sport ftp-data -j TOS --set-tos 0x02/0x10
>> nft add rule ip mangle PREROUTING tcp sport 20 counter --set-tos 0x02/0x10
>
> You did not test this :-/
>
Sorry! I realised this after sending this patch.

> nft add rule ip mangle PREROUTING tcp sport 20 counter --set-tos 0x02/0x10
> nft: unrecognized option '--set-tos'
>
> besides, there is no TOS support in nftables.
> Please look at xt_DSCP.c and the xlate function there.
>
>From what I gather, the first 6 bits are used for DSCP and the last 2 for ecn.
Should I write both dscp and ecn equivalent for the TOS specified?

Thanks,
Gargi
> You could rewrite -j TOS iptables rules to their corresponding dscp
> eqivalent in some cases at least.
