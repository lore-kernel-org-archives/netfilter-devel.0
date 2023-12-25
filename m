Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E8452F6C
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Dec 2023 17:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hY+Sauog"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-427b1bf1896so26194591cf.3
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Dec 2023 09:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703525571; x=1704130371; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3EkRPOVY5W4uHqcjVdowvwHSkXQ7n4UR70DwP3SjxS8=;
        b=hY+Sauogbqoc7h1pVz31Bz7ZfE/ZSr38WslDjbn5wPCd5t9kG6MlRjmXJzmlfRqXsZ
         Oa7my4+q7/RWHDJ8fn6sHE6aIViKA+AKhRI1fIwzaK0kWn9zNUemarIJN3dx8sBD/qsG
         7LgDli7q98GgPGmPQGeExhYPCs9zdZYg0FbNw0oQeo5N20xyEynhN9li5FbC/NVyjtMx
         IsNj66H0obLQozKpI4pgj/5KgZ/xDjQDACyp5pRM6fLcP5QEunRka0lFZ0A00/T+CcmI
         wTh84z/76VhMUo5mQRwuclXEItCHm3FT5EwzJnPtt5QLrfBNOaA4aGpVYGDHDGKXSRDI
         8ALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703525571; x=1704130371;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3EkRPOVY5W4uHqcjVdowvwHSkXQ7n4UR70DwP3SjxS8=;
        b=MltLkTyFENAuGr3wRN8y17zegjL9oroL+bqBoQ20cE4gT9IuRFX4+TfcfS5T2ixm61
         dOIyGQ6PnK3CpB99IYQ/BDoCjf3RJfIIvoPPNHF/z6z7SUJy3IsqIqzhXENGKDmQOXd8
         +0daAlZXm8T2f2r4AwmyTVSU9CMn7tws2b/phGKWlo4aEVAcHxzK0l783htBGLpDnzVm
         oghG0QkNtsC8BWFU1kx7jIP/RMBrrZLg8ntpd/O02Ehv+jcYECKX7P8WOE6J7lG7mqQl
         j/v0/EWwlNgTn2Wc09ag+ql6DuxcBRVR3uBgIUFO3neL5ZpNv3taA8+DQQcHYBss5/AI
         blXw==
X-Gm-Message-State: AOJu0Yy2MBuRKauBEu36rT1u1vwEbv4VPzZBU09ICJQFnEEOPQlnFe3a
	+pEwp2Jpr/h9MdWTBTpSOvqQD9R2QuU496vkdDM82LvieTs=
X-Google-Smtp-Source: AGHT+IEWtJkYrvr/R0nxWCa/z4glDbZS94XWBbv7XVDGfBKAktUSlOp0Jf09SGrVyUIMikWOoIK3/g50hs3pUV1192c=
X-Received: by 2002:ac8:5a8b:0:b0:425:4043:5f41 with SMTP id
 c11-20020ac85a8b000000b0042540435f41mr8621368qtc.127.1703525571338; Mon, 25
 Dec 2023 09:32:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: P K <pkopensrc@gmail.com>
Date: Mon, 25 Dec 2023 23:02:40 +0530
Message-ID: <CAL0j0DG26=dxHysHajcFkS+Aac8e9rnM3Rsy8drBZMns=eynOQ@mail.gmail.com>
Subject: Kprobe for nf_nat is broken in Latest Debian 6.1.66-1
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

In recent debian kernel 6.1.66-1 kprobe to nf_nat_ipv4_manip_pkt or
any nf_nat function is not working. It was working fine on 6.1.55-1
kfunc is working fine.

Any suggestions on how to fix this?

Below are logs:

Not working :

/ # bpftrace --info
System
  OS: Linux 6.1.0-15-cloud-amd64 #1 SMP PREEMPT_DYNAMIC Debian
6.1.66-1 (2023-12-09)
  Arch: x86_64

Build
  version: v0.17.1
  LLVM: 16.0.3
  unsafe uprobe: no
  bfd: yes
  libdw (DWARF support): yes

