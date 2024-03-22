Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D451F22EF5;
	Fri, 22 Mar 2024 10:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711105019; cv=none; b=XemYA5+nGs9IL4t5OtGuoagPt3FNig10+yE61oUDLk3foxS2ixMZmWLJbsihuq6dEYbFekOGhWMiZ6eKhI/PiqshhzNU6ZcNjkmNEXRwKCQLwZA+bLHs6DEfRJDuIreNczco+UxYKI/bFIFiFjthiiSKeMVJ1UA9U1gL22e6sMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711105019; c=relaxed/simple;
	bh=p5h0Ekt/5OGS/d2f6VAYvbRLErwIl9wceTcWD5HJinU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NfKq8VzfGZrBvBqNpGbsqV3goo0TwCv23LrEPl3KHQU743U8qiY/NfuFvIlu28igMtCyu4sUBsnFXARupjeiOOvDcdkEoRe/oLIcZAzTAqMPZ5a7p6jkkFzUTmX9A4GXkxX3BrZXMNgQtbzXeJTYdoJuwHn59leylqSAevBRScA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=OmC0Gp2/; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="OmC0Gp2/"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 79EE7CC0322;
	Fri, 22 Mar 2024 11:50:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1711104615; x=1712919016; bh=sSXfrbOtKs
	4Rd5Qdr5pjJx6Eu086T6ixg22ddZHLIiY=; b=OmC0Gp2/AgbVCeWXFSHp9Z60Vp
	JkP3AhmWVt+kAd1oDq/XrFcadjKfJrUw+KNJdfTvPsm8PRJXEt4rOA3pMRWs2fVe
	F9r6BkrVxJdySTV1Sz7yuQlM6uiSV2ao95Woqb56FY57wdbOCMOfF0cJDrnH+Cug
	dLJ6GK6z7DQ6opMnY=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Fri, 22 Mar 2024 11:50:15 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id D3444CC00FC;
	Fri, 22 Mar 2024 11:50:13 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id A56B234316B; Fri, 22 Mar 2024 11:50:13 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id A38CC34316A;
	Fri, 22 Mar 2024 11:50:13 +0100 (CET)
Date: Fri, 22 Mar 2024 11:50:13 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Jason Xing <kerneljasonxing@gmail.com>, edumazet@google.com, 
    Florian Westphal <fw@strlen.de>, kuba@kernel.org, pabeni@redhat.com, 
    David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, netdev@vger.kernel.org, 
    Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
In-Reply-To: <ZfyhR_24HmShs78t@calendula>
Message-ID: <2aa340d2-c098-9ed8-4e65-896e1d63c2da@blackhole.kfki.hu>
References: <20240311070550.7438-1-kerneljasonxing@gmail.com> <ZfyhR_24HmShs78t@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi,

On Thu, 21 Mar 2024, Pablo Neira Ayuso wrote:

