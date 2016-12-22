From: Tom Hacohen <tom@stosb.com>
Subject: Re: nftables: masquerade sets wrong source address
Date: Thu, 22 Dec 2016 22:40:34 +0000
Message-ID: <CAEvi_o8k-LYKD2QyvPnejHN9XVe7+N=xPNJutSFe4p4BKacMHQ@mail.gmail.com>
References: <CAEvi_o9_SJNGH-RWq6Kt+UiXVY4ozaMy3yJ2rPdV0Rbk1QrRZw@mail.gmail.com>
 <CAML_gOdZn8UmZzeDWd6q--U9+f+SzBLMppCEtdCFsZ4rrTZ24A@mail.gmail.com>
 <CAEvi_o-7soTh5vPqniCo76Szbf7J1y6nwwD-YqJ5uJvOYSeVHw@mail.gmail.com>
 <CAML_gOfxzY9iWefK8Vw8kxYXNmOrZBmouO=PfMxtyz4jfp=13g@mail.gmail.com>
 <CAEvi_o96hh=ZfkofcjswUEDeH1Pi6wGD99qV+k87B=Z+QM-78w@mail.gmail.com>
 <20161222103448.GA31504@breakpoint.cc> <CAEvi_o8wV5GNk8JvSg96kP3WdDsVsf8PubRe=K1ZiD2+nBaYTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Liping Zhang <zlpnobody@gmail.com>, netfilter@vger.kernel.org,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38279 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966025AbcLVWk4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2016 17:40:56 -0500
Received: by mail-wm0-f52.google.com with SMTP id k184so2280141wme.1
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2016 14:40:55 -0800 (PST)
In-Reply-To: <CAEvi_o8wV5GNk8JvSg96kP3WdDsVsf8PubRe=K1ZiD2+nBaYTg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 22, 2016 at 4:56 PM, Tom Hacohen <tom@stosb.com> wrote:
>
>
> On 22 Dec 2016 12:35, "Florian Westphal" <fw@strlen.de> wrote:
>
> Tom Hacohen <tom@stosb.com> wrote:
>> I'm sorry for repeating myself, however I'd like to stress out again,
>> that while your workaround fixes an inconsistency between iptables and
>> nftables, the scenario itself is caused by the buggy behaviour of
>> masquerade with "lo", and that needs to be fixed too. The workaround
>> above, and any fixes to that issue will only fix the dropping of the
>> packets, but the wrong rewrite will still be there.
>
> The 'wrong rewrite' also occurs with iptables.
>
> It doesn't cause connectivity issues because in iptables the nat table
> always registers the output hook.
>
> (I agree that nft masquerade should not cause these connectivity issues,
>  but I think proper ruleset fix is to use meta iif to restrict masq to
>  the correct interface(s)).
>
>
> Yes, iptables so misbehaves here. I know you agree about not causing the
> connectivity issues, but don't you agree that the wrong rewrite shouldn't
> happen? For both iptables and nftables?
>
> I already use oif to restrict the masquerade, I'm not trying to solve it for
> myself, because I already have a working workaround. I'm trying to help
> reporting and resolving a bug.
>
> --
> Tom

Resending as plain text.

Yes, iptables so misbehaves here. I know you agree about not causing
the connectivity issues, but don't you agree that the wrong rewrite
shouldn't happen? For both iptables and nftables?

I already use oif to restrict the masquerade, I'm not trying to solve
it for myself, because I already have a working workaround. I'm trying
to help reporting and resolving a bug.

--
Tom
