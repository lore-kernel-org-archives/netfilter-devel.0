From: jamal <hadi@cyberus.ca>
Subject: Re: RFC: introduce xtables global param struct
Date: Wed, 11 Feb 2009 12:03:10 -0500
Message-ID: <1234371790.20903.98.camel@dogo.mojatatu.com>
References: <1234034911.4441.32.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0902111611140.20223@fbirervta.pbzchgretzou.qr>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:3233 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbZBKRFJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:05:09 -0500
Received: by ey-out-2122.google.com with SMTP id 25so34549eya.37
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2009 09:05:06 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0902111611140.20223@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2009-02-11 at 16:13 +0100, Jan Engelhardt wrote:
> On Saturday 2009-02-07 20:28, jamal wrote:

> Please post patch inline. I otherwise need to save them
> and reinsert them into alpine..

I have problems with my client  with insertion of whitespaces if 
i do that. I will send the next one inlined and see if Patrick 
complains when applying.

> >+struct xtables_globals
> >+{
> >+	unsigned int option_offset;
> >+	char *program_version;
> >+	char *program_name;
> >+	struct xtables_afinfo *afinfo;
> >+	struct option *opts;
> >+};
> 
> These should be const, esp. program_version and program_name.
> I added myself a patch now.

Ok, so you took care of this?

cheers,
jamal

