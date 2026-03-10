Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25D7271468;
	Tue, 10 Mar 2026 10:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773138838; cv=none; b=gGb6OTR5g+R5GQR/dcbIO6Ai8Y9LdcZkStgVbmiovfMdEMcf41wK/YsHpRaaG/OWqy6EU1Nc8kr0/wduVa0HDgARboYM5En5vAjRDnu3K2LNxwICPDFnNf80mtcBJoMrrMc+dblozHT7YzLvvxFKKWSJzbkA4W9N9gKfoszC08c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773138838; c=relaxed/simple;
	bh=a55lUpeA26zDb/0g4h/jfJ8mwz9U47tGl4tVQmz+BbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hyd1GeFWgMu8+K1ZR2jeGR1WDSiPPt/46/gmQanYIKCQ6TKKz/GJ1YVto9n/lF4PR3e+kvE3YRkJJe44m/hdueFKYyy+DUbdogBzR0ZaZyELrt4cSRUpPZ/MwhvxEDsiYNupW8Xn6vMOqN5vhm3QTk2+FkFIGwV7JQMh/bdduJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Qd7WgNiy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Qd7WgNiy"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8DE3E6055C;
	Tue, 10 Mar 2026 11:33:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773138827;
	bh=tUSmWE2RbjPu+6It5uyYg4McPg3jKQUPLt/9npl99ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qd7WgNiycBeA7rXcR66BE3SIun2alGmDjd+8hy3/qNkWsdsFvIIWe6w+NWtBHaXJK
	 /vNrbt/naN5KfqbEGcA4DxOrD8HZ7jK14krHmH0vbafla3dxeLhKrAOiGYTS4D1Fuq
	 /OFvohcVBUdY8sftOLmbzeeu69bIC8Q5i/dGD9B+pVpIn0t1A58otY8GEHMrtIIOdQ
	 c75rRS0nQI0xyFI/YvgFBTgyekOenxmekxmYCKgJrd89x+RtTUuA0kAPPxDukxIZnP
	 PkEKgGAcpNWJg0HJM+076biq/fG/QkDy5lc8ZEvDmk0z0CyFN4vMcQGFzsiUeje8S7
	 nlU5RQsRFl9/Q==
Date: Tue, 10 Mar 2026 11:33:44 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2 nf] netfilter: nf_flow_table_ip: Introduce
 nf_flow_vlan_push()
Message-ID: <aa_ziMdBBa1kHNhl@chamomile>
References: <20260227162955.122471-1-ericwouds@gmail.com>
 <aa86Ai1FRuJzthEF@strlen.de>
 <5f8c4194-5066-4a55-898f-257bfdce4a6c@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0i2WGxtpAoAh3qoB"
Content-Disposition: inline
In-Reply-To: <5f8c4194-5066-4a55-898f-257bfdce4a6c@gmail.com>


--0i2WGxtpAoAh3qoB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Mar 10, 2026 at 09:25:46AM +0100, Eric Woudstra wrote:
> 
> 
> On 3/9/26 10:22 PM, Florian Westphal wrote:
> > Eric Woudstra <ericwouds@gmail.com> wrote:
> > 
> > Hi Eric
> > 
> >> With double vlan tagged packets in the fastpath, getting the error:
> >>
> >> skb_vlan_push got skb with skb->data not at mac header (offset 18)
> >>
> >> Introduce nf_flow_vlan_push(), that can correctly push the inner vlan
> >> in the fastpath. It is closedly modelled on existing nf_flow_pppoe_push()
> >>
> >> Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
> >> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> >   
> >> +static int nf_flow_vlan_push(struct sk_buff *skb, __be16 proto, u16 id)
> >> +{
> >> +	if (skb_vlan_tag_present(skb)) {
> >> +		struct vlan_hdr *vhdr;
> >> +
> >> +		if (skb_cow_head(skb, VLAN_HLEN))
> >> +			return -1;
> >> +
> >> +		__skb_push(skb, VLAN_HLEN);
> >> +		skb_reset_network_header(skb);
> >> +
> >> +		vhdr = (struct vlan_hdr *)(skb->data);
> >> +		vhdr->h_vlan_TCI = htons(id);
> >> +		vhdr->h_vlan_encapsulated_proto = skb->protocol;
> >> +		skb->protocol = proto;
> >> +	} else {
> >> +		__vlan_hwaccel_put_tag(skb, proto, id);
> >> +	}
> > 
> > I did not apply this because I'm not sure if this preserves correct tag
> > order.  Can you clarify?
> > 
> > Lets consider vlan-offload-doesn't-exist case.
> > 
> > First loop pushes vlan tag 1, we get:
> > 
> >   [vlan1][inet]
> 
> Always !skb_vlan_tag_present (all vlan tags are pulled before the push
> in the fastpath), so vlan1 is always stored in skb->vlan_all.
> 
> > 
> > 2nd items pushes vlan tag 2, we get:
> >   [vlan2][vlan1][inet]
> > 
> 
> The second is pushed directly [vlan2][inet]. At a later moment the
> contents of skb->vlan_all is pushed by SW. Ending up with
> [vlan1][vlan2][inet].
> 
> > Now lets consider with-offload.  We have one tag only, so we get 1 skb with hwaccel
> > tag in the sk_buff.  This is fine, HW will insert it for us.
> > 
> > But now lets consider two tags:
> > 
> > First loop pushes vlan1, we get the vlan1 tag in sk_buff vlan info.
> > Packet is: [inet].
> 
> Correct, so same as SW, vlan1 in skb->vlan_all.
> 
> > 
> > 2nd loop pushes vlan2, we get:
> > 	[vlan2][inet].
> > 
> 
> Correct, [vlan2][inet].
> 
> > Now, when packet is transmitted, where will the HW insert the tag?
> > 
> > [vlan1][vlan2][inet]?
> > Or will this be [vlan2][vlan1][inet]?
> 
> The contents of skb->vlan_all is pushed by HW. Ending up with
> [vlan1][vlan2][inet], same as SW.
> 
> Hope this is enough to clarify, but you can double-check it looking at
> nf_flow_tuple_encap(). With 2 vlan tags, the contents of skb->vlan_all,
> is always vlan1, the first in the encap array, which is the outer tag.

In your patch, if vlan offload is present, then this outer (second)
VLAN header is pushed with the outer vlan ID.

This goes against the assumption that the outer VLAN header is always
offloaded.

Probably it is easier to fix this by resetting the mac header (see
your patch).

But if you prefer, just fix your patch to be similar to
skb_vlan_push().

--0i2WGxtpAoAh3qoB
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix.patch"

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3fdb10d9bf7f..ab58ba0c5ff6 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -738,6 +738,9 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 		switch (tuple->encap[i].proto) {
 		case htons(ETH_P_8021Q):
 		case htons(ETH_P_8021AD):
+			skb_reset_mac_header(skb);
+			skb_reset_mac_len(skb);
+
 			if (skb_vlan_push(skb, tuple->encap[i].proto,
 					  tuple->encap[i].id) < 0)
 				return -1;

--0i2WGxtpAoAh3qoB--
