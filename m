From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 lnf-ct 2/2] conntrack: snprintf: add connlabel format
 specifier
Date: Tue, 25 Jun 2013 17:39:59 +0200
Message-ID: <20130625153959.GA5883@localhost>
References: <1372022079-11719-1-git-send-email-fw@strlen.de>
 <1372022079-11719-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51630 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3FYPkF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:40:05 -0400
Content-Disposition: inline
In-Reply-To: <1372022079-11719-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 23, 2013 at 11:14:39PM +0200, Florian Westphal wrote:
> By default, nfct_snprintf will not print connlabels, as they're
> system specific and can easily generate lots of output.
> 
> This adds a fmt attribute to print connlabel names.
> 
> output looks like this:
> ... mark=0 use=1 labels=eth0-in,eth1-in
> or
> <labels>
> <label>eth0-in</label>
> <label>eth1-in</label>
> </labels>
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Pablo, I _think_ this is pretty much what you had in
>  mind, if I misunderstood anything please let me know.
> 
>  Change since V1:
>  - avoid changing current nfct_snprint default output
>  - print only name of a label, needs NFCT_OF_CONNLABELS output format
> 
>  include/internal/prototypes.h                      |  1 +
>  .../libnetfilter_conntrack.h                       |  3 ++
>  src/conntrack/snprintf_default.c                   | 60 ++++++++++++++++++++++
>  src/conntrack/snprintf_xml.c                       | 37 +++++++++++++
>  4 files changed, 101 insertions(+)
> 
> diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
> index 484deea..414d7f8 100644
> --- a/include/internal/prototypes.h
> +++ b/include/internal/prototypes.h
> @@ -15,6 +15,7 @@ int __snprintf_protocol(char *buf, unsigned int len, const struct nf_conntrack *
>  int __snprintf_proto(char *buf, unsigned int len, const struct __nfct_tuple *tuple);
>  int __snprintf_conntrack_default(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags);
>  int __snprintf_conntrack_xml(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags);
> +int __snprintf_connlabels(char *buf, unsigned int len, struct nfct_labelmap *map, const struct nfct_bitmask *b, const char *fmt);
>  
>  enum __nfct_addr {
>  	__ADDR_SRC = 0,
> diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> index 39dc24c..eedf85e 100644
> --- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> +++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> @@ -389,6 +389,9 @@ enum {
>  
>  	NFCT_OF_TIMESTAMP_BIT = 3,
>  	NFCT_OF_TIMESTAMP = (1 << NFCT_OF_TIMESTAMP_BIT),
> +
> +	NFCT_OF_CONNLABELS_BIT = 4,
> +	NFCT_OF_CONNLABELS = (1 << NFCT_OF_CONNLABELS_BIT),
>  };
>  
>  extern int nfct_snprintf(char *buf, 
> diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
> index 911faea..2ede0bc 100644
> --- a/src/conntrack/snprintf_default.c
> +++ b/src/conntrack/snprintf_default.c
> @@ -288,6 +288,61 @@ __snprintf_helper_name(char *buf, unsigned int len, const struct nf_conntrack *c
>  	return (snprintf(buf, len, "helper=%s ", ct->helper_name));
>  }
>  
> +int
> +__snprintf_connlabels(char *buf, unsigned int len,
> +		      struct nfct_labelmap *map,
> +		      const struct nfct_bitmask *b, const char *fmt)
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
> +
> +		ret = snprintf(buf + offset, len, fmt, name);
> +		BUFFER_SIZE(ret, size, len, offset);
> +	}
> +	return size;
> +}
> +
> +static int
> +__snprintf_clabels(char *buf, unsigned int len,
> +		   const struct nf_conntrack *ct)
> +{
> +	const struct nfct_bitmask *b = nfct_get_attr(ct, ATTR_CONNLABELS);
> +	struct nfct_labelmap *map;
> +	int ret, size = 0, offset = 0;
> +
> +	if (!b)
> +		return 0;
> +
> +	map = nfct_labelmap_new(NULL);
> +	if (!map)
> +		return 0;

This opens and parses the map file for each conntrack, it would be
expensive.  I think it's better provide more control to the client
regarding the load of the mapping, it's more flexible.

Consider adding:

int nfct_snprintf_connlabel(char *buf, unsigned int len,
                            const struct nf_conntrack *ct,
                            const struct nfct_labelmap *labelmap);
