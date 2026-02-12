Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA53A2BE7C3
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 07:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770880635; cv=pass; b=EQpAoRhXaU9q2umehhiB2bUHamYQ7oj8df4dcyNPHV+yHZ2/oV/P1ujuXCK96oyrjpbIQ64keVQuwxqGdn8Lac2dpAHgxlcyaskI+MjaL5pvGfjnKXTuSsmm9GOCA04GlLX7Ct0MF5fKAg9omwhXUbEx4PG4RuGslTRl1+oM9uI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770880635; c=relaxed/simple;
	bh=5dKyNqtSv+8+nW0M8u8B/TNdAd78HmYWkm0JDenM2Rk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i971q91KzDCIqS/SuDyc4HqyRtPR6n6CXIwV6SoSnwymfNZvZ4hV2blzT6iNDjV8dP0xZp3r+xX8UTubVQELBK7OZ70KQvWb5Qnnp8ReRx3qNd33OmuhvE8e/VgGyp77mMNwlYGZlPTlsN9OKaHBj04CFK5AkqNVWVhjvKLgAz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3clod9zs; arc=pass smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3clod9zs"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cb382f5c0bso15777485a.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 23:17:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770880633; cv=none;
        d=google.com; s=arc-20240605;
        b=Vk/hPBHngnwSBm5rqQz80i5b3S8zRkFN7Lso10KPAFvegUIf1itzfU/0f7aRzTOKEf
         5Sq/EWZXWP5Q3K6ZVRADemThAXcgXLDx+eGqnwONKzQ6uDdX9utQJvDmW04KOLQzYvHQ
         7jyUMXjP/lEvzhz9KtD0TjRB9EQ+h2kx4azqUKWslQZTH7UcAcZLMYWkGnTWtsc+VkcU
         psT1duUh6MIXTT12/dVeDyEVu1ZGCPwbCIn915TmPtPlfRZCk6rxluBD+31hcIq2Fist
         zncw0BbCSAOjMFq8gsJhLFGZg8G7voPJoKRGA92xgG3dVmvB3SAtnPtlRAexAKQAVBcM
         Hy6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yltUO2cOxxVoQIpCKjjDxarQqdo4BfaqnH+MtRjb2qE=;
        fh=koZAU9dCuKWY3/5wyuQRA7U5k0TikRtzcXFzRw19IyE=;
        b=gv3zngEfyP/EC9Z0oYdmwvgvJQitBPv1hB5LMX75G6efRISl7vRZ4W8D3Sbm68NGFl
         +wk3NXs+0VkI8Oh2nCDki6vdWlae1Nu4w4sYm24HwRcR3+ylj6ee/Xrxh3rxwQNNMr1n
         3WKbVgP3MbqLsRW4DrCEr0debyL9JilXJ+EuotWVoxe4jKhWGHIu8n6vVG6LeRwFPB1l
         q8oUMOdLAnM/SPw0zQcy6ItL39Zca15kGbuvR9lHU2/xhBvwgeelqCdnaZYtr4rA03rd
         Zs+tRSjwSsAqoBR4eXQGhc/EbiMFboj6PCqo0nXmJjZIeL5YBcQkxNE+WMtWawm/5Swd
         XXug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770880633; x=1771485433; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yltUO2cOxxVoQIpCKjjDxarQqdo4BfaqnH+MtRjb2qE=;
        b=3clod9zsDBUatTwqMk8zM++sqBlIznysxhCOnQUPFhaAVwCLnxMkReBm6pQ2QItCe2
         EgfTAJ1c4tRYxno2MuDrTCu5dMCsXv11MqIuAii02jIdSPUpcW280RkgXihyTKLu5tTr
         MhZR/7ZCVBnX80xn9RPqt12hQFw0qSae3Qb6BCZHVDtWbwqLNv/HQw1Q7Ecsivsc/LRP
         ex1AwhCoXWV2kXS/2Sam77H1EYeGzkVd0bhGmVCM+ChgO+azePhhM68K84PbsFmCOdBi
         H8SvjjiOBQ6Wrk8GiXLb9cYGw5eN0bqaRGQGU5HHQ/3TuiZGmAAEUZbBOwGj24qgn73u
         r7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770880633; x=1771485433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yltUO2cOxxVoQIpCKjjDxarQqdo4BfaqnH+MtRjb2qE=;
        b=OPni/r/bdiLZ/dOHT4M7KLhq60Gb1kiavMM8+4ztCwjTI0zgrkj9lXyK6lnuqxcfD4
         lwLaCjIc5ca/2yYxrx0Xe25Jb22At7EU10/DnUDAst0gzyadBPNqGm30A53ny42JJJoY
         JsaGun18i1eOBi2BeG78A/3lDXgalytx3riTTnFEysfozeIH2hgh8+MpSo1JAdgmeX1b
         RUbG9wtlenE1xx+YnUZfPNoH0EkUPj2EYry5ZjjQ5BMHWqFxt+9gtD1JadJjJ8Ly+QwZ
         FfFxnj65I/dlcCwWCxSOma7aQLLbCk0ryRirSfpGjZiKM6zzkw7QCwZCcHrACUskat0Q
         UYJw==
