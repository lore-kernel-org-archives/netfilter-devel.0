From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] iptables: accept multiple IP address specifications
 for -s, -d
Date: Sat, 06 Jun 2009 08:53:20 +0200
Message-ID: <4A2A1260.7050207@netfilter.org>
References: <1244229955-27642-1-git-send-email-jengelh@medozas.de> <1244229955-27642-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50862 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZFFGyT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:54:19 -0400
In-Reply-To: <1244229955-27642-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Jan Engelhardt wrote:
> From: Michael Granzow <mgranzow@zeus.com>
> 
> libiptc already supports adding and deleting multiple rules with
> different addresses, so it only needs to be wired up to the options.
> 
> 	# ip6tables -I INPUT -s 2001:db8::d,2001:db8::e -j DROP
> 
> References: http://marc.info/?l=netfilter-devel&m=123929790719202&w=2

I think this is handy for users so I can find it useful.

The only concern that I have with this is that it changes the existing
1:1 mapping between commands and iptables rules. I mean, people may get
confused because of this "rule expansion" feature, they may think that
we natively support layer 3 address sets? Probably it's a matter of
documenting this.

I'd like to know what Patrick thinks about this anyway.

Just a minor nitpick:

> +Multiple addresses can be specified when, but this will \fBreplicate\fP the
                                       ^^^^
This sentence is incomplete? I suggest to refer to the rule expansion
feature.

> +rule (when adding with \-A), or will cause multiple rules to be
> +deleted (with \-D).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
