From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: Mixed IPv4+IPv6 sets
Date: Tue, 8 Sep 2015 10:21:39 +0200
Message-ID: <CAOkSjBjvRbCufHSwOayAnVvgrwYwaijhXAsUfbLWqzu+1fBXxA@mail.gmail.com>
References: <55EC8B7F.4040303@gaast.net> <20150907185025.GB17921@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Wilmer van der Gaast <wilmer@gaast.net>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:32997 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbbIHIWA convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 04:22:00 -0400
Received: by lbcjc2 with SMTP id jc2so48965295lbc.0
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Sep 2015 01:21:58 -0700 (PDT)
In-Reply-To: <20150907185025.GB17921@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 7 September 2015 at 20:50, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> On Sun, Sep 06, 2015 at 07:52:47PM +0100, Wilmer van der Gaast wrote:
>> Hello,
>>
>> The "inet" family is a great idea for unifying IPv4 and IPv6
>> firewalling, but I just ran into one thing I'm missing.
>>
>> nft lets me define sets with both IPv4 and IPv6 addresses, but once
>> I try using them things go wrong - I assume this means that the
>> addresses aren't actually parsed until that point?
>>
>> I can invoke the set from an ip match, and it will complain about
>> IPv6 addresses in the list being invalid. And vice versa, invoke the
>> set from an "ip6" match and the IPv4 addresses will cause parse
>> errors.
>>
>> Would it be possible to either have an "inet" match rule, or tell
>> nft to skip unknown address families so I could just invoke the set
>> twice, once using "ip" and once using "ip6" match rule, without
>> running into syntax errors?
>>
>> I could of course just define two separate sets to get something
>> similar to my alternative idea, and maybe I'll try that, but it gets
>> kludgier that way. :-(
>
> Could you illustrate with examples what you would like to have and th=
e
> limitations you currently hitting?
>

I guess Wilmer is talking about multi-datatype sets (IPv4 and IPv6
mixed addresses). That would be a nice feature indeed.

@Wilmer: AFAIK thats not possible by now. It would require some
changes in the kernel.
Among other things, IPv4 and IPv6 addresses have different lengths. I
guess it would require a special syntax in userspace for the anon-set
case as well.

This seems to be the expected behaviour right now:

 # nft add rule inet filter input ip6 saddr @ipv4_set
<cmdline>:1:38-42: Error: datatype mismatch, expected IPv6 address,
set has type IPv4 address
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
