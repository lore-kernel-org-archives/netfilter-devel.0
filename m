From: jamal <hadi@cyberus.ca>
Subject: Re: [PATCH] libxtables: define xtables_free_opts()
Date: Wed, 11 Feb 2009 12:08:01 -0500
Message-ID: <1234372081.20903.103.camel@dogo.mojatatu.com>
References: <1234213287.20903.19.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0902111615590.20223@fbirervta.pbzchgretzou.qr>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:12897 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410AbZBKRJ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:09:57 -0500
Received: by ey-out-2122.google.com with SMTP id 25so34836eya.37
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2009 09:09:55 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0902111615590.20223@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2009-02-11 at 16:17 +0100, Jan Engelhardt wrote:
> On Monday 2009-02-09 22:01, jamal wrote:

> 
> >+void xtables_free_opts(int reset_offset, struct option *original_opts)
> >+{
> >+	if (xt_params->opts != original_opts) {
> >+		if (original_opts) 
> >+			free(xt_params->opts);
> >+		xt_params->opts = original_opts;
> >+		if (reset_offset)
> >+			xt_params->option_offset = 0;
> >+	}
> >+}
> >+
> 
> While this may have been just moved from iptables.c or so
> (where? I do not see any deletions or conversions of code
> that is supposed to make use of xtables_free_opts!)
> this function needs some comments to explain just why
> it is supposed to be doing this.

I use it in a version of tc/m_xt.c i am working on but hadnt
made the changes to iptables and friends at this point. I
do that in later patches and did change it back to the original 
version in the "merge_options"  patch; so in the new version it looks
like regular free_opts(). So now it looks like:

-----
void xtables_free_opts(int reset_offset)
{
        if (xt_params->opts != xt_params->orig_opts) {
                free(xt_params->opts);
                xt_params->opts = xt_params->orig_opts;
                if (reset_offset)
                        xt_params->option_offset = 0;
        }
}
-------------


cheers,
jamal

