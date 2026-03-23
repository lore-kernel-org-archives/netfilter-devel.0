Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF7E3DF014
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2026 20:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774298682; cv=none; b=O16v+1LzptyOaytakAt461Ke5/NRIBZnQPOnp4r+kXp7bcF83ZumYWLFtf7ysRrRNx+LNtU5KQrsD5RYoPY3IQBVxYaW/DWL/FPduYTWC9rM45PGl7WD/LzSNeUS/31mpnUTc1M7KqZY9t6d69AEAmiHaf+L9I43UiSgolN6X5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774298682; c=relaxed/simple;
	bh=hMEiijTr+QrN/3sITfuv7cI4A3qIFAMwNzPLdm0negY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sOq0FDehfPxjlUt35md2607Tzef2W4QQtUIiz0WLUA4lbl+m1EYIXxR9rRbOVjxNdRZeSkL2WRK3wMJOZgN5ZqIwM0QtprWvlCgBSXwd6D3eUpQVtYwWC42TK3niQSWSAMEf3FniDETYUfy/PuhLzB4TiLPPGHsN/vFmduISNJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CkH6845A; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CkH6845A"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8772260177;
	Mon, 23 Mar 2026 21:44:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774298676;
	bh=ODqWlZMtNg9EOfxXl3ejcpoRZqxm5XmgPdXu9YeYiBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CkH6845AL3GM2bLOevdaYn917XAgoUT4OgvYKRVWZUp0Z5WYkR3V7NfMfCaqAC5bV
	 n8t11B65Lgu8qoPvSLxhaU/KJUJ76Y7C3cnqAeniC41Ya4CgnR49geKOnlVDMXWPqm
	 JbsyhajSbn5RZVLqLZnE/SxLnmrHkFhSB2Fjp/+SD52PJFHO9A4WYioatNItp2ETkx
	 ONgqHU9PJIRW8qczn/Bd4/z1ShnPWUHYKFOwmCESED7CnSXo4EkmRAIroB6o7JXWBQ
	 MjI39zAFWxpEmWANk9Qt+wQGgRvuDmxcvzdcAKAEbFNAT490g5uzJYTIEeaK7um5B+
	 L4DYq/hfJ9VWQ==
Date: Mon, 23 Mar 2026 21:44:33 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: Re: [PATCH nf-next,v2] netfilter: nft_meta: add double-tagged vlan
 and pppoe support
Message-ID: <acGmMZJSUFcT_6au@chamomile>
References: <20260322225147.469027-1-pablo@netfilter.org>
 <acF-pua5PjDy_UhO@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acF-pua5PjDy_UhO@chamomile>

On Mon, Mar 23, 2026 at 06:55:50PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Mar 22, 2026 at 11:51:47PM +0100, Pablo Neira Ayuso wrote:
> > Currently:
> > 
> >   add rule netdev x y ip saddr 1.1.1.1
> > 
> > does not work with neither double-tagged vlan nor pppoe packets. This is
> > because the network and transport header offset are not pointing to the
> > IP and transport protocol headers in the stack.
> > 
> > This patch expands NFT_META_PROTOCOL and NFT_META_L4PROTO to parse
> > double-tagged vlan and pppoe packets so matching network and transport
> > header fields becomes possible with the existing userspace generated
> > bytecode. Note that this parser only supports double-tagged vlan which
> > is composed of vlan offload + vlan header in the skb payload area for
> > simplicity.
> > 
> > NFT_META_PROTOCOL is used by bridge and netdev family as an implicit
> > dependency in the bytecode to match on network header fields.
> > Similarly, there is also NFT_META_L4PROTO, which is also used as an
> > implicit dependency when matching on the transport protocol header
> > fields.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: - Fix typo comment "packer" -> "packet".
> >     - Add comment to clarify this support double-tagged vlan with
> >       vlan offload + vlan header in skb data area.
> >     - remove nft_meta_protocol_store() helper function.
> >     Note: IPv6 still untested here.
> 
> PPPoE with IPv4 and IPv6 is working, but there is an issue with VLAN.
> 
> I will post a v3, apologies.

No need for v3, actually this works fine/tested with:

- vlan
- pppoe
- vlan/pppoe
- vlan/vlan

testing with a simple ruleset that matches on layer 3 and 4:

table netdev x {
        chain y {
                type filter hook ingress device eth0 priority 0;
                ip daddr 1.1.1.1 udp sport 12345 counter
        }
}

so let's just reinstantiate this patch in patchwork as under review.
