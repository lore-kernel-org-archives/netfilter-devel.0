From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables release
Date: Tue, 27 Nov 2007 19:57:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711271942330.20371@fbirervta.pbzchgretzou.qr>
References: <474C4B67.3000200@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <coreteam@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51469 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077AbXK0S5G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:57:06 -0500
In-Reply-To: <474C4B67.3000200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 27 2007 17:52, Patrick McHardy wrote:
>
> I have a large number of pending patches for iptables for new
> matches and targets. I'm not going apply patches for new things
> unless they are at least in a -rc kernel, so we have a chance to
> fix mistakes. So my question is whether we're ready to release
> the current iptables -rc anytime soon (before/when 2.6.24 is
> released) or whether we're more likely going to need until 2.6.25,
> in which case I would apply them now.
>
> Any opinions?

Apply now, make an rc2 (maybe?),
apply more gems (coming), target 2.6.25,
be done :-)
