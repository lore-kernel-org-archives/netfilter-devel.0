Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792533725;
	b=Dq1ulR1x1jA0ZXmtHknGokavmMQYWaHKvzVtvpQ4Lb/TOuaSslUrjgQ2i/PY+aDVKhUT
	 8MX8pHgoS9i2P4TYJdevXnUVzyWie2xFnYRAgyRZE0Q75qe40faYuzuwwnyD17f6eKt6U
	 JNcnrjKjfEd9uKp2kKv31s5BUJ8UkiUl3p2igcIFwqKyzDTZYYkX/UC3lzcuyed/brPrK
	 0ykSnZjE61YpnTiSuw6FxZCO7Q3xW8B1aIZoChdcpKgJx0Tl0ZQMcuDy6bEiJAjLroFYl
	 SvnHxf+Cvj1D0+YD00/UrCJbvFUfw0qbE7Lhk4gJbEEnQRWkgefOixd4ZgfegVbQOiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792533725;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=cEfg6TQOl4fvtdftJ1/ez1z9HrOcl9TL5QfIsA4wvdg=;
	b=gbVufSkhem4I5ADcAQim5w2HkXT2r3NaIX0oPoiSzcoDmsOtAki6IBExdKTqwjv9UlPe
	 pPmIGtgooPHpkORfO6SW8FtlV1Uwk4MG88LFyF1/dxlIK0L5A9/x2iGrgV+/YSpQ8vy+F
	 YDXlv34oFZIvp426JLm4DRfgJfAbsHmjKo6g1u6fiLQUY4z22Yhn6W5ZW/8cKCXjT+TcO
	 +vHdUDsH6QCmegGM9EhSqRBsrd+UwO+MwjGWUyVMFh0K8qP+RiG7aHQq5rvfc/ByHCh32
	 68fdA709M78YiBENKv8Dm6RMOww8f5/yCeQcJje0LJL+FlLvC1rq6HSdI2dwowkgdEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ip9wkiMf;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A0083606A31B;
	Tue, 20 Oct 2026 22:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0083606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ip9wkiMf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792533717;
	bh=cEfg6TQOl4fvtdftJ1/ez1z9HrOcl9TL5QfIsA4wvdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ip9wkiMfVMx7MNEyEKW99XvsFTthH2wE5b19Gqn6ZHbRwfBfvlPtgkuugLxr0JEF+
	 8HoPCLz8hnRR5Z87lxoX8ZCCd+//N31PxRjgdeUbs1UcTRfWdcmCD2FJWwFMAVECbY
	 ptOZhCRp/Y9m1Gz6jV2oY9i77Md60moI3xOFJd38wGTIMTeeI10qF5FxhjgWK2+sAE
	 +uZ4u0GYF3FvwLl3bvIpRSCTd/N+B1LuEbXWHW6Vcvm/4IUniCNspX6MP+7g9Ehtwe
	 iiUMTPzcni3/RuF+prj0X9RLAeRV3KTaYZrJjEEICQvRVcztojhclzvMUw9jvqH5ke
	 pqUiFbyz1UwBw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E8E8260050;
	Wed, 21 Oct 2026 00:01:56 +0200 (CEST)
Date: Wed, 21 Oct 2026 00:01:53 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 06/10] netfilter: nf_reject: initialize IPCB at inet
 ingress
Message-ID: <atfk0c7OlGd6hxWc@chamomile>
References: <20261019150249.1879516-7-pablo@netfilter.org>
 <179251065552.3135.365430607202597759@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179251065552.3135.365430607202597759@kernel.org>

