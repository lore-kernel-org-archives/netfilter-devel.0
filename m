From: "Changli Gao" <xiaosuo@gmail.com>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't work
Date: Sat, 16 Aug 2008 08:38:58 +0800
Message-ID: <412e6f7f0808151738k3b03cafax900b01f45726051e@mail.gmail.com>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
	 <48A5CEFE.5090407@netfilter.org>
	 <alpine.LNX.1.10.0808151633500.10478@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0808152243280.20098@blackhole.kfki.hu>
	 <alpine.LNX.1.10.0808151743310.10478@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0808160037390.20328@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	"Pablo Neira Ayuso" <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:63773 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbYHPAjA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 20:39:00 -0400
Received: by ti-out-0910.google.com with SMTP id b6so498655tic.23
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2008 17:38:59 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0808160037390.20328@blackhole.kfki.hu>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 16, 2008 at 6:44 AM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Fri, 15 Aug 2008, Jan Engelhardt wrote:
>
>>
>> On Friday 2008-08-15 16:48, Jozsef Kadlecsik wrote:
>> >> - ecn and ECN
>> >
>> >The options of the ecn match and the ECN target are not clashing.
>>
>> They do. Both libipt_ecn.c and libipt_ECN.c have --ecn-ip-ect,
>> --ecn-tcp-cwr and --ecn-tcp-ece even if they are not documented
>> (what, more of these? Patch follows).
>
> Non-documented options do not exist ;-) - so updates are highly welcomed.
>
> But as the ECN options has not been documented so far, I think it'd be
> better to rename them at the same time to something like
>
> --ecn-tcp-cwr-remove
> --ecn-tcp-ece-remove
> --ecn-ip-ect-set
>
> and clashing with the ecn options were resolved.

It sounds a good idae. But in order to avoid clashing, we'd better
change all the options for all matches in this way:

match: foo
match-options: --foo-bar

I don't mean that some maches share the same options is encouraged,
but I don't think it lose readable, as I think most of people will
think the long options after a "-m" option until another match appears
with the leading "-m"  are all for this corresponding match. Global
option naming space allow commands like this:

iptables ... -m a --a-option-1 -m b --b-option-1 --a-option-2

Oh, I think it make the command unreadable, and we should not allow it happen.

I encountered this issue when I debugging a match. Its parse function
is like this:

parse(...)
{
        if (*flags)
                error...;
        switch (c) {
        case 'a':
                ....
                break;
        default:
                return 0;
        }
       *flags = 1;

        return 1;
}

it will fail if there is another kinds of match after it, as all the
options not belong to it are parsed to its parse function. I think it
is the reason why default branch in switch exists. I make things a
little different from my original thought.

When writting this, I get another idea to solve this. Before calling
the parse function, we should check if c is in the option range with
one line code:

c > m->option_offset && c < m->option_offset + OPTION_OFFSET

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
