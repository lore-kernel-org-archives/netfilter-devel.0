From: Ed W <lists@wildgooses.com>
Subject: Re: How to access conntrack connection expiration in a netfilter
 module?
Date: Wed, 03 Oct 2012 08:35:31 +0100
Message-ID: <506BEAC3.30103@wildgooses.com>
References: <506A084E.5060505@wildgooses.com> <20121002181747.GB2397@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:47152 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab2JCHfd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:35:33 -0400
In-Reply-To: <20121002181747.GB2397@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/10/2012 19:17, Pablo Neira Ayuso wrote:

> We used to have notifier call chains to deliver in-kernel
> nofitications to events. However, since it was overkill for just one
> single client (ctnetlink), we removed it and use a single hook
> function.
>
> The workaround is to dig into the history, find that code and forward
> port it.
>
> But I have to warn you that I won't take that patch into mainstream
> since there's only one single client in the official Linux kernel
> code, and external clients like that ndpi thing do not justify such
> change. Sorry.

Understood.  I have temporarily hacked in a crude second notifier 
variable, just about to test it.

However, it seems like a common requirement to want to be able to do 
some housekeeping in netfilter modules - what am I missing, how are 
other modules doing stuff like this?  Is there another technique which 
might be used?  Any other modules which do something similar that I 
could crib from, ie with some internal state augmenting a flow and then 
needing to cleanup sometime after the flow has gone away?

Thanks

Ed W
