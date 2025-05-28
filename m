Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383DA84A3E
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 11:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748432539; cv=none; b=Dczxg+vUM59cfI54q9KgIzqgn8gMERmMqm0uXbU/RrTYcrvNY2/wR3DgbWydTr34ffbtLr8THpl5qN3PR8j1VR/7oXvoilDxtgG0OYEXqcdY88GSlmjpOCfsua+miFYmBVfVaUvGBOITkMlhf+migC/vkT8AeMpcqXUMSRKSvqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748432539; c=relaxed/simple;
	bh=3/2HkDIp7Dv/s2Rmof64Ha7tdpONnvBkn9ubDy9DjKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hp0pEd3CkBoIWqjGSZyZoX6+PGTepkrBSC8UeOVWvORjX+9Cr+KV8Rz1uZ8CzOWW3H6YCB2rfQyPNl1T7slOGET6Dvny6EG8VzVkDfJuzboH5Akv1PduIGD5LknEzbjuCGiLphWgMGytI/b9xVsmgWtBuCU3AmxTyw3Si2fIVI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FUf7J9M1; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FUf7J9M1"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-72b0626c785so3389358a34.2
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 04:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748432534; x=1749037334; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmQzZXmbA9uwAN1V0XKCbJsMgyT8TzLQTF7DDPC2UnQ=;
        b=FUf7J9M1RmxZUnypFIHGUOukN+aWUKVyuPIcvNQxx65zmdvUxJBL2MU/0jQGefnuZH
         bxInQwjRRgRp+iGwGoF5Hrn9Iz/VTzNDXisyy+byGYT2h0sEhj7f90M6gjcROHPwxZGA
         LwRhrHG5H6nMrelKFXiJxwwv9UaUywJqBlOdZ76HQQY7qiDwmhAKA4ktrlaVUUmDGPTI
         kFLdQXYuieOJDuFqfnZBsISHHyZPGy6ZFLSBjEC7cr5JBrx9buB64UJubPMn0FSQqJPX
         3eb6Dbh0YEKCUE5qV73sFvpeVFRhxe/XpKzyRnYSPCM2lL7jApUxv5pgwYe57aZvRQA7
         7PtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748432534; x=1749037334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KmQzZXmbA9uwAN1V0XKCbJsMgyT8TzLQTF7DDPC2UnQ=;
        b=OBNSHGXogcAWOGNhEUCZc6s6EnlCZO2Kc2CldZ3t/AVP888w2HikgUnNprWDepskqT
         NEbZMxEpRK4H1GhIK751FZK50yrgMnZhQOobcVCU3X1ND/AxSOpVk3j9Ls4S7qbHS+48
         8yyVpsAMH/HTDsDhpZeqyaCTdXSNxP0pF8WVIIwH9c6MI1CPdieRvdoWvzJVCEg6iPJv
         Pwzf69xAf50goDvbdhe+0D1b/85veVJt7Dm5MCHCIPunL8LuDkdJMy+jCCC7weUm8+SB
         ouk4S7VyyfjfNPv57/JoZDevQCeoni1gI3GjcUQwNiFUnIbSg0rsams49fcvWTPGkCU2
         BH9w==
X-Forwarded-Encrypted: i=1; AJvYcCX6oQ1Pi5ddsB0tVSzjLS3paIE5aSfjPFluPZtr7UsAudjhK8XQGlrgjuzq/q9qgZ2yhuBu2ngJb1qWzxG6S6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YweS8QTLvxdrO0PMQWH6fE8bBrrYLUSnMwwlXEYCVHsF8f0/ocR
	RyV1x5UkIWQWXO+fHfWCXawH9gnIyiZ0AOJsQGIZfThSFlEi/mngdX9hOHsfTDjRs9z11ZR90Pm
	odf98+snoI48SKpKfbPQN9kN1JFCJGCZxrPOpjRMo+Q==
X-Gm-Gg: ASbGncusdYKXvtycTOwZU7esg77KbFDTT1MtYWcXarh3CKSoxn35SuOVNWf4B3E2xcP
	6geZhITztylhsfsAaLFhn1cZ6cDXaTV4UkgEFz2AJKKAufg9wBdiPeDbO+Mgmxa3vuLHLVkf1hq
	v33NRWRZzs2SvbBrSYD8w6DNg6q029VTqTbzYHKjXOJ8dm
X-Google-Smtp-Source: AGHT+IGNFs/Uphr9vsW5HXOCwoyqLM98ssFhw6Yp8eyguOqKpWKoYCo+Qyktdq1vlU+ecMFy+XHD6lmqKEBFGwsDYA0=
X-Received: by 2002:a05:6214:1d0d:b0:6f8:e2ab:cb8a with SMTP id
 6a1803df08f44-6fa9cfff18fmr275428776d6.5.1748432523809; Wed, 28 May 2025
 04:42:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDbyDiOBa3_MwsE4@strlen.de>
In-Reply-To: <aDbyDiOBa3_MwsE4@strlen.de>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 28 May 2025 19:41:27 +0800
X-Gm-Features: AX0GCFsBMdL8b8ESOuZXDakgxLfreHt5dlOLBLJhhN7ii9nY1sWDnxe918-3SkI
Message-ID: <CALOAHbAeVhLAe3o3UL8UOJrCRbRP8mqYZy37CYNHYFa3zss6Zg@mail.gmail.com>
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, 
	David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 7:23=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Yafang Shao <laoar.shao@gmail.com> wrote:
