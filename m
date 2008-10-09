From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH][libnetfilter_conntrack] add support for explicit helper
 assignment
Date: Thu, 9 Oct 2008 18:26:19 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0810091814490.13257@bizon.gios.gov.pl>
References: <48EDDE81.9070606@netfilter.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-691498199-1223569579=:13257"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:44751 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbYJIQqp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:46:45 -0400
In-Reply-To: <48EDDE81.9070606@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-691498199-1223569579=:13257
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Thu, 9 Oct 2008, Pablo Neira Ayuso wrote:

> This patch adds support for the explicit helper assignment to
> libnetfilter_conntrack. You can use it to test the load-on-demand helper
> modules via ctnetlink.

<CUT>

> +enum nf_conntrack_helper_id {
> +	NFCT_HELPER_UNSPEC = 0,
> +	NFCT_HELPER_AMANDA,
> +	NFCT_HELPER_FTP,
> +	NFCT_HELPER_H323,
> +	NFCT_HELPER_IRC = 4,
> +	NFCT_HELPER_NETBIOS_NS,
> +	NFCT_HELPER_PPTP,
> +	NFCT_HELPER_SANE,
> +	NFCT_HELPER_SIP = 8,
> +	NFCT_HELPER_TFTP,
> +	NFCT_HELPER_MAX
> +};
> +
>  /* message type */
>  enum nf_conntrack_msg_type {
>  	NFCT_T_UNKNOWN = 0,
> diff --git a/src/conntrack/build.c b/src/conntrack/build.c
> index 1bc87f9..8c7cb7f 100644
> --- a/src/conntrack/build.c
> +++ b/src/conntrack/build.c
> @@ -308,6 +308,38 @@ void __build_secmark(struct nfnlhdr *req,
>  	nfnl_addattr32(&req->nlh, size, CTA_SECMARK, htonl(ct->secmark));
>  }
>
> +const char *helper_id_to_name[] = {
> +	[NFCT_HELPER_UNSPEC]		= "unknown-helper",
> +	[NFCT_HELPER_AMANDA] 		= "amanda",
> +	[NFCT_HELPER_FTP] 		= "ftp",
> +	[NFCT_HELPER_H323]		= "h323",
> +	[NFCT_HELPER_IRC]		= "irc",
> +	[NFCT_HELPER_NETBIOS_NS]	= "netbios_ns",
> +	[NFCT_HELPER_PPTP]		= "pptp",
> +	[NFCT_HELPER_SANE]		= "sane",
> +	[NFCT_HELPER_SIP]		= "sip",
> +	[NFCT_HELPER_TFTP]		= "tftp",
> +};
> +

Any chances to make it more frendly to new helpers and compatible with 
out-of-tree helpers by registering a name directly from a helper and using 
it? We may for example introduce something like /proc/net/nf_helpers.

Best regards,

 			Krzysztof Olêdzki
---1144830174-691498199-1223569579=:13257--
