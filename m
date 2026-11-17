Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794933036;
	b=RMGiVTtyvlKcyczYz5k6gcqbXPBO950PFCQTSzsxswlpfMoQwc5toWhqUThQPCWnA4qD
	 QEvFIF0iHV4nLxa5v8pW3trc19UbM9Y8BJt0+bSD+cw6gxdHik4dkymSOc1jI8mjkCx8B
	 CnGd39QR9OGOYZ9sfNQE4az6/sqzTGfNhXOUazIZaKIgS4np1IaJX32F+uiJmlF/WjECp
	 LgeB5juozWfGPFY8jjgP4qnPYhiGE+28jYJUDSQ7EuPsNYBcSkwCJTEvPdpMu8ZpoZm9y
	 E6I8HPwuXVTZe5V689SpNHBStpUSaPQTCvujfFF5YpNJlTsbzZTij3RTCbhpIwOnxNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794933036;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=gzNj9YY/nz5fvfy6gpTsHNPiMT4iZgLl23IUytoqvOw=;
	b=NJAdU6nl4rtqOFjbMxuFMlNc9sTAGG3CcFsNkXpHtAYhBbNEhft2pwL03Gb2R6fVvsVl
	 kskTGxxJDhRRQM123O+kNIfF02vCKvb9ZHycFsKk82Yh9eB+cVxjPfBmKNHQQmfLOl9j1
	 OadkGta/0j4x024mUsL3kBJlYAhsna4dg9/RjQ1v0Y4Rxi9C4lLiAORFo09u1URTEXgJJ
	 ni2zm9xJMul7nuq+nHxUJDLhPCUy5ObHLGPFMa2gJQgCJMNion4xwohirtxSnrA52yhuC
	 wLWvmjvnQEUogFBeFMuLpB4qRaztLhRbtz0fYas1ZNbp3/zGHCxGPmqZLoiFYZm+JHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CwtuUpEv;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qf60IkSA;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB7A606A337
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 16:30:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADB7A606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CwtuUpEv;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qf60IkSA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794933034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gzNj9YY/nz5fvfy6gpTsHNPiMT4iZgLl23IUytoqvOw=;
	b=CwtuUpEvtmjSJ1RAGrXIZwziL8OMuG1ofVyxGbIzOQhVsAGi199940zQgBAU2KRXFTFX1L
	7rPPObmcOljahmrepHhnpChC+QprBcwnOR3uZ3tyO0m+vGyDRnFFxu738DvrOqFmIqL3/y
	q06ZE2Tzg1QAY5cnkUvSVzaIB4KVbhQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-YK6Gwz_7Nfycm7Map95xTg-1; Tue, 17 Nov 2026 11:30:32 -0500
X-MC-Unique: YK6Gwz_7Nfycm7Map95xTg-1
X-Mimecast-MFC-AGG-ID: YK6Gwz_7Nfycm7Map95xTg_1794933031
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-490c1867460so3132651f8f.2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 08:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794933031; x=1795537831; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gzNj9YY/nz5fvfy6gpTsHNPiMT4iZgLl23IUytoqvOw=;
        b=qf60IkSAFxTD8xr8bOjsd/byszjQSqPLfjok2uQ+ANozpf+0gR9NTS8yPJ7RUtY0eA
         IKfVZEz+ooTfmV3fZJ0ZPon3xFvNtD5Qvmc59ZPJCk5/1J+xOLhIq1v9zlJomaZAW2H4
         aUpvwfLGlWZ8xdmIH1uQwJfzN33jnBbmgxGNoj6XQRm6sNK/Gyq9QSz43sCTQa6Kjnfl
         6cDq4OXrIKMWWsaSc1ryv6UsrZeF3f4vIogqHWTxd6IFuqA7Tp+7HLuhJ+4JbxnWVjXe
         7eXmtj7+9avNVfGIN/HUPG3A48fEIcZx46uDs3vt9/5EDAh+btcari2jaZKPIQ9zA4Mx
         Zcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794933031; x=1795537831;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gzNj9YY/nz5fvfy6gpTsHNPiMT4iZgLl23IUytoqvOw=;
        b=1jtWdlGT6rIKHulq5SrODpkKdTUT4ZC/KEYqUg5pbIVM9JoD79QynimsoFHTiFwxOr
         nEctVacNsT3wNMjbjChYq+adZR9RX9L0M6Nlm8K0wHI8jl8b2wb1mgVSASa4Dl/ZmosE
         7uuFR+bqVhs8xdGDV831Wwngjae01GrLN9bC1eqySHBwRZaf9V2GC1HWz9GD2nBktriT
         S6SPVDT/lg5bzYS1kx4AZNwA3rC4gYcem8BLPT5vAFrBjNtK1IP9wINwf1t9QKOHQwhg
         wjhj2dmP4L1x/llRz6GarEQ9Vr9H70Q+t28InkuYnWvllIaG/xHv6ZBZ3tNnlK5kPlfH
         YmlA==