On Tue, Oct 20, 2026 at 03:37:35PM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0 (1)
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The new IPv6 initializer in nf_send_unreach6() sets
>   IP6CB(skb_in)->iif = skb_in->skb_iif unconditionally.
> 
> Pre-existing issues:
> - [Low] At NF_INET_INGRESS, the reject helpers do not check the L4
>   checksum of CHECKSUM_COMPLETE packets.
> 
> --
> 
> netfilter: nf_reject: initialize IPCB at inet ingress
> 
> The inet ingress hook runs before ip_rcv_core() and ip6_rcv_core(), so
> skb->cb can still hold stale data from an earlier layer. When called from
> NF_INET_INGRESS, nf_send_unreach() and nf_send_unreach6() now clear
> IPCB/IP6CB and restore iif. This stops stale IPv4 option offsets from
> overflowing the stack buffer in __ip_options_echo().
> 
> > diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> > index 59ec465a9df9..7cb33af671e2 100644
> > --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> > +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> > @@ -357,6 +357,11 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
> >  	if (!skb_valid_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
> >  		return;
> >  
> > +	if (hook == NF_INET_INGRESS) {
> > +		memset(IPCB(skb_in), 0, sizeof(*IPCB(skb_in)));
> > +		IPCB(skb_in)->iif = skb_in->skb_iif;
> > +	}
> > +
> >  	if (skb_csum_unnecessary(skb_in) ||
> >  	    !nf_reject_verify_csum(skb_in, dataoff, proto)) {
> >  		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
> 
> [Severity: Low]
> This is a pre-existing issue and was not introduced by this patch. Since
> this path now has NF_INET_INGRESS handling, though: is the L4 checksum of
> a CHECKSUM_COMPLETE packet ever checked at this hook?
> 
> Further down, nf_send_unreach() does:
> 
> 	if (nf_ip_checksum(skb_in, hook, dataoff, proto) == 0)
> 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
> 
> nf_ip_checksum() in net/netfilter/utils.c only verifies for PRE_ROUTING
> and LOCAL_IN:
> 
> 	case CHECKSUM_COMPLETE:
> 		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
> 			break;
> 
> With hook == NF_INET_INGRESS, csum stays 0, and the reject code reads that
> as a good checksum.
> 
> nf_ip6_checksum() has the same check. It affects
> reject6_csum_ok()->icmpv6_send() in nf_send_unreach6(), and also the TCP
> RST path through nf_reject_ip6_tcphdr_get().
> 
> So can an inet ingress reject rule answer a packet with a bad L4 checksum
> with an ICMP/ICMPv6 unreachable or a TCP RST? The same packet would get no
> reply at PRE_ROUTING, or at netdev ingress (NF_NETDEV_INGRESS has the same
> value as NF_INET_PRE_ROUTING).
> 
> Adding NF_INET_INGRESS to that hook list may not be enough on its own. At
> ingress, skb->len can still include link-layer trailer padding, which
> ip_rcv_core()/ip6_rcv_core() would normally trim.
> 
> This came in with commit 117ca1f8920c ("netfilter: nft_reject_inet: allow
> to use reject from inet ingress").
> 
> > diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
> > index 07cdaa10da0d..5e08d8529cc8 100644
> > --- a/net/ipv6/netfilter/nf_reject_ipv6.c
> > +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
> > @@ -444,6 +444,11 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
> >  	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
> >  		skb_in->dev = net->loopback_dev;
> >  
> > +	if (hooknum == NF_INET_INGRESS) {
> > +		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
> > +		IP6CB(skb_in)->iif = skb_in->skb_iif;
> > +	}
> 
> [Severity: Medium]
> The commit message says this matches ip6_rcv_core(). Does that hold for
> packets looped back through lo? ip6_rcv_core() chooses iif based on the
> dst:
> 
> 	IP6CB(skb)->iif = skb_valid_dst(skb) ?
> 				ip6_dst_idev(skb_dst(skb))->dev->ifindex :
> 				dev->ifindex;

There is no dst in the inet/ingress reject path.

This currently does not dst lookup.

This fix aims at a minimal cure for uninitialized access to skb->cb
area.

This fix address the issue reported here by moving this block

        if (hooknum == NF_INET_INGRESS) {
                memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
                IP6CB(skb_in)->iif = skb_in->skb_iif;
        }

after:

        if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
                return;

in nf_send_unreach6().

That should fix this feature in loopback.

But I prefer this patch gets in because it is already improving the
situation.
