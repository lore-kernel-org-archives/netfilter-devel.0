From: Eric Leblond <eric@regit.org>
Subject: Re: [ulogd2 PATCHv2] Use stdint types everywhere
Date: Wed, 24 Jun 2015 09:37:12 +0200
Message-ID: <1435131432.18335.7.camel@regit.org>
References: <20150623172708.GA1343@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Felix Janda <felix.janda@posteo.de>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:47310 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbbFXHhV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2015 03:37:21 -0400
In-Reply-To: <20150623172708.GA1343@euler>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 2015-06-23 at 19:27 +0200, Felix Janda wrote:
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> ---
> v2: Ensure that <stdint.h> is included where used. Only the changes 
> to
>     the headers are different from v1.
> ---
...

> @@ -594,14 +594,14 @@ static int _interp_udp(struct 
> ulogd_pluginstance *pi, struct udphdr *udph,
>  
>  /* Section 3.1.  SCTP Common Header Format */
>  typedef struct sctphdr {
> -	__be16 source;
> -	__be16 dest;
> -	__be32 vtag;
> -	__be32 checksum;
> +	uint16_t source;
> +	uint16_t dest;
> +	uint32_t vtag;
> +	uint32_t checksum;
>  } __attribute__((packed)) sctp_sctphdr_t;

Sorry for not mentioning that in previous mail but I'm not comfortable
with this hunk. We are loosing synchronization with upstream definition
as well as some information on endianness.

Could you repost the patch removing this hunk?

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

