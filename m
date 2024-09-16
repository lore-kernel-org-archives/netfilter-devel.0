Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0B7149C4D
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2024 10:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726483066; cv=none; b=BrXrvsJK1VK3peBiJAiIPA+79g3rP+obSUrj3mC/FTHIdrzq8HtMaIOsKx+2qLApdf7krGpe2tmRpU7bES1WmkCedv3N7Ko5ohutl8kx9u37Zuut3K6dmLsR5QmOGznd8QlYQq1TBOLhL+Arib89+AR0sdeRzu+ZpQCgwvLLFQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726483066; c=relaxed/simple;
	bh=ydStSIWRNar3wbe8rTmkX5pgjyke7hmUQ0BmrPAzBnU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=hCP/rk6OYUhCYRgAABvyYRvLw9TDOWkABKLSPNy5cNWJ4NLXbd//0KWqmNhdZsSqUyi18gCwllncOF6DuXp533K3v88oXeANF3+5lkxpSgFHyNJNwGC4j+BrfB7rZSv5irqucDHqm3fnSvPy/sCV6vDOLZHETfW6xDp903ZDqFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y0iu/FKV; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0iu/FKV"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-82aa7c3b3dbso176513939f.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2024 03:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726483064; x=1727087864; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d/v8rR5G35S0A0aRp1X69BmBYEapcqqzLse9uCP3UVc=;
        b=Y0iu/FKVr/VJ+MFN5moBRr+KnEijcKLu0QDsMik1KGoe3GLnVD1DZujOL8l3jAPCjI
         U/wubaSz++NC0tFlAlHLfwqME3ClpQPBBq5XCTF/fgCNcCl7ThJ0FUsvbNbYn6IEg78Q
         b6Mhq8CvLWrGu5zNy9FPMSJMgjgRE2u7+ugmaQb0RP2QAeiix2neCzS2/XfkNjZ2SPW6
         q5KJxK7UzGym6hk44GPsM2aqJteD2Se5AdCbh8vZPYrThYIgB16teFukOiY/lTfZN6Mg
         AqKyKLKp9oXnkTulZarlWHpy8l9d8YjcTfaflgj56xwPe1o11lbRBZhKgQ1kQ+yz9/mP
         KMhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726483064; x=1727087864;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d/v8rR5G35S0A0aRp1X69BmBYEapcqqzLse9uCP3UVc=;
        b=Mi0TtoA+VKMdGUiOD4eBbEZnB+imui84AVUqTpZsGrEJ7UkNd92lvrJjqAi5C60XRi
         4INlqrQ9eOdIkRtQwdDpzKO624YqSijLVreyWaDnZ0Yx35xYIjUrmYZIXiGq3QMaN3r+
         b7BcJEyaCAE8CU8epOlQ8PoH5r9KEEFsTpyS/7MND6QlvAgTMTWqSV1+AGR4yTWTbyZP
         O8pAI3RgGVGCLbIzlcN1agWI9/wCYCIE0jSCLKyP0scxXbmySGY0qvHeb5bmwPwtD65V
         Ed3yaeCNuSFOt/lMyNP+Io3FQNZn+wWVDq8PZ5//9a9hm6Y6fpqW1xiF+b8zaiquJion
         6ONQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpdFaCimmd84KvsYtzC5EoPMw8KWH6XeVrvHI8AM1yft4RW22CFpzKjM7ITLudUBpos3sneLX0p7hNMjCnKwk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoFIVTHhOniuskqqrg5ZmX5/NQGJqYnrlVoEEB5d7utbWH2RQX
	o+qtlB5DAhEVSuKOJC/JC3+K+/ZyCoK4MDwaAA65+ZIEwg4lXKzDfKka8UWjdFRESodpmgVcKRq
	6nM9d+aG/pJ0BTpAtPgb8HqCbNno=
X-Google-Smtp-Source: AGHT+IFh8kak2Sw3S8qwp3SdA3dh/dueL+s/PMua05tWknEv9Nl/k4PZQ8wi4ZSlnjE6vCkO9/MByUHevpHuUfOAbQU=
X-Received: by 2002:a05:6e02:18c9:b0:3a0:a80a:997c with SMTP id
 e9e14a558f8ab-3a0a80a9c4cmr8302565ab.19.1726483064248; Mon, 16 Sep 2024
 03:37:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913102347.GA15700@breakpoint.cc> <ZuQT60TznuVOHtZg@calendula>
 <20240913104101.GA16472@breakpoint.cc> <ZuQYPr3ugqG-Yz82@calendula>
 <CABhP=tZKgrWo2oH3h=cA8KreLZtYr1TZw7EfqgGwWitWZAPqyw@mail.gmail.com>
 <ZuQg6d9zGDZKbWBO@calendula> <ZuQpbnjAoutXEFUj@orbyte.nwl.cc>
 <ZuQx3_x6JJgzA0gS@calendula> <20240913141804.GA22091@breakpoint.cc>
 <CABhP=tYWf7-Ydi6HyOQ_syeS=k6Y9xPbSGYTSjOjhYpA=Jk-TQ@mail.gmail.com> <ZuSh_Io3Yt8LkyUh@orbyte.nwl.cc>
