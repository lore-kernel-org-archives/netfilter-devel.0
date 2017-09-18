From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 1/2] iptables: support match info fixup after tc_init
Date: Mon, 18 Sep 2017 18:28:11 +0200
Message-ID: <20170918162811.GA6091@salvia>
References: <20170917112031.8644-1-shmulik@nsof.io>
 <20170917112031.8644-2-shmulik@nsof.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>, rbk@nsof.io,
        Rafael Buchbinder <rafi@rbk.ms>
To: Shmulik Ladkani <shmulik@nsof.io>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:36366 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755981AbdIRQ2P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2017 12:28:15 -0400
Content-Disposition: inline
In-Reply-To: <20170917112031.8644-2-shmulik@nsof.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Rafael,

On Sun, Sep 17, 2017 at 02:20:30PM +0300, Shmulik Ladkani wrote:
> From: Rafael Buchbinder <rafi@rbk.ms>
> 
> From: Rafael Buchbinder <rafi@rbk.ms>
> 
> This commit introduces a framework to fixup match info,
> which may be required by an extension.
> 
> Signed-off-by: Rafael Buchbinder <rafi@rbk.ms>
> Signed-off-by: Shmulik Ladkani <shmulik@nsof.io>
> ---
>  include/xtables.h    |  3 +++
>  iptables/ip6tables.c | 35 +++++++++++++++++++++++++++++++++++
>  iptables/iptables.c  | 34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 72 insertions(+)
> 
> diff --git a/include/xtables.h b/include/xtables.h
> index e9bc3b7d..687cfe9f 100644
> --- a/include/xtables.h
> +++ b/include/xtables.h
> @@ -273,6 +273,9 @@ struct xtables_match {
>  	/* ip is struct ipt_ip * for example */
>  	void (*save)(const void *ip, const struct xt_entry_match *match);
>  
> +	/* Fixes the match info after init. */
> +	void (*tc_init_fixup)(struct xt_entry_match *match);

If this is only broken from tc ipt actions, could you fix this from
iproute2/tc instead?
