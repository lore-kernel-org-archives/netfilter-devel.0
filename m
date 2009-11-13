From: Luca Pesce <pesce.luca@gmail.com>
Subject: Re: How to register conntrack notifier
Date: Fri, 13 Nov 2009 09:39:56 +0100
Message-ID: <873dce860911130039q2e0ecf38nfeaeaa8cd030cadc@mail.gmail.com>
References: <894367326@web.de> <4AE835A7.7040400@netfilter.org>
	 <873dce860911120252x6b00c4c6n564e09a88c341c19@mail.gmail.com>
	 <4AFBFC05.2000802@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Nils Rennebarth <Nils.Rennebarth@web.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59984 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbZKMIjw convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:39:52 -0500
Received: by bwz27 with SMTP id 27so3144454bwz.21
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2009 00:39:56 -0800 (PST)
In-Reply-To: <4AFBFC05.2000802@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ok, so newer kernels opted for performance, giving that on 99% of the
time only nf_conntrack_netlink uses event notifier callbacks, which is
usually the case...
But I am curious...what if another kernel module needs to receive
conntrack events? Are there any way to keep track of events in kernel
space while nf_conntrack_netlink is holding the one and only callback
hook?
Thanks Pablo!
Luca

On Thu, Nov 12, 2009 at 1:13 PM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> Luca Pesce wrote:
>>
>> Hi Pablo,
>> =A0 I was looking at conntrack events callbacks and conntrack tools =
too.
>> As you said in your mail, only one callback can be registered, so if
>> nf_conntrack_netlink module is loaded, no other modules can register=
 a
>> callback for events.
>>
>> If I correctly undertand the code, it seems that in the past kernels
>> this limitation was not there.
>
> Indeed. This limitation was introduced recently
>
>> For example, 2.6.21.5 version had a
>> notifier chain declared in nf_conntrack_ecache.c:
>>
>> ATOMIC_NOTIFIER_HEAD(nf_conntrack_chain);
>>
>> and nf_conntrack_register_notifier() simply adds an entry (callback
>> block) to the chain, so many callbacks could be registered for
>> conntrack events. Am I right?
>
> Yes.
>
>> Why has this been changed nowadays?
>
> Because the notifier chain added too much overhead for the only singl=
e
> client (nf_conntrack_netlink) in the kernel code.
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
