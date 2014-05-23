From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] src: Add support for adding TOS symbols
Date: Fri, 23 May 2014 20:26:53 +0200
Message-ID: <20140523182653.GA3658@localhost>
References: <1400868602-23142-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45257 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaEWS07 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2014 14:26:59 -0400
Content-Disposition: inline
In-Reply-To: <1400868602-23142-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 23, 2014 at 08:10:02PM +0200, Alvaro Neira Ayuso wrote:
> This patch allows to add type of service using symbols not
> only with mask.
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  include/datatype.h |    2 ++
>  src/proto.c        |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 61 insertions(+), 1 deletion(-)
> 
> diff --git a/include/datatype.h b/include/datatype.h
> index 2c66e9d..b53358c 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -35,6 +35,7 @@
>   * @TYPE_CT_STATUS:	conntrack status (bitmask subtype)
>   * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
>   * @TYPE_CT_LABEL:	Conntrack Label (bitmask subtype)
> + * @TYPE_TOS:		Type of service
                                                ^^^^^
                  Minor nitpick: Missing comment above regarding the subtype.

>   */
>  enum datatypes {
>  	TYPE_INVALID,
> @@ -63,6 +64,7 @@ enum datatypes {
>  	TYPE_TC_HANDLE,
>  	TYPE_UID,
>  	TYPE_GID,
> +	TYPE_TOS,

You have to add this to the end of the list of enum.

The datatypes are used in the sets keytype, nft needs them to
interpret the elements. If you add this here and someone upgrades nft,
it will break.

>  	TYPE_CT_STATE,
>  	TYPE_CT_DIR,
>  	TYPE_CT_STATUS,