X-Forwarded-Encrypted: i=1; AJvYcCVd3vVdAgSolKrwpf7Ic9DRDGp46jc4A+n/GbObPlZrEMYnR7QGYodtfI/3d5X3dCa209HgjqSaKc+iML2Ld4c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbZRtx15pihfms2KeaBa/jj5jS95au4QxkzXVvjMuWJYRnbygQ
	mIGI1+QAfPMQJT0XKzcNrIVy/DLfT49QLv9iGCcVdUrmdnvUQ0bK6xIsKaCLQnNHfSh8GVjON9T
	0z+NbM3ZgB1THUsxlZgPeNov2qhQeg0RMXDFjOPeD
X-Gm-Gg: AZuq6aIJloXQUKTG8vtdAKvxpJYhmra86cvXdsFyUtKQ3ZkWZIt9Bv/aAqfuxsIYoAk
	0LHFaV3MxN3u0FNHnTyQKHpoRmtCk4HK2dAd57dgjFNDPmto/7isxLGH2zHjBZd4DEvqke23HK6
	oNIB+twVbCvTGBJer8OShNgPFl6RE4RoqSXNxZ3hZCijKb7QW8INXyx6WWPESvuuxAq/3gEhMVL
	HqWiNUXnKG6G46qANCuIwV7XdCSGiVfy1EysyekjcML6zIy5NLHTH0vr30cm5dhQx99weZfKBnM
	zGMEr/jZ
X-Received: by 2002:a05:622a:148f:b0:501:46b7:22b2 with SMTP id
 d75a77b69052e-50691f68782mr25609751cf.82.1770880627918; Wed, 11 Feb 2026
 23:17:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260211103243epcms1p2dd304fd11b28df04f4e680e8c90a7fc5@epcms1p2>
 <207b2879-e022-4b50-837b-d536f8fcabcd@suse.de> <CGME20260211030048epcms1p54c6ed78458f57def8e3163032498ca00@epcms1p7>
 <CANn89i+mNojd9mUL_dt_=D+7nZ9xcV96CYJG_LYFmBZDOYUMFQ@mail.gmail.com> <20260212002207epcms1p7a1c19ed12038cf74f8632e5a305bd7ec@epcms1p7>
In-Reply-To: <20260212002207epcms1p7a1c19ed12038cf74f8632e5a305bd7ec@epcms1p7>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 12 Feb 2026 08:16:56 +0100
X-Gm-Features: AZwV_QgqTD6QqUZeQpStnEGD1Af1tXL6z0Hf9erBzMxQ2x7izWr-zSLdtDTfSGQ
Message-ID: <CANn89iJ6MJxh7BFjVdBMBLYeopgJ52Sbg7jEfQbQeQ-n0MUOTw@mail.gmail.com>
Subject: Re: (2) [net-next,v3] ipv6: shorten reassembly timeout under fragment
 memory pressure
To: soukjin.bae@samsung.com
Cc: Fernando Fernandez Mancera <fmancera@suse.de>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, 
	"davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com" <pabeni@redhat.com>, 
	"dsahern@kernel.org" <dsahern@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>, 
	"horms@kernel.org" <horms@kernel.org>, "phil@nwl.cc" <phil@nwl.cc>, 
	"coreteam@netfilter.org" <coreteam@netfilter.org>, "fw@strlen.de" <fw@strlen.de>, 
	"pablo@netfilter.org" <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 12, 2026 at 1:22=E2=80=AFAM =EB=B0=B0=EC=84=9D=EC=A7=84 <soukji=
