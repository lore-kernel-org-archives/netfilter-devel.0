From: John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH 0/2] Security improvements for xt_SYSRQ
Date: Fri, 24 Jun 2011 14:30:17 +0100
Message-ID: <4E049169.9050805@oracle.com>
References: <cover.1308920081.git.john.haxby@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, prarit@redhat.com
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:42884 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab1FXNa3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:30:29 -0400
In-Reply-To: <cover.1308920081.git.john.haxby@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24/06/11 14:14, John Haxby wrote:
> These two patches are something I promised a long time ago and never
> actually got around to.
> [snip]

I'd like to ask, again, if we can include these upstream.

Last time I asked, Patrick McHardy not unreasonably suggested that
rather than being part of iptables (xtables) this would be better as a
standalone module.   This seemed like a good idea: putting the sysrq
handler in an encapsulation socket gets it running in BH context so that
it even works when the machine is mostly wedged and you can still use
iptables for filtering to protect the destination address and port.

This worked beautifully until I tried to extend it to cover IPv6: IPv6
doesn't have an encapsulation socket (and probably shouldn't have).  I
really don't want to provide an IPv4-only solution: that won't even work
today in some environments and it will certainly look rather lame before
long.

So can we have xt_SYSRQ upstream please?  Pretty please? :-)

jch
