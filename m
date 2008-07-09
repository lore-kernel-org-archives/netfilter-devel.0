From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD PATCH] rework, fill MAC address in ULOG for ethernet.
Date: Wed, 09 Jul 2008 12:53:13 +0200
Message-ID: <48749899.7070505@trash.net>
References: <486B88F4.7060704@trash.net> <1215554219-13763-1-git-send-email-eric@inl.fr> <487497F4.8070004@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56763 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYGIKxP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:53:15 -0400
In-Reply-To: <487497F4.8070004@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
>> This patch introduces a parsing of the hardware header field based on
>> the length of the field. It currently only detects ethernet header and
>> fill mac.saddr and mac.daddr properly.
>>
>> With this behaviour it may be impossible to support all kind of devices
>> but ULOG will soon be deprecated in favor of NFLOG.
> 
> Since we do not have more information in ULOG, I see this as a best try
> to detect what kind of layer 2 header is there. The other choice is not
> to include layer 2 information at all if we use ulog as input which also
> seems reasonable to me. If users want new features they have to migrate
> from ulog to nflog IMO.
> 
> I'm willing to finish the compatibility layer in libnetfilter_queue,
> this could probably help to deprecate it.
> 
> If Patrick does not have any objection, I'll apply this and the previous
> layer 2 related patches.

One objection:

> +static int parse_macheader(struct ulogd_key *ret, ulog_packet_msg_t *pkt,
> +			   )
> +{
> +	int hwlen;
> +
> +	switch (pkt->mac_len) {
> +		case (2 * ETH_ALEN +2):
> +			hwlen = ETH_ALEN;
> +			break;
> +		default:
> +			ulogd_log(ULOGD_DEBUG, "Unknown mac_len (%d), "
> +					"rejecting packet", pkt->mac_len);
> +			ret[ULOG_KEY_OOB_PROTOCOL].u.value.ui16 = 0;
> +			ret[ULOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
> +			return ULOGD_IRET_OK;

This appears to be breaking logging for anything but ethernet
packets. We can't do that, especially since ulogd1 has long
been in maintenance-only mode.

