Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988D43C17
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2024 11:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711022120; cv=none; b=RgjTdIM69IzKBesYm+Oo5AzxcpRFgBce4mJQEvztUuouTc1NXdJSpATmwsbLusS37MtNY0cIl0FvblDIODgpMZ8DnIMnpK4riOnN2c2HDB/HIyUHVXE7CY/PJBD+fy7ZTJYJS8dmuTIe2ildrtyl3iv7BgUDZdX8NHr+urQE/MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711022120; c=relaxed/simple;
	bh=M7rrx/tj/7cm7v6OqWu1lwee64D1yHNq/+n62D56OFg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mPuFxZfa2Scy2PjwRIkLtbzVrbIkExn6ZWlCKa6YnJfQR1FPXTxSOHxdZB0XyfQkmIuuM2HVr7ZYvhjTvz5EYI1hZVAMsT7vevcUj+S6FpJtZdu9xJ6T+vN/pjjHzlHBeQhdnIN7SfNDrrF/XzQy+DaXidmQ+DGhXAI2MITb4Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bqR5j3EO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bqR5j3EO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711022117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XDBSGogvTfMEiiiAhO5bwULBPt5bFujWQnwhyU3va9s=;
	b=bqR5j3EOjJ2DrXklUIrWwCf5DJDQfGZic3T2ylUXEDpTBEM+1p+KAuB6+AvuCL3xy0h1y+
	xuV+AK7COt91lvgQnLItkVWbvDUEVl0bBhEWUnzeZrnDMR8Mr56Tr+OPGmDl30sMVq5XRA
	ZCoY9c4JCfZbRZBg11hHUYKGzDWpjHo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-j0VojR1QNwifXu6sXO8BKQ-1; Thu, 21 Mar 2024 07:55:16 -0400
X-MC-Unique: j0VojR1QNwifXu6sXO8BKQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33ed4bb926cso158552f8f.0
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2024 04:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711022114; x=1711626914;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XDBSGogvTfMEiiiAhO5bwULBPt5bFujWQnwhyU3va9s=;
        b=hfP5xkEWPTdVeWcClEWBeZC5ceeigDphLJPZ7eN6DEJFLE5av0GQf1ONUgV4p9xZxv
         KESbbnVL2iSsEzKetzLtRB8lZP2Q/xMwyCV+NgFusv/mjQZnmRsUh7EkpCNdJwE84iM+
         kX4V1jKtaUle5428qmdcIzCpjdaYaJcxKtAOwqoMIYHCUWjMY5NeLq4phbbp3ppV2oZn
         CPoC9U+HAE8AN+Syh3UbTvC6L0h8mpl76GV4ApM2lcVi9qjzCclQ5AnB7RZsqfmSuyLD
         P2ppVUyuYnAvHyNXFY7td8XfX+YHtBd7wd8mBK3hy1uHhO/4f+CpTaVU56c4dJ3GoaSM
         IhSA==
X-Forwarded-Encrypted: i=1; AJvYcCX4kZXYYyZFMP/Al9IqsUtXBqJ2C+Zpod3BD4+MVTpHgWp0Fne/EyXlvz1NizYJxEuYyn+How+iw66NzHOk46uEr63o+108aSsJIWOeHqoM
X-Gm-Message-State: AOJu0Yzy8loDO4njYXcy8q7whIdZ2yKesCJTg1RB8zQi2S+b9BEFO80D
	5nC0kYTGriv+n5B+w4B+PUoxyBh0TRLy+gfZHFvrlaQ+Lah8qetRmwaw2lIATNKzGqVsG9bonvw
	ZA9q2LBelDdjAbGfY9VG6afsnLZp873l2bRREeFsVqeqrBry2JUaFBveOTyk3469whOlj1J7BLQ
	==
X-Received: by 2002:a05:6000:1044:b0:341:90a1:3e09 with SMTP id c4-20020a056000104400b0034190a13e09mr2960636wrx.1.1711022114302;
        Thu, 21 Mar 2024 04:55:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8S/hD8D1xjZ43PSNQn4IbIlw/LoHvIG1ScdsnjssBF0X6RaA70evBLiWEjWcqgtpo+3Kl4A==
X-Received: by 2002:a05:6000:1044:b0:341:90a1:3e09 with SMTP id c4-20020a056000104400b0034190a13e09mr2960625wrx.1.1711022113923;
        Thu, 21 Mar 2024 04:55:13 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-249-130.dyn.eolo.it. [146.241.249.130])
        by smtp.gmail.com with ESMTPSA id i7-20020a5d5587000000b0033ec68dd3c3sm17102683wrv.96.2024.03.21.04.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 04:55:13 -0700 (PDT)
