Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B7D26C39B
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 15:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754063581; cv=none; b=YNECFCKgBPxCfEkJNmHytN0nhY7zOgiMYy/Bg1ImSYYDDAdjl2JojsPRM7e9PnlbKOFROU+36qQTG4fpPWhhKelN+8fgizwolxtXT8KJzxzcI6uMyoKVxbPxLHbncfYkSDIHcmIuTgoLO6Aq8u49vYIQ81fv8e/xYw7jJei10Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754063581; c=relaxed/simple;
	bh=IKhSviFqFxKNZXODGWt6Q8u8jf/2SZ7NuDp4KJ6OSIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EmAvskeIoFjru5c4dAPSBm53rS2RRwTjiIkipQ+16DwrV30prByg0jbE5/gcQ/zIZbf/MDVMtjepkjw0DHQWJqVNI1dv/JeDJnFxjahtvQpa7rRoTWuoUSRBjGnaR5HpbOGpc8hFOCLxdsKCBedUieH4WbT+skUcKAkAMGOXdP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GSFZ+xlk; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GSFZ+xlk"
Message-ID: <a8e756ca-e9f7-4c56-bd39-3f71e4be9528@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754063577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IKhSviFqFxKNZXODGWt6Q8u8jf/2SZ7NuDp4KJ6OSIo=;
	b=GSFZ+xlk/ppOyrzb+KtX2+Rh5mlxxkSu162KzpeMYyG1bk7qI5SgH/k7kgS4oGKMhNA8jC
	7DkE58bC3fOtkVwTxtok27M8y/FcoaKSYH1jv3a5uLXQcv7Po5n4liL0mq0v5GaOt/sf+2
	+EJMZKbwdytdYo0BEuT/iJyg7cFvg04=
Date: Fri, 1 Aug 2025 08:52:48 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf 1/4] bpf: Check flow_dissector ctx accesses are
 aligned
Content-Language: en-GB
To: Paul Chaignon <paul.chaignon@gmail.com>, bpf@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>, Martin KaFai Lau
 <martin.lau@linux.dev>, netfilter-devel@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Petar Penkov <ppenkov@google.com>,
 Florian Westphal <fw@strlen.de>
References: <cc1b036be484c99be45eddf48bd78cc6f72839b1.1754039605.git.paul.chaignon@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yonghong Song <yonghong.song@linux.dev>
In-Reply-To: <cc1b036be484c99be45eddf48bd78cc6f72839b1.1754039605.git.paul.chaignon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 8/1/25 2:47 AM, Paul Chaignon wrote:
> flow_dissector_is_valid_access doesn't check that the context access is
> aligned. As a consequence, an unaligned access within one of the exposed
> field is considered valid and later rejected by
> flow_dissector_convert_ctx_access when we try to convert it.
>
> The later rejection is problematic because it's reported as a verifier
> bug with a kernel warning and doesn't point to the right instruction in
> verifier logs.
>
> Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
> Reported-by: syzbot+ccac90e482b2a81d74aa@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ccac90e482b2a81d74aa
> Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>

Acked-by: Yonghong Song <yonghong.song@linux.dev>

