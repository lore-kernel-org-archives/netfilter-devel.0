From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: introduce xtables global param struct
Date: Wed, 11 Feb 2009 18:17:40 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902111817200.26797@fbirervta.pbzchgretzou.qr>
References: <1234034911.4441.32.camel@dogo.mojatatu.com>  <alpine.LSU.2.00.0902111611140.20223@fbirervta.pbzchgretzou.qr> <1234371790.20903.98.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54334 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbZBKRRm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:17:42 -0500
In-Reply-To: <1234371790.20903.98.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-02-11 18:03, jamal wrote:
>
>> >+struct xtables_globals
>> >+{
>> >+	unsigned int option_offset;
>> >+	char *program_version;
>> >+	char *program_name;
>> >+	struct xtables_afinfo *afinfo;
>> >+	struct option *opts;
>> >+};
>> 
>> These should be const, esp. program_version and program_name.
>> I added myself a patch now.
>
>Ok, so you took care of this?
>
About the const - yes. (Since the patch itself was already applied.)
