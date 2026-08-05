Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B24324716;
	Wed,  5 Aug 2026 04:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785903507; cv=none; b=Ft2TyCSfHEGgKJhylTzhLNGHnKy3G4tbYMTZVYdwDilRGiUNHVLOr2mj7S+p9GCPI94hDTkojdbRmIJUIgj9zbJP27bS0lj2fmNkObriLWtkq/Ye4xCgQ+PDQR8v7bbDwBLK9AkwHpw8TZWqtaAAQlaaFEfeu0ufPRW6dLQ0iI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785903507; c=relaxed/simple;
	bh=XUQ/5p0vw0zVEQFmjsfYtLhCS4HGIvX+Fo2tFLPu9h4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aPIDhMdv0saE1oxXLKs7nae5jTfdX4POSKpdVIvwlJXFwLZx98LE/jWsBLyT7kRjAHKEfztqfxaIIbqIAkDVVnMzAevgqadDekfnNhfReZudwpl+mVlmZEG7Wtqnr6hGBiGVmY3AcQ70eiS3wPyEq38BhYOH/tzB0wfxiLhM0Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=QVoAP7of; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="QVoAP7of"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id F023621CB3;
	Wed, 05 Aug 2026 07:18:17 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=GuuHhZMYTRGY80ss6IHD4pWUrr/VGLldq8C9VCzhnqU=; b=QVoAP7ofyKQp
	QvkulT53n4ivDJLZQbV97I+FeQ/mA3eGSEkUZDusZoSjSVcnPf59WMX/CkfuljKL
	QJYguVu8EZRJ2VvbKEmO7W+CdaRaSf/uJza7+S/+OmxhWU/OGa/7IXoIsR2CPvlr
	v9WlJqCVxlrLIrvi05diAoDQXnadT0znPy4vn7gkPKqGs7UtNij4KFlzvbnAiy7T
	ynwsUGGpyPZeCAjJA39Y6J+KvXZsM2wecU4mc/mrryieHYVSOun2aE3mAG+Ll/GB
	am5XUoF2TC5B6XHBB8GAgOsaBLTV1Gump9ck8D5pJcHbZOIoAtcthyjCdvtMrmjS
	m91FiSlwf2lSRGo0jnWH9J+EBlymk4dpnEhgZS6TEtzJZhAxZ59SqVFKXQSH6tOc
	drTPeqCld/CBIzXJeIreudclX1oC3bjZkvDK3DewoidKJkC/1UubHQFNvOLRBGAg
	P1sVoD40dAlzgSZLzDVq8DIBfXW8ABH3Ecd/40dQaVxhaEYASPYF10PoaIMmm28b
	gibDVr7UaUZgNb+m6FcekigKXta/AvL+FzwIJyoTr7Jh+cMMS0agBdNI3LD7tx59
	2IxvJ5c6hSZ8BvP0v0ij3Xqi2dc+VvM0hvI7nYJWrDyfNB07foHOypRcL1RL+BU+
	KNaJda4oitQhR55AurF1omujlP3f+Js=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Wed, 05 Aug 2026 07:18:17 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 46BFF60A8F;
	Wed,  5 Aug 2026 07:18:18 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 6754IE8O010992;
	Wed, 5 Aug 2026 07:18:14 +0300
Date: Wed, 5 Aug 2026 07:18:14 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Jakub Kicinski <kuba@kernel.org>
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net 08/10] ipvs: avoid out-of-bounds write in
 ip_vs_nat_icmp
In-Reply-To: <20260805001534.3978877-1-kuba@kernel.org>
Message-ID: <94204793-387d-c4f4-cdbd-c5876739ad1c@ssi.bg>
References: <20260731151806.849724-9-pablo@netfilter.org> <20260805001534.3978877-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Tue, 4 Aug 2026, Jakub Kicinski wrote:

> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> ipvs: avoid out-of-bounds write in ip_vs_nat_icmp
> 
> This passes the already-parsed ip_vs_iphdr down into ip_vs_nat_icmp() so
> the embedded transport header offset comes from ciph->len instead of a
> second read of the inner IPv4 ihl field.  The IPv4 header sanity checks in
> ip_vs_out_icmp() and ip_vs_in_icmp() are also reworked to read ihl only
> once.
> 
> Link: https://sashiko.dev/#/patchset/20260722101517.36313-1-ja%40ssi.bg
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > index 6b79e0c4d9e28..0bdaeb4ed61e4 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > @@ -925,28 +925,27 @@ static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
> >   */
> >  void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
> >  		    struct ip_vs_conn *cp, int inout, unsigned int toff,
> > -		    bool has_ports)
> > +		    bool has_ports, struct ip_vs_iphdr *ciph)
> >  {
> >  	struct iphdr *iph	 = ip_hdr(skb);
> >  	struct icmphdr *icmph	 = (struct icmphdr *)(skb->data + toff);
> > -	struct iphdr *ciph	 = (struct iphdr *)(icmph + 1);
> > -	unsigned int coff __maybe_unused = toff + sizeof(struct icmphdr);
> > +	struct iphdr *cih	 = (struct iphdr *)(icmph + 1);
> >  
> >  	if (inout) {
> >  		iph->saddr = cp->vaddr.ip;
> >  		ip_send_check(iph);
> > -		ciph->daddr = cp->vaddr.ip;
> > -		ip_send_check(ciph);
> > +		cih->daddr = cp->vaddr.ip;
> > +		ip_send_check(cih);
> >  	} else {
> >  		iph->daddr = cp->daddr.ip;
> >  		ip_send_check(iph);
> > -		ciph->saddr = cp->daddr.ip;
> > -		ip_send_check(ciph);
> > +		cih->saddr = cp->daddr.ip;
> > +		ip_send_check(cih);
> >  	}
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but the two ip_send_check(cih)
> calls here still read the inner ihl field a second time, which looks like
> the same multi-read pattern the commit message describes fixing in this
> function.
> 
> ip_send_check() takes its own fresh read of ihl and checksums 4 * ihl
> bytes:
> 
> net/ipv4/ip_output.c:ip_send_check() {
> 	iph->check = 0;
> 	iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
> }
> 
> The only length the callers guarantee is the snapshot value ciph->len (plus
> 4 when ports are mangled):
> 
> net/netfilter/ipvs/ip_vs_core.c:handle_response_icmp() {
> 	unsigned int ctoff = ciph->len;
> 	...
> 		ctoff += 2 * sizeof(__u16);
> 	if (skb_ensure_writable(skb, ctoff))
> 		goto out;
> 	...
> 		ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph);
> }
> 
> ciph->len was computed earlier in ip_vs_fill_iph_skb_off() as
> offset + iph->ihl * 4 from a skb_header_pointer() snapshot, and
> skb_ensure_writable() -> pskb_may_pull() re-copies the bytes out of the
> fragments, so the ihl byte ip_send_check() then reads can differ from the
> one that sized the validated window.
> 
> If the fresh ihl is larger than the snapshot value, can ip_fast_csum() read
> up to 40 bytes past what skb_ensure_writable() guaranteed, and fold
> adjacent skb memory into the inner header checksum that is emitted?
> 
> If the fresh ihl ends up below 5 (for example the version/ihl byte going
> from 0x45 to 0x40, compensated in tot_len so both the inner IP and ICMP
> checksums stay valid), some architectures do not tolerate it:
> 
> arch/mips/include/asm/checksum.h:ip_fast_csum() {
> 	word += 4;
> 	do {
> 		csum += *word;
> 		carry = (csum < *word);
> 		csum += carry;
> 		word++;
> 	} while (word != stop);
> }
> 
> with stop = iph + ihl, so for ihl <= 4 the loop termination is never hit.
> 
> arch/s390/include/asm/checksum.h:ip_fast_csum() {
> 	ihl -= 4;
> 	while (ihl--)
> 		csum += *ptr++;
> }
> 
> where ihl == 0 underflows into roughly four billion forward word reads.
> 
> Would it make sense to checksum over the validated length
> (ciph->len - ciph->off), or to re-validate version/ihl after
> skb_ensure_writable(), matching what was done for the port offset?

	New version of this patch was delayed on friday with
some hours, so now I have a separate fix that revalidates ihl,
ready to be applied on top of this patch...

Regards

--
Julian Anastasov <ja@ssi.bg>

