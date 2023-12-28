Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF0AF9E0
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2023 18:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JIHsvjOC"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-59502aa878aso210041eaf.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2023 10:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703787915; x=1704392715; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TuY6MMc33fQdxQvrMewBtz4gZujrbRUWhZfJnqX5tt4=;
        b=JIHsvjOChLQmE6hTgZjefaIFqCcg3DrAOzequL3XKMg22dGc7J+2yjRjxS2i7EOKXK
         ZE5FM/2iP79jQRXq6i0OculqB2CarLgwoqLBNTyQj6s722pYV/r8gOvNMBcHSdo+Fkz9
         +ZjyKWam1lwQCOLrNyYuuqYUkkUNFZ7tATeWqL0rTMAc1Fjc+SXOeCA4ZUcLiYn0Dz7t
         ItXwIdmYoGCfdGgdJsEYqpR3TS5+UdFRsTNvXtvl4EbsFLpqemKkPfztXF+e1dw4L6K6
         zEKrJmTfmiaktcjK39jpGrd4N5xptVTfRMwIn7PZDtcAIH2+aQMMR4a+aQhRodA4YsUg
         VBqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703787915; x=1704392715;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TuY6MMc33fQdxQvrMewBtz4gZujrbRUWhZfJnqX5tt4=;
        b=JPMXmXv2Ony9GhO/OP0w3HyF1vgtofHodJYwM7xts600R34ep4h+gA6zFxoSrqGYkv
         MkKFeKgWy1BTFjzxGxtWGc54qFOPPTtm5O0RjWQYIVU5GfJyMzK6WxFMe7fSaS7idY1P
         HBdbm4cdPZJMf4j0exsdwyuEu6HY6cxLk17vvRHNX0BfkMuiYgkLBmW1fRVy5kxUoUqb
         85HU3sxy7dspFtXHR3JJcBFcnYxiY0n98hfrTAdEHJLBbicVWShmBTB23m9IE5E3StnB
         v33Vd2re8+vwxeAG1eXQCClHfC5YiKgapEk1MA27qGS25apzt3wiFDq92YmJCrWnw/19
         vFvA==
X-Gm-Message-State: AOJu0YxQnElwuU6Kv4mY5MPOsBO+Tzm2T49lCSXp4q5kXJRp3/9WdGNd
	V+9AJMZlYjQGHyUo9zl3kXuylUwYOgY/lqFSOA2wInYjdS4=
X-Google-Smtp-Source: AGHT+IHDzKq++bcyXis8X/0muSVGBiAhj/u2gV0feata5dyPGOmbz6R1AU9jdmCL9k/U+5kYArj9rNh1eDzjh9Ch8qc=
X-Received: by 2002:a4a:b044:0:b0:58d:b097:b014 with SMTP id
 g4-20020a4ab044000000b0058db097b014mr5100088oon.0.1703787915457; Thu, 28 Dec
 2023 10:25:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAL0j0DG26=dxHysHajcFkS+Aac8e9rnM3Rsy8drBZMns=eynOQ@mail.gmail.com>
In-Reply-To: <CAL0j0DG26=dxHysHajcFkS+Aac8e9rnM3Rsy8drBZMns=eynOQ@mail.gmail.com>
From: P K <pkopensrc@gmail.com>
Date: Thu, 28 Dec 2023 23:55:04 +0530
Message-ID: <CAL0j0DFaK+ihi2HWZn6EFPkYetjPRibboy_OR2sJ5Q_wR_swXQ@mail.gmail.com>
Subject: Re: Kprobe for nf_nat is broken in Latest Debian 6.1.66-1
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please let me know if it's broken in the recent kernel or  not or any
workaround to attach to the function nf_nat_ipv4_manip_pkt using bpf?
I am still stuck on to find workaround.

