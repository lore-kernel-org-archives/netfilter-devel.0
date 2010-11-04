From: Patrick McHardy <kaber@trash.net>
Subject: Re: Can NFQUEUE accept/continue when there is no userspace listener
 registered ?
Date: Thu, 04 Nov 2010 05:37:54 +0100
Message-ID: <4CD238A2.8070900@trash.net>
References: <4CD22E08.2060300@netbauds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Darryl Miles <darryl-mailinglists@netbauds.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63410 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0KDEh4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 00:37:56 -0400
In-Reply-To: <4CD22E08.2060300@netbauds.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.11.2010 04:52, Darryl Miles wrote:
> Is there any mechanism which would allow additional options to NFQUEUE
> target to instruct the kernel what to do:
> 
>  --action-no-listener NF_ACCEPT|NF_DROP|CONTINUE  (with NF_DROP being
> the default)
>  --action-backlog-overflow NF_ACCEPT|NF_DROP|CONTINUE   (with NF_DROP
> being the default)

--action-no-listener is hard to do because the rule has no direct
connection to the queue and backend queueing mechanism and thus
it can't determine whether a listener exists. There's also currently
no way to propagate that information to the backend. Well, maybe
you could encode it in the verdict, similar to the queue number.

--action-backlog-overflow should be pretty easy to add to the
queueing backend itself (nfnetlink_queue), however when the packet
reaches the backend, it has already left the ruleset, so it won't
continue in the chain but instead continue as if a verdict of
NF_ACCEPT had been issued.

> Where CONTINUE would in effect ignore the existence of the "-j NFQUEUE"
> rule in the chain and continue to the next rule.  I guess this is
> possible if the packet never made it to user-space.
> 
> 
> Would there be any objections to providing a patch to kernel and
> userspace tooling to provide this configurable behavior ?   Is it
> obviously useful to others ?

Having the packet continue when the queue overflows has been requested
a couple of times for hung snort processes, so yes, this sounds useful.
If you can implement the no-listener feature in a reasonable way that
also sounds useful.
