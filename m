From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH v2] extensions: libxt_mark: Add translation to nft
Date: Sun, 20 Dec 2015 01:06:33 +0530
Message-ID: <CAKHNQQEPML7UN+0+tE0pzAvr2GRRdAOi61q8b1TDvYZVYLM7xw@mail.gmail.com>
References: <20151206033214.GA5939@gmail.com> <20151209132600.GA29450@salvia>
 <CAKHNQQF3XFhMJaoi8gBLOeGTLJjxncPQ-s9Tke3nC0FNoGVJjg@mail.gmail.com>
 <CAKHNQQEtTZ0Hg57VcgrOTaFZww-3T8nc8+P1WFq5Ms4Ap2qmbg@mail.gmail.com>
 <CAKHNQQGSbN8QQru8PB9GntbGGBKLT7v3VRYnjhEObshs7qKPcg@mail.gmail.com>
 <20151218214013.GA26438@salvia> <CAKHNQQGcET7S+RJENLs+p5zwCe4Xd8FdmJTCT5E-16zjD_PNqw@mail.gmail.com>
 <20151219174720.GA1421@salvia> <CAKHNQQGddf+RKXceY6X_wWHv5Nok10FRw2bZUA044kaOyt15RQ@mail.gmail.com>
 <CAKHNQQE+_cy2d59ro-Uth0Lkr8U3DK-ovcYjOXja_Z4_Di1mvw@mail.gmail.com> <20151219183443.GA2170@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:33412 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbbLSTgy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2015 14:36:54 -0500
Received: by mail-wm0-f42.google.com with SMTP id p187so24209266wmp.0
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 11:36:53 -0800 (PST)
In-Reply-To: <20151219183443.GA2170@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 20, 2015 at 12:04 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Dec 19, 2015 at 11:51:14PM +0530, Shivani Bhardwaj wrote:
>> On Sat, Dec 19, 2015 at 11:41 PM, Shivani Bhardwaj
>> <shivanib134@gmail.com> wrote:
>> > On Sat, Dec 19, 2015 at 11:17 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> >> On Sat, Dec 19, 2015 at 07:56:56PM +0530, Shivani Bhardwaj wrote:
>> >>> On Sat, Dec 19, 2015 at 3:10 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> >>> > But, anyway after applying you patch I can see:
>> >>> >
>> >>> > # iptables-translate -I INPUT -m mark --mark 10
>> >>> > nft insert rule ip filter INPUT ct mark  & xa counter
>> >>> >
>> >>> > So this kind of work already.
>> >>> >
>> >>>
>> >>> Hi,
>> >>>
>> >>> I just tried adding this rule to nft. It does not work. It only works
>> >>> for integer values of mark. nft shows syntax error for ampersand and
>> >>> hex values.
>> >>>
>> >>> Isn't there something wrong? Please let me know.
>> >>
>> >> The line above should be:
>> >>
>> >> nft insert rule ip filter INPUT ct mark & 0xa counter
>> >>
>> >
>>
>> Ampersand again causes syntax error. However, it works fine as below:
>>
>> nft insert rule ip filter INPUT ct mark 0xa counter
>
> Yes, that is fine as I indicated in a previous email.

Thank you.
Could you please tell why ct mark and not simply mark?
