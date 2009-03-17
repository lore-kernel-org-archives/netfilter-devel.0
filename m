From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 09:24:25 +0100
Message-ID: <20090317082425.GA25491@mail.eitzenberger.org>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>, pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:64874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763228AbZCQNAO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:00:14 -0400
Content-Disposition: inline
In-Reply-To: <49BE84D4.7050804@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 16, 2009 at 05:56:52PM +0100, Patrick McHardy wrote:

> Currently the default is set based on the old config option.
> When unset, no acct-extend is allocated for *new* conntracks.
> The old ones that do have an acct-extend are still displayed.

I think the current implementation is unfortunate, because the
connbytes match auto-selects CONFIG_NF_CT_ACCT, and you end up having
the message always and can't get rid of it other than patching
it out.

