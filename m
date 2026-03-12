Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503E63D0933
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 15:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773329824; cv=none; b=c260ZXRdsKAnu/+7AsW+mNrN7x7M+WYMXIJA7hxHkA+g/4axEauVSChKQqGNhqVAcu0YAqL5gP8w13hNCDvAX2Suwe2uw5SQ3G7/ubiRgyv4hAjpGObaxwvNpF+pefmWWLpIrBPdCHBxR0n2WODQKLAvvqyWU/TXVb1w6UM7NKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773329824; c=relaxed/simple;
	bh=nLaLkCYLcZYEQ3kcxDVmVs5yLq9IFl0pcxzeNc60tzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UovTnNgJ68OOs++S7t2dcEp+dCTIObk4ekDufqZocdAsQ1A+RVV8l9VewRHeV+wHyjZkvETnomtQ9C2DViYSMQl7Qo3bQVwkm/X9LDLUn5WkDO06+JUZOdJTrE0dPXBbOoyzR2C92vq2/VRR3ji8MfyyW8ifFbuNNeC/dZx0q6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 553AA6047A; Thu, 12 Mar 2026 16:36:59 +0100 (CET)
Date: Thu, 12 Mar 2026 16:37:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Jenny Guanni Qu <qguanni@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org, klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix OOB read in SIP URI
 port parsing
Message-ID: <abLdnHeh8lEKqqB-@strlen.de>
References: <20260312145506.2192682-1-qguanni@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260312145506.2192682-1-qguanni@gmail.com>

Jenny Guanni Qu <qguanni@gmail.com> wrote:
> In epaddr_len() and ct_sip_parse_header_uri(), after sip_parse_addr()
> parses an IP address, the pointer (dptr or c) may point at or past
> limit. The subsequent check for a ':' port separator dereferences the
> pointer without a bounds check, causing a 1-byte out-of-bounds read.
> 
> Add bounds checks before the dereference in both locations.

I'm not sure.

This bug is real, but I suspect there are many many more bugs in this
code.

> Fixes: 05e3ced297fe ("[NETFILTER]: nf_conntrack_sip: introduce SIP-URI parsing helper")
> Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
> Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
> Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
> Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
> ---
>  net/netfilter/nf_conntrack_sip.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index d0eac27f6ba0..a232054d7919 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -194,7 +194,7 @@ static int epaddr_len(const struct nf_conn *ct, const char *dptr,
>  	}
>  
>  	/* Port number */
> -	if (*dptr == ':') {
> +	if (dptr < limit && *dptr == ':') {
>  		dptr++;
>  		dptr += digits_len(ct, dptr, limit, shift);
>  	}
> @@ -520,7 +520,7 @@ int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
>  
>  	if (!sip_parse_addr(ct, dptr + *matchoff, &c, addr, limit, true))
>  		return -1;
> -	if (*c == ':') {
> +	if (c < limit && *c == ':') {
>  		c++;
>  		p = simple_strtoul(c, (char **)&c, 10);

I'm not sure this check is enough.  simple_strtoul() assumes
a c-string.  Are we dealing with a c-string here?

I suspect the anser is: 'no' and that we depend on 0 bytes appearing in
skb_shinfo at end of network buffer for this to 'work'.

I would prefer to add much stricter constraints everywhere.

Untested example:
static bool sip_parse_port(const char *dptr, const char **endp, const char *limit)
{
        static const unsigned int max = strlen("65535");
        int len = 0;

        /* port is optional, but dptr >= limit indicates malformed
         * sip message.
         */
        if (dptr >= limit)
                return false;

        if (*dptr != ':') /* this is fine, no port provided. */
                return true;

        while (dptr < limit && isdigit(*dptr)) {
                dptr++;
                len++;

                if (len > max)
                        return false;
        }

        /* reached limit while parsing port */
        if (dptr >= limit)
                return false;

        if (endp)
                *endp = dptr;

        return true;
}

@@ -193,11 +225,9 @@ static int epaddr_len(const struct nf_conn *ct, const char *dptr,
                return 0;
        }
 
-       /* Port number */
-       if (*dptr == ':') {
-               dptr++;
-               dptr += digits_len(ct, dptr, limit, shift);
-       }
+       if (!sip_parse_port(dptr, &dptr, limit))
+               return 0;
+
        return dptr - aux;
 }

Whats your take?