On Mon, Dec 25, 2023 at 11:02=E2=80=AFPM P K <pkopensrc@gmail.com> wrote:
>
> Hi,
>
> In recent debian kernel 6.1.66-1 kprobe to nf_nat_ipv4_manip_pkt or
> any nf_nat function is not working. It was working fine on 6.1.55-1
> kfunc is working fine.
>
> Any suggestions on how to fix this?
>
> Below are logs:
>
> Not working :
>
> / # bpftrace --info
> System
>   OS: Linux 6.1.0-15-cloud-amd64 #1 SMP PREEMPT_DYNAMIC Debian
> 6.1.66-1 (2023-12-09)
>   Arch: x86_64
>
> Build
>   version: v0.17.1
>   LLVM: 16.0.3
>   unsafe uprobe: no
>   bfd: yes
>   libdw (DWARF support): yes
>
> Kernel helpers
>   probe_read: yes
>   probe_read_str: yes
>   probe_read_user: yes
>   probe_read_user_str: yes
>   probe_read_kernel: yes
>   probe_read_kernel_str: yes
>   get_current_cgroup_id: yes
>   send_signal: yes
>   override_return: no
>   get_boot_ns: yes
>   dpath: yes
>   skboutput: no
>
> Kernel features
>   Instruction limit: 1000000
>   Loop support: yes
>   btf: yes
>   map batch: yes
>   uprobe refcount (depends on Build:bcc bpf_attach_uprobe refcount): yes
>
> Map types
>   hash: yes
>   percpu hash: yes
>   array: yes
>   percpu array: yes
>   stack_trace: yes
>   perf_event_array: yes
>
> Probe types
>   kprobe: yes
>   tracepoint: yes
>   perf_event: yes
>   kfunc: yes
>   iter:task: yes
>   iter:task_file: yes
>   kprobe_multi: no
>   raw_tp_special: yes
>
> / #
>
> $ sudo bpftrace -l | grep "manip"
> kfunc:nf_nat:l4proto_manip_pkt
> kfunc:nf_nat:nf_nat_ipv4_manip_pkt
> kfunc:nf_nat:nf_nat_ipv6_manip_pkt
> kfunc:nf_nat:nf_nat_manip_pkt
> kprobe:l4proto_manip_pkt
> kprobe:nf_nat_ipv4_manip_pkt
> kprobe:nf_nat_ipv6_manip_pkt
> kprobe:nf_nat_manip_pkt
>
>
> / # bpftrace -e 'kprobe:nf_nat_ipv4_manip_pkt { printf("func called\n"); =
}'
> Attaching 1 probe...
> cannot attach kprobe, probe entry may not exist
> ERROR: Error attaching probe: 'kprobe:nf_nat_ipv4_manip_pkt'
>
>
> / # bpftrace -e 'kfunc:nf_nat:nf_nat_ipv4_manip_pkt { printf("func
> called\n"); }'
> Attaching 1 probe...
>
> func called
> func called
> func called
> func called
> func called
> func called
> func called
> func called
> func called
> func called
> func called
> func called
> ^C
>
> / #
>
>
> Working:
> / # bpftrace --info
> System
>   OS: Linux 6.1.0-13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.55-1 (2023-0=
9-29)
>   Arch: x86_64
>
> Build
>   version: v0.17.1
>   LLVM: 16.0.3
>   unsafe uprobe: no
>   bfd: yes
>   libdw (DWARF support): yes
>
> Kernel helpers
>   probe_read: yes
>   probe_read_str: yes
>   probe_read_user: yes
>   probe_read_user_str: yes
>   probe_read_kernel: yes
>   probe_read_kernel_str: yes
>   get_current_cgroup_id: yes
>   send_signal: yes
>   override_return: no
>   get_boot_ns: yes
>   dpath: yes
>   skboutput: no
>
> Kernel features
>   Instruction limit: 1000000
>   Loop support: yes
>   btf: yes
>   map batch: yes
>   uprobe refcount (depends on Build:bcc bpf_attach_uprobe refcount): yes
>
> Map types
>   hash: yes
>   percpu hash: yes
>   array: yes
>   percpu array: yes
>   stack_trace: yes
>   perf_event_array: yes
>
> Probe types
>   kprobe: yes
>   tracepoint: yes
>   perf_event: yes
>   kfunc: yes
>   iter:task: yes
>   iter:task_file: yes
>   kprobe_multi: no
>   raw_tp_special: yes
>
>
> / # bpftrace -l | grep "manip"
> kprobe:l4proto_manip_pkt
> kprobe:nf_nat_ipv4_manip_pkt
> kprobe:nf_nat_ipv6_manip_pkt
> kprobe:nf_nat_manip_pkt
> / #
>
>
> / # bpftrace --version
> bpftrace v0.17.1
> / # bpftrace -e 'kprobe:nf_nat_ipv4_manip_pkt { printf("func called\n"); =
}'
> Attaching 1 probe...
> func called
> func called
> func called
> func called
> func called
> func called
> func called
> func called
> ^C
>
> / # bpftrace -e 'kfunc:nf_nat:nf_nat_ipv4_manip_pkt { printf("func
> called\n"); }'
> Attaching 1 probe...
> func called
> func called
> func called
> func called
> func called
> func called
> func called
> func called
> func called
>
> ^C
> / #
