Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7283ECBE2;
	Fri, 17 Jul 2026 17:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784310094; cv=none; b=jzEN3fFwOHBZd5xjPO7j9UKzyEOtgd8PKOzlJTrPWBbUgFnrym9DRkEo2wRPkocokPjYyax1nGXEMs9C4vjdNKnyhdjZ36lxtYfu236tBgcyXsbvvV5OHDfTBB/UitbCjCuD4aquOas6q+wW/sj8EaAPxARv1ysc2VxobYp+Vdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784310094; c=relaxed/simple;
	bh=2dkWwyPzlKkKFNt2/pQ7QPzYHYY5xILeNtLZ9EGUNzM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WmMjwnY8n36tAthkdahtQAyMcFlcwYJn1xWsiAdkCsuPPlAowXZsTSL2a6J8uG87HD60yJt/DUvf1EiIAu5ijETIF7FDgGsKcFegSq/YOPEt9AIcJlaMCp1aZiz4G7YZitdjmAMRE7N5mLOnas5LBnuPCJCNUqFRnblnhpvAq8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=DcENfLX3; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="DcENfLX3"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 2974221B59;
	Fri, 17 Jul 2026 20:41:20 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=FT48w2Qqspin9Ty3SWm4VXe9uwMrmWlNsNRsKal69tY=; b=DcENfLX3J0PQ
	izwgNkR3027zqW9VYUwT4LIkFlUgMu3+rECgBGTP9bCRdU4Q+KpdSL4d2N+UGba2
	4Myq26SeXnBT4JMZwdnjShur5JisD9/+2D0fNMFsoa0hy6lagdSBqUhp4bXggwjg
	ji913AG2n94NR/mwOPFb6PP202wsbQ+m2sCiSzHSbqwDLeSJ8hNLf9DbxRVjHqJd
	eo2W1JQhEBeWWfGk0xzTz6UfLkPel96v7HGsMQ3G6AgJLdDEiDm+NVol4pcY5y0t
	vdi4FPNNdPNsZhHu47gZFHRKudbocQukbkOxZAf87ZhlKuQ4aoN9tsxe+yOgLQDB
	TJqEXWxaR+ZclVr+h/iM/kR6HWt5s9i+ed/tEhVGNPC17h5sVd8SrFBqrQanYhCy
	sMPLjSiDm9MSCv3C1q5HvpO9mMI3Cuk+BPjufGIuOyxgIq5jAT2J/nF9DY/+rKb/
	QnN++ljfmHmzMbUL1Yd9ZLpqOsV142yCI4dYcYwQYpCsmTWiL7lm7s+ksSElPnLS
	PgpW9iKyuTZYNY4JARVn+tZRYn5K0yWBA1tdH/x13qQUWq5Qg4Nq6sS8QbR/3Dga
	IFV62ukWeRSHqOJ48g/9PQ3+vcFzWhQryrIXrHHmHcAk8K7BvJmYp9lro2D3XEem
	UtpgPelEi9X3A6QP6LX+/NA/+JRaUcA=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Fri, 17 Jul 2026 20:41:20 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id DEC5C60948;
	Fri, 17 Jul 2026 20:41:20 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 66HHfJUL062786;
	Fri, 17 Jul 2026 20:41:19 +0300
Date: Fri, 17 Jul 2026 20:41:19 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Paolo Abeni <pabeni@redhat.com>
cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net 8/9] ipvs: fix more places with wrong ipv6 transport
 offsets
In-Reply-To: <e7ed31d3-a3aa-427a-8e82-aa65b4388368@redhat.com>
Message-ID: <37bd52c6-1ad6-00a9-fa79-e4139ebed025@ssi.bg>
References: <20260710143733.29741-1-fw@strlen.de> <20260710143733.29741-9-fw@strlen.de> <e7ed31d3-a3aa-427a-8e82-aa65b4388368@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Fri, 17 Jul 2026, Paolo Abeni wrote:

> Hi,
> 
> On 7/10/26 4:37 PM, Florian Westphal wrote:
> > From: Julian Anastasov <ja@ssi.bg>
> > 
> > Sashiko reports for more incorrect IPv6 transport offsets.
> > 
> > The app code for TCP was assuming IPv4 network header
> > even after the ipvsh argument was provided. This can
> > cause problems with apps over IPv6. As for the only
> > official app in the kernel tree (FTP) this problem is
> > harmless because we use Netfilter to mangle the FTP
> > ports and we do not adjust the TCP seq numbers.
> > 
> > Also, provide correct offset of the ICMPV6 header in
> > ip_vs_out_icmp_v6() for correct checksum checks when
> > the IPv6 packet has extension headers.
> > 
> > Fixes: d12e12299a69 ("ipvs: add ipv6 support to ftp")
> > Fixes: 2a3b791e6e11 ("IPVS: Add/adjust Netfilter hook functions and helpers for v6")
> > Cc: stable@vger.kernel.org
> > Link: https://sashiko.dev/#/patchset/20260706101624.69471-1-zhaoyz24%40mails.tsinghua.edu.cn
> > Signed-off-by: Julian Anastasov <ja@ssi.bg>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  net/netfilter/ipvs/ip_vs_app.c  | 10 ++++------
> >  net/netfilter/ipvs/ip_vs_core.c |  3 +--
> >  2 files changed, 5 insertions(+), 8 deletions(-)
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
> > index d54d7da58334..b0e00be85cb1 100644
> > --- a/net/netfilter/ipvs/ip_vs_app.c
> > +++ b/net/netfilter/ipvs/ip_vs_app.c
> > @@ -361,14 +361,13 @@ static inline int app_tcp_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb,
> >  				  struct ip_vs_iphdr *ipvsh)
> >  {
> >  	int diff;
> > -	const unsigned int tcp_offset = ip_hdrlen(skb);
> >  	struct tcphdr *th;
> >  	__u32 seq;
> >  
> > -	if (skb_ensure_writable(skb, tcp_offset + sizeof(*th)))
> > +	if (skb_ensure_writable(skb, ipvsh->len + sizeof(*th)))
> >  		return 0;
> >  
> > -	th = (struct tcphdr *)(skb_network_header(skb) + tcp_offset);
> > +	th = (struct tcphdr *)(skb_network_header(skb) + ipvsh->len);
> 
> Beyond the usual set of pre-existing issues, sashiko-gemini noted this
> patch may need a follow-up:
> 
> https://sashiko.dev/#/patchset/20260710143733.29741-2-fw%40strlen.de

	I'll provide fix to continue supporting non-zero
network offset but I already don't remember what is the use
case. As for the handle_response_icmp() checksum validation
problem I'm still working on the patch.

Regards

--
Julian Anastasov <ja@ssi.bg>

