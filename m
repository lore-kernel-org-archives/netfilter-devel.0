Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net (zg8tmja5ljk3lje4mi4ymjia.icoremail.net [209.97.182.222])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3973EB0E8;
	Thu, 18 Jun 2026 10:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.182.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781777986; cv=none; b=IT0vNs328sXO2krpPXjjz+2prh6JCx3hAETaoLnaD2hjnzAv9qPHuXX8Sq0K66UsyYVJB68dIF7WWu6sF+tKGkLxuPsJsW7qCSrqTA3u9iMABI0f6RvQBO8diigG8UrXs+8Z1z7dDU7GQ8xHq+xeRRnomTtKqd9/rJgiBWj1G/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781777986; c=relaxed/simple;
	bh=G+PitzFSe2fg4eSYpsm+PJaJd5UrlFZtN6Vmq1Na+kU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JRKjHBCTqptRTZsGb/w/FQrACOKVI9t+UiVAubJUcaAZ0uu1il4CYc0tS+hCf2abNpRNuBFKQ2GsbKUJfAE4Ycc0jY1rSG0CZHl0MFERwA5o0B9Xos9JX0pEBzT8m+TjTnY1TNUCt2e2m8rV0w3ItjjZ8mga60tm9MxF2I5Da0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=ZPR2/oRS; arc=none smtp.client-ip=209.97.182.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="ZPR2/oRS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:In-Reply-To:References:MIME-Version:
	Content-Transfer-Encoding; bh=Y7guVCzhklovqsmxAETrv+dVmNu2/oIyCL
	Z54YmwyuI=; b=ZPR2/oRSCkHp0/nMH9GvucrclgDVvmAzeYYJQScyAX1EkIvvjn
	9MqgWZ6Tc3Uquqnmsom9H0gVkGdNCMZVOxP8csWW31tAAM0oVIbm66bGxKJKm604
	o9YYvO7ovwW2LjYyhk+YVCHkRceFBnZ8gEnM5YTNdWuJv8fxtl85+zjDs=
Received: from c9a6c405b3f2.. (unknown [202.112.238.121])
	by web5 (Coremail) with SMTP id zAQGZQB3L78IxjNq23+CAg--.46531S2;
	Thu, 18 Jun 2026 18:18:55 +0800 (CST)
From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
To: bpf@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrii@kernel.org,
	eddyz87@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	shuah@kernel.org,
	kartikey406@gmail.com,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 0/2] bpf: Guard conntrack opts error writes
Date: Thu, 18 Jun 2026 10:18:42 +0000
Message-Id: <cover.1781765747.git.chenyy23@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1781586477.git.chenyy23@mails.tsinghua.edu.cn>
References: <cover.1781586477.git.chenyy23@mails.tsinghua.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zAQGZQB3L78IxjNq23+CAg--.46531S2
X-Coremail-Antispam: 1UD129KBjvJXoWxur47XrWxZr18Xw1fJFyrJFb_yoW5Xry7pF
	WfKwn0krn7JF4UGF4I9FWxta4rC3Z3J34fCrn8GryfCwnxtry8JFWSvryDuF9xCr9xur1a
	vw4F9345Cr4rAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCY02Avz4vE14
	v_Gw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTRR4E_UUUU
	U
X-CM-SenderInfo: xfkh05r1stqzpdlo2hxwvl0wxkxdhvlgxou0/

The conntrack lookup/allocation kfuncs expose an opts/opts__sz pair.
The verifier checks the caller-provided opts__sz range, but the wrappers
currently write opts->error after internal errors even when opts__sz is too
small to include that field.

Patch 1 writes opts->error only when opts__sz includes it, and uses a
single helper to fold ERR_PTR returns into the kfunc ABI result while keeping
the local nfct result variable in each wrapper.
Patch 2 adds a bpf_nf regression check that keeps a guard in opts->error
while passing opts__sz covering only netns_id.

The regression check follows the existing bpf_nf test shape.  Before the
fix, the guard is overwritten with -EINVAL even though opts__sz covers only
the first four bytes of the options object.  After the fix, the kfunc still
returns NULL for the invalid size, but the guard remains intact.

Validation, rebased and tested on bpf-next master e771677c937d
("Merge tag 'for-linus-iommufd' of git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd"):

  git diff --check origin/master..HEAD: OK
  scripts/checkpatch.pl --strict on 1/2 and 2/2: OK
  make O=/root/ebpf-verifier-bug-detection/kernel-build/bpf-next \
    net/netfilter/nf_conntrack_bpf.o: OK
  Focused QEMU direct-runner against XDP and TC lookup/alloc paths:
    unpatched bpf-next e771677c937d: guard overwritten with -EINVAL
    patched v2 007dfd0341cd: guard preserved as 0x12345678
  QEMU upstream bpf_nf selftest with CONFIG_NF_CONNTRACK_MARK,
  CONFIG_NF_CONNTRACK_ZONES, and legacy iptables enabled:
    ./test_progs -t bpf_nf -vv: OK
  git am of exported 1/2 and 2/2 on a fresh worktree at base: OK
  range-diff between branch commits and git-am result: equivalent

Changes in v2:
  - Rebased onto current bpf-next master.
  - Reworked patch 1 to use bpf_ct_opts_result() for the ERR_PTR-to-NULL
    conversion and guarded opts->error write, as suggested by Alexei.
  - Kept the local nfct result variable in each wrapper before returning
    through bpf_ct_opts_result().
  - Added matching Fixes tags to the selftest patch so the regression test
    can be backported with the fix.

v1: https://lore.kernel.org/bpf/cover.1781586477.git.chenyy23@mails.tsinghua.edu.cn/

Yiyang Chen (2):
  bpf: Guard conntrack opts error writes
  selftests/bpf: Cover small conntrack opts error writes

 net/netfilter/nf_conntrack_bpf.c              | 35 +++++++------------
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  6 ++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 ++++++++++++++
 3 files changed, 45 insertions(+), 22 deletions(-)


base-commit: e771677c937da5808f7b6c1f0e4a97ec1a84f8a8
-- 
2.34.1

