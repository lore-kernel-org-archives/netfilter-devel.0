Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889D5BA33;
	Fri, 16 Aug 2024 01:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723770021; cv=none; b=nAfKAkNQhGcH4b7o1qyGFp8yNo5jW4SHOXcAxQ6FSJ7UW604T0wncMvX7Re44SIrXzaymEQuN11xcqiNRA9nt7/QdozM7jze8I4Tt9sr70UifSwMMGjKWtwP0zAuXGCx9IQeKqoCzgudvX8VYpPfhqG5Cb06oqY5eAKqyZifGNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723770021; c=relaxed/simple;
	bh=6Z1VJolCoXQLTemHjcVrm7KRpDaT1/mtr2A5nye3pUg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=arqSQZkMAjAlTpaEOopc8ScnaB0g4w8PezDP40+sVWWibWoGJN1mO1R0Exev/vZp9nJjtteNxb35mIDyvL3u7LgId+PvXOW8XSuOjcTXCcvsude2URnYYz4I2lcIIJT1fF4ggU/UtioRJruj1qz6wA+UneFSLLoBfVNuvg8salc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WlNp26qBSz20ldC;
	Fri, 16 Aug 2024 08:55:38 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id A80CA180043;
	Fri, 16 Aug 2024 09:00:14 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 09:00:12 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 0/4] Implement performance impact measurement tool
Date: Fri, 16 Aug 2024 08:59:39 +0800
Message-ID: <20240816005943.1832694-1-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Hello! This is v1 RFC patch dedicated to Landlock performance measurement.

Landlock LSM hooks are executed with many operations on Linux internal
objects (files, sockets). This hooks can noticeably affect performance
of such operations as it was demonstrated in the filesystem caching
patchset [1]. Having ability to calculate Landlock performance overhead
allows to compare kernel changes and estimate the acceptability
of new features (e.g. [2], [3], [4]).

A syscall execution time was chosen as the measured metric.
Landlock performance overhead is defined as the difference between syscall
duration in sandboxed mode and default mode.

Initially, perf trace was chosen as tracer that measures syscalls
durations. I've figured out that it can show imprecise values.
It doesn't affect real overhead value, but it shows the wrong
proportion of overhead relative to syscall baseline duration. Moreover,
using perf trace caused some measurement noise.

AFAICS all this happens due to its implementation and perf event handlers.
Until someone figures out if it's possible to fix this issues somehow I
suggest using libbpf-based simple program provided in this patchset
that uses per-syscall tracepoints and calculates average durations for
specified syscalls. In fact it has simple implementation based on a small
BPF programs and provides more precise metrics.

This patchset implements Landlock sandboxer which provides the ability to
customize the ruleset in a variable way.

Currently, following workloads are implemented:
* Simple script for syscalls microbenchmarking with `openat` support.
* Script that executes find tool under Linux source files with various
  depth and sandboxer configurations.

Microbenchmarks can have only simple rulesets with few number
of rules but in the next patches they should be extended with support of
large rulesets with different number of layers.

Here is an example of how this tool can be used to measure read access
Landlock overhead for workload that uses find tool on linux source files
(with depth 5):

    # ./bench/run.sh -t fs:.topology:4 -e openat -s -b \
    #    $FIND $LINUX_SRC -mindepth 5 -maxdepth 5 -exec file '{}' \;

    Tracing baseline workload...
    376.294s elapsed
    Tracing sandboxed workload...
    381.298s elapsed

    Tracing results
    ===============
    cmd: /usr/bin/find /root/linux -mindepth 5 -maxdepth 5 -exec file '{}' \;
    syscalls: openat
    access: 4
    overhead:
        syscall                  bcalls     scalls   duration+overhead(us)
        =======                  ======     ======   =====================
        syscall-257             1498623    1770882       1.88+0.46(+24.0%)

Please, share your opinion on the design of the tool and your ideas for
improving measurement and workloads!

[1] https://lore.kernel.org/all/20210630224856.1313928-1-mic@digikod.net/
[2] https://github.com/landlock-lsm/linux/issues/10
[3] https://github.com/landlock-lsm/linux/issues/19
[4] https://github.com/landlock-lsm/linux/issues/1

Closes: https://github.com/landlock-lsm/linux/issues/24

Mikhail Ivanov (4):
  selftests/landlock: Implement performance impact measurement tool
  selftests/landlock: Implement per-syscall microbenchmarks
  selftests/landlock: Implement custom libbpf-based tracer
  selftests/landlock: Add realworld workload based on find tool

 tools/testing/selftests/Makefile              |   1 +
 .../testing/selftests/landlock/bench/Makefile | 179 ++++++++
 .../landlock/bench/bench_find_on_linux.sh     |  84 ++++
 .../testing/selftests/landlock/bench/common.c | 283 ++++++++++++
 .../testing/selftests/landlock/bench/common.h |  18 +
 tools/testing/selftests/landlock/bench/config |  10 +
 .../selftests/landlock/bench/microbench.c     | 192 ++++++++
 .../selftests/landlock/bench/progs/tracer.c   | 126 ++++++
 tools/testing/selftests/landlock/bench/run.sh | 409 ++++++++++++++++++
 .../selftests/landlock/bench/sandboxer.c      | 117 +++++
 .../testing/selftests/landlock/bench/tracer.c | 278 ++++++++++++
 .../selftests/landlock/bench/tracer_common.h  |  15 +
 12 files changed, 1712 insertions(+)
 create mode 100644 tools/testing/selftests/landlock/bench/Makefile
 create mode 100755 tools/testing/selftests/landlock/bench/bench_find_on_linux.sh
 create mode 100644 tools/testing/selftests/landlock/bench/common.c
 create mode 100644 tools/testing/selftests/landlock/bench/common.h
 create mode 100644 tools/testing/selftests/landlock/bench/config
 create mode 100644 tools/testing/selftests/landlock/bench/microbench.c
 create mode 100644 tools/testing/selftests/landlock/bench/progs/tracer.c
 create mode 100755 tools/testing/selftests/landlock/bench/run.sh
 create mode 100644 tools/testing/selftests/landlock/bench/sandboxer.c
 create mode 100644 tools/testing/selftests/landlock/bench/tracer.c
 create mode 100644 tools/testing/selftests/landlock/bench/tracer_common.h


base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
-- 
2.34.1

