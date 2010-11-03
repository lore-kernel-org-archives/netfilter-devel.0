From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: rules matching ipv6 prefix addrs
Date: Wed, 3 Nov 2010 13:32:42 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr>
References: <20101102.135254.226783976.davem@davemloft.net> <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pascal.mail@plouf.fr.eu.org, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47328 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab0KCMco (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 08:32:44 -0400
In-Reply-To: <20101103.051925.193703726.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-11-03 13:19, David Miller wrote:
>
>> What would be a use case ?
>
>I thought it was painfully obvious but...  the use case is setting up
>a rule that matches the prefix addresses and having such rules still
>work properly when the link flaps onto a link with a different prefix

A link moving to another link.. you lost me there.
Links usually don't move, packets do. Can you provide `ip addr`-style 
output of Before and After, to better see what's being meant?
