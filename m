From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] xtables: deactivate intrapositional support
Date: Mon, 02 Nov 2009 17:17:58 +0100
Message-ID: <4AEF0636.6010604@trash.net>
References: <1256891969-18437-1-git-send-email-jengelh@medozas.de> <1256891969-18437-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Netfilter Core Team <coreteam@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54038 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbZKBQR6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:17:58 -0500
In-Reply-To: <1256891969-18437-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> In going to fix NF bug #611, "argv" would be needed in
> xtables_check_inverse to set "optarg" to the right spot in case of an
> intrapositional negation. Adding argv to the parameter list would
> cause an API change, which I would like to avoid because it is
> planned to be thrown out anyway.
> 
> So deactive intrapositional support now already, but leave the error
> message (which has already been there for two releases). Slightly
> adjust it, because some users have been wondering whether iptables
> or they are at "fault".

I'm worried that this is too early, two releases is not particulary
long and I'd expect a lot of people haven't noticed the warning yet,
especially on headless systems. Looking at bug #611, we've never
claimed "-ptcp" would be supported, so this hardly justifies the
risk IMO.

At least this needs more discussion, I'd like to hear a few more
opinions on this.


