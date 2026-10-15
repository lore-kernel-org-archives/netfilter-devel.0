Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B46855198F
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 15:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792079974; cv=pass; b=R8jB0+VW+WtmQa8pJHqNSDNkevES+A2uwvrVGTcRRT7KaI0O9m4ItRAyxR2tyM75OVFwbQLICNFQMXCFLPZSSRLD1swwgJtTZGBsVBYf69NZO4IA4RxPZOa9EGUZS76KxIwtfkKEygDwSc/tWC0q91Bz+yL7ZWFNLyXZR+N4bwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792079974; c=relaxed/simple;
	bh=vsysFOdstGPjfJp+JkcWvbbb1iAX34r9MXUA9GuKneM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=cVKQGrlx0hBCYESSNZQOQeOZPHtpHsxvaZ6zlEuK6fAo3KnROIipPh6/o7/c3z2eNIoSlnWaSCp+qCcU6hYiARbpAkmtKITBWA/uj+IMve4n435V3mqyo7+qIa057Q0J7jZsVctHk9/AtrYrwdW+uqhHNo9b0XjksdKeGmPukkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cjkQx6QI; arc=pass smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cjkQx6QI"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-6714595153cso163259d50.0
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 08:59:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792079961; cv=none;
        d=google.com; s=arc-20260327;
        b=YMro7zKTJm5wAOetTBUqtTQm4u4CkMHXm/xlijqr2yPv5gaVlI+hYZmoyeL+n67b1y
         0TIWLW1LDK/kcu4K0jGweTlcfh3ukquTd+hJfc0ymA1L4NHRzzzjmhUcDNmeFcxrU3pS
         YfWZNQTQjbJUjCZrHDIZu4ouhFoS1pTVyTDX/um9svTWHMPQTwZ0mS+AHTKzWUod1ic7
         FrlD1bp8uirhYWplVRvCrdF7PmDTGcc7SWq+J0oIbgbdvoyy6tNcYUY7U6Gi2W+3zN6d
         +mIK6DCeksB5c8WOs9zOhw50d1gHC1olwqPwVRZ+GxOu/JR1p+PmeKMVRzaZ6mR1HmRQ
         GwKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=jBb2AXlFHZfyj51hFLN2Fk9uHl7OyIwpeiQF3n86YDI=;
        fh=94XZ0kbhVmGEa7CVQQn7x19t/0l9HgwgaJK+mk7Jllo=;
        b=H6Njwe9W8gwvx/Ri2josWOgMOZYaz5Zc+DplJLH2Bceij1lltLbwpGKxgrIj3Fj3Z8
         ef6CgOHwVYiq/q5TbqNVOsDzWSdMq0/npAbppjU38pC0ZlkZdz+D6ShNG/LypJ3NLUQw
         0sGt4HuDHMDjbr0c8BZgN7gnTeZaOSTn7aARb0QOVKsYu6TEl3TsfKojCATYYWyP7e+2
         2x3Xalk43UfIUtQZxF7NI/AF5i/b4AdW+pxseoDyyyQiNezR2PfT3GJqAbQMQPE6xCpn
         4VPmE1F5dZU8PfDwtGtO4ECIXXxLS5Zw2lmBBkoS1CFg0szVz4zfEH7jHQ8fDEfBdpLY
         q6cw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792079961; x=1792684761; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jBb2AXlFHZfyj51hFLN2Fk9uHl7OyIwpeiQF3n86YDI=;
        b=cjkQx6QIbDcjBGgCMPHLfcCtXwI1sdWPZUuWF2zSvGYdE9tBtDOJNveC0NinnxhEt5
         cBj9i8ABwbqhhU4LGU5N3wXrPcOU8vkpSu+r0eozYSCG4yhbZtBfvuwhmRuLxMW57QLm
         qbiFdipfxcaKonnANz0oLt+xg5XBgrGNE7a/mJDQcm0wMZRk8WAJlEbA70S5N7/iLuNx
         rHPUHyzfHae7MMH0Awjl+QPDsfGyadrcaGIjW/+LktxKxzPBLPDuSv7lWb34duNdx4bv
         FY/94TGOKu3gm5oZWugHFk/AuemAOvqBBFjFDDygzyGOzj0tk8137YAV9wU3vyPqK8nb
         1DXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792079961; x=1792684761;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jBb2AXlFHZfyj51hFLN2Fk9uHl7OyIwpeiQF3n86YDI=;
        b=AxNHxPCPXd7WEsSWYMq8KMgNnk1UJXoVaKNx6/EsMTZX9OM+BRXRERYdffwbbaJOxI
         3qLUQtzJurVfFW9sj6wRWvBwf4jnr4wrKZ0X9YzZrco6r50CtqEyPlJ2NEKz2KYJgCp1
         TzMSfm3OWhZRMe3YDkZFewgiH57Pf7stGtdifJJ3bb0eroptjIeW9QlvdBsjutecYYCr
         Iu+JJS5LVZYYVCitwPlCdvPp+ZNyXjLEjlXSui11LjKq/YyQ7F1H0XGUD92/Ex4HxYIw
         wR2BA9i6JXEV5oC7oEfDamSm2OmAarRu8O4LFgKMZW9ibdHi62H8P/A78Kv7PMnXUxm7
         MxVA==
