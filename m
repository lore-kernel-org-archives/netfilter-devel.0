From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: How to register conntrack notifier
Date: Thu, 12 Nov 2009 13:13:57 +0100
Message-ID: <4AFBFC05.2000802@netfilter.org>
References: <894367326@web.de> <4AE835A7.7040400@netfilter.org> <873dce860911120252x6b00c4c6n564e09a88c341c19@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Nils Rennebarth <Nils.Rennebarth@web.de>,
	netfilter-devel@vger.kernel.org
To: Luca Pesce <pesce.luca@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32899 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZKLLzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:55:07 -0500
In-Reply-To: <873dce860911120252x6b00c4c6n564e09a88c341c19@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Luca Pesce wrote:
> Hi Pablo,
>    I was looking at conntrack events callbacks and conntrack tools too.
> As you said in your mail, only one callback can be registered, so if
> nf_conntrack_netlink module is loaded, no other modules can register a
> callback for events.
> 
> If I correctly undertand the code, it seems that in the past kernels
> this limitation was not there.

Indeed. This limitation was introduced recently

> For example, 2.6.21.5 version had a
> notifier chain declared in nf_conntrack_ecache.c:
> 
> ATOMIC_NOTIFIER_HEAD(nf_conntrack_chain);
> 
> and nf_conntrack_register_notifier() simply adds an entry (callback
> block) to the chain, so many callbacks could be registered for
> conntrack events. Am I right?

Yes.

> Why has this been changed nowadays?

Because the notifier chain added too much overhead for the only single 
client (nf_conntrack_netlink) in the kernel code.
