From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnf-ct] conntrack: api: add nfct_snprintf_labels
Date: Sun, 30 Jun 2013 23:34:33 +0200
Message-ID: <20130630213433.GA5096@localhost>
References: <1372626410-19162-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50896 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab3F3Vei (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jun 2013 17:34:38 -0400
Content-Disposition: inline
In-Reply-To: <1372626410-19162-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 30, 2013 at 11:06:50PM +0200, Florian Westphal wrote:
> nfct_snprintf doesn't print connlabels, as they're system specific
> and can easily generate lots of output.
> 
> This adds a new helper function, nfct_snprintf_labels, to print the mapped
> label names to a buffer.  Input is a bitmask to test, and a map
> describing the names of the individual bits.
> 
> Those names whose bits are contained in the bitset are then
> written to the buffer.
> 
> output looks like this:
> eth0-in,eth1-in
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  I added an 'output_type' argument, not sure if this is useful.
>  [ I don't see why NFCT_O_XML would be useful here, OTOH
>    adding the output_type argument would allow to add it later ]

That's a good idea. Users can benefit from the well structured XML
output, with this parameter can be easily added in a follow up patch.

This looks good.

>  include/internal/prototypes.h                      |  2 +
>  .../libnetfilter_conntrack.h                       |  4 ++
>  src/conntrack/api.c                                | 16 ++++++++
>  src/conntrack/labels.c                             | 44 ++++++++++++++++++++++
>  4 files changed, 66 insertions(+)
> 
> diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
> index 484deea..dded472 100644
> --- a/include/internal/prototypes.h
> +++ b/include/internal/prototypes.h
> @@ -62,5 +62,7 @@ void __labelmap_destroy(struct nfct_labelmap *);
>  
>  int __labelmap_get_bit(struct nfct_labelmap *map, const char *name);
>  const char *__labelmap_get_name(struct nfct_labelmap *map, unsigned int bit);
> +int __labels_snprintf(char *buf, unsigned int len, struct nfct_labelmap *map,
> +			const struct nfct_bitmask *b, unsigned int out_type);
>  
>  #endif
> diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> index 39dc24c..3dafe46 100644
> --- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> +++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> @@ -294,6 +294,10 @@ struct nfct_labelmap *nfct_labelmap_new(const char *mapfile);
>  void nfct_labelmap_destroy(struct nfct_labelmap *map);
>  const char *nfct_labelmap_get_name(struct nfct_labelmap *m, unsigned int bit);
>  int nfct_labelmap_get_bit(struct nfct_labelmap *m, const char *name);
> +int nfct_snprintf_labels(char *buf, unsigned int len,
> +			 struct nfct_labelmap *labelmap,
> +			 const struct nfct_bitmask *b,
> +			 unsigned int out_type);
>  
>  /* setter */
>  extern void nfct_set_attr(struct nf_conntrack *ct,
> diff --git a/src/conntrack/api.c b/src/conntrack/api.c
> index b6c453f..0a668ce 100644
> --- a/src/conntrack/api.c
> +++ b/src/conntrack/api.c
> @@ -1523,6 +1523,22 @@ int nfct_labelmap_get_bit(struct nfct_labelmap *m, const char *name)
>  }
>  
>  /**
> + * nfct_snprintf_labels - print a bitmask object to a buffer
> + * \param buf buffer used to build the names of the bitmask
> + * \param len size of the buffer
> + * \param map nfct_labelmap which maps the bit values to the desired strings
> + * \param b pointer to a valid bitmask object
> + * \param output_type print type (NFCT_O_DEFAULT only at this time)
> + */
> +int nfct_snprintf_labels(char *buf, unsigned int len,
> +			 struct nfct_labelmap *map,
> +			 const struct nfct_bitmask *b,
> +			 unsigned int out_type)
> +{
> +	return __labels_snprintf(buf, len, map, b, out_type);
> +}
> +
> +/**
>   * nfct_labelmap_new - create a new label map
>   *
>   * \param mapfile the file containing the bit <-> name mapping
> diff --git a/src/conntrack/labels.c b/src/conntrack/labels.c
> index 7dfb780..4511180 100644
> --- a/src/conntrack/labels.c
> +++ b/src/conntrack/labels.c
> @@ -267,3 +267,47 @@ struct nfct_labelmap *__labelmap_new(const char *name)
>  	__labelmap_destroy(map);
>  	return NULL;
>  }
> +
> +static int
> +__labels_snprintf_fmt(char *buf, unsigned int len,
> +		      struct nfct_labelmap *map,
> +		      const struct nfct_bitmask *b,
> +		      const char *fmt)
> +{
> +	unsigned int i, max;
> +	int ret, size = 0, offset = 0;
> +
> +	max = nfct_bitmask_maxbit(b);
> +	for (i = 0; i <= max && len; i++) {
> +		const char *name;
> +		if (!nfct_bitmask_test_bit(b, i))
> +			continue;
> +		name = nfct_labelmap_get_name(map, i);
> +		if (!name || strcmp(name, "") == 0)
> +			continue;
> +		ret = snprintf(buf + offset, len, fmt, name);
> +		BUFFER_SIZE(ret, size, len, offset);
> +	}
> +	return size;
> +}
> +
> +int
> +__labels_snprintf(char *buf, unsigned int len,
> +		  struct nfct_labelmap *map,
> +		  const struct nfct_bitmask *b, unsigned int out_type)
> +{
> +	int size = 0;
> +
> +	switch (out_type) {
> +	case NFCT_O_DEFAULT:
> +		size = __labels_snprintf_fmt(buf, len, map, b, "%s,");
> +		if (size && size <= len)
> +			buf[--size] = 0; /* strip trailing ',' */
> +		break;
> +	default:
> +		errno = ENOENT;
> +		return -1;
> +	}
> +
> +	return size;
> +}
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