> On Mon, Mar 11, 2024 at 03:05:50PM +0800, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> > 
> > Supposing we set DNAT policy converting a_port to b_port on the
> > server at the beginning, the socket is set up by using 4-tuple:
> > 
> > client_ip:client_port <--> server_ip:b_port
> > 
> > Then, some strange skbs from client or gateway, say, out-of-window
> > skbs are eventually sent to the server_ip:a_port (not b_port)
> > in TCP layer due to netfilter clearing skb->_nfct value in
> > nf_conntrack_in() function. Why? Because the tcp_in_window()
> > considers the incoming skb as an invalid skb by returning
> > NFCT_TCP_INVALID.
> > 
> > At last, the TCP layer process the out-of-window
> > skb (client_ip,client_port,server_ip,a_port) and try to look up
> > such an socket in tcp_v4_rcv(), as we can see, it will fail for sure
> > because the port is a_port not our expected b_port and then send
> > back an RST to the client.
> > 
> > The detailed call graphs go like this:
> > 1)
> > nf_conntrack_in()
> >   -> nf_conntrack_handle_packet()
> >     -> nf_conntrack_tcp_packet()
> >       -> tcp_in_window() // tests if the skb is out-of-window
> >       -> return -NF_ACCEPT;
> >   -> skb->_nfct = 0; // if the above line returns a negative value
> > 2)
> > tcp_v4_rcv()
> >   -> __inet_lookup_skb() // fails, then jump to no_tcp_socket
> >   -> tcp_v4_send_reset()
> > 
> > The moment the client receives the RST, it will drop. So the RST
> > skb doesn't hurt the client (maybe hurt some gateway which cancels
> > the session when filtering the RST without validating
> > the sequence because of performance reason). Well, it doesn't
> > matter. However, we can see many strange RST in flight.
> > 
> > The key reason why I wrote this patch is that I don't think
> > the behaviour is expected because the RFC 793 defines this
> > case:
> > 
> > "If the connection is in a synchronized state (ESTABLISHED,
> >  FIN-WAIT-1, FIN-WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT),
> >  any unacceptable segment (out of window sequence number or
> >  unacceptible acknowledgment number) must elicit only an empty
> >  acknowledgment segment containing the current send-sequence number
> >  and an acknowledgment..."
> > 
> > I think, even we have set DNAT policy, it would be better if the
> > whole process/behaviour adheres to the original TCP behaviour as
> > default.
> > 
> > Suggested-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> > v2
> > Link: https://lore.kernel.org/netdev/20240307090732.56708-1-kerneljasonxing@gmail.com/
> > 1. add one more test about NAT and then drop the skb (Florian)
> > ---
> >  net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> > index ae493599a3ef..19ddac526ea0 100644
> > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > @@ -1256,10 +1256,21 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
> >  	case NFCT_TCP_IGNORE:
> >  		spin_unlock_bh(&ct->lock);
> >  		return NF_ACCEPT;
> > -	case NFCT_TCP_INVALID:
> > +	case NFCT_TCP_INVALID: {
> > +		int verdict = -NF_ACCEPT;
> > +
> > +		if (ct->status & IPS_NAT_MASK)
> > +			/* If DNAT is enabled and netfilter receives
> > +			 * out-of-window skbs, we should drop it directly,
> 
> Yes, if _be_liberal toggle is disabled this can happen.
> 
> > +			 * or else skb would miss NAT transformation and
> > +			 * trigger corresponding RST sending to the flow
> > +			 * in TCP layer, which is not supposed to happen.
> > +			 */
> > +			verdict = NF_DROP;
> 
> One comment for the SNAT case.
> 
> nf_conntrack_in() calls this function from the prerouting hook. For
> the very first packet, IPS_NAT_MASK might not be yet fully set on
> (masquerade/snat happens in postrouting), then still one packet can be
> leaked without NAT mangling in the SNAT case.
> 
> Rulesets should really need to set default policy to drop in NAT
> chains to address this.
> 
> And after this update, user has no chance anymore to bump counters at
> the end of the policy, to debug issues.
> 
> We have relied on the rule that "conntrack should not drop packets"
> since the very beginning, instead signal rulesets that something is
> invalid, so user decides what to do.
> 
> I'm ambivalent about this, Jozsef?

[I'm putting on my sysadmin hat.]

My personal opinion is that silently dropping packets does not make 
sysadmin's life easier at all. On the contrary, it makes hunting down 
problems harder and more challenging: you have got no indication 
whatsoever why the given packets were dropped.

The proper solution to the problem is to (log and) drop INVALID packets.
That is neither a knob nor a workaround: conntrack cannot handle the 
packets and should only signal it to the rule stack. 

Actually, the few cases where conntrack itself drops (directly causes it) 
packets should be eliminated and not more added.

Do not blind sysadmins by silently dropping packets. 

Jason, the RST packets which triggered you to write your patch are not 
cause but effect. The cause is the INVALID packets.

Best regards,
Jozsef 

> >  		nf_tcp_handle_invalid(ct, dir, index, skb, state);
> >  		spin_unlock_bh(&ct->lock);
> > -		return -NF_ACCEPT;
> > +		return verdict;
> > +	}
> >  	case NFCT_TCP_ACCEPT:
> >  		break;
> >  	}
> > -- 
> > 2.37.3
> > 
> 

-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
