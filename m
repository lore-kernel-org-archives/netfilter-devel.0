From: jamal <hadi@cyberus.ca>
Subject: Re: [PATCH] libxtables: Add exit_error cb to xtables_globals
Date: Wed, 11 Feb 2009 12:13:08 -0500
Message-ID: <1234372388.20903.108.camel@dogo.mojatatu.com>
References: <1234236584.20903.31.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0902111618170.20223@fbirervta.pbzchgretzou.qr>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:13418 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbZBKRPE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:15:04 -0500
Received: by ey-out-2122.google.com with SMTP id 25so35078eya.37
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2009 09:15:02 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0902111618170.20223@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2009-02-11 at 16:19 +0100, Jan Engelhardt wrote:
> On Tuesday 2009-02-10 04:29, jamal wrote:

> > 
> >+struct xtables_globals
> >+{
> >+	unsigned int option_offset;
> >+	char *program_version;
> >+	char *program_name;
> >+	struct option *opts;
> >+	void (*exit_error)(enum xtables_exittype status, const char *msg, ...);
> >+};
> >+
> 
> Why move the struct now.. makes it harder to figure out what changed.
> So right, exit_error.

Right (because of xtables_exittype)

> > #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
> > #endif
> > 
> >-struct xtables_globals *xt_params;
> >+struct xtables_globals *xt_params = NULL;
> 
> Do not initialize static members - this takes up extra space
> and adds no benefit. (zeroed anyway even in .bss)

Ok. Do i need to regenerate the patch or send on top?


> When is basic_exit_error invoked? In this patch alone, the users
> are missing (or the #define).

tc/m_xt.c was at this point - but not any of the native iptables apps.
Later on patches iptables-xml uses the basic_exit_error() as well

cheers,
jamal

