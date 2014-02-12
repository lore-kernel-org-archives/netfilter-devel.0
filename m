From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: Netfilter Extension Development Queries
Date: Wed, 12 Feb 2014 23:03:47 +0100
Message-ID: <52FBEFC3.1030706@chello.at>
References: <CAECcapiTOutsUuaukD7uzuXtLeJTmqua4jhzZFZZ735OQ+L9dA@mail.gmail.com>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Duncan Eastoe <duncaneastoe@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep12.mx.upcmail.net ([62.179.121.32]:34588 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaBLWC5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:02:57 -0500
In-Reply-To: <CAECcapiTOutsUuaukD7uzuXtLeJTmqua4jhzZFZZ735OQ+L9dA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11.02.2014 22:30, Duncan Eastoe wrote:
> Hello,
>
> I wish to build an extension that strips LSRR IPv4 Options from
> outgoing traffic and re-inserts it for inbound traffic. I've been
> given some pointers about how to approach this which are:
>      * A match extension which matches on the presence of LSRR options.
>      * A target extension, similar to NAT, that removes/reinserts the
> appropriate LSRR options.
>
> On the Netfilter Extensions HOWTO I have found a match extension by
> Fabrice Marie (http://www.netfilter.org/documentation/HOWTO/netfilter-extensions-HOWTO-3.html#ss3.6)
> which should already do what I want. There is also a target extension
> which strips all IP Options
> (http://www.netfilter.org/documentation/HOWTO/netfilter-extensions-HOWTO-4.html#ss4.2).
>
> I believe these extensions were in the deprecated Patch-O-Matic system
> (?) and this has been replaced by Xtables-addons which appears to
> contain an IP Options match extension but not a target extension?

Not that I'm a developer...
There's only TCPOPTSTRIP in main iptables.

>
> Also, regarding the switch to nftables from iptables. Will my approach
> listed above work with iptables and nftables or is a different
> approach required for nftables?

there is work in progress on a compat-layer:
http://git.netfilter.org/iptables-nftables/
which should transparently *translate* the syntax (if implemented in 
nftables).

Best regards

Mart
