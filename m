From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] libiptc: add symbol maps to libiptc
Date: Fri, 30 Dec 2011 12:48:59 +0100
Message-ID: <20111230114859.GA12204@1984>
References: <1325209595-23244-1-git-send-email-jengelh@medozas.de>
 <1325209595-23244-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48936 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab1L3LtC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Dec 2011 06:49:02 -0500
Content-Disposition: inline
In-Reply-To: <1325209595-23244-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Fri, Dec 30, 2011 at 02:46:33AM +0100, Jan Engelhardt wrote:
> This is mostly cosmetic, as using a libxtables.so with a too old
> libiptc should now say something about "version symbol LIBIP4TC_1.4.13
> required" (or so) instead of just "unknown symbol: iptc_ops".
> 
> Reported-by: Pablo Neira Ayuso
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  libiptc/Makefile.am  |   10 +++++++-
>  libiptc/libip4tc.map |   52 +++++++++++++++++++++++++++++++++++++++++++++++++
>  libiptc/libip6tc.map |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 113 insertions(+), 2 deletions(-)
>  create mode 100644 libiptc/libip4tc.map
>  create mode 100644 libiptc/libip6tc.map
> 
> diff --git a/libiptc/libip4tc.map b/libiptc/libip4tc.map
> new file mode 100644
> index 0000000..f978b50
> --- /dev/null
> +++ b/libiptc/libip4tc.map
> @@ -0,0 +1,52 @@
> +LIBIP4TC_1.0.0 {
> +global:
> +	iptc_builtin;
> +	iptc_init;
> +	iptc_is_chain;
> +	iptc_strerror;
> +local:
> +	*;
> +};
> +
> +LIBIP4TC_1.4.1 {
> +global:
> +	dump_entries;
> +};

I think this can be done much simpler. You can with the current symbol
list by the iptables version that includes the first symbol map, e.g:

LIBIP4TC_1.4.13 {
... all exported symbols here ...
}

Then, if you add new symbols in the hypothetical 1.4.14 release, add:

LIBIP4TC_1.4.14 {
... new symbols here ...
} LIBIPT4TC_1.4.13

and so on.

No old binaries will refer to old symbols that you have defined. See
`nm' utility, e.g.:

$ nm .libs/conntrack_dump
[...]
0000000000400930 T main
                 U nfct_callback_register
                 U nfct_close
                 U nfct_open
                 U nfct_query
                 U nfct_snprintf

No symbol maps in libnetfilter_conntrack. Thus, old binaries refer to
them without requesting any specific version.

In libmnl, we have symbol maps:

$ nm .libs/genl-family-get
[...]
                 U mnl_attr_get_payload@@LIBMNL_1.0
                 U mnl_attr_get_payload_len@@LIBMNL_1.0
                 U mnl_attr_get_str@@LIBMNL_1.0
                 U mnl_attr_get_type@@LIBMNL_1.0
                 U mnl_attr_get_u16@@LIBMNL_1.0
                 U mnl_attr_get_u32@@LIBMNL_1.0
                 U mnl_attr_next@@LIBMNL_1.0
                 U mnl_attr_ok@@LIBMNL_1.0

So, binaries ask for specific version.

Old iptables binaries will not benefit for such fine definition that
you're proposing.

Moreover, I remember to have read that once you start using symbol
maps, you only bump the revision field of the c:r:a library version
numbers.

I looked into this time ago (and I'm telling you by heart), so please
correct me if I'm wrong.