> > Our kernel is 6.1.y (also reproduced on 6.14)
> >
> > Host Network Configuration:
> > --------------------------------------
> >
> > We run a DNS proxy on our Kubernetes servers with the following iptable=
s rules:
> >
> > -A PREROUTING -d 169.254.1.2/32 -j DNS-DNAT
> > -A DNS-DNAT -d 169.254.1.2/32 -i eth0 -j RETURN
> > -A DNS-DNAT -d 169.254.1.2/32 -i eth1 -j RETURN
> > -A DNS-DNAT -d 169.254.1.2/32 -i bond0 -j RETURN
> > -A DNS-DNAT -j DNAT --to-destination 127.0.0.1
> > -A KUBE-MARK-MASQ -j MARK --set-xmark 0x4000/0x4000
> > -A POSTROUTING -j KUBE-POSTROUTING
> > -A KUBE-POSTROUTING -m mark --mark 0x4000/0x4000 -j MASQUERADE
> >
> > Container Network Configuration:
> > --------------------------------------------
> > Containers use 169.254.1.2 as their DNS resolver:
> >
> > $ cat /etc/resolve.conf
> > nameserver 169.254.1.2
> >
> > Issue Description
> > ------------------------
> >
> > When performing DNS lookups from a container, the query fails with an
> > unexpected source port:
> >
> > $ dig +short @169.254.1.2 A www.google.com
> > ;; reply from unexpected source: 169.254.1.2#123, expected 169.254.1.2#=
53
> >
> > The tcpdump is as follows,
> >
> > 16:47:23.441705 veth9cffd2a4 P   IP 10.242.249.78.37562 >
> > 169.254.1.2.53: 298+ [1au] A? www.google.com. (55)
> > 16:47:23.441705 bridge0 In  IP 10.242.249.78.37562 > 127.0.0.1.53:
> > 298+ [1au] A? www.google.com. (55)
> > 16:47:23.441856 bridge0 Out IP 169.254.1.2.53 > 10.242.249.78.37562:
> > 298 1/0/1 A 142.250.71.228 (59)
> > 16:47:23.441863 bond0 Out IP 169.254.1.2.53 > 10.242.249.78.37562: 298
> > 1/0/1 A 142.250.71.228 (59)
> > 16:47:23.441867 eth1  Out IP 169.254.1.2.53 > 10.242.249.78.37562: 298
> > 1/0/1 A 142.250.71.228 (59)
> > 16:47:23.441885 eth1  P   IP 169.254.1.2.53 > 10.242.249.78.37562: 298
> > 1/0/1 A 142.250.71.228 (59)
> > 16:47:23.441885 bond0 P   IP 169.254.1.2.53 > 10.242.249.78.37562: 298
> > 1/0/1 A 142.250.71.228 (59)
> > 16:47:23.441916 veth9cffd2a4 Out IP 169.254.1.2.124 >
> > 10.242.249.78.37562: UDP, length 59
> >
> > The DNS response port is unexpectedly changed from 53 to 124, causing
> > the application can't receive the response.
> >
> > We suspected the issue might be related to commit d8f84a9bc7c4
> > ("netfilter: nf_nat: don't try nat source port reallocation for
> > reverse dir clash"). After applying this commit, the port remapping no
> > longer occurs, but the DNS response is still dropped.
>
> Thats suspicious, I don't see how this is related.  d8f84a9bc7c4
> deals with indepdent action, i.e.
>  A sends to B and B sends to A, but *at the same time*.
>
> With a request-response protocol like DNS this should obviously never
> happen -- B can't reply before A's request has passed through the stack.

Correct, these operations cannot occur simultaneously. However, after
implementing this commit, port reallocation no longer occurs.

>
> > The response is now correctly sent to port 53, but it is dropped in
> > __nf_conntrack_confirm().
> >
> > We bypassed the issue by modifying __nf_conntrack_confirm()  to skip
> > the conflicting conntrack entry check:
> >
> > diff --git a/net/netfilter/nf_conntrack_core.c
> > b/net/netfilter/nf_conntrack_core.c
> > index 7bee5bd22be2..3481e9d333b0 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -1245,9 +1245,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
> >
> >         chainlen =3D 0;
> >         hlist_nulls_for_each_entry(h, n,
> > &nf_conntrack_hash[reply_hash], hnnode) {
> > -               if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].=
tuple,
> > -                                   zone, net))
> > -                       goto out;
> > +               //if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY=
].tuple,
> > +               //                  zone, net))
> > +               //      goto out;
> >                 if (chainlen++ > max_chainlen) {
> >  chaintoolong:
> >                         NF_CT_STAT_INC(net, chaintoolong);
>
> I don't understand this bit either.  For A/AAAA requests racing in same
> direction, nf_ct_resolve_clash() machinery should have handled this
> situation.
>
> And I don't see how you can encounter a DNS reply before at least one
> request has been committed to the table -- i.e., the conntrack being
> confirmed here should not exist -- the packet should have been picked up
> as a reply packet.

We've been able to consistently reproduce this behavior. Would you
have any recommended debugging approaches we could try?

--=20
Regards
Yafang
