Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976FC226CFE
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 22:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781045828; cv=pass; b=Qmd4FjmL0lE1cUxebIoFJuIOjwog4cVjhpc/60iqyiEvLPkslxKH5TapgBHRxGvbAoY68+cA2Jr2YXJdQjJ8pDfhDaWAjRAm8cD2eYrfQjzzhY0yTwwIk+AZIhg0lFkiWDJPX40CpCzqXBLtZf+ImONZ8v7NBucnkQEOFI6gyYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781045828; c=relaxed/simple;
	bh=FJVNHzxPnmF861w/IYvmWTP6kYwvaOT2RUNaoEZTad8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ocJR7ER5od/2DCyobSbJ/cvN9/dbetupGpjnYUPwr03dsZP8A2td8Wmx78BjF6dxFgd6ZNngHSK0aNIADqlsmVbshnxp1MtDz2OdQtNMCVvY7bT6uGJ7Sz5dV/6ihL9KZ1usRnP6yg48U9B9chbbh1eSfQ9ylgv74VzsQlvKL/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=i0LGsEPZ; arc=pass smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="i0LGsEPZ"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c0c1e0b0faso42147465ad.0
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jun 2026 15:57:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781045826; cv=none;
        d=google.com; s=arc-20240605;
        b=Gh4G5W07nlVF+kw4xB34+/v6CYaxu3e1XxrLtBDi+SNiiIJxPbOE9dkcRV+8+rb4sQ
         38aGu27JM/PAHirLF9VogFFlysxYJeUq9TCEK0NMdnlEpWkfHqHBGM3GZBZce+OoODFP
         EzekOdSIdf6TrTafCiPxIdevOjG9IpQlb5clAijuEZ3mwbjtTH/CBE+8+0I7zc5K2pOV
         29Imkc2QvZYzwpCqgEcnWT0WBhC4VD/7quXiXt2kUxZlM0nhgs7ZEA58qKjqRhNEWhmy
         f09TK9B9hpZhOP5QQaH20tD0M29HWBBneGtpsKWYjdW1poN//5IEIQ59fHq9/pKclBXg
         RFAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qEqKUzJO2jlie+1r8aMh98L/XxOod7KRRcuXrHmlPxg=;
        fh=ObWj8Zx/D4ZRetQvx7woF7iXsYgtqBE2vWdPCkyKcu4=;
        b=YdV44sJmpc+zoj1GOK9OC6bXbuvaBrNs+FZZMU2J6Q4YQTU3au6vinoMJLT5NGZAjC
         RQ+FDE9vDP5L6WJvrZ06YoWNE8LrbhEk7WFNXQGjjA6LAR0eSst459+6ix1Bfm9wZee/
         /cc0SIHCb27pjAbubRuyNhXeePtyygRv7qrZJtMuBfBOR5H6uqX0QqwwX5HFJksasDm9
         /hcKs77x1kw3Mbtuammr4WZwZ65LjDmWYz+OPmH/m8WxhbJ1fff6gIRM0QskZKQLJ7zh
         lcJl2+WQe2+32Blo9fd1uIfDY3k//D/e+d5MgTABGwcnqbrv4DkoyDUlLoj5gSOH01/F
         Gfrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781045826; x=1781650626; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qEqKUzJO2jlie+1r8aMh98L/XxOod7KRRcuXrHmlPxg=;
        b=i0LGsEPZJIHkIKI62mWwLHAgxTcz352vwK41lcG8WuG5CwLDt0kTmvGvu9QYC4Uec1
         nHWW/g8U91FrXEYg+wRizHoQi2n3VZ0TuJv0QPBgIpTt9IQNX9CKJq+Sxmxxb38F+oCm
         Hai0JNr5eZGGy83ZHLxxgFyr7NfnxyeIsugr1HaZ7vAtvjCY+S0K9uSaBplcd7+C7UnB
         pVznf/IQ7gPD+5bUlakb+wfHXxhduny1Rl8pPqRR4RRdWnKnY/9Q93ifP0SqusRrw1yi
         UBKN9RQRV79XcJFzTcGsv2fp+bhZij7+IhcBAPB15xu2yIE1BNX/8ScbP2zMt/tBLzdq
         yvtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781045826; x=1781650626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qEqKUzJO2jlie+1r8aMh98L/XxOod7KRRcuXrHmlPxg=;
        b=r6F/CkeKR1bLDWElOMwA2wxhghRiQv58yM4I8wSiG6gkgeHc8/UfTcLUok8uKSIwiS
         jueczIcN6HlSn9gEjiNiuAYWpN96Kp5t4c0CSrUz8Ny/3E7IxwRchEaYELBizh39R+Mm
         EnGai0yyijJ0BTpvMNcAhqbgLqIZ05Hw7NIvviLge+Z+IfkrjBXqypRqHV/RGlHJ7CaU
         R0WlnnCwnW8r89FQHHv9BCawwYfkLSM+itCuASMKiP2TsxPmJSWRWvy5iVStoZb8TECe
         +LyHiGUGrqih2Od6j2iLMtQ6YjUnh8agA5IybJOPdrZ5kx1IcxRFgbtWq3UoZ47zshtH
         Wo0A==