Message-ID: <cde2dc9e07c49e642f16ab80c6f5b9f605ecbef4.camel@redhat.com>
Subject: Re: [PATCH net] inet: inet_defrag: prevent sk release while still
 in use
From: Paolo Abeni <pabeni@redhat.com>
To: Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, kuba@kernel.org, 
 netfilter-devel@vger.kernel.org, xingwei lee <xrivendell7@gmail.com>, yue
 sun <samsun1006219@gmail.com>, 
 syzbot+e5167d7144a62715044c@syzkaller.appspotmail.com
Date: Thu, 21 Mar 2024 12:55:12 +0100
In-Reply-To: <CANn89i+S0EYPM4N-3RsN5-QDQts5wobJjBikF7=feMo6hHY3Lw@mail.gmail.com>
References: <20240319122310.27474-1-fw@strlen.de>
	 <CANn89i+S0EYPM4N-3RsN5-QDQts5wobJjBikF7=feMo6hHY3Lw@mail.gmail.com>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=mQINBGISiDUBEAC5uMdJicjm3ZlWQJG4u2EU1EhWUSx8IZLUTmEE8zmjPJFSYDcjtfGcbzLPb63BvX7FADmTOkO7gwtDgm501XnQaZgBUnCOUT8qv5MkKsFH20h1XJyqjPeGM55YFAXc+a4WD0YyO5M0+KhDeRLoildeRna1ey944VlZ6Inf67zMYw9vfE5XozBtytFIrRyGEWkQwkjaYhr1cGM8ia24QQVQid3P7SPkR78kJmrT32sGk+TdR4YnZzBvVaojX4AroZrrAQVdOLQWR+w4w1mONfJvahNdjq73tKv51nIpu4SAC1Zmnm3x4u9r22mbMDr0uWqDqwhsvkanYmn4umDKc1ZkBnDIbbumd40x9CKgG6ogVlLYeJa9WyfVMOHDF6f0wRjFjxVoPO6p/ZDkuEa67KCpJnXNYipLJ3MYhdKWBZw0xc3LKiKc+nMfQlo76T/qHMDfRMaMhk+L8gWc3ZlRQFG0/Pd1pdQEiRuvfM5DUXDo/YOZLV0NfRFU9SmtIPhbdm9cV8Hf8mUwubihiJB/9zPvVq8xfiVbdT0sPzBtxW0fXwrbFxYAOFvT0UC2MjlIsukjmXOUJtdZqBE3v3Jf7VnjNVj9P58+MOx9iYo8jl3fNd7biyQWdPDfYk9ncK8km4skfZQIoUVqrWqGDJjHO1W9CQLAxkfOeHrmG29PK9tHIwARAQABtB9QYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+iQJSBBMBCAA8FiEEg1AjqC77wbdLX2LbKSR5jcyPE6QFAmISiDUCGwMFCwkIBwIDIgIBBhUKCQgLAgQWAgMBAh4HAheAAAoJECkkeY3MjxOkJSYQAJcc6MTsuFxYdYZkeWjW//zbD3ApRHzpNlHLVSuJqHr9/aDS+tyszgS8jj9MiqALzgq4iZbg
 7ZxN9ZsDL38qVIuFkSpgMZCiUHdxBC11J8nbBSLlpnc924UAyr5XrGA99 6Wl5I4Km3128GY6iAkH54pZpOmpoUyBjcxbJWHstzmvyiXrjA2sMzYjt3Xkqp0cJfIEekOi75wnNPofEEJg28XPcFrpkMUFFvB4Aqrdc2yyR8Y36rbw18sIX3dJdomIP3dL7LoJi9mfUKOnr86Z0xltgcLPGYoCiUZMlXyWgB2IPmmcMP2jLJrusICjZxLYJJLofEjznAJSUEwB/3rlvFrSYvkKkVmfnfro5XEr5nStVTECxfy7RTtltwih85LlZEHP8eJWMUDj3P4Q9CWNgz2pWr1t68QuPHWaA+PrXyasDlcRpRXHZCOcvsKhAaCOG8TzCrutOZ5NxdfXTe3f1jVIEab7lNgr+7HiNVS+UPRzmvBc73DAyToKQBn9kC4jh9HoWyYTepjdcxnio0crmara+/HEyRZDQeOzSexf85I4dwxcdPKXv0fmLtxrN57Ae82bHuRlfeTuDG3x3vl/Bjx4O7Lb+oN2BLTmgpYq7V1WJPUwikZg8M+nvDNcsOoWGbU417PbHHn3N7yS0lLGoCCWyrK1OY0QM4EVsL3TjOfUtCNQYW9sbyBBYmVuaSA8cGFvbG8uYWJlbmlAZ21haWwuY29tPokCUgQTAQgAPBYhBINQI6gu+8G3S19i2ykkeY3MjxOkBQJiEoitAhsDBQsJCAcCAyICAQYVCgkICwIEFgIDAQIeBwIXgAAKCRApJHmNzI8TpBzHD/45pUctaCnhee1vkQnmStAYvHmwrWwIEH1lzDMDCpJQHTUQOOJWDAZOFnE/67bxSS81Wie0OKW2jvg1ylmpBA0gPpnzIExQmfP72cQ1TBoeVColVT6Io35BINn+ymM7c0Bn8RvngSEpr3jBtqvvWXjvtnJ5/HbOVQCg62NC6ewosoKJPWpGXMJ9SKsVIOUHsmoWK60spzeiJoSmAwm3zTJQnM5kRh2q
 iWjoCy8L35zPqR5TV+f5WR5hTVCqmLHSgm1jxwKhPg9L+GfuE4d0SWd84y GeOB3sSxlhWsuTj1K6K3MO9srD9hr0puqjO9sAizd0BJP8ucf/AACfrgmzIqZXCfVS7jJ/M+0ic+j1Si3yY8wYPEi3dvbVC0zsoGj9n1R7B7L9c3g1pZ4L9ui428vnPiMnDN3jh9OsdaXeWLvSvTylYvw9q0DEXVQTv4/OkcoMrfEkfbXbtZ3PRlAiddSZA5BDEkkm6P9KA2YAuooi1OD9d4MW8LFAeEicvHG+TPO6jtKTacdXDRe611EfRwTjBs19HmabSUfFcumL6BlVyceIoSqXFe5jOfGpbBevTZtg4kTSHqymGb6ra6sKs+/9aJiONs5NXY7iacZ55qG3Ib1cpQTps9bQILnqpwL2VTaH9TPGWwMY3Nc2VEc08zsLrXnA/yZKqZ1YzSY9MGXWYLkCDQRiEog1ARAAyXMKL+x1lDvLZVQjSUIVlaWswc0nV5y2EzBdbdZZCP3ysGC+s+n7xtq0o1wOvSvaG9h5q7sYZs+AKbuUbeZPu0bPWKoO02i00yVoSgWnEqDbyNeiSW+vI+VdiXITV83lG6pS+pAoTZlRROkpb5xo0gQ5ZeYok8MrkEmJbsPjdoKUJDBFTwrRnaDOfb+Qx1D22PlAZpdKiNtwbNZWiwEQFm6mHkIVSTUe2zSemoqYX4QQRvbmuMyPIbwbdNWlItukjHsffuPivLF/XsI1gDV67S1cVnQbBgrpFDxN62USwewXkNl+ndwa+15wgJFyq4Sd+RSMTPDzDQPFovyDfA/jxN2SK1Lizam6o+LBmvhIxwZOfdYH8bdYCoSpqcKLJVG3qVcTwbhGJr3kpRcBRz39Ml6iZhJyI3pEoX3bJTlR5Pr1Kjpx13qGydSMos94CIYWAKhegI06aTdvvuiigBwjngo/Rk5S+iEGR5KmTqGyp27o6YxZy6D4NIc6PKUzhIUxfvuHNvfu
 sD2W1U7eyLdm/jCgticGDsRtweytsgCSYfbz0gdgUuL3EBYN3JLbAU+UZpy v/fyD4cHDWaizNy/KmOI6FFjvVh4LRCpGTGDVPHsQXaqvzUybaMb7HSfmBBzZqqfVbq9n5FqPjAgD2lJ0rkzb9XnVXHgr6bmMRlaTlBMAEQEAAYkCNgQYAQgAIBYhBINQI6gu+8G3S19i2ykkeY3MjxOkBQJiEog1AhsMAAoJECkkeY3MjxOkY1YQAKdGjHyIdOWSjM8DPLdGJaPgJdugHZowaoyCxffilMGXqc8axBtmYjUIoXurpl+f+a7S0tQhXjGUt09zKlNXxGcebL5TEPFqgJTHN/77ayLslMTtZVYHE2FiIxkvW48yDjZUlefmphGpfpoXe4nRBNto1mMB9Pb9vR47EjNBZCtWWbwJTIEUwHP2Z5fV9nMx9Zw2BhwrfnODnzI8xRWVqk7/5R+FJvl7s3nY4F+svKGD9QHYmxfd8Gx42PZc/qkeCjUORaOf1fsYyChTtJI4iNm6iWbD9HK5LTMzwl0n0lL7CEsBsCJ97i2swm1DQiY1ZJ95G2Nz5PjNRSiymIw9/neTvUT8VJJhzRl3Nb/EmO/qeahfiG7zTpqSn2dEl+AwbcwQrbAhTPzuHIcoLZYV0xDWzAibUnn7pSrQKja+b8kHD9WF+m7dPlRVY7soqEYXylyCOXr5516upH8vVBmqweCIxXSWqPAhQq8d3hB/Ww2A0H0PBTN1REVw8pRLNApEA7C2nX6RW0XmA53PIQvAP0EAakWsqHoKZ5WdpeOcH9iVlUQhRgemQSkhfNaP9LqR1XKujlTuUTpoyT3xwAzkmSxN1nABoutHEO/N87fpIbpbZaIdinF7b9srwUvDOKsywfs5HMiUZhLKoZzCcU/AEFjQsPTATACGsWf3JYPnWxL9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,

