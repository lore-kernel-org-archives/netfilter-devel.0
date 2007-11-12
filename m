From: Philip Craig <philipc@snapgear.com>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in  
 2.6.22.6
Date: Mon, 12 Nov 2007 17:35:20 +1000
Message-ID: <47380238.6070502@snapgear.com>
References: <W352381485970601194435879@nocme1bl6.telenet-ops.be>	 <4731A7A9.1050606@trash.net> <1194478191.2983.7.camel@localhost.localdomain> <4737EBF6.6000506@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	"bdschuym@pandora.be" <bdschuym@telenet.be>,
	ron lai <ronlai@cs.stanford.edu>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:54264 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753590AbXKLHe6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2007 02:34:58 -0500
In-Reply-To: <4737EBF6.6000506@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Both are fine with me. Does this patch look correct to you?
> 
> +	if (!nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT))

I think it needs more parentheses:

	if (!(nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT)))