X-Gm-Message-State: AOJu0Yx1g93t9lsc0phNReasGWusE8QasAYSo4aUVklFUAznHPB8kB5g
	So0lLwKMzaVvqpJXw+KPwAK8ZMz164PfOM5KOJF8rfYOu9ZSQWYIjg0ZrPM1U9DQETaLO8XwCuQ
	A/y0NceTBfn3qeBsZ75S8Z8prIi30PKdKNb7oafCy
X-Gm-Gg: Acq92OGXBHC4TLrKJQVGdsN5zqCacq+MET08DMIHGIw7gXlVXgACnw5yn+0ubULgSkU
	WNF+ZN0iaz1DUBceymUWhVLLBPhtpn0ReuB5UlMd81UrudcPO4NRxZMYHp2B62xgRb196HBjodi
	S4VqwaDF2ZaSXH0M2o5bVClACuHH1SPPvlSKnOyDoC2B1waL1M07d1dcU6mS4hkpyd6b3BfGfmp
	tJrf2V8fwvUS5GfiscmA3hk3YPqU2Jzo/3DHqfYem7v3zU6OrBYVLsTr5P2XsEwJC1nDxc/1PIW
	cyJsqexq8K/9Wea01OkU1Bo00p+Gzbh5bf8qo4FHQmBm3R+b1yyZ
X-Received: by 2002:a17:903:faf:b0:2c0:ca99:3d73 with SMTP id
 d9443c01a7336-2c1e7b2f203mr251660005ad.8.1781045825877; Tue, 09 Jun 2026
 15:57:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260608001124.309352-1-xmei5@asu.edu> <aih9kXLYQKsWbUmP@chamomile>
 <uirq3v4lihhyfwg5x46xfupncevwzo4lgncit2ftsbq3jse67k@yavzv6oocv4d> <aiiVY8ieb4o6wOgP@chamomile>
In-Reply-To: <aiiVY8ieb4o6wOgP@chamomile>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 9 Jun 2026 15:56:54 -0700
X-Gm-Features: AVVi8Cf2Kzxou-mxBuvg5OhyiHxUFJ3PvFaNT_fh9YTC6YOAazq1HCmb3GSEpRo
Message-ID: <CAPpSM+TKh2n2YMa7Opm-_EYjCd0-6J9Cg=zB_DtiNGs4tRRd=Q@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_log: validate MAC header was set before
 dumping it
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, davem@davemloft.net, edumazet@google.com, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Weiming Shi <bestswngs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 9, 2026 at 3:36=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> On Tue, Jun 09, 2026 at 03:01:14PM -0700, Xiang Mei wrote:
> > On Tue, Jun 09, 2026 at 10:54:41PM +0200, Pablo Neira Ayuso wrote:
> > > On Sun, Jun 07, 2026 at 05:11:24PM -0700, Xiang Mei wrote:
> > > > The fallback path of dump_mac_header() guards the MAC header access
> > > > only with "skb->mac_header !=3D skb->network_header", without check=
ing
> > > > skb_mac_header_was_set().  When the MAC header is unset, mac_header=
 is
