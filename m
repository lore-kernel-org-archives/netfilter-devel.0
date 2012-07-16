From: Florian Westphal <fw@strlen.de>
Subject: Re: pgsql-ulogd2
Date: Mon, 16 Jul 2012 10:00:13 +0200
Message-ID: <20120716080013.GA522@breakpoint.cc>
References: <50002CEF.508@googlemail.com>
 <1342194935.11019.12.camel@tiger.regit.org>
 <50016D84.5080207@googlemail.com>
 <1342300959.6098.8.camel@tiger.regit.org>
 <5002B688.4070907@googlemail.com>
 <1342385528.8476.2.camel@tiger.regit.org>
 <500345F1.3050407@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56237 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab2GPIAP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:00:15 -0400
Content-Disposition: inline
In-Reply-To: <500345F1.3050407@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mr Dash Four <mr.dash.four@googlemail.com> wrote:
> The specific reason I raised this issue is because on the main
> firewall we have here, if I deploy ulogd2 and use NFCT at its
> present form, I will get the logs from all 7 interfaces, and it
> would make it an absolutely huge task to sift through all these logs
> and "match" the various entries (OK, doing it through the database
> will help up a bit, but not a lot).

Try something like
iptables -t raw -A PREROUTING (thingsyoudontwant) -j CT --ctevents related

(i don't think its possible to disable event delivery completely
 at the moment without disabling conntrack ).
