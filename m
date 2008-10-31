From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [Fwd: Re: Shortcuts to counting rules?]
Date: Fri, 31 Oct 2008 19:07:58 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr>
References: <490B46F0.4010100@hp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Rick Jones <rick.jones2@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47081 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYJaSH7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:07:59 -0400
In-Reply-To: <490B46F0.4010100@hp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2008-10-31 18:57, Rick Jones wrote:

> The end goal here is to teach netperf how to get a count of
> iptables rules in place in the kernel.  There was also a drifting
> question of whether or not strace should be taught about the
> getsockopt() options.

iptables-save | grep ^- | wc -l

And strace should not be taught that. We have seen at least one
change of the interpretation of the binary stream.
