From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] iptables: improve chain name validation
Date: Tue, 8 Oct 2013 09:08:56 -0700
Message-ID: <20131008160856.GA18402@home>
References: <20131005163315.GA16881@home>
 <alpine.LSU.2.11.1310071613590.6551@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57881 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab3JHQI7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:08:59 -0400
Received: by mail-pd0-f169.google.com with SMTP id r10so8970551pdi.28
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Oct 2013 09:08:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1310071613590.6551@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 07, 2013 at 04:14:47PM +0200, Jan Engelhardt wrote:
> IMO iptables-save should just put the chain name in quotes (calling 
> xtables_save_string) if there is a need to do so.

Example:
# iptables -N 'hog wash'
# iptables -A INPUT -j 'hog wash'
iptables v1.4.20: Invalid target name `hog wash'
Try `iptables -h' or 'iptables --help' for more information.

Code:
static const char *
parse_target(const char *targetname)
{
...
        for (ptr = targetname; *ptr; ptr++)
                if (isspace(*ptr))
                        xtables_error(PARAMETER_PROBLEM,
                                   "Invalid target name `%s'", targetname);

Conclusion:
It seems pointless to allow adding chains which cannot actually be used.

Phil
