Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792612951;
	b=38iflVH6MD9Ttu7QZ+SvUKvuXYjGmN5+RGi6NpbB9elaKf39adptYuJI0a/lnUrzYpcR
	 z72KY8pcKyy/ekVhdbYp4/HN+gylj6eyyR3/VFroxRdq/4THR1TZM14SAujjvGTz7caF6
	 KCowk6igdaNpd+/cuYeaDVIqdAmrnDyHz8LSuW3uoD66c3UEhBNTUE6zvAaK1QjWMR49r
	 sVyM+sBp1te8z+7JmPnPvRGp5OjZBqrhTTULnmduOz7XeiAm+We82SGSXWRVVlD9/ATYv
	 qaLacjQramcSTnkHZzgieXDJ+cvcxlgLzeTQtliZXdbrYYaRO7V2A2qcGIXiL/Illdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792612951;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=ZPDN9BexYqJgQl45SdfU9meWuyazsqHXMxCiEWebsmU=;
	b=sX4a9j4yqS04TwEeE+GVGEUEoxqsR9Wp6TrYwuPsFgdO1LNPQuVvDyQxomWIIZkKgyJT
	 jSbzNw7kCGuB4eHxyb0MjeF7yE7s4OcO8mVsv4TLBhcy7XQehhqWUYdNXBxzfsFdRJs/C
	 rNemb/SWElKOMjfRGip1uYEcOconij/y8tZQ8HQr+Iji0zXkWCGWBH+rWg4WdvvayzjIv
	 BIIC/bK1Enfm3UPnravR3bNq5P65UT1B9qW0zOimM3sRriEnrKV8JljBONv6sA5P0KLNy
	 xWtSirIhU9ggyfUTZ0j32N41Bh5QDJJ6CRpTojn1JWXzYWkzcrzaLbKdNpMa8sA3XeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=e29+mULU;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=UjJox1PV;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1E8606A31A
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 20:02:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F1E8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=e29+mULU;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=UjJox1PV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792612949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZPDN9BexYqJgQl45SdfU9meWuyazsqHXMxCiEWebsmU=;
	b=e29+mULUFeLobQo+uKn8gQNftlS5OaKjvXTj0kV0Os9YPMNIAvf5zxN9RtW08fP1Qwrkhi
	OJDtJ6pchd9LhnG9+2lhAETKM2TmygTBq5lb8sxIophiuSehSUv7u509D6wuo6hwlwcmWu
	TI95R9sD9s6LQMYB3gnH/TRUdMXWk64=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-SsCZewkBP2udAgrIDPKfzQ-1; Wed, 21 Oct 2026 16:02:28 -0400
X-MC-Unique: SsCZewkBP2udAgrIDPKfzQ-1
X-Mimecast-MFC-AGG-ID: SsCZewkBP2udAgrIDPKfzQ_1792612947
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48e1291432aso802340f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 13:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792612947; x=1793217747; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZPDN9BexYqJgQl45SdfU9meWuyazsqHXMxCiEWebsmU=;
        b=UjJox1PV3vRCck/ghKbgtwmVLGA1Q+GcnLL03CwW+0LDXjxRO490mF887lIG0gI3hh
         xPOCF4ugAtCv2VAmJDVTfUx5JY6IB7n51WUhStnzTyFlYj8f8nCZxSUz0/dj+/+j+9Bi
         D6U1P54Fi/25f/ECZBtRgIlPB8YcB5eMTlhL3SSzr04BhDovwZrwiqhTkzJTEWZljp3F
         fOU3AJq/xDwjth2LRZ/AlkGZDv93gEIYBYXvJRVrrnS5bLnm3ApPeytsCB8I1O1dqwua
         L77s99sCt+kGHExOg7QXPgm2I35s0uVwDp1mC1nSqNhsHqdHgrw3kbJlfThtWuK1F5DE
         ZjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792612947; x=1793217747;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZPDN9BexYqJgQl45SdfU9meWuyazsqHXMxCiEWebsmU=;
        b=pw2k5tiqPhU+2fkGKCDJuL36ebSm3ovmq3YRXaqxHTFd/ePHBzz9YJms9EuKxmmpr/
         GcNI7yvfCGYIPFY0+sWL8z16IqLgWorxr/j+xl81eljLA0vmiKLTQl+agyxEBzMY/OWi
         sWKX0S3uLpE5R2nY1xHt59WLroZCN6I5Lty4tR8nLZwda1oIjDdkjHkoyymPFvFdZOhB
         Vh+mDWILlfCEtmSCwZEAcxSF0qM5MiQa3f2OmQ4PiJUNFsvuf6Nj7YWrj7DRllV5oxyh
         pk+jDk1niP1XVOQJOlx4TqxK/DNXSOrzdxmptrGmGzdkE+yNOy66j3ybWTgroRSOJjV3
         /7Bw==
