From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: can libnetfilter_conntrack be used to write a userspace connection
 tracker?
Date: Wed, 12 Jan 2011 22:36:54 +0100
Message-ID: <4D2E1EF6.1010003@netfilter.org>
References: <AANLkTimfmoEKVWA_kBM-1DiuTR0=OG0Y8kC5nvq0G7G-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Sam Roberts <vieuxtech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36000 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab1ALVg7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 16:36:59 -0500
In-Reply-To: <AANLkTimfmoEKVWA_kBM-1DiuTR0=OG0Y8kC5nvq0G7G-@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/01/11 22:25, Sam Roberts wrote:
> I'm working on a connection tracker for a RPC-like protocol (over TCP).
> 
> I believe that by inspecting packets using nfqueue, and
> creating/destroying expectations using nfconntrack, I can do a
> connection tracker in user-space.
> 
> In order to remove nfqueue from the mix, I've been looking at the
> conntrack code, trying to figure out whether even notifications about
> connection status can include the TCP data that I need to inspect, the
> data that's in the skbs provided to kernel module conntrack helpers. I
> haven't been able to be certain what libnfconntrack can/cannot do, but
> it seems outside of the usage that the command line tools and
> conntrack daemon need, so I suspect its not possible.
> 
> Can somebody confirm my suspicions?

You can implement a user-space conntrack helper with NFQUEUE and
libnetfilter_conntrack:

http://people.netfilter.org/pablo/userspace-conntrack-helpers/

That's a proof-of-concept, ideally there would be a generic daemon so
you can develop your own plugins for state tracking upon it.

That daemon's on my TODO list.

You require Linux kernel >= 2.6.37
