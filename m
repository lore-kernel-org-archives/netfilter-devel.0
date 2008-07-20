From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH] Sync NFLOG input plugin with NFLOG modification
 related to hardware header.
Date: Mon, 21 Jul 2008 01:51:23 +0200
Message-ID: <4883CF7B.9000105@netfilter.org>
References: <487CA584.3030200@trash.net> <1216247506-21802-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58952 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753560AbYGTXvc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jul 2008 19:51:32 -0400
In-Reply-To: <1216247506-21802-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch modifies ulogd2 to synchronize NFLOG with ULOG relatively to the
> definition of raw.mac. It fills the field with the complete hardware header
> instead of simply using the source hardware header.
> 
> This is a preliminary work for an implementation of an hardware header parsing.
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>
> ---
>  input/packet/ulogd_inppkt_NFLOG.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
> index cb58661..b69a99f 100644
> --- a/input/packet/ulogd_inppkt_NFLOG.c
> +++ b/input/packet/ulogd_inppkt_NFLOG.c
> @@ -290,9 +290,8 @@ static inline int
>  interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
>  {
>  	struct ulogd_key *ret = upi->output.keys;
> -
> +	
>  	struct nfulnl_msg_packet_hdr *ph = nflog_get_msg_packet_hdr(ldata);
> -	struct nfulnl_msg_packet_hw *hw = nflog_get_packet_hw(ldata);
>  	char *payload;
>  	int payload_len = nflog_get_payload(ldata, &payload);
>  	char *prefix = nflog_get_prefix(ldata);
> @@ -318,10 +317,11 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
>  		ret[NFLOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
>  	}
>  
> -	if (hw) {
> -		ret[NFLOG_KEY_RAW_MAC].u.value.ptr = hw->hw_addr;
> +	if (nflog_get_msg_packet_hwhdrlen(ldata)) {
> +		ret[NFLOG_KEY_RAW_MAC].u.value.ptr = nflog_get_msg_packet_hwhdr(ldata);
>  		ret[NFLOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
> -		ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 = ntohs(hw->hw_addrlen);
> +		ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 =
> +			nflog_get_msg_packet_hwhdrlen(ldata);
>  		ret[NFLOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;

OK, but we also need a key for the hw header type here to fix the
MAC2STR plugin - and probably rename it by ETHERNET2STR or HWADDR2STR if
we want to enable generic link layer header parsing.

Anyhow, the main problem is the database back-end. I think that we'll
have to log the whole hardware header again together with the hardware
type. But then, the MAC2STR plugin would not be useful for the database
output - still it may be for the plain text output.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
