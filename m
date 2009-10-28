From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: How to register conntrack notifier
Date: Wed, 28 Oct 2009 13:14:31 +0100
Message-ID: <4AE835A7.7040400@netfilter.org>
References: <894367326@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Nils Rennebarth <Nils.Rennebarth@web.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43436 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbZJ1MOa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Oct 2009 08:14:30 -0400
In-Reply-To: <894367326@web.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nils Rennebarth wrote:
> Hi,
> 
> The help text for NF_CONNTRACK_EVENTS reads:
>   If this option is enabled, the connection tracking code will
>   provide a notifier chain that can be used by other kernel code
>   to get notified about changes in the connection tracking state.
> which sounds just like what I need: I want to execute a callback
> whenever a conntrack gets destroyed. However studying
> nf_conntrack_netlink.c, nf_conntrack_ecache.c and related header files
> for quite a while now, i am still unable to figure out how to do that.
> 
> Can someone enlighten me?

You have to register a structure nf_ct_event_notifier with the callback
function, you have to look at nf_conntrack_ecache.c and
nf_conntrack_netlink.c. There one problem though since you can only
register one callback and that one is usually used by nf_conntrack_netlink.c

You can also catch events from user-space by means of
libnetfilter_conntrack, have a look at utils/, it includes some examples.
