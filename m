Return-Path: <SRS0=byYJ=Z5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E02DC43603
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 00:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA5A3205ED
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 00:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfLGAdC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Dec 2019 19:33:02 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37569 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726453AbfLGAdC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Dec 2019 19:33:02 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 320207E9415
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Dec 2019 11:32:47 +1100 (AEDT)
Received: (qmail 11364 invoked by uid 501); 7 Dec 2019 00:32:47 -0000
Date:   Sat, 7 Dec 2019 11:32:46 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 1/2] src: doc: Major re-work of user
 packet buffer documentation
Message-ID: <20191207003246.GB5579@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191118033638.26472-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118033638.26472-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8 a=fh4mg5NFAAAA:8
        a=NiKunFauZK85qd66RdEA:9 a=UPvvrVn-fYQfX8cC:21 a=LZeGrbnA-IJcnYA-:21
        a=CjuIK1q_8ugA:10 a=T77Lwl-6BFbSlNe0EbSH:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Nov 18, 2019 at 02:36:37PM +1100, Duncan Roe wrote:
> Divide functions into a hierarchy:
>  top-level: Functions all programs that modify data will use
>  2nd-level: Rarely-used functions
>  3rd-level: Functions not to use (should have been declared static)
> Only the top-level functions appear on the "User-space network packet buffer"
> page, which looks a lot less daunting than it used to.
>
> Parameter descriptions all match prototypes
>
> All non-void functions have a "Returns" paragraph
>
> Code change:
>
>  pktb_alloc: set errno to EPROTONOSUPPORT before doing error return because
>              protocol is not supported
>
> Detailed other updates (top-level)
>
>  pktb_alloc: - Add "Errors" para
>              - Add "See also" para
>
>  pktb_data, pktb_len: Add "appropriate use" line
>
>  pktb_mangle: Add warning to use a different function unless mangling MAC hddr
>
>  pktb_mangled: Add usage hint line
>
> Detailed other updates (2nd-level)
>
>  pktb_mac_header: Point out only for AF_BRIDGE
>
>  pktb_tailroom: Point out no dynamic expansion
>
>  pktb_transport_header: Add note that programmer must code to set this
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  src/extra/pktbuff.c | 154 +++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 117 insertions(+), 37 deletions(-)
>
> diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
> index f1f8323..26d7ca8 100644
> --- a/src/extra/pktbuff.c
> +++ b/src/extra/pktbuff.c
> @@ -9,6 +9,7 @@
>   * This code has been sponsored by Vyatta Inc. <http://www.vyatta.com>
>   */
>
> +#include <errno.h>
>  #include <stdlib.h>
>  #include <string.h> /* for memcpy */
>  #include <stdbool.h>
> @@ -30,7 +31,8 @@
>
>  /**
>   * pktb_alloc - allocate a new packet buffer
> - * \param family Indicate what family, eg. AF_BRIDGE, AF_INET, AF_INET6, ...
> + * \param family Indicate what family. Currently supported families are
> + * AF_BRIDGE, AF_INET & AF_INET6.
>   * \param data Pointer to packet data
>   * \param len Packet length
>   * \param extra Extra memory in the tail to be allocated (for mangling)
> @@ -38,7 +40,13 @@
>   * This function returns a packet buffer that contains the packet data and
>   * some extra memory room in the tail (if requested).
>   *
> - * \return a pointer to a new queue handle or NULL on failure.
> + * \return Pointer to a new userspace packet buffer or NULL on failure.
> + * \par Errors
> + * __ENOMEM__ From __calloc__()
> + * \n
> + * __EPROTONOSUPPORT__ _family_ was __AF_BRIDGE__ and this is not an IP packet
> + * (v4 or v6)
> + * \sa __calloc__(3)
>   */
>  EXPORT_SYMBOL
>  struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
> @@ -78,6 +86,7 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
>  			break;
>  		default:
>  			/* This protocol is unsupported. */
> +			errno = EPROTONOSUPPORT;
>  			free(pktb);
>  			return NULL;
>  		}
> @@ -88,8 +97,12 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
>  }
>
>  /**
> - * pktb_data - return pointer to the beginning of the packet buffer
> - * \param pktb Pointer to packet buffer
> + * pktb_data - get pointer to network packet
> + * \param pktb Pointer to userspace packet buffer
> + * \return Pointer to start of network packet data within __pktb__
> + * \par
> + * It is appropriate to use _pktb_data_ as the second argument of
> + * nfq_nlmsg_verdict_put_pkt()
>   */
>  EXPORT_SYMBOL
>  uint8_t *pktb_data(struct pkt_buff *pktb)
> @@ -99,7 +112,11 @@ uint8_t *pktb_data(struct pkt_buff *pktb)
>
>  /**
>   * pktb_len - return length of the packet buffer
> - * \param pktb Pointer to packet buffer
> + * \param pktb Pointer to userspace packet buffer
> + * \return Length of packet contained within __pktb__
> + * \par
> + * It is appropriate to use _pktb_len_ as the third argument of
> + * nfq_nlmsg_verdict_put_pkt()
>   */
>  EXPORT_SYMBOL
>  uint32_t pktb_len(struct pkt_buff *pktb)
> @@ -109,7 +126,7 @@ uint32_t pktb_len(struct pkt_buff *pktb)
>
>  /**
>   * pktb_free - release packet buffer
> - * \param pktb Pointer to packet buffer
> + * \param pktb Pointer to userspace packet buffer
>   */
>  EXPORT_SYMBOL
>  void pktb_free(struct pkt_buff *pktb)
> @@ -118,8 +135,35 @@ void pktb_free(struct pkt_buff *pktb)
>  }
>
>  /**
> - * pktb_push - update pointer to the beginning of the packet buffer
> - * \param pktb Pointer to packet buffer
> + * \defgroup otherfns Other functions
> + *
> + * The library provides a number of other functions which many user-space
> + * programs will never need. These divide into 2 groups:
> + * \n
> + * 1. Functions to get values of members of opaque __struct pktbuff__, described
> + * below
> + * \n
> + * 2. Internal functions, described in Module __Internal functions__
> + *
> + * @{
> + */
> +
> +/**
> + * \defgroup uselessfns Internal functions
> + *
> + * \warning Do not use these functions. Instead, always use the mangle
> + * function appropriate to the level at which you are working.
> + * \n
> + * pktb_mangle() uses all the below functions except _pktb_pull_, which is not
> + * used by anything.
> + *
> + * @{
> + */
> +
> +/**
> + * pktb_push - decrement pointer to packet buffer
> + * \param pktb Pointer to userspace packet buffer
> + * \param len Number of bytes to subtract from packet start address
>   */
>  EXPORT_SYMBOL
>  void pktb_push(struct pkt_buff *pktb, unsigned int len)
> @@ -129,8 +173,9 @@ void pktb_push(struct pkt_buff *pktb, unsigned int len)
>  }
>
>  /**
> - * pktb_pull - update pointer to the beginning of the packet buffer
> - * \param pktb Pointer to packet buffer
> + * pktb_pull - increment pointer to packet buffer
> + * \param pktb Pointer to userspace packet buffer
> + * \param len Number of bytes to add to packet start address
>   */
>  EXPORT_SYMBOL
>  void pktb_pull(struct pkt_buff *pktb, unsigned int len)
> @@ -141,7 +186,8 @@ void pktb_pull(struct pkt_buff *pktb, unsigned int len)
>
>  /**
>   * pktb_put - add extra bytes to the tail of the packet buffer
> - * \param pktb Pointer to packet buffer
> + * \param pktb Pointer to userspace packet buffer
> + * \param len Number of bytes to add to packet tail (and length)
>   */
>  EXPORT_SYMBOL
>  void pktb_put(struct pkt_buff *pktb, unsigned int len)
> @@ -152,7 +198,8 @@ void pktb_put(struct pkt_buff *pktb, unsigned int len)
>
>  /**
>   * pktb_trim - set new length for this packet buffer
> - * \param pktb Pointer to packet buffer
> + * \param pktb Pointer to userspace packet buffer
> + * \param len New packet length (tail is adjusted to reflect this)
>   */
>  EXPORT_SYMBOL
>  void pktb_trim(struct pkt_buff *pktb, unsigned int len)
> @@ -162,8 +209,17 @@ void pktb_trim(struct pkt_buff *pktb, unsigned int len)
>  }
>
>  /**
> - * pktb_tailroom - get room in bytes in the tail of the packet buffer
> - * \param pktb Pointer to packet buffer
> + * @}
> + */
> +
> +/**
> + * pktb_tailroom - get room available for packet expansion
> + * \param pktb Pointer to userspace packet buffer
> + * \return room in bytes after the tail of the packet buffer
> + * \n
> + * This starts off as the __extra__ argument to pktb_alloc().
> + * Programmers should ensure this __extra__ argument is sufficient for any
> + * packet mangle, as packet buffers cannot be expanded dynamically.
>   */
>  EXPORT_SYMBOL
>  unsigned int pktb_tailroom(struct pkt_buff *pktb)
> @@ -172,8 +228,11 @@ unsigned int pktb_tailroom(struct pkt_buff *pktb)
>  }
>
>  /**
> - * pktb_mac_header - return pointer to layer 2 header (if any)
> - * \param pktb Pointer to packet buffer
> + * pktb_mac_header - get address of layer 2 header (if any)
> + * \param pktb Pointer to userspace packet buffer
> + * \return Pointer to MAC header or NULL if no such header present.
> + * \n
> + * Only packet buffers in family __AF_BRIDGE__ have a non-NULL MAC header.
>   */
>  EXPORT_SYMBOL
>  uint8_t *pktb_mac_header(struct pkt_buff *pktb)
> @@ -182,8 +241,10 @@ uint8_t *pktb_mac_header(struct pkt_buff *pktb)
>  }
>
>  /**
> - * pktb_network_header - return pointer to layer 3 header
> - * \param pktb Pointer to packet buffer
> + * pktb_network_header - get address of layer 3 header
> + * \param pktb Pointer to userspace packet buffer
> + * \return Pointer to layer 3 header or NULL if the packet buffer was created
> + * with an unsupported family
>   */
>  EXPORT_SYMBOL
>  uint8_t *pktb_network_header(struct pkt_buff *pktb)
> @@ -192,8 +253,13 @@ uint8_t *pktb_network_header(struct pkt_buff *pktb)
>  }
>
>  /**
> - * pktb_transport_header - return pointer to layer 4 header (if any)
> - * \param pktb Pointer to packet buffer
> + * pktb_transport_header - get address of layer 4 header (if known)
> + * \param pktb Pointer to userspace packet buffer
> + * \return Pointer to layer 4 header or NULL if not (yet) set
> + * \note
> + * Unlike the lower-level headers, it is the programmer's responsibility to
> + * create the level 4 (transport) header pointer by caling e.g.
> + * nfq_ip_set_transport_header()
>   */
>  EXPORT_SYMBOL
>  uint8_t *pktb_transport_header(struct pkt_buff *pktb)
> @@ -201,6 +267,10 @@ uint8_t *pktb_transport_header(struct pkt_buff *pktb)
>  	return pktb->transport_header;
>  }
>
> +/**
> + * @}
> + */
> +
>  static int pktb_expand_tail(struct pkt_buff *pkt, int extra)
>  {
>  	/* No room in packet, cannot mangle it. We don't support dynamic
> @@ -228,19 +298,24 @@ static int enlarge_pkt(struct pkt_buff *pkt, unsigned int extra)
>
>  /**
>   * pktb_mangle - adjust contents of a packet
> - * \param pkt Pointer to packet buffer
> + * \param pktb Pointer to userspace packet buffer
>   * \param dataoff Offset to layer 4 header. Specify zero to access layer 3 (IP)
> - * header
> + * header (layer 2 for family \b AF_BRIDGE)
>   * \param match_offset Further offset to content that you want to mangle
>   * \param match_len Length of the existing content you want to mangle
>   * \param rep_buffer Pointer to data you want to use to replace current content
>   * \param rep_len Length of data you want to use to replace current content
>   * \returns 1 for success and 0 for failure. Failure will occur if the \b extra
> - * argument to the pktb_alloc() call that created \b pkt is less than the excess
> - * of \b rep_len over \b match_len
> + * argument to the pktb_alloc() call that created \b pktb is less than the
> + * excess of \b rep_len over \b match_len
> + \warning pktb_mangle does not update any checksums. Developers should use the
> + appropriate mangler for the protocol level: nfq_ip_mangle(),
> + nfq_tcp_mangle_ipv4() or nfq_udp_mangle_ipv4(). IPv6 versions are planned.
> + \n
> + It is appropriate to use pktb_mangle to change the MAC header.
>   */
>  EXPORT_SYMBOL
> -int pktb_mangle(struct pkt_buff *pkt,
> +int pktb_mangle(struct pkt_buff *pktb,
>  		unsigned int dataoff,
>  		unsigned int match_offset,
>  		unsigned int match_len,
> @@ -250,39 +325,44 @@ int pktb_mangle(struct pkt_buff *pkt,
>  	unsigned char *data;
>
>  	if (rep_len > match_len &&
> -	    rep_len - match_len > pktb_tailroom(pkt) &&
> -	    !enlarge_pkt(pkt, rep_len - match_len))
> +	    rep_len - match_len > pktb_tailroom(pktb) &&
> +	    !enlarge_pkt(pktb, rep_len - match_len))
>  		return 0;
>
> -	data = pkt->network_header + dataoff;
> +	data = pktb->network_header + dataoff;
>
>  	/* move post-replacement */
>  	memmove(data + match_offset + rep_len,
>  		data + match_offset + match_len,
> -		pkt->tail - (pkt->network_header + dataoff +
> +		pktb->tail - (pktb->network_header + dataoff +
>  			     match_offset + match_len));
>
>  	/* insert data from buffer */
>  	memcpy(data + match_offset, rep_buffer, rep_len);
>
> -	/* update pkt info */
> +	/* update packet info */
>  	if (rep_len > match_len)
> -		pktb_put(pkt, rep_len - match_len);
> +		pktb_put(pktb, rep_len - match_len);
>  	else
> -		pktb_trim(pkt, pkt->len + rep_len - match_len);
> +		pktb_trim(pktb, pktb->len + rep_len - match_len);
>
> -	pkt->mangled = true;
> +	pktb->mangled = true;
>  	return 1;
>  }
>
>  /**
> - * pktb_mangled - return true if packet has been mangled
> - * \param pktb Pointer to packet buffer
> + * pktb_mangled - test whether packet has been mangled
> + * \param pktb Pointer to userspace packet buffer
> + * \return __true__ if packet has been mangled (modified), else __false__
> + * \par
> + * When assembling a verdict, it is not necessary to return the contents of
> + * un-modified packets. Use _pktb_mangled_ to decide whether packet contents
> + * need to be returned.
>   */
>  EXPORT_SYMBOL
> -bool pktb_mangled(const struct pkt_buff *pkt)
> +bool pktb_mangled(const struct pkt_buff *pktb)
>  {
> -	return pkt->mangled;
> +	return pktb->mangled;
>  }
>
>  /**
> --
> 2.14.5
>
Did you forget about this one?

Cheers ... Duncan.
