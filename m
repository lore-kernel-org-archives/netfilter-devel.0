From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Syntax errors in man and help regarding rulenum placement
Date: Fri, 20 Feb 2009 17:57:45 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902201755020.3426@fbirervta.pbzchgretzou.qr>
References: <gnmh9h$vt7$1@ger.gmane.org> <alpine.LSU.2.00.0902201640001.27281@fbirervta.pbzchgretzou.qr> <gnmn2j$mvh$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ralf <rm@amitrader.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48846 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZBTQ5r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:57:47 -0500
In-Reply-To: <gnmn2j$mvh$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-02-20 17:51, Ralf wrote:
>
> Hmm. Jan, I'm afraid there is more to fix because of the fact
> that rulenum is mostly optional...
> The main question here is: must rulenum come before OR after the chain?

>+"       %s -I chain [rulenum] rule-specification [options]\n"                 

As an exception to standard getopt practices, -I, and a few others,
can take two args (chain and rulenum). Given this knowledge,
it becomes obvious that the order is mandatory.