X-Forwarded-Encrypted: i=1; AKwUvBw7fMbii0C+P/WbMw63BH9wbPPPE3PKhe0PhpT5+wvQ2JYQiaUMbft58OlXMIY6Yl/ueKP0cy2kC4jx5p7SiVM=@vger.kernel.org
X-Gm-Message-State: AFq9FYJhxx8bpZDIbtcphLKpQC9rNSvJfyLA43LzlvQ3w3ivYEnoZjH1
	cWVk05Jk4Bnn5cTGKZp38FIRq7QfXBOnI8H1gqXYpgmi98YaLL9OthpthA5Nrt8Gr0kiVJ39USY
	0AiaF/jOXZTpGrHrfkEHEboMH1SFt7TbqPjOkas3Wnlnj/rxjTjp54h39EGQ/qnskxW4Gzg==
X-Gm-Gg: AYBFou3N4QDU6WtzMJQcF7WzHo+MXNGTGhs7xF6VmG9SY0sdTRkoHK2CLkiAUPOsF86
	oduPXtEvRqmsjYDtJvf5Ijuush86dd2ICbf1BNKa27n0JkpCduy3GQQ6Zjlyql9395iJG6uewJ1
	uE5mG1lBqDceI5rHWPXkJiXST4oXqsJ8O4hkdpmJR+82ahalM+d4gFAahOvqjly7ESclH4M5l6h
	KOuZVHMiHrHRhvvrhNVyd8IGcsQaOPoV7iiOhkZTb/KbRWSLlAgAuB3rbzLAJ6GyOg1+WpeaELo
	bDEXZqVcbWhX37HzssNmGpff20GFg1MRj7pKuSRpHjlsoY4sDnXAN5UwXja9Z8DS3as=
X-Received: by 2002:a05:6000:2901:b0:48e:25e1:5eb8 with SMTP id ffacd0b85a97d-48e2642e9aemr6954041f8f.3.1792612946228;
        Wed, 21 Oct 2026 13:02:26 -0700 (PDT)
X-Received: by 2002:a05:6000:2901:b0:48e:25e1:5eb8 with SMTP id ffacd0b85a97d-48e2642e9aemr6953990f8f.3.1792612945553;
        Wed, 21 Oct 2026 13:02:25 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1536:fc00:b838:383:1c7:6e81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2581f15esm8122007f8f.20.2026.10.21.13.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 13:02:24 -0700 (PDT)
Date: Wed, 21 Oct 2026 16:02:20 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <edumazet@kernel.org>
Cc: Nick Simpson <nick.simo@gmail.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Sridhar Samudrala <sri@us.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org, bpf@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 3/3] ipv6: validate checksum_start before fragmenting
Message-ID: <20261021155431-mutt-send-email-mst@kernel.org>
References: <20261021180329.26358-1-nick.simo@gmail.com>
 <20261021180329.26358-4-nick.simo@gmail.com>
 <CAL4Wiiq6Jy1XPtkrA-Ge2N+voJrE86DWPJp_jXwHJG3ZgMvPaQ@mail.gmail.com>
 <CAL4WiirCmk_rZBhaXmmgHSHiUjeBSt5hPoRn6Q+AXUGYVNXRaA@mail.gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL4WiirCmk_rZBhaXmmgHSHiUjeBSt5hPoRn6Q+AXUGYVNXRaA@mail.gmail.com>