Kernel helpers
  probe_read: yes
  probe_read_str: yes
  probe_read_user: yes
  probe_read_user_str: yes
  probe_read_kernel: yes
  probe_read_kernel_str: yes
  get_current_cgroup_id: yes
  send_signal: yes
  override_return: no
  get_boot_ns: yes
  dpath: yes
  skboutput: no

Kernel features
  Instruction limit: 1000000
  Loop support: yes
  btf: yes
  map batch: yes
  uprobe refcount (depends on Build:bcc bpf_attach_uprobe refcount): yes

Map types
  hash: yes
  percpu hash: yes
  array: yes
  percpu array: yes
  stack_trace: yes
  perf_event_array: yes

Probe types
  kprobe: yes
  tracepoint: yes
  perf_event: yes
  kfunc: yes
  iter:task: yes
  iter:task_file: yes
  kprobe_multi: no
  raw_tp_special: yes

/ #

$ sudo bpftrace -l | grep "manip"
kfunc:nf_nat:l4proto_manip_pkt
kfunc:nf_nat:nf_nat_ipv4_manip_pkt
kfunc:nf_nat:nf_nat_ipv6_manip_pkt
kfunc:nf_nat:nf_nat_manip_pkt
kprobe:l4proto_manip_pkt
kprobe:nf_nat_ipv4_manip_pkt
kprobe:nf_nat_ipv6_manip_pkt
kprobe:nf_nat_manip_pkt


/ # bpftrace -e 'kprobe:nf_nat_ipv4_manip_pkt { printf("func called\n"); }'
Attaching 1 probe...
cannot attach kprobe, probe entry may not exist
ERROR: Error attaching probe: 'kprobe:nf_nat_ipv4_manip_pkt'


/ # bpftrace -e 'kfunc:nf_nat:nf_nat_ipv4_manip_pkt { printf("func
called\n"); }'
Attaching 1 probe...

func called
func called
func called
func called
func called
func called
func called
func called
func called
func called
func called
func called
^C

/ #


Working:
/ # bpftrace --info
System
  OS: Linux 6.1.0-13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.55-1 (2023-09-29)
  Arch: x86_64

Build
  version: v0.17.1
  LLVM: 16.0.3
  unsafe uprobe: no
  bfd: yes
  libdw (DWARF support): yes

Kernel helpers
  probe_read: yes
  probe_read_str: yes
  probe_read_user: yes
  probe_read_user_str: yes
  probe_read_kernel: yes
  probe_read_kernel_str: yes
  get_current_cgroup_id: yes
  send_signal: yes
  override_return: no
  get_boot_ns: yes
  dpath: yes
  skboutput: no

Kernel features
  Instruction limit: 1000000
  Loop support: yes
  btf: yes
  map batch: yes
  uprobe refcount (depends on Build:bcc bpf_attach_uprobe refcount): yes

Map types
  hash: yes
  percpu hash: yes
  array: yes
  percpu array: yes
  stack_trace: yes
  perf_event_array: yes

Probe types
  kprobe: yes
  tracepoint: yes
  perf_event: yes
  kfunc: yes
  iter:task: yes
  iter:task_file: yes
  kprobe_multi: no
  raw_tp_special: yes


/ # bpftrace -l | grep "manip"
kprobe:l4proto_manip_pkt
kprobe:nf_nat_ipv4_manip_pkt
kprobe:nf_nat_ipv6_manip_pkt
kprobe:nf_nat_manip_pkt
/ #


/ # bpftrace --version
bpftrace v0.17.1
/ # bpftrace -e 'kprobe:nf_nat_ipv4_manip_pkt { printf("func called\n"); }'
Attaching 1 probe...
func called
func called
func called
func called
func called
func called
func called
func called
^C

/ # bpftrace -e 'kfunc:nf_nat:nf_nat_ipv4_manip_pkt { printf("func
called\n"); }'
Attaching 1 probe...
func called
func called
func called
func called
func called
func called
func called
func called
func called

^C
/ #