On Wed, 2024-03-20 at 15:14 +0100, Eric Dumazet wrote:
> On Tue, Mar 19, 2024 at 12:36=E2=80=AFPM Florian Westphal <fw@strlen.de> =
wrote:
> >=20
> > ip_local_out() and other functions can pass skb->sk as function argumen=
t.
> >=20
> > If the skb is a fragment and reassembly happens before such function ca=
ll
> > returns, the sk must not be released.
> >=20
> > This affects skb fragments reassembled via netfilter or similar
> > modules, e.g. openvswitch or ct_act.c, when run as part of tx pipeline.
> >=20
> > Eric Dumazet made an initial analysis of this bug.  Quoting Eric:
> >   Calling ip_defrag() in output path is also implying skb_orphan(),
> >   which is buggy because output path relies on sk not disappearing.
> >=20
> >   A relevant old patch about the issue was :
> >   8282f27449bf ("inet: frag: Always orphan skbs inside ip_defrag()")
> >=20
> >   [..]
> >=20
> >   net/ipv4/ip_output.c depends on skb->sk being set, and probably to an
> >   inet socket, not an arbitrary one.
> >=20
> >   If we orphan the packet in ipvlan, then downstream things like FQ
> >   packet scheduler will not work properly.
> >=20
> >   We need to change ip_defrag() to only use skb_orphan() when really
> >   needed, ie whenever frag_list is going to be used.
> >=20
> > Eric suggested to stash sk in fragment queue and made an initial patch.
> > However there is a problem with this:
> >=20
> > If skb is refragmented again right after, ip_do_fragment() will copy
> > head->sk to the new fragments, and sets up destructor to sock_wfree.
> > IOW, we have no choice but to fix up sk_wmem accouting to reflect the
> > fully reassembled skb, else wmem will underflow.
> >=20
> > This change moves the orphan down into the core, to last possible momen=
t.
> > As ip_defrag_offset is aliased with sk_buff->sk member, we must move th=
e
> > offset into the FRAG_CB, else skb->sk gets clobbered.
> >=20
> > This allows to delay the orphaning long enough to learn if the skb has
> > to be queued or if the skb is completing the reasm queue.
> >=20
> > In the former case, things work as before, skb is orphaned.  This is
> > safe because skb gets queued/stolen and won't continue past reasm engin=
e.
> >=20
> > In the latter case, we will steal the skb->sk reference, reattach it to
> > the head skb, and fix up wmem accouting when inet_frag inflates truesiz=
e.
> >=20
> > Diagnosed-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: xingwei lee <xrivendell7@gmail.com>
> > Reported-by: yue sun <samsun1006219@gmail.com>
> > Reported-by: syzbot+e5167d7144a62715044c@syzkaller.appspotmail.com

