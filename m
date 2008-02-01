From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD RFC 29/30] NFCT: adapt to new libnetfilter_conntrack
Date: Fri, 01 Feb 2008 04:55:35 +0100
Message-ID: <47A29837.2000709@netfilter.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190130.347773797@kruemel.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42343 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751324AbYBADzv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:55:51 -0500
In-Reply-To: <20080130190130.347773797@kruemel.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> +static int
> +nfct_to_conntrack(const struct ulogd_pluginstance *pi,
> +				  const struct nf_conntrack *ct, struct nfct_conntrack *out)

I frankly prefer if you don't this "translator" and use the new API
directly.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
