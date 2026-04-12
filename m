Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FB5201113;
	Sun, 12 Apr 2026 16:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776012900; cv=none; b=XX+uqeL2lrlGATgKaJ6j/WmctDcQoTi0jotSHgZaiAzLHwVP3u2UYkZ/JFnqk1mjy+rkftG2AIa6JKkBEEgsVF49ELSCYUXy0krzTnhOZOm/LWLmNu37yZiX+HzCS9DguXANczS3/JvskkgbnHRSrEYyRtb0s/lQTJxoGUcq/No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776012900; c=relaxed/simple;
	bh=mfCDb1wTLzEZ0086Uc8EtQKquHg23wphbTpWO/EeuNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CD1y0fYgJLMpm7FK1MVuUEsrbcqGToqf4yA/fkno5O97MgYI3gve0vE0oc4TD6L8/Z+p0gS7/c/l+FvvWr3bbsp3/RWQFlto41hRlTmWIj7jygx+peslJ16KiqjRiQ7G7c4lu1jddZTiW+bJtDE9IAkp9iCRGV1yDDDZb9uHO8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8FF8D60490; Sun, 12 Apr 2026 18:54:49 +0200 (CEST)
Date: Sun, 12 Apr 2026 18:54:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 00/11] netfilter: updates for net-next
Message-ID: <advOUl92VLlqaiCJ@strlen.de>
References: <20260410112352.23599-1-fw@strlen.de>
 <20260412094049.7b01dd7b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260412094049.7b01dd7b@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 10 Apr 2026 13:23:41 +0200 Florian Westphal wrote:
> > 1-3) IPVS updates from Julian Anastasov to enhance visibility into
> >      IPVS internal state by exposing hash size, load factor etc and
> >      allows userspace to tune the load factor used for resizing hash
> >      tables.
> 
> Someone should take a look at the Sashiko reports for those, please?

https://sashiko.dev/#/patchset/20260410112352.23599-1-fw%40strlen.de

Sorry Pablo I am dumping this on you.  Already wasted 3h on saturday
on LLM crap 8-(

---------
Could this trigger the DEBUG_NET_WARN_ON_ONCE() inside skb_mac_header_len()?
If a user program sends a verdict containing the NFQA_L2HDR attribute for a
packet where the MAC header is not set, it seems this code would call
skb_mac_header_len() without first checking skb_mac_header_was_set(entry->skb).
---------

And thus a new era of cargo cult programming will be born.

Because I have no idea how on earth PF_BRIDGE packets cannot have
a mac header attached to them.

Do I add this check as LLM overlord demands?

-------------
Is it safe to access the IP header here without ensuring the packet length
is sufficient and the header is in the linear data area?
Looking at the surrounding code in nft_fwd_neigh_eval(),
skb_try_make_writable() is called with sizeof(*iph), which is 20 bytes. At
the netdev hook, skb->data points to the MAC header, meaning the 20 bytes
only covers the Ethernet header and the first 6 bytes of the IP header.
Should this code use pskb_may_pull() or skb_ensure_writable() with an
offset that accounts for skb_network_offset(skb) + sizeof(*iph) before
dereferencing iph->ttl to avoid out-of-bounds accesses?
-------------

Dunno.  Existing code does that.