X-Forwarded-Encrypted: i=1; AL+hErEAoOsdzJTcEcmBrUqfwkUVeahT7lQSliCG1/cJFydKF3iFjGGxlMKA0Q1sNkVbcAGU+UWipXuFIRWi6emn2qM=@vger.kernel.org
X-Gm-Message-State: APuU4Z8sDpAFxVkuEVXoLnRwRp4oqmHflZiJheazqZ76TUJ3fNBsx7e4
	1TBV/UJrjj5X6q6iXopvfRNs1tbu0icJU7Qr1CCyb1pU7hayw4+3tcduqQxZ2AztWCQ67Cjd9/e
	Qjj5At49oXvgWtGGFGVOoS08GNeKHTbdJmIRe0bmRivnMcwo/090kwUDv816CdN2ZoxFdSQ==
X-Gm-Gg: AZFdTZfiiaMb7Vn0LlMcmgklXT5gvcRzDPShLv+WcWPV6Gbr4bnGQUaIOXJuIDE4EQm
	8MYJ6CzD34EXt0lmWvNwyTgNuil5nQek2Btn8ctVZ7pzQaS8lJw5PRU78SpGxgJ5My2DqQ9y0LR
	uDkpY/DWGeJBsj9Irev7Sv1DMrMXD6rJ5F6ph8MkehM20jMIGxd6Ox7bqJfChOqpNsQDTWoNilg
	sGeb8H0rOG38kXD2JfX76xbt1az6+g1vFF+GD8LNRcnkvSS12XJtficGiWhpueIzVVXjxPbCghV
	+jk7BVSWD41kLU6l/XNlcSPi53TnrxI/tl8t5N0o30sTOJg3lrQECd5ZuHb54QGD0ZreZL8/PKO
	hn1TP1W1uZvAtkQm1l/qMvRqq8p9o6qwoQizAM3CgdVOwZJ6wgcFuqyf6MK/vn/AapC7T83rJAp
	Vblcz8nM5vETQFQwWfi8gdlTIOM7zbnFil3kwuouynez4U
X-Received: by 2002:a05:6000:1a8a:b0:48b:f93:3b87 with SMTP id ffacd0b85a97d-49c726da6e1mr33405908f8f.30.1794933030651;
        Tue, 17 Nov 2026 08:30:30 -0800 (PST)
X-Received: by 2002:a05:6000:1a8a:b0:48b:f93:3b87 with SMTP id ffacd0b85a97d-49c726da6e1mr33405842f8f.30.1794933030089;
        Tue, 17 Nov 2026 08:30:30 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c888b90d4sm29021988f8f.9.2026.11.17.08.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 08:30:29 -0800 (PST)
Message-ID: <09765df8-89a7-4b7e-b889-5bafd7622c20@redhat.com>
Date: Tue, 17 Nov 2026 17:30:27 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v4 0/2] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
To: Ido Schimmel <idosch@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Leonard Lausen <leonard@lausen.nl>, netdev@vger.kernel.org,
 David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261117110813.9894-2-leonard@lausen.nl>
 <avxPFYfEirXzTup8@chamomile> <94f4ea0e-c1bf-467c-94be-b65963410d30@lausen.nl>
 <avxRfzsnke7VJq_w@chamomile> <20261117152414.GA824125@shredder>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261117152414.GA824125@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/17/26 16:24, Ido Schimmel wrote:
> On Tue, Nov 17, 2026 at 02:07:11PM +0100, Pablo Neira Ayuso wrote:
>> As Paolo suggests you explore fixing this from nft_fib itself,
> 
> Why?
> 
> fib6_lookup() is the IPv6 counterpart of fib_lookup() which is used by
> nft_fib_ipv4. The fact that it's not working with
> 'suppress_prefixlength' is an oversight, which is being fixed here.

I must admit I read the previous version as the issue was caused by an
API misuse by nft.

It looks like I misread it, I'm fine with this fix.

/P

