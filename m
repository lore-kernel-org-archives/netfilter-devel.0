Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EE01CEE91
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2024 22:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730500557; cv=none; b=QE8lG8ei9aKf3/2fV9rJ4NToNTk70PnGcaG8O+TvoVjvQ4TI39TdrSIntq3tuxSOdeGCgRcgRdtPT866ee7VZq258bVSZcaO+cEPlhiFJVZmIIsqI2SVxk+4ap6Ki/psjpptH5FI0EsLT7fTyiPHZqdEd3cxdiUMbhUwEIMFtts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730500557; c=relaxed/simple;
	bh=HkdujpmeM6leajezGFJ0dIxPW0s833+qOO5HkzuxjSw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iJtqRv5rFpodH4xhUu06+zf6+JurBb58EYKdGc6shkOXgGKmEUq8kxQIBZIOknbt6hg8LG7Xzf7rK4us8YD0KhETSPPGG5ujBAApBLd7eloBWh2UCqEhguh5YILhrSwdy7HqnHvXbaKqpasW9z2Y6mnXaAAjI4AZggGmOEfrpIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=QvBEgVn0; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="QvBEgVn0"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-6ea339a41f1so22240147b3.2
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Nov 2024 15:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1730500554; x=1731105354; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2lhhyRmRqR2JT6E7K6yR9k0iZHG3B0RckCd16k7TYww=;
        b=QvBEgVn0X38ntqruQyMAaRHoJXPh2+yCaYULYvhXCXWKxewA1A1Q1DFsxRSNeKXjB6
         GounxMvEV8MGTAicbueTPjLhVXAREBZujdzVDBjxZkygscnupcEBHScdDV3ZfIB7SL04
         1G9UjxNI7R/7M3z+gEifXhMdR2m7MPvU7a1WeHw1CpTGcx6vNGy3pj7oQ/JVOYrCBYJ9
         ZvcL4OXU4XMEBtQUUdlxh3Ed3b3nH4hpWZ0PSdHtvFwkvArNLV7sjyS+DZ6W0Opmt5uT
         QWxL9kvhsEQeZQH4KcbkyL0hKxm7TUgReOakKTYBjSByxocqSAv94htcyM1eChoVcXVc
         IvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730500554; x=1731105354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2lhhyRmRqR2JT6E7K6yR9k0iZHG3B0RckCd16k7TYww=;
        b=riPAi0SEPwC82/YbWSqM367wsgz7hLxOO5mEG8b5Vn3gRrLpymdU/ycNerRNjSM2nk
         3sDYY8I1te6YmjVTneVa51phLMGCgTAtGXKJ4/MrjoOL9GJOf71ZypoM3gqvWsjREBM7
         yJSb+9gQnXcU55Rwdh7T4Zh7YotqccjMMd7ROdJrinij8MFs+aJ0JMrt9yBXqfZtzMKB
         861x/7cL7Blz04Cs93ijgcreNfLZNIizNwWIw49lsv9jyf0GQ0OR7kHP+WUvLcM493WA
         65K7oS/xNFYmksB9LxpGaw6Jp2Ergi1koqfvJpnjkp90YUf/M6so2Gjd3JlY9G7JXxl/
         oZVA==
X-Forwarded-Encrypted: i=1; AJvYcCXvMVcKx9Fez/23Mhro7lPsLEjudsiRJ4DESrSqOlRvsCOJzMz2eo95t54GafwRqTEijYL8N7v3EwY/cDmww/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YygsmNrvqr+iA16/C2WLa8ShgpLryeNjCLo0I7Laffc092/pwlR
	MdH+wfenju2SSeZm/9dn2dM/3LctstYOgcYvw+sgZvYHvnRDARQ7QkOMowtPyJf2zN/9A6VkzLF
	kNLJGsdWFtpa9mUQAAN+rp0KWUEmcdhFiB+Dd
X-Google-Smtp-Source: AGHT+IGLZXmJsQQ2sKiikz9TgnPYgXD0tbva/bCDySD9hmHigbkngL/rc+p0gWujXikryeKbgIOjKIhW5Aq3ZD5DE8M=
X-Received: by 2002:a05:690c:380f:b0:6e5:de2d:39b1 with SMTP id
 00721157ae682-6ea523215demr93648977b3.5.1730500553895; Fri, 01 Nov 2024
 15:35:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <97463c75-2edd-47e0-b081-a235891bee6e.ref@schaufler-ca.com>
 <97463c75-2edd-47e0-b081-a235891bee6e@schaufler-ca.com> <CAHC9VhTAijBwEtqi5cpdpo1MwSW4aLL+jy9ctwbU1XVcq4wEYg@mail.gmail.com>