In-Reply-To: <ZuSh_Io3Yt8LkyUh@orbyte.nwl.cc>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Mon, 16 Sep 2024 11:37:08 +0100
Message-ID: <CABhP=taSX5Ka=Xa98RpnQj2Rx3E+gemUPPCs0c66yHAFh0=NxA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
To: Phil Sutter <phil@nwl.cc>, Antonio Ojea <antonio.ojea.garcia@gmail.com>, 
	Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Sept 2024 at 21:35, Phil Sutter <phil@nwl.cc> wrote:
>
> Hi Antonio,
>
> On Fri, Sep 13, 2024 at 05:38:21PM +0200, Antonio Ojea wrote:
> > On Fri, 13 Sept 2024 at 16:18, Florian Westphal <fw@strlen.de> wrote:
> > >
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > Hmm. Looking at nft_nat.c, 'accept' seems consistent with what nat
> > > > > statements do implicitly.
> > > >
> > > > Yes, and xt_TPROXY does NF_ACCEPT.
> > > >
> > > > On the other hand, I can see it does NF_DROP it socket is not
> > > > transparent, it does NFT_BREAK instead, so policy keeps evaluating the
> > > > packet.
> > >
> > > Yes, this is more flexible since you can log+drop for instance in next
> > > rule(s) to alert that proxy isn't running for example.
> > >
> >
> > This is super useful, in the scenario that the transparent proxy takes
> > over the DNATed virtual IP, if the transparent proxy process is not
> > running the packet goes to the DNATed virtual IP so the clients don't
> > observe any disruption.
>
> So here's a use-case for why non-terminal tproxy statement is superior
> over terminal one. :)
>
> > > > > > is this sufficient in your opinion? If so, I made this quick update
> > > > > > for man nft(8).
> > > > >
> > > > > Acked-by: Phil Sutter <phil@nwl.cc>
> > > > >
> > > > > In addition to that, I will update tproxy_tg_xlate() in iptables.git to
> > > > > emit a verdict, too.
> > > >
> > > > Thanks, this is very convenient.
> > >
> > > Agreed, it should append accept keyword in the translator.
> >
> > I'm not completely following the technical details sorry.
>
> In essence, tproxy statement does not set a verdict unless it fails to
> find a suitable socket. A sample ruleset illustrating this is:
>
> | table t {
> |       chain c {
> |               type filter hook prerouting priority 0
> |               tproxy to :1234 log "packet tproxied" accept
> |               log "no socket on port 1234 or not transparent?" drop
> |       }
> | }
>
> > With my current configuration I do set an accept action
> >
> >    udp dport 53 tproxy ip to 127.0.0.1:46659 accept
> >
> > and I have dnat statements after that action.
>
> For the record, your ruleset looks like this (quoting from the kselftest
> you sent me):
>
> | table inet filter {
> |        chain divert {
> |                type filter hook prerouting priority -100; policy accept;
> |                $ip_proto daddr $virtual_ip udp dport 8080 tproxy ip_proto to :12345 meta mark set 1 accept
> |        }
> |        # Removing this chain makes the first connection to succeed
> |        chain PREROUTING {
> |                type nat hook prerouting priority 1; policy accept;
> |                $ip_proto daddr $virtual_ip udp dport 8080 dnat to umgen inc mod 2 map { 0 : $ns2_ip , 1: $ns3_ip }
> |        }
> | }
>
> Foundational lecture: 'accept' verdict covers the current hook only. Like
> with iptables, if you accept in e.g. PREROUTING, INPUT may still see the
> packet. 'drop' verdict OTOH discards the packet, so no following hooks
> will see it (obviously).
>
> Your case is special because of the different types. If I interpret this
> correctly, a new connection's packet will get tproxied by divert chain
> and dnatted by PREROUTING chain (which sets up a conntrack entry). The
> second packet will hit conntrack in prerouting hook at priority -200
> (according to the big picture[1]) and your tproxy rule does not match
> anymore. The nat type chain does not see the packet as it's not a new
> connection. Maybe this explains the behaviour you're seeing.
>
> In order to avoid the inadvertent dnat of tproxied packets, terminating
> the divert chain's rule with 'drop' instead of 'accept' should do - if
> tproxy fails, it set NFT_BREAK so the packet continues and hits
> PREROUTING chain (if the connection is new).

Awesome, I just add a rule that drops the tproxied marked packets

| meta mark 1 drop

and works perfectly.

Although, since it is not really intuitive you have to do this it will
be nice to have it documented

Thanks

>
> Cheers, Phil
>
> [1] https://people.netfilter.org/pablo/nf-hooks.png