> > > > 0xffff, so the test passes and skb_mac_header(skb) returns
> > > > skb->head + 0xffff, ~64 KiB past the buffer; the loop then reads
> > > > dev->hard_header_len bytes out of bounds into the kernel log.
> > > >
> > > > This is reachable via the netdev logger: nf_log_unknown_packet() ca=
lls
> > > > dump_mac_header() unconditionally, and an skb sent through AF_PACKE=
T
> > > > with PACKET_QDISC_BYPASS reaches the egress hook with mac_header st=
ill
> > > > unset (__dev_queue_xmit(), which would reset it, is bypassed).
> > > >
> > > > Add the skb_mac_header_was_set() check the ARPHRD_ETHER path alread=
y
> > > > uses.  Only skbs with an unset MAC header are affected; valid ones =
are
> > > > dumped as before.
> > > >
> > > >  BUG: KASAN: slab-out-of-bounds in dump_mac_header (net/netfilter/n=
f_log_syslog.c:831)
> > > >  Read of size 1 at addr ffff88800ea49d3f by task exploit/148
> > > >  Call Trace:
> > > >   kasan_report (mm/kasan/report.c:595)
> > > >   dump_mac_header (net/netfilter/nf_log_syslog.c:831)
> > > >   nf_log_netdev_packet (net/netfilter/nf_log_syslog.c:938 net/netfi=
lter/nf_log_syslog.c:963)
> > > >   nf_log_packet (net/netfilter/nf_log.c:260)
> > > >   nft_log_eval (net/netfilter/nft_log.c:60)
> > > >   nft_do_chain (net/netfilter/nf_tables_core.c:285)
> > > >   nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:307)
> > > >   nf_hook_slow (net/netfilter/core.c:619)
> > > >   nf_hook_direct_egress (net/packet/af_packet.c:257)
> > > >   packet_xmit (net/packet/af_packet.c:280)
> > > >   packet_sendmsg (net/packet/af_packet.c:3114)
> > > >   __sys_sendto (net/socket.c:2265)
> > > >
> > > > Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to pr=
int decoded MAC header")
> > > > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > > > Assisted-by: Claude:claude-opus-4-8
> > > > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > > > ---
> > > >  net/netfilter/nf_log_syslog.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_s=
yslog.c
> > > > index 7a8952b049d1..ed5283fb6b67 100644
> > > > --- a/net/netfilter/nf_log_syslog.c
> > > > +++ b/net/netfilter/nf_log_syslog.c
> > > > @@ -815,7 +815,7 @@ static void dump_mac_header(struct nf_log_buf *=
m,
> > > >
> > > >  fallback:
> > > >   nf_log_buf_add(m, "MAC=3D");
> > > > - if (dev->hard_header_len &&
> > > > + if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
> > > >       skb->mac_header !=3D skb->network_header) {
> > >
> > > Maybe this instead?
> > >
> > > +           skb_mac_header_was_set(skb) &&
> > > +           skb_mac_header_len(skb) !=3D 0) {
> >
> > Thanks for the quick reply to this patch.
> >
> > The skb_mac_header_len is a combination of
> > 1) `skb_mac_header_was_set(skb)` and
> > 2) `skb->network_header - skb->mac_header`
>
> No, 1) is only true if DEBUG_NET_WARN_ON_ONCE() is enabled.
>
> > However, we have skb_mac_header_was_set added in the
> > original patch, and we have `skb->network_header - skb->mac_header`
>
> I think this is the last spot which opencodes skb_mac_header_len() in
> the netfilter tree.

I see it! I misunderstood the previous message. Thanks for the explanations=
.
>
> > at the start of the fallback code block:
> >
> > ```
> > fallback:
> >       nf_log_buf_add(m, "MAC=3D");
> >       if (dev->hard_header_len &&
> >           skb->mac_header !=3D skb->network_header) {
> >           ...
> > ```
> >
> > So I think the original patch should be enough.
>
> I think this patch could be streamlined like this:
>
> ebb966d3bdfe ("netfilter: fix regression in looped (broad|multi)cast's MA=
C handling")
Thanks for the example. We have sent v2.

Xiang