In-Reply-To: <CAHC9VhTAijBwEtqi5cpdpo1MwSW4aLL+jy9ctwbU1XVcq4wEYg@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 1 Nov 2024 18:35:43 -0400
Message-ID: <CAHC9VhT89kE=wbWFG+eU8VCM2aeDXnwn0az95b7pXOtM_8EQjg@mail.gmail.com>
Subject: Re: [PATCH lsm/dev] netfilter: Use correct length value in ctnetlink_secctx_size
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LSM List <linux-security-module@vger.kernel.org>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 4:07=E2=80=AFPM Paul Moore <paul@paul-moore.com> wro=
te:
>
> On Fri, Nov 1, 2024 at 2:43=E2=80=AFPM Casey Schaufler <casey@schaufler-c=
a.com> wrote:
> >
> > Use the correct value for the context length returned by
> > security_secid_to_secctx().
> >
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > ---
> >  net/netfilter/nf_conntrack_netlink.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Thanks Casey, I'm going to merge this into lsm/dev-staging for
> testing, but additional comments, reviews, etc. are always welcome.

Unfortunately it looks like there is still an issue.  Running the NFS
tests from the selinux-testsuite I hit the panic splat below.

There are instructions on how to run the selinux-testsuite's NFS tests
in the test suite's README.md (linked below), but basically make sure
you have a working test suite, install the "nfs-utils" package, and
then run `./tools/nfs.sh`.

https://github.com/SELinuxProject/selinux-testsuite

If it helps, the kernel I used for testing can be found in the
directory below, it's version
6.12.0-0.rc5.20241101git6c52d4da.48.3.secnext.fc42 on x86_64.  There
are debuginfos in there too if needed.

https://repo.paul-moore.com/rawhide/x86_64

