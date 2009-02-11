From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: introduce xtables global param struct
Date: Wed, 11 Feb 2009 16:13:59 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902111611140.20223@fbirervta.pbzchgretzou.qr>
References: <1234034911.4441.32.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59472 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZBKPOB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:14:01 -0500
In-Reply-To: <1234034911.4441.32.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-02-07 20:28, jamal wrote:
>
>I would like to introduce this new struct so as to pass 
>localize the globals used and help in symbol renames. 

Please post patch inline. I otherwise need to save them
and reinsert them into alpine..

>xtables_set_params() is intended to free xtables from depending
>(as it does right now) on existence of such externally definitions
>(from iptables/iptables6 etc).
> 
>Ive included a sample user - xtables_free_opts() to show
>how i plan to use it.
>
>Let me know what you think before i proceed since i am going
>to be using this approach as a basis for other changes.
>
>cheers,
>jamal
>

>+struct xtables_globals
>+{
>+	unsigned int option_offset;
>+	char *program_version;
>+	char *program_name;
>+	struct xtables_afinfo *afinfo;
>+	struct option *opts;
>+};

These should be const, esp. program_version and program_name.
I added myself a patch now.