n.bae@samsung.com> wrote:
>
> >On Wed, Feb 11, 2026 at 4:11=E2=80=AFPM Fernando Fernandez Mancera
> ><fmancera@suse.de> wrote:
> >>
> >> On 2/11/26 11:32 AM, =EB=B0=B0=EC=84=9D=EC=A7=84 wrote:
> >> >   Changes in v3:
> >> > - Fix build bot error and warnings
> >> > - baseline update
> >> >
> >> >
> >> >
> >> >  From c7940e3dd728fdc58c8199bc031bf3f8f1e8a20f Mon Sep 17 00:00:00 2=
001
> >> > From: Soukjin Bae <soukjin.bae@samsung.com>
> >> > Date: Wed, 11 Feb 2026 11:20:23 +0900
> >> > Subject: [PATCH] ipv6: shorten reassembly timeout under fragment mem=
ory
> >> >   pressure
> >> >
> >> > Under heavy IPv6 fragmentation, incomplete fragment queues may persi=
st
> >> > for the full reassembly timeout even when fragment memory is under
> >> > pressure.
> >> >
> >> > This can lead to prolonged retention of fragment queues that are unl=
ikely
> >> > to complete, causing newly arriving fragmented packets to be dropped=
 due
> >> > to memory exhaustion.
> >> >
> >> > Introduce an optional mechanism to shorten the IPv6 reassembly timeo=
ut
> >> > when fragment memory usage exceeds the low threshold. Different time=
out
> >> > values are applied depending on the upper-layer protocol to balance
> >> > eviction speed and completion probability.
> >> >
> >> > Signed-off-by: Soukjin Bae <soukjin.bae@samsung.com>
> >>
> >> Hello,
> >>
> >> isn't this what net.ipv6.ip6frag_time does? In addition, the situation
> >> you described could be overcome by increasing the memory thresholds at
> >> net.ipv6.ip6frag_low_thresh and net.ipv6.ip6frag_high_thresh.
> >>
> >> Please, let me know if I am missing something.
> >
> >Also :
> >
> >1) net-next is closed.
> >Please read Documentation/process/maintainer-netdev.rst
> >
> >2) We do not send 3 versions of a patch in the same day.
> >Please read Documentation/process/maintainer-netdev.rst
> >
> >3) What about IPv4 ?
> >
> >4) Only the first fragment contains the 'protocol of the whole
> >datagram', and fragments can be received in any order.
> >
> >5) We do not add a MAINTAINER entry for such a patch, sorry.
>
>
> Hello,
>
>
> Regarding about net.ipv6.ip6frag_time and low/high_thresh:
>
> The issue we are addressing currently occurs due to a large volume of mDN=
S
> traffic from WiFi APs. As a temporary measure, we increased the high_thre=
sh
> value to accommodate the traffic.
>
> However, UDP traffic such as mDNS cannot recover once a fragment stream i=
s
> lost, leading to wasted memory. Therefore, this patch is intended to make
> more efficient use of the currently allocated fragment memory by shorteni=
ng
> the reassembly timeout under memory pressure.
>
> Also, we tend to avoid changing the global value of ip6frag_time to
> preserve existing behavior. This is why I added new config too.
>
>
> Regarding others:
>
> 1, 2) net-next is closed and multiple patch
> I apologize for the oversight regarding the net-next status and the frequ=
ent
> submissions. I was tried to fix CI build failures. I will follow the
> documented guidance going forward.
>
> 3) What about IPv4?
> The issue was primarily observed in IPv6-dominant IMS environments, which
> was the initial focus. However, I agree that the same memory management l=
ogic
> is beneficial for IPv4. I will include IPv4 support in the next version t=
o
> provide a unified solution.
>
> 4) Only the first fragment contains the 'protocol of the whole datagram'.
> You are correct. I will update the logic to store the L4 protocol informa=
tion
> once the first fragment is received, and only then apply the adjusted tim=
eout.
> If the first fragment is lost, the adjusted timer will not be triggered, =
but
> this is acceptable as a partial case.

I do not think we will accept a patch trying to 'fix' reassembly. This
is fundamentally not fixable.

I can tell you that in crowded wifi environments, I have seen delays
of 30 seconds (and more) to complete
a datagram of only 2 fragments. Your default settings are not viable.

If you depend on receiving fragments, change the existing tunables.
Instead of :

/proc/sys/net/ipv6/ip6frag_high_thresh:4194304  (4 MB)
/proc/sys/net/ipv6/ip6frag_low_thresh:3145728 (3 MB)
/proc/sys/net/ipv6/ip6frag_time:60

Use:

/proc/sys/net/ipv6/ip6frag_high_thresh:104857600  (100 MB)
/proc/sys/net/ipv6/ip6frag_low_thresh:78643200 (75 MB)
/proc/sys/net/ipv6/ip6frag_time:60

Of course, avoiding fragments is the right solution.

https://datatracker.ietf.org/doc/html/rfc6762#section-17

TCP should avoid using frags by default.
