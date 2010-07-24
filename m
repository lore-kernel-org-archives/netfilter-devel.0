From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC 0/4] nfnetlink_queue bypass queue to userspace X bytes of
 connection
Date: Sat, 24 Jul 2010 20:26:39 +0200
Message-ID: <4C4B305F.2070005@netfilter.org>
References: <1279986285-11665-1-git-send-email-karl@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Karl Hiramoto <karl@hiramoto.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51821 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757Ab0GXS0r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 14:26:47 -0400
In-Reply-To: <1279986285-11665-1-git-send-email-karl@hiramoto.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24/07/10 17:44, Karl Hiramoto wrote:
> Hi, I'm working on a nf_queue based HTTP filter. Sometimes I want to
> NF_ACCEPT X bytes of a connection. In a HTTP connection its part of the
> Content-Length.  Being able to directly NF_ACCEPT large parts of a connection
> is a 2X to 3X speedup, by not queuing these packets to user-space.

I think that you could avoid this extensions by means of conntrack marks
and the string match. Could you elaborate your application, please?
