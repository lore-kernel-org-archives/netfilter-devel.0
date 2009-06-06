From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/3] iptables: accept multiple IP address specifications
 for -s, -d
Date: Sat, 6 Jun 2009 13:16:03 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906061314330.22992@fbirervta.pbzchgretzou.qr>
References: <1244229955-27642-1-git-send-email-jengelh@medozas.de> <1244229955-27642-2-git-send-email-jengelh@medozas.de> <4A2A1260.7050207@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42135 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZFFLQE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jun 2009 07:16:04 -0400
In-Reply-To: <4A2A1260.7050207@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-06-06 08:53, Pablo Neira Ayuso wrote:
>> 
>> 	# ip6tables -I INPUT -s 2001:db8::d,2001:db8::e -j DROP
>> 
>> References: http://marc.info/?l=netfilter-devel&m=123929790719202&w=2
>
>I think this is handy for users so I can find it useful.
>
>The only concern that I have with this is that it changes the existing
>1:1 mapping between commands and iptables rules. I mean, people may get
>confused because of this "rule expansion" feature, they may think that
>we natively support layer 3 address sets? Probably it's a matter of
>documenting this.

Hence:

>> +Multiple addresses can be specified when, but this will \fBreplicate\fP the
>                                       ^^^^
>This sentence is incomplete? I suggest to refer to the rule expansion
>feature.

Well, I think <b>replicate</b> hits the expansion pretty good.

>> +rule (when adding with \-A), or will cause multiple rules to be
>> +deleted (with \-D).

I'll remove the 'when' in a rebase.
