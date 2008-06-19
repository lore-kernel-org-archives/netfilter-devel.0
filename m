From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: Make NFLOG dump all hardware header.
Date: Thu, 19 Jun 2008 14:30:21 +0200
Message-ID: <485A515D.10200@trash.net>
References: <1213878187-909-1-git-send-email-eric@inl.fr> <1213878331-1074-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, chifflier@inl.fr
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64404 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbYFSMaa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:30:30 -0400
In-Reply-To: <1213878331-1074-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch synchronises behaviour of ULOG and NFLOG relatively to the
> hardware header:
>  * NFLOG sends MAC address to userspace (dev_parse_header content)
>  * ULOG sends complete link header (skb_mac_header content)
> This patch double the size of hardware header for NFLOG and fill it
> with the complete hardware header.

This looks like an API breaking patch. It would be better to use
a new attribute for this. Also this structure encapsulation is a
bad idea IMO, it should just use a NLA_BINARY attribute.

> +	if (indev && indev->hard_header_len > 0
> +	    && skb->mac_header != skb->network_header
> +	    && indev->hard_header_len <= MAX_HWHEADER_LEN * sizeof(char)) {

skb_mac_header_was_set()?