Possibly:

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")

it's not very accurate but should be a reasonable oldest affected
version.

> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  include/linux/skbuff.h                  |  7 +--
> >  net/ipv4/inet_fragment.c                | 71 ++++++++++++++++++++-----
> >  net/ipv4/ip_fragment.c                  |  2 +-
> >  net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
> >  4 files changed, 61 insertions(+), 21 deletions(-)
> >=20
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 7d56ce195120..6d08ff8a9357 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -753,8 +753,6 @@ typedef unsigned char *sk_buff_data_t;
> >   *     @list: queue head
> >   *     @ll_node: anchor in an llist (eg socket defer_list)
> >   *     @sk: Socket we are owned by
> > - *     @ip_defrag_offset: (aka @sk) alternate use of @sk, used in
> > - *             fragmentation management
> >   *     @dev: Device we arrived on/are leaving by
> >   *     @dev_scratch: (aka @dev) alternate use of @dev when @dev would =
be %NULL
> >   *     @cb: Control buffer. Free for use by every layer. Put private v=
ars here
> > @@ -875,10 +873,7 @@ struct sk_buff {
> >                 struct llist_node       ll_node;
> >         };
> >=20
> > -       union {
> > -               struct sock             *sk;
> > -               int                     ip_defrag_offset;
> > -       };
> > +       struct sock             *sk;
> >=20
> >         union {
> >                 ktime_t         tstamp;
> > diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
> > index 7072fc0783ef..7254b640ba06 100644
> > --- a/net/ipv4/inet_fragment.c
> > +++ b/net/ipv4/inet_fragment.c
> > @@ -24,6 +24,8 @@
> >  #include <net/ip.h>
> >  #include <net/ipv6.h>
> >=20
> > +#include "../core/sock_destructor.h"
> > +
> >  /* Use skb->cb to track consecutive/adjacent fragments coming at
> >   * the end of the queue. Nodes in the rb-tree queue will
> >   * contain "runs" of one or more adjacent fragments.
> > @@ -39,6 +41,7 @@ struct ipfrag_skb_cb {
> >         };
> >         struct sk_buff          *next_frag;
> >         int                     frag_run_len;
> > +       int                     ip_defrag_offset;
> >  };
> >=20
> >  #define FRAG_CB(skb)           ((struct ipfrag_skb_cb *)((skb)->cb))
> > @@ -396,12 +399,12 @@ int inet_frag_queue_insert(struct inet_frag_queue=
 *q, struct sk_buff *skb,
> >          */
> >         if (!last)
> >                 fragrun_create(q, skb);  /* First fragment. */
> > -       else if (last->ip_defrag_offset + last->len < end) {
> > +       else if (FRAG_CB(last)->ip_defrag_offset + last->len < end) {
> >                 /* This is the common case: skb goes to the end. */
> >                 /* Detect and discard overlaps. */
> > -               if (offset < last->ip_defrag_offset + last->len)
> > +               if (offset < FRAG_CB(last)->ip_defrag_offset + last->le=
n)
> >                         return IPFRAG_OVERLAP;
> > -               if (offset =3D=3D last->ip_defrag_offset + last->len)
> > +               if (offset =3D=3D FRAG_CB(last)->ip_defrag_offset + las=
t->len)
> >                         fragrun_append_to_last(q, skb);
> >                 else
> >                         fragrun_create(q, skb);
> > @@ -418,13 +421,13 @@ int inet_frag_queue_insert(struct inet_frag_queue=
 *q, struct sk_buff *skb,
> >=20
> >                         parent =3D *rbn;
> >                         curr =3D rb_to_skb(parent);
> > -                       curr_run_end =3D curr->ip_defrag_offset +
> > +                       curr_run_end =3D FRAG_CB(curr)->ip_defrag_offse=
t +
> >                                         FRAG_CB(curr)->frag_run_len;
> > -                       if (end <=3D curr->ip_defrag_offset)
> > +                       if (end <=3D FRAG_CB(curr)->ip_defrag_offset)
> >                                 rbn =3D &parent->rb_left;
> >                         else if (offset >=3D curr_run_end)
> >                                 rbn =3D &parent->rb_right;
> > -                       else if (offset >=3D curr->ip_defrag_offset &&
> > +                       else if (offset >=3D FRAG_CB(curr)->ip_defrag_o=
ffset &&
> >                                  end <=3D curr_run_end)
> >                                 return IPFRAG_DUP;
> >                         else
> > @@ -438,23 +441,39 @@ int inet_frag_queue_insert(struct inet_frag_queue=
 *q, struct sk_buff *skb,
> >                 rb_insert_color(&skb->rbnode, &q->rb_fragments);
> >         }
> >=20
> > -       skb->ip_defrag_offset =3D offset;
> > +       FRAG_CB(skb)->ip_defrag_offset =3D offset;
> >=20
> >         return IPFRAG_OK;
> >  }
> >  EXPORT_SYMBOL(inet_frag_queue_insert);
> >=20
> > +void tcp_wfree(struct sk_buff *skb);
>=20
> Thanks a lot Florian for looking at this !
>=20
> Since you had : #include "../core/sock_destructor.h", perhaps the line
> can be removed,
> because it includes <net/tcp.h>

I think Florian will not able to reply for a few days.

Since the issue looks ancient and we are early in the cycle, I guess
there are no problems with that.

Cheers,

Paolo

