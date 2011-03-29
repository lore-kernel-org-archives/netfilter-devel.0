From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: ctnetlink kernel dump while running multiple libnfct clients
Date: Tue, 29 Mar 2011 15:44:25 -0700
Message-ID: <AANLkTi=9y=E3dfq3QZEUHcQ506uHb+VhsivB+Ot-QQgR@mail.gmail.com>
References: <AANLkTi=17VZ6Sjgj57LTa-xcJj00BSjv_-4DveiutNo1@mail.gmail.com>
	<4D908351.5010407@netfilter.org>
	<AANLkTi=LNMqTMf34OnjP3rgp5hrw=bLgrdZneZ4cyffi@mail.gmail.com>
	<4D91B083.2000001@netfilter.org>
	<AANLkTi=XfknKE9RkiohtW4+xzpAe2CGY1JDg7_JtfSUG@mail.gmail.com>
	<4D925614.2000909@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47919 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1C2Wo0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:44:26 -0400
Received: by vxi39 with SMTP id 39so587393vxi.19
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2011 15:44:26 -0700 (PDT)
In-Reply-To: <4D925614.2000909@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 29, 2011 at 2:58 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On 29/03/11 20:52, Sam Roberts wrote:
>> Even if that happened, why would that helper have a NULL name?
>
> My guess is that this is not related to the backtrace that you sent, the
> problem must be elsewhere.

> I never used the user-space expectations with permanency.

The version running when the kernel died didn't set permanent: the output shows
no sign of a helper associating with my userspace expectations.

>>> Please, send me the code so I can reproduce the problem here.

For what its worth, my prototype is here:

https://github.com/sam-github/libnet/blob/master/lua/echoconntracker
https://github.com/sam-github/libnet/blob/master/lua/echoserver
https://github.com/sam-github/libnet/blob/master/lua/echoclient

You have to build the whole libnet (and yes, this code has nothing to
do with libnet, and I'll rip it out somewhere else RSN).

>> Its not reproduceable, it seems more like a race condition leaving
>> pointers in an undefined state. Maybe printing of expectations while
>> expectations are being created/destroyed?
>
> Let me check this.

When this happened, I was running the prototype conntracker, and
several instances of conntrack -E (for each table). I typed a
conntrack -L command, and the kernel died after I hit ENTER. Could be
unrelated to that, but seems suspiciously coincidental that the
backtrace shown reflects something I did (it looks related to printing
conntracks). Still, you would know better than me what the kernel does
when things go wrong.

Thanks,
Sam
