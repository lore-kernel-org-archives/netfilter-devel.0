From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: security impact of creating rulesets with iptables (cmd)
Date: Mon, 10 Aug 2009 10:31:01 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908101016210.22371@fbirervta.pbzchgretzou.qr>
References: <4A7F431E.70706@gmail.com> <4A7FC50A.80608@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Christoph A." <casmls@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36125 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZHJIbB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:31:01 -0400
In-Reply-To: <4A7FC50A.80608@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-08-10 08:58, Patrick McHardy wrote:
>> 
>> The second and more interesting point is that this would also introduce
>> a timeframe where packets could slip through while these exchanges
>> between kernel and userspace are happening. Why does setting the policy
>> to DROP not solve this problem?
>
>This is not correct, the replacement is atomic.

(Elaborating on this.) The _replacement_ itself is indeed atomic,
the issue arises when a table is in place that allows something
that is later restricted again by a new table update.

1. iptables -A INPUT -p esp -j ACCEPT
2. echo 'Possibly open from here on...'
3. iptables -P FORWARD DROP
4. echo 'Now closed again'

Now if you have a large ruleset, and RT preemption, or lots of CPUs,
or an overly busy system, etc., it may take "longer than usual" until
step 3 is in effect.
