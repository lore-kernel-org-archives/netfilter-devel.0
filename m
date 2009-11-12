From: Luca Pesce <pesce.luca@gmail.com>
Subject: Re: How to register conntrack notifier
Date: Thu, 12 Nov 2009 11:52:27 +0100
Message-ID: <873dce860911120252x6b00c4c6n564e09a88c341c19@mail.gmail.com>
References: <894367326@web.de> <4AE835A7.7040400@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Nils Rennebarth <Nils.Rennebarth@web.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:47570 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZKLKwX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:52:23 -0500
Received: by fxm21 with SMTP id 21so2066498fxm.21
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2009 02:52:28 -0800 (PST)
In-Reply-To: <4AE835A7.7040400@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
   I was looking at conntrack events callbacks and conntrack tools too.
As you said in your mail, only one callback can be registered, so if
nf_conntrack_netlink module is loaded, no other modules can register a
callback for events.

If I correctly undertand the code, it seems that in the past kernels
this limitation was not there. For example, 2.6.21.5 version had a
notifier chain declared in nf_conntrack_ecache.c:

ATOMIC_NOTIFIER_HEAD(nf_conntrack_chain);

and nf_conntrack_register_notifier() simply adds an entry (callback
block) to the chain, so many callbacks could be registered for
conntrack events. Am I right?
Why has this been changed nowadays?

Thanks!
Luca


On Wed, Oct 28, 2009 at 1:14 PM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> Nils Rennebarth wrote:
>> Hi,
>>
>> The help text for NF_CONNTRACK_EVENTS reads:
>> =A0 If this option is enabled, the connection tracking code will
>> =A0 provide a notifier chain that can be used by other kernel code
>> =A0 to get notified about changes in the connection tracking state.
>> which sounds just like what I need: I want to execute a callback
>> whenever a conntrack gets destroyed. However studying
>> nf_conntrack_netlink.c, nf_conntrack_ecache.c and related header fil=
es
>> for quite a while now, i am still unable to figure out how to do tha=
t.
>>
>> Can someone enlighten me?
>
> You have to register a structure nf_ct_event_notifier with the callba=
ck
> function, you have to look at nf_conntrack_ecache.c and
> nf_conntrack_netlink.c. There one problem though since you can only
> register one callback and that one is usually used by nf_conntrack_ne=
tlink.c
>
> You can also catch events from user-space by means of
> libnetfilter_conntrack, have a look at utils/, it includes some examp=
les.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
