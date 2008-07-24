From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 2/4] Add parsing module for raw.mac.
Date: Thu, 24 Jul 2008 09:10:59 +0200
Message-ID: <48882B03.2030806@netfilter.org>
References: <> <1216848048-13516-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60093 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750808AbYGXHLG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:11:06 -0400
In-Reply-To: <1216848048-13516-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch adds a module named RAWMAC which is in charge of parsing the
> hardware header to extract source and destination hardware address.

I think that this should be merged with MAC2STR, can you see any other
potential user of this information apart from the string converter?
Also, it would be nice to rename it to HW2STR instead.

Minor glitch below:

> +static int parse_rawmac(struct ulogd_key *ret, struct ulogd_key *inp, int type)
> +{
> +	switch (type) {
> +		case ARPHRD_ETHER:
> +			return parse_ethernet(ret, inp);
> +		default:
> +			ulogd_log(ULOGD_NOTICE, "Unsupported hardware type (%d), "
> +				  "unable to parse.\n", GET_VALUE(ret, KEY_RAW_TYPE).ui16);

This can generate lots of log messages. I prefer to remove this and
document that only ethernet is supported at the moment.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
