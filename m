From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: several messages
Date: Mon, 9 Feb 2009 22:04:40 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902092202020.25199@fbirervta.pbzchgretzou.qr>
References: <1234213032.20903.13.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36830 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZBIVEl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:04:41 -0500
In-Reply-To: <1234213032.20903.13.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-02-09 21:45, jamal wrote:
>
>Ok, I just synced with latest git. I will send you a few patches first.
>My path to resolving tc/ipt is to start with being able to take a basic
>useless program like:
>
>----------
>#include <xtables.h>
>int main(int argc, char **argv) {
>
>        return 0;
>}
>--------
>
>then compile and link with "gcc useless.c -lxtables -ldl"
>
>As it is right now i have to define in the minimal exit_error()

I do not think a library should call exit() and cause the main program 
to terminate; to this end it might be best to add a

	void (*exit_error)(..

function pointer to the xtables_global struct you are proposing.


>
>Here's the basic change.

If you could convert iptables.c and friends to also make use of this, 
that'd be great.
