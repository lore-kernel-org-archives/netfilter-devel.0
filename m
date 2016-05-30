From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: kernel 4.5.1 issue at system boot
Date: Mon, 30 May 2016 20:38:44 +0200
Message-ID: <CAOkSjBi9S3K=_c1ia9e1xoGRGx5JYMbDEfqzDahOWew7tUnHmA@mail.gmail.com>
References: <CAOkSjBh-P0RNKhNeR8fBmRVda7mtU9332punaUufO4Rx3aqpqA@mail.gmail.com>
 <CAOkSjBh--Ro9YzOdsTQsK6F73kPMdihjfU-tbyHc9gYN4gjOYA@mail.gmail.com>
 <20160523100811.GA9385@breakpoint.cc> <20160530172213.GA1349@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37644 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161301AbcE3SjG convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 14:39:06 -0400
Received: by mail-wm0-f51.google.com with SMTP id z87so80495610wmh.0
        for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:39:05 -0700 (PDT)
In-Reply-To: <20160530172213.GA1349@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30 May 2016 at 19:22, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, May 23, 2016 at 12:08:11PM +0200, Florian Westphal wrote:
>> Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
>> > On 23 May 2016 at 08:49, Arturo Borrero Gonzalez
>> > <arturo.borrero.glez@gmail.com> wrote:
>> > > This was in the log of my system boot today:
>> > >
>> >
>> > Probably more readable in this link:
>> >
>> > http://paste.debian.net/695904/
>>
>> This looks like an ABBA-style deadlock of
>> net_mutex and nfnl_lock(NFNL_SUBSYS_NFTABLES).
>
> @Arturo: Could you enable CONFIG_LOCKDEP and CONFIG_DEBUG_MUTEXES?
> this instrumention should provide a bit more information on the locks
> that are involved in the deadlock.
>
> Thanks.

I have been totally unable to reproduce the issue, I tried with
several boot configs and module-loading order, but no way.
I've not seen the issue to appear by itself neither, so I'm a bit
tempted to simply move on.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
