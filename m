From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD PATCH] Output mac.saddr, mac.daddr and oob.protocol in
 ULOG plugin.
Date: Wed, 02 Jul 2008 15:56:04 +0200
Message-ID: <486B88F4.7060704@trash.net>
References: <1214607780-31389-4-git-send-email-eric@inl.fr> <1215006740-13074-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38511 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbYGBN4G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:56:06 -0400
In-Reply-To: <1215006740-13074-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> +	/* compute hardware header length hwlen from mac_len, we suppose
> +	 * header field is [ HW DST ADDR | HW SRC ADDR | PROTO ] with
> +	 * proto code on two bytes.
> +	 * Thus, we have:
> +	 * 	hwlen = (mac_len - 2) / 2
> +	 */
> +	if ((pkt->mac_len % 2) || (pkt->mac_len < 2)) {
> +		ulogd_log(ULOGD_NOTICE, "Invalid  mac_len (%d), rejecting"
> +			  " packet", pkt->mac_len);
> +		return ULOGD_IRET_ERR;
> +	} else
> +		hwlen = (pkt->mac_len - 2) / 2;


Thats not correct. The mac header (which is badly named) includes
the entire device specific header, for IPIP tunnels for example its
the outer IP header. So this needs device specific logic.
