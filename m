Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6057D30E833
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2025 22:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750371330; cv=none; b=kDDxNnx6gLJnWJI0AmceB4rhy2WIosS0PRIYNSj8DpqMWcPjTSPLAb38O6xYkyTdtU2QfwO2eYSjvSZ9bd/Pv/swtrkYdx3DjXcVWu0t4jF9ud0sdiCuHy6sszyi2yuPMati70VCnTZgjaZOC4CVpVfITTaDQg277CZRPujEA1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750371330; c=relaxed/simple;
	bh=CdObc4DcA9utv6MV+AAQk5MUzNpH7MovuJgCbaoiBXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g4SdeK4r9h1NxNqsHt+qGP0IY1dMDCe52wkOI8auMbzIIqYfKa21qDokAX+SFDn9+7elrwiny67qANBZ7yAgzqLslA+Ysu+CRqkKxfbFe/hTgBDBc6nVDngsZ1woXdT8ZUNk94Ba8B3dNpUWEE5ZDxj2BilYuntSP8o61a4DJvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MDfHNB6b; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=I8xeU7zK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MDfHNB6b";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="I8xeU7zK"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B496860269; Fri, 20 Jun 2025 00:15:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750371317;
	bh=x9dz9/4k63v4QQKUMSyit3kkNQHBNFxN5kmHHFKsK84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MDfHNB6bi2wqhdgaVOfSN1Agh4kVBiyyTKZINj1twe3CpQujmeKk+IxYaxJd4Wbni
	 d/QRLmEF0YlBy21Yk2IgyImkyZVsH7nU43p0FzjutY29WLtgGCM4T2VpSyUpCX08+L
	 oiiNmPPOuOJyyV6EeysdR03FIF5C74Eas9En6N8wVnGw5EVBWnxz03yACZDKQgGjdz
	 eTG/1K64OcyweOT/S0hO+dL/yxvFHa84M79okf+4kYXoXEwqkxCmZbtKmtSbbq0AJU
	 r4dvoZkZMywAeCRT+7cO9Wy5dQSVnQEcP/Ct8xfbiSi0T+d9greWwnzq4fiXVATQeO
	 MRrUWq/zVNjTA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 68D7F60255;
	Fri, 20 Jun 2025 00:15:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750371316;
	bh=x9dz9/4k63v4QQKUMSyit3kkNQHBNFxN5kmHHFKsK84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I8xeU7zKph1ThpGK/n1nyRhcdctjDuDEJPZ11uK/bjv1kOPRpPk5MF5kHFRc094Fr
	 QhBGCxkSgBnJU1BvIWPtFI6qRXBOpcAEvQ5LwBZ6MFH2J7DG7N9qiFBKLjYHdYVLQs
	 71IhEFpQQA3zbUO8bcRAaZ5FaL5oKrDVsxSh9cWudZhzrooXVKGw1hPfX8NdRTksDU
	 r2h2+BevLhUi7wi4YOZSEl551VLrQ3iGAt/ajALp6pDAbJmN1fxbIqBLlYixpZyVCA
	 CP+rwXKv15FJxEbbzuralYe6I/pywkPGY0ro2IwkD8lVmHth2ORoSu5lkm31icsVGh
	 K0rO71JNvSXmg==
Date: Fri, 20 Jun 2025 00:15:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Christoph Heiss <c.heiss@proxmox.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH conntrack-tools v2 1/2] conntrack: move label parsing
 after argument parsing
Message-ID: <aFSL8jORxYEZZrrD@calendula>
References: <20250617104837.939280-1-c.heiss@proxmox.com>
 <20250617104837.939280-2-c.heiss@proxmox.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250617104837.939280-2-c.heiss@proxmox.com>

Hi Christoph,

On Tue, Jun 17, 2025 at 12:48:33PM +0200, Christoph Heiss wrote:
> Instead of parsing directly inline while parsing, put them into a list
> and do it afterwards.
> 
> Preparation for introduction a new `--labelmap` option to specify the
> path to the label mapping file.

Just a few cosmetic nitpicks on my side.

