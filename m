From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables logging
Date: Thu, 15 Nov 2007 22:16:47 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711152215190.3340@fbirervta.pbzchgretzou.qr>
References: <473CAC9E.6060109@seclark.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stephen Clark <Stephen.Clark@seclark.us>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41329 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062AbXKOVQt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:16:49 -0500
In-Reply-To: <473CAC9E.6060109@seclark.us>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 15 2007 15:31, Stephen Clark wrote:
>
> Hello,
>
> Is there a way to have iptables LOG using a facility other than "kern".
> I would like to
> segregate out the messages from iptables into a file separate from
> /var/log/messages.
>
> Any advice would be appreciated.

You should use syslog-ng, which allows text matching and filtering.
This is from a regular openSUSE install:

	filter f_iptables   { facility(kern) and match("IN=") and match("OUT="); };

Or, you can use the ULOG target together with ulogd2.