[   36.233175] NFSD: starting 90-second grace period (net f0000000)
[   36.348290] Key type dns_resolver registered
[   36.538794] NFS: Registering the id_resolver key type
[   36.539855] Key type id_resolver registered
[   36.540109] Key type id_legacy registered
[   36.563308] NFSD: all clients done reclaiming, ending NFSv4 grace
period (net f0000000)
[   36.718416] BUG: kernel NULL pointer dereference, address: 0000000000000=
000
[   36.724501] #PF: supervisor read access in kernel mode
[   36.724824] #PF: error_code(0x0000) - not-present page
[   36.725126] PGD 0 P4D 0
[   36.725285] Oops: Oops: 0000 [#1] PREEMPT SMP PTI
[   36.725588] CPU: 2 UID: 0 PID: 1228 Comm: sh Not tainted
6.12.0-0.rc5.20241101git6c52d4da.48.3.secnext.fc42.x86_64 #1
[   36.726284] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   36.726638] RIP: 0010:memcpy_orig+0x1e/0x140
[   36.726922] Code: 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00
48 89 f8 48 83 fa 20 0f 82 86 00 00 00 40 38 fe 7c 35 48 83 ea 20 48
83 ea 20 <4c> 8b 06 4c 8b 4e 08 4c 8b 56 10 4c 8b 5e 18 48 8d 76 20 4c
89 07
[   36.727992] RSP: 0018:ffffb9e680aa7900 EFLAGS: 00010283
[   36.728298] RAX: ffff95cac1458800 RBX: ffff95cac5035000 RCX: 00000000000=
00000
[   36.728734] RDX: ffffffffffffffe6 RSI: 0000000000000000 RDI: ffff95cac14=
58800
[   36.729148] RBP: ffff95cad8f1be40 R08: 0000000000000800 R09: 00000000000=
00000
[   36.729572] R10: ffffb9e680aa78e8 R11: 0000000000000192 R12: ffff95cac0a=
85e00
[   36.730075] R13: ffff95cac09f0a80 R14: ffffb9e680aa7ad0 R15: ffff95caf18=
9b400
[   36.730494] FS:  00007f961aa98740(0000) GS:ffff95cbf7d00000(0000)
knlGS:0000000000000000
[   36.730964] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.731300] CR2: 0000000000000000 CR3: 00000001197b8000 CR4: 00000000001=
506f0
[   36.731720] Call Trace:
[   36.731875]  <TASK>
[   36.732010]  ? __die_body.cold+0x19/0x27
[   36.732247]  ? page_fault_oops+0x15a/0x2f0
[   36.732490]  ? search_module_extables+0x19/0x60
[   36.732766]  ? search_bpf_extables+0x5f/0x80
[   36.733024]  ? exc_page_fault+0x7e/0x180
[   36.733261]  ? asm_exc_page_fault+0x26/0x30
[   36.733511]  ? memcpy_orig+0x1e/0x140
[   36.733842]  nfs4_opendata_alloc+0x314/0x470 [nfsv4]
[   36.734431]  nfs4_do_open+0x207/0xd10 [nfsv4]
[   36.734957]  ? security_sid_to_context_core+0x114/0x150
[   36.735492]  ? selinux_dentry_init_security+0xc5/0x120
[   36.736061]  nfs4_atomic_open+0xbf/0x140 [nfsv4]
[   36.736638]  nfs_atomic_open+0x20f/0x670 [nfs]
[   36.737205]  path_openat+0xbfa/0x12e0
[   36.737626]  do_filp_open+0xc4/0x170
[   36.738063]  do_sys_openat2+0xae/0xe0
[   36.738489]  __x64_sys_openat+0x55/0xa0
[   36.738939]  do_syscall_64+0x82/0x160
[   36.739368]  ? __count_memcg_events+0x77/0x130
[   36.739859]  ? count_memcg_events.constprop.0+0x1a/0x30
[   36.740285]  ? handle_mm_fault+0x21b/0x330
[   36.740622]  ? do_user_addr_fault+0x55a/0x7b0
[   36.740992]  ? exc_page_fault+0x7e/0x180
[   36.741316]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   36.741739] RIP: 0033:0x7f961ab072d6
[   36.742056] Code: 89 df e8 8d c1 00 00 8b 93 08 03 00 00 59 5e 48
83 f8 fc 75 15 83 e2 39 83 fa 08 75 0d e8 32 ff ff ff 66 90 48 8b 45
10 0f 05 <48> 8b 5d f8 c9 c3 0f 1f 40 00 f3 0f 1e fa 55 48 89 e5 48 83
ec 08
[   36.743559] RSP: 002b:00007ffcce132c80 EFLAGS: 00000202 ORIG_RAX:
0000000000000101
[   36.744172] RAX: ffffffffffffffda RBX: 00007f961aa98740 RCX: 00007f961ab=
072d6
[   36.744748] RDX: 0000000000000241 RSI: 000055a76c121be0 RDI: fffffffffff=
fff9c
[   36.745323] RBP: 00007ffcce132c90 R08: 0000000000000000 R09: 00000000000=
00000
[   36.745899] R10: 00000000000001b6 R11: 0000000000000202 R12: 00000000000=
00000
[   36.746527] R13: 0000000000000001 R14: 000055a76c121be0 R15: 000055a7308=
f67c0
[   36.747187]  </TASK>
[   36.747388] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver
nfsd auth_rpcgss nfsv3 nfs_acl nfs lockd grace netfs rfkill vfat fat
intel_rapl_msr intel_rapl_common virtio_balloon i2c_piix4 virtio_net
i2c_smbus net_failover failover joydev loop nfnetlink vsock_loopback
vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vsock
vmw_vmci rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod
target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm
ib_ipoib iw_cm ib_cm fuse mlx5_ib macsec ib_uverbs ib_core
crct10dif_pclmul crc32_pclmul crc32c_intel polyval_clmulni
polyval_generic ghash_clmulni_intel virtio_blk sha512_ssse3
sha256_ssse3 sha1_ssse3 ata_generic pata_acpi serio_raw mlx5_core
mlxfw psample tls pci_hyperv_intf qemu_fw_cfg virtio_console
[   36.753333] CR2: 0000000000000000
[   36.753832] ---[ end trace 0000000000000000 ]---
[   36.754298] RIP: 0010:memcpy_orig+0x1e/0x140
[   36.756227] Code: 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00
48 89 f8 48 83 fa 20 0f 82 86 00 00 00 40 38 fe 7c 35 48 83 ea 20 48
83 ea 20 <4c> 8b 06 4c 8b 4e 08 4c 8b 56 10 4c 8b 5e 18 48 8d 76 20 4c
89 07
[   36.757911] RSP: 0018:ffffb9e680aa7900 EFLAGS: 00010283
[   36.758560] RAX: ffff95cac1458800 RBX: ffff95cac5035000 RCX: 00000000000=
00000
[   36.759869] RDX: ffffffffffffffe6 RSI: 0000000000000000 RDI: ffff95cac14=
58800
[   36.760455] RBP: ffff95cad8f1be40 R08: 0000000000000800 R09: 00000000000=
00000
[   36.761039] R10: ffffb9e680aa78e8 R11: 0000000000000192 R12: ffff95cac0a=
85e00
[   36.761718] R13: ffff95cac09f0a80 R14: ffffb9e680aa7ad0 R15: ffff95caf18=
9b400
[   36.762316] FS:  00007f961aa98740(0000) GS:ffff95cbf7d00000(0000)
knlGS:0000000000000000
[   36.762990] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.763476] CR2: 0000000000000000 CR3: 00000001197b8000 CR4: 00000000001=
506f0

--=20
paul-moore.com
