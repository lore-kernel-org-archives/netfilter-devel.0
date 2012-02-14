From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Tue, 14 Feb 2012 01:46:46 +0100
Message-ID: <20120214004646.GH24194@1984>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
 <alpine.LNX.2.01.1202130940390.30851@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Darren Willis <djw@google.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45645 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab2BNAqt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:46:49 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1202130940390.30851@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 13, 2012 at 10:55:58AM +0100, Jan Engelhardt wrote:
> On Friday 2012-02-10 03:30, Darren Willis wrote:
> 
> >+MODULE_ALIAS("ipv6_conntrack_dhcpv6");
> 
> I see no use for this one.
> 
> >+static int dhcpv6_help(struct sk_buff *skb,
> >+		       unsigned int protoff,
> >+		       struct nf_conn *ct,
> >+		       enum ip_conntrack_info ctinfo)
> >+{
> >+	struct nf_conntrack_expect *exp;
> >+	struct iphdr *iph = ip_hdr(skb);
> >+	if (iph->version == 6) {
> >+		struct ipv6hdr *ip6h = ipv6_hdr(skb);
> >+		if (skb->sk == NULL)
> >+			goto out;
> >+		if (ipv6_addr_is_multicast(&ip6h->daddr)) {
> >+			exp = nf_ct_expect_alloc(ct);
> >+			if (exp == NULL)
> >+				goto out;
> >+			exp->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
> 
> This reeks of http://stackoverflow.com/a/57611/1091587 :)
> And an ip(v4)hdr is not very fruitful in the realm of IPv6.
> How about getting rid of the goto as well, as in
> 
> 	struct nf_conntrack_expect *exp;
> 	const struct ipv6hdr *iph = ipv6_hdr(skb);
> 	if (iph->version == 6 || skb->sk == NULL ||
> 	    !ipv6_addr_is_multicast(&iph->daddr))
> 		return NF_ACCEPT;
> 	exp = nf_ct_expect_alloc(ct);
> 	if (exp == NULL)
> 		return NF_ACCEPT;
> 	exp->tuple = ...
> 	...
> 	return NF_ACCEPT;
> 
> 
> 
> Something for further separate patches on top:
> 
> You probably want to add a test for the skb actually being a
> DHCP message type that desires a reply (DHCPOFFER, etc.)
> before creating the exp.
> 
> >+	nf_ct_refresh(ct, skb, timeout * HZ);
> >	return NF_ACCEPT;
> >+}
> 
> In all cases, NF_ACCEPT is returned - makes some eyebrows raise.
> Upon looking for it, nf_conntrack_ftp.c returns NF_DROP on exp==NULL, so 
> should you.
> It is probably a sane thing to also check that the DHCP packet is 
> looking valid (packet size, flag combinations, etc.)
> 
> Thirdly, your module does not seem to make any attempt (yet) to handle 
> the DHCP v6 RECONFIGURE message.
> 
> The timeout value for the exp could depend on the message type; RFC 
> 3315 defines different timeouts for different message types, up to 600 
> seconds for RENEW/REBOUND. (Is 600 seconds a wise thing?)

I agree with Jan's review.