X-Gm-Message-State: AFq9FYKFv9elqheEdrwebYUq/hjGd3g5Q8Hwd4Ygoxk4fF/d923VgxN8
	p56+/j6eKu9WdRgs8jETuGFwVlSMFN/IzgNqibp0X5tCHlK1Njg7Sb5utIDmqwcFVPgIiIsONXa
	ArA4azsBguBQjhnWMg0hbK8fUtywgh8+yM/HGYyI=
X-Gm-Gg: AYBFou1tZyokWYHgUnrLwL2jre/IG7EMAoMAZCNlWNQbqV9kIPv9urn3/7QSikPUfqM
	ALaOxQ+EF279wssQqaUaZb0OkCtvKLCLF0GaDwGq7XW7T6+bvDNuqI8REtC6Iu34B48kHr9Rxau
	AR5Z0MceVmNEiIapGbv+TLmmFepSg78lIxXKW0DBc+5RHJkULJbFwFfMHrWRxrl8LWIaOzy9hKj
	+29/tmUAWjuFVw2RDDSWbZAIapwuyusUvZ6tpsT+xEgCKhmspk0i+CGopvyOOtDmVU5LJO6g1W2
	CnEIrKr56uESs+O9Sv/pFLMlAsIvKgqzeiv/s56h4Yl0hGdRmZ784EA=
X-Received: by 2002:a05:690e:11c7:b0:675:6e70:f21c with SMTP id
 956f58d0204a3-679b0ef3851mr128182d50.15.1792079960868; Thu, 15 Oct 2026
 08:59:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: L0crian <ryan.claridge13@gmail.com>
Date: Thu, 15 Oct 2026 11:59:08 -0400
X-Gm-Features: AclHuK9qPyNKooPJusOan1ImRAiKD65MD_-xTpuhwqPzZQ7MqY3XNfRc-CAZIYU
Message-ID: <CAHiFa4d6+TxR7xy_Fzd8EM3f8qe9VbkP4t-hEPVoLg2M3Z5-2w@mail.gmail.com>
Subject: [RFC]: Per-element logging for sets and maps
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello nftables devs!

I'd like nftables sets and maps to support optional logging on
individual elements. This would allow individual elements to retain
distinct logging behavior and prefixes when rules are consolidated
into sets or maps.

For example, with a verdict map:

    map test_ips {
        type ipv4_addr : verdict
        counter
        elements = {
            1.1.1.1 log prefix "VMAP-1.1.1.1: " : accept,
            4.2.2.2                              : accept,
            8.8.8.8 log prefix "VMAP-8.8.8.8: " : accept,
            9.9.9.9                              : accept
        }
    }

    chain output {
        type filter hook output priority filter; policy accept;
        ip daddr vmap @test_ips
    }

A prototype implementation supporting sets and maps is working
(userspace and kernel changes required). Testing the verdict map above
with locally generated traffic produces logging only for elements
configured with a prefix:

    # ping 1.1.1.1 -c 1 | grep VMAP
    VMAP-1.1.1.1: IN= OUT=lo SRC=1.1.1.1 DST=1.1.1.1 ... PROTO=ICMP TYPE=8 ...
    VMAP-1.1.1.1: IN= OUT=lo SRC=1.1.1.1 DST=1.1.1.1 ... PROTO=ICMP TYPE=0 ...

    # ping 4.2.2.2 -c 1 | grep VMAP
    <no output>

    # ping 8.8.8.8 -c 1 | grep VMAP
    VMAP-8.8.8.8: IN= OUT=lo SRC=8.8.8.8 DST=8.8.8.8 ... PROTO=ICMP TYPE=8 ...
    VMAP-8.8.8.8: IN= OUT=lo SRC=8.8.8.8 DST=8.8.8.8 ... PROTO=ICMP TYPE=0 ...

    # ping 9.9.9.9 -c 1 | grep VMAP
    <no output>

Per-element counters also continue to work alongside logging:

    elements = { 1.1.1.1 counter packets 14 bytes 1176 log prefix
"VMAP-1.1.1.1: " : accept,
                 4.2.2.2 counter packets 12 bytes 1008 : accept,
                 8.8.8.8 counter packets 10 bytes 840 log prefix
"VMAP-8.8.8.8: " : accept,
                 9.9.9.9 counter packets 8 bytes 672 : accept }

The use case is being able to consolidate individual rules into sets
and maps without losing the per-rule logging visibility that would
otherwise be available. Individual elements can retain their own
logging behavior and prefix while still benefiting from set/map
lookups.

The lack of per-element logging can also be a blocker for projects
that would otherwise use "nft -o" to optimize rulesets, since
combining individual rules into sets or maps may currently mean losing
distinct logging behavior or prefixes.