> Signed-off-by: Christoph Heiss <c.heiss@proxmox.com>
> ---
>  src/conntrack.c | 60 ++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 42 insertions(+), 18 deletions(-)
> 
> diff --git a/src/conntrack.c b/src/conntrack.c
> index 2d4e864..b9afd2f 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -122,6 +122,12 @@ struct ct_cmd {
>  	struct ct_tmpl	tmpl;
>  };
>  
> +struct ct_label {
> +	struct list_head list;
> +	char *name;
> +	bool is_modify;
> +};
> +
>  static int alloc_tmpl_objects(struct ct_tmpl *tmpl)
>  {
>  	tmpl->ct = nfct_new();
> @@ -2963,6 +2969,30 @@ static int print_stats(const struct ct_cmd *cmd)
>  	return 0;
>  }
>  
> +static void parse_and_merge_labels(struct list_head *labels, struct ct_tmpl *tmpl)
> +{
> +	struct ct_label *l, *next;
        struct nfct_bitmask *b;
        unsigned int max;

reverse xmas tree in variable declaration

and line break here after variable declaration block.

I would suggest these variable names:

- label_list instead of labels.
- label instead of l.

the short variable name 'l' usually makes it harder to search for
variables in my editor.

> +	list_for_each_entry_safe(l, next, labels, list) {
> +		unsigned int max = parse_label_get_max(l->name);
> +		struct nfct_bitmask *b = nfct_bitmask_new(max);

> +		if (!b)
> +			exit_error(OTHER_PROBLEM, "out of memory");
> +
> +		parse_label(b, l->name);
> +
> +		/* join "-l foo -l bar" into single bitmask object */
> +		if (l->is_modify) {
> +			merge_bitmasks(&tmpl->label_modify, b);
> +		} else {
> +			merge_bitmasks(&tmpl->label, b);
> +		}

For single statement:

		if (l->is_modify)
			merge_bitmasks(&tmpl->label_modify, b);
		else
			merge_bitmasks(&tmpl->label, b);

Just cosmetic stuff, I hope not to bother you and Florian too much
with this.

> +
> +		list_del(&l->list);
> +		free(l->name);
> +		free(l);
> +	}
> +}
> +
>  static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
>  {
>  	unsigned int type = 0, event_mask = 0, l4flags = 0, status = 0;
> @@ -2973,6 +3003,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
>  	struct ct_tmpl *tmpl;
>  	int res = 0, partial;
>  	union ct_address ad;
> +	LIST_HEAD(labels);
>  	uint32_t value;
>  	int c, cmd;
>  
> @@ -3088,8 +3119,6 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
>  		case 'o':
>  			options |= CT_OPT_OUTPUT;
>  			parse_parameter(optarg, &output_mask, PARSE_OUTPUT);
> -			if (output_mask & _O_CL)
> -				labelmap_init();
>  			if ((output_mask & _O_SAVE) &&
>  			    (output_mask & (_O_EXT |_O_TMS |_O_ID | _O_KTMS | _O_CL | _O_XML)))
>  				exit_error(OTHER_PROBLEM,
> @@ -3162,8 +3191,6 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
>  		case '>':
>  			options |= opt2type[c];
>  
> -			labelmap_init();
> -
>  			if ((options & (CT_OPT_DEL_LABEL|CT_OPT_ADD_LABEL)) ==
>  			    (CT_OPT_DEL_LABEL|CT_OPT_ADD_LABEL))
>  				exit_error(OTHER_PROBLEM, "cannot use --label-add and "
> @@ -3176,22 +3203,13 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
>  				optarg = tmp;
>  			}
>  
> -			char *optarg2 = strdup(optarg);
> -			unsigned int max = parse_label_get_max(optarg);
> -			struct nfct_bitmask * b = nfct_bitmask_new(max);
> -			if (!b)
> +			struct ct_label *l = calloc(1, sizeof(*l));
> +			if (!l)
>  				exit_error(OTHER_PROBLEM, "out of memory");
>  
> -			parse_label(b, optarg2);
> -
> -			/* join "-l foo -l bar" into single bitmask object */
> -			if (c == 'l') {
> -				merge_bitmasks(&tmpl->label, b);
> -			} else {
> -				merge_bitmasks(&tmpl->label_modify, b);
> -			}
> -
> -			free(optarg2);
> +			l->name = strdup(optarg);
> +			l->is_modify = c == '<' || c == '>';
> +			list_add_tail(&l->list, &labels);
>  			break;
>  		case 'a':
>  			fprintf(stderr, "WARNING: ignoring -%c, "
> @@ -3246,6 +3264,12 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
>  		}
>  	}
>  
> +	/* any of these options (might) use labels */
> +	if ((options & (CT_OPT_LABEL | CT_OPT_ADD_LABEL | CT_OPT_DEL_LABEL)) ||
> +	    ((options & CT_OPT_OUTPUT) && (output_mask & _O_CL))) {
> +		labelmap_init();
> +		parse_and_merge_labels(&labels, tmpl);
> +	}
>  
>  	/* we cannot check this combination with generic_opt_check. */
>  	if (options & CT_OPT_ANY_NAT &&
> -- 
> 2.49.0
> 
> 
> 