On Wed, Oct 21, 2026 at 08:47:40PM +0200, Eric Dumazet wrote:
> Le mer. 21 oct. 2026 à 20:20, Eric Dumazet <edumazet@kernel.org> a écrit :
> >
> > Le mer. 21 oct. 2026 à 20:05, Nick Simpson <nick.simo@gmail.com> a écrit :
> > >
> > > ip6_fragment() and br_ip6_fragment() complete CHECKSUM_PARTIAL skbs with
> > > skb_checksum_help() without checking where csum_start points. After
> > > reassembly by nf_defrag_ipv6, the IPv6 header has moved forward by the
> > > 8 bytes of the fragment header while csum_start has not, so a
> > > CHECKSUM_PARTIAL skb from an untrusted source (tun/tap or packet sockets
> > > with a virtio_net_hdr, or AF_XDP TX metadata) can have csum_start inside
> > > the IPv6 header, and the checksum is then written into a header that the
> > > forward hook has already accepted. When csum_start lies before the
> > > network header, skb_checksum_help() warns.
> > >
> > > Add the IPv6 counterpart of ip_check_csum_start() from
> > > commit 6785011f8b16 ("ipv4: validate checksum_start before completing
> > > checksum") to the two IPv6 fragmentation paths: refuse to complete a
> > > checksum that starts inside the unfragmentable part of the packet (the
> > > IPv6 header and the extension headers before the fragment header) and
> > > drop the packet instead.
> > >
> > > For IPv4, ip_check_csum_start() is also called from nfnetlink_queue,
> > > xt_CHECKSUM and xfrm_output; their IPv6 counterparts are not changed
> > > here. A reassembled packet that is not fragmented again, such as an
> > > atomic fragment, and an unfragmented packet whose checksum is completed
> > > at egress are not covered either; those have to be handled where the
> > > CHECKSUM_PARTIAL skb is created, or by a check at reassembly time.
> >
> > Then let's do that, instead of adding checks to every consumer.
> >
> > A CHECKSUM_PARTIAL fragment is meaningless: the L4 checksum covers the
> > whole datagram, and our own stack completes it before fragmenting
> > (ip_do_fragment(), ip6_fragment()). Only untrusted injectors produce
> > them. Yet inet_frag_reasm_finish() keeps the reassembled skb
> > CHECKSUM_PARTIAL when all fragments are.
> >
> > Downgrading CHECKSUM_PARTIAL to CHECKSUM_NONE in inet_frag_reasm_finish()
> > covers IPv4, IPv6, nf_defrag_ipv6 (and the bridge path) in one place;
> > the bogus L4 checksum is then verified and the packet dropped.
> >
> >
> 
> Scratch that suggestion, it would be one more consumer-side check.
> 
> The fix belongs where CHECKSUM_PARTIAL skbs are created, and Michael
> is already doing this for virtio_net_hdr sources (tun, tap, packet
> sockets, virtio_net):
> 
> https://lore.kernel.org/netdev/cover.1792411304.git.mst@redhat.com/
> 
> In particular "net: resolve uncommon partial checksums at ingress":
> https://lore.kernel.org/netdev/9c08d12b3a7819ae03ded6a154e4f908276e93d4.1792411304.git.mst@redhat.com/
> CHECKSUM_PARTIAL is only kept when csum_start/csum_offset match a
> parsed TCP or UDP header, and fragments are explicitly refused
> (ip_is_fragment(), IP6_FH_F_FRAG): their checksum is completed at
> ingress, before any protocol processing.
> 
> Your patch 1/3 applies the same rule to AF_XDP copy mode, and already
> links to Michael's patch.

Oh great, AF_XDP. Another one no one noticed.

> With both, no untrusted source can feed a CHECKSUM_PARTIAL fragment
> to reassembly, nor an unfragmented packet with a bogus csum_start, so
> neither this patch nor a reassembly change is needed.
> 
> Once the ingress validation is merged, the ip_check_csum_start() calls
> added by commit 6785011f8b16 can be removed as well.

I think this would be a mistake. While plugging all places where some
packet change can confuse the stack is hard, making at least sure
there's no slab oob if we missed one is a no brainer imho: this is the
extent of the overhead:


        if (unlikely(skb->csum_start < skb->network_header + ip_hdrlen(skb)))
                return -EINVAL;
        return 0;

I will be frank, messing up one of the subtle checks we are adding in
virtio_net_hdr_from_skb is *trivially easy*. It is getting them right
that is hard. Can we pretty please get help in not turning every such
mistake into a publicity stunt with most major cloud vendors affected by
guest driven host code execution?

I know, we should write less bugs (
Still, you guys are the net maintainers.

-- 
MST

