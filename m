From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables nfacct match question
Date: Tue, 26 Feb 2013 22:47:07 +0100
Message-ID: <20130226214707.GA3555@localhost>
References: <51292D41.8000703@googlemail.com>
 <20130225154848.GA20609@localhost>
 <512BC79F.1070708@googlemail.com>
 <20130226135529.GA9526@localhost>
 <512D0BA4.7060809@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:57911 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757513Ab3BZVrR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:47:17 -0500
Content-Disposition: inline
In-Reply-To: <512D0BA4.7060809@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 26, 2013 at 07:23:16PM +0000, Michael Zintakis wrote:
[...]
> Different types of traffic, by their very nature, have different
> volume requirements. At the "low" end, we have DNS and
> authentication-type traffic (think RADIUS for example), where the
> denomination needs to be pretty "low" - in KiB or even "plain bytes"
> range.

I see. Then my new proposal is to add a new automagic function to
round the output to the most expressive measure, would be somehow
similar to xtables_print_num:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=blob;f=libxtables/xtables.c;h=009ab9115f6fd687a762a2552f89ac0b81ee1a42;hb=HEAD#l1915

Would that fit into your needs?

Regards.
