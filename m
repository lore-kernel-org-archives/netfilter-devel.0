From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC v2] netfilter: add connlabel conntrack extension
Date: Mon, 12 Nov 2012 17:24:15 +0100
Message-ID: <20121112162415.GA16990@1984>
References: <1351860231-5434-1-git-send-email-fw@strlen.de>
 <20121107200427.GB12876@breakpoint.cc>
 <20121112064457.GA11330@1984>
 <20121112123053.GB20678@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58878 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab2KLQYX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:24:23 -0500
Content-Disposition: inline
In-Reply-To: <20121112123053.GB20678@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Mon, Nov 12, 2012 at 01:30:53PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > int nfct_label_set(struct nf_conntrack *ct, const char *label);
> > > 
> > > 	sets the label 'label' on the ct object.
> > > 
> > > void nfct_label_unset(struct nf_conntrack *ct, const char *label);
> > > 
> > > 	opposite, label is cleared if it was set.
> > 
> > Can you use the existing nfct_attr_set/unset API for this?
> 
> Don't see how, nfct_attr_unset clears the entire attribute.
> I admit that it would be nice if one could re-use existing api...
> 
> Right now nfct_attr_set_l(.. ATTR_CONNLABELS..) can be used to assign
> the bit-vector directly (and _get can be used to retrieve the
> label bit-vector).

You could use a nfct_bitmask object and methods to modify it:

struct nfct_bitmask *nfct_bitmask_alloc(void)
nfct_bitmask_set_bit(struct nfct_bitmask *, uint16_t bit)
nfct_bitmask_test_bit(struct nfct_bitmask *, uint16_t bit)
nfct_bitmask_unset_bit(struct nfct_bitmask *, uint16_t bit)

Then you can attach the bitmask to the object:

nfct_set_attr(ct, ATTR_CONNLABELS, bitmask);

The setter would do the special handling internally by attaching the
bitmask label to the ct object.

> > > open question is how the library should do the mapping, i.e.
> > > should it hard-code a path to the mapping file (currently
> > > its /etc/xtables/connlabel.conf in my iptables-patch).
> > 
> > Add a new parameter to nfct_label_open to indicate where the file that
> > contains the mapping is.
> 
> I think that we should avoid it; else this might become a
> portability nightmare where applications end up
> trying half a zillion names (/etc/xtables, /usr/etc, /usr/local...)

We can provide some constant to recommend a path. My only concern is
that the hardcoded path may not exist in some filesystem, thus,
forcing to recompile the library.

Anyway, I think the main user for this will be the conntrack utility
and any netfilter utilities.

One more question below:

> > > void *nfct_label_open(void);
> > > void nfct_label_close(void *);
> > > int nfct_label_iterate(void *fp, char *buf, size_t buflen);
> > > 
> > > so you could do
> > > void *h = nfct_label_open();
> > > int bit;
> > > while ((bit = nfct_label_iterate(h, bufm sizeof(buf))) > 0)
> > > 	printf("bit %d: %s\n", bit, buf);
> > > 
> > > ?
> > 
> > That seems fine to me.
> 
> Thanks.  I now have the following public API:
> 
> /**
>  * nfct_label_set_bit - set a bit in the label bitvector
>  * \param ct pointer to a valid conntrack object
>  * \param bit bit to set
>  * returns 0 if the bit is now set
>  */
> int nfct_label_set_bit(struct nf_conntrack *ct, uint16_t bit)
> {
>         return __label_set_bit(ct, bit);
> }
> 
> /**
>  * nfct_label_unset_bit - clear label bit on a conntrack object
>  * \param ct pointer to a valid conntrack object
>  * \param bit bit to clear
>  */
> void nfct_label_unset(struct nf_conntrack *ct, uint16_t bit)
> {
>         __label_unset_bit(ct, bit);
> }
> 
> /**
>  * nfct_label_test_bit - determine wheter bit is set
>  * \param ct pointer to a valid conntrack object
>  * \param bit bit to query
>  *
>  * returns 0 on sucess and -1 if bit is not set.
>  */
> int nfct_label_test_bit(struct nf_conntrack *ct, uint16_t bit)
> {
>         return __label_test_bit(ct, bit);
> }
> 
> /**
>  * nfct_label_get_max - get highest bit set in label vector
>  * \param ct pointer to a valid conntrack object
>  * returns highest bit set, or -1 if no bits are set.
>  */
> int nfct_label_get_max(struct nf_conntrack *ct)
> {
>         return __label_get_max(ct);
> }
> 
> /**
>  * nfct_label_open
>  * \param open the default bit-name mapping file for reading.
>  *
>  * returns a FILE handle to be passed to nfct_label_iterate.
>  */
> void *nfct_label_open(void);
> 
> /**
>  * nfct_label_iterate
>  * \param handle handle obtained from nfct_label_open
>  * \param buf buffer where name will be stored
>  * \param len size of the buffer
>  *
>  * returns the bit the name is mapped to, or -1 when no more
>  * labels are defined.  The handle should be closed via
>  * fclose() once it is of no more interest.
>  */
> int nfct_label_iterate(void *handle, char *buf, size_t len);

One question, what is void *handle? Is it hidding a FILE * or a cache
containing the bitmask?
 
You can define some:

struct nfct_label_handle;

in libnetfilter_conntrack.h, and keep the layout private by defining
it in some internal header.

I'd go for the cache-based approach, ie. store a lookup array in
memory extracted from the file.

> /**
>  * @}
>  */
> 
> Since nfct_label_open() now returns FILE* userspace can provide other
> mapping files as well [ nfct_label_open just looks at the default location ].
> 
> I've killed the functions that took a "const char *labelname" as
> argument; it's error prone to fiddle with hidden file-descriptor
> in the library (not thread-safe...).
> 
> We could later add another library that provides more sophisticated
> stuff, such as a label<->bit cache.
> 
> The patch that i currently have (untested, so I won't send it yet...)
> adds about 300 LOC, i would like to avoid bloating libnetfilter_conntrack
> more than that.

Examples files usually help to see how the API looks in action, if you
can attach one in the next round, in would be great.

Regards.
