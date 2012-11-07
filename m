From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC v2] netfilter: add connlabel conntrack extension
Date: Wed, 7 Nov 2012 21:04:28 +0100
Message-ID: <20121107200427.GB12876@breakpoint.cc>
References: <1351860231-5434-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41064 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577Ab2KGUE3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:04:29 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@strlen.de>)
	id 1TWBrQ-0001x9-2K
	for netfilter-devel@vger.kernel.org; Wed, 07 Nov 2012 21:04:28 +0100
Content-Disposition: inline
In-Reply-To: <1351860231-5434-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Further plans:
>  - extend ctnetlink to send a label bit-vector to userspace, or
>    remove/attach labels from/to connections.

I've implemented this via CTA_LABELS attribute, which
is a unsigned long[] blob; each bit set indicates that the
connlabel is set on the given connection.

CTA_LABELS is sent to userspace via ctnetlink, it may also be
used to replace the labels currently assigned to a connection
by sending request with CTA_LABELS attribute set to the kernel.

>  This would also require extending libnetfilter_conntrack to provide
>  some meaningful abstraction; I'll send a separate email with an API
>  proposal before working on this, though.

I propose to add following API calls:

int nfct_label_set(struct nf_conntrack *ct, const char *label);

	sets the label 'label' on the ct object.

void nfct_label_unset(struct nf_conntrack *ct, const char *label);

	opposite, label is cleared if it was set.

int nfct_label_get_max(const struct nf_conntrack *ct);

	returns the highest label-bit currently set on the connection,
	or -1 if none is set.

int nfct_label_get(const struct nf_conntrack *ct, int bit, char *buf,
				size_t len);

fills buf (up to size len) with the name of the label identified
by 'bit', if it is currently set on the conntrack.

returns -1 on error (i.e., label was not set), else length of the name.

Can be used together with nfct_label_get_max() to iterate over all the
labels set on the object, e.g. something like

for i = 0; i < nfct_label_get_max(ct); i++
	if (nfct_label_get(ct, i, buf, len) > 0)
		printf("label: %s (bit %d)\n", buf, i);

open question is how the library should do the mapping, i.e.
should it hard-code a path to the mapping file (currently
its /etc/xtables/connlabel.conf in my iptables-patch).

I think exposing it makes no sense since noone could know
where the file would be located on a given system.

Also, should we add calls to iterate of the entire set of
configured labels, e.g. something like

void *nfct_label_open(void);
void nfct_label_close(void *);
int nfct_label_iterate(void *fp, char *buf, size_t buflen);

so you could do
void *h = nfct_label_open();
int bit;
while ((bit = nfct_label_iterate(h, bufm sizeof(buf))) > 0)
	printf("bit %d: %s\n", bit, buf);

?

If there are no objections/suggestions i'll have a stab at adding
this to libnetfilter_conntrack.

Thanks,
Florian
