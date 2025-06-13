Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73B5275AE2
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 12:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749817102; cv=none; b=dmp/pnwLpE24iwz3Kn++SBrn5ea3zS9NzhQrhmT4yMYfqyUitj7Qo4NMETFax3okb5deBAYJmvESVytR9fd0xFx+6dEfyQtO3va+cZO26fJJj6+RJXEQQ/JjbOSbrApkrf22VdDtowiiEUPNVkQH+Pa6zqG0QVLsPRT7ExJq07o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749817102; c=relaxed/simple;
	bh=Jey843NytDo9hvvbIpsNUOzFoCoazgepAFdUwCnGPO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kamC4SoXRUiRYVzlC5EerpoylXLTqNOUTFB9kVYliiezQ99zBz/8WTy+CdKdqsTS62LTHGsDVIyUpB6RQCeSUWuICZ3u5LkTqVUMjagCyf690JWBQwUMbMSZWnuKc06WItg5wGD2VoEhGY8HU0DTpmciE0VwSI2LEVKX/pCEiaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EBF5C612CD; Fri, 13 Jun 2025 14:18:08 +0200 (CEST)
Date: Fri, 13 Jun 2025 14:18:08 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Heiss <c.heiss@proxmox.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] conntrack: introduce --labelmap option
 to specify connlabel.conf path
Message-ID: <aEwXADKlOKotEVRi@strlen.de>
References: <20250613102742.409820-1-c.heiss@proxmox.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613102742.409820-1-c.heiss@proxmox.com>

Christoph Heiss <c.heiss@proxmox.com> wrote:
> Enables specifying a path to a connlabel.conf to load instead of the
> default one at /etc/xtables/connlabel.conf.
> 
> nfct_labelmap_new() already allows supplying a custom path to load
> labels from, so it just needs to be passed in there.

Makes sense, patch looks good to me.

>  3 files changed, 46 insertions(+), 25 deletions(-)
> 
> diff --git a/conntrack.8 b/conntrack.8
> index 3b6a15b..2b6da25 100644
> --- a/conntrack.8
> +++ b/conntrack.8
> @@ -189,6 +189,13 @@ This option is only available in conjunction with "\-L, \-\-dump",
>  Match entries whose labels include those specified as arguments.
>  Use multiple \-l options to specify multiple labels that need to be set.
>  .TP
> +.BI "--labelmap " "PATH"
> +Specify the path to a connlabel.conf file to load instead of the default one.
> +This option is only available in conjunction with "\-L, \-\-dump", "\-E,
> +\-\-event", "\-U \-\-update" or "\-D \-\-delete". Must come before any of
> +"\-l, \-\-label", "\-\-label\-add" or "\-\-label\-del", otherwise the argument is
> +ignored.
> +.TP
>  .BI "--label-add " "LABEL"
>  Specify the conntrack label to add to the selected conntracks.
>  This option is only available in conjunction with "\-I, \-\-create",
> diff --git a/include/conntrack.h b/include/conntrack.h
> index 6dad4a1..317cab6 100644
> --- a/include/conntrack.h
> +++ b/include/conntrack.h
> @@ -78,7 +78,7 @@ enum ct_command {
>  };
>  
>  #define NUMBER_OF_CMD   _CT_BIT_MAX
> -#define NUMBER_OF_OPT   29
> +#define NUMBER_OF_OPT   30
>  
>  struct nf_conntrack;
>  
> diff --git a/src/conntrack.c b/src/conntrack.c
> index 2d4e864..9850825 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -249,6 +249,9 @@ enum ct_options {
>  
>  	CT_OPT_REPL_ZONE_BIT	= 28,
>  	CT_OPT_REPL_ZONE	= (1 << CT_OPT_REPL_ZONE_BIT),
> +
> +	CT_OPT_LABELMAP_BIT	= 29,
> +	CT_OPT_LABELMAP		= (1 << CT_OPT_LABELMAP_BIT),

Why is this needed?

> +static char *labelmap_path;
>  static struct nfct_labelmap *labelmap;
>  static int filter_family;
>  
> @@ -2756,7 +2764,7 @@ static void labelmap_init(void)
>  {
>  	if (labelmap)
>  		return;
> -	labelmap = nfct_labelmap_new(NULL);
> +	labelmap = nfct_labelmap_new(labelmap_path);
>  	if (!labelmap)
>  		perror("nfct_labelmap_new");
>  }
> @@ -3212,6 +3220,10 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
>  			socketbuffersize = atol(optarg);
>  			options |= CT_OPT_BUFFERSIZE;
>  			break;
> +		case 'M':
> +			labelmap_path = strdup(optarg);

Should this exit() if labelmap_path != NULL?

> +	if (labelmap_path)
> +		free(labelmap_path);

free(NULL) is ok, so no need for the conditional.

Patch looks fine, but I think it would be good to have a preparation
patch that moves all labelmap_init() calls from do_parse() to into
do_command_ct().

Then the option ordering would not matter anymore.
