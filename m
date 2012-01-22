From: Richard Weinberger <richard@nod.at>
Subject: [PATCH v2] Merge ipt_LOG and ip6t_LOG, add ring bufffer support
Date: Sun, 22 Jan 2012 22:56:15 +0100
Message-ID: <1327269381-20748-1-git-send-email-richard@nod.at>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	eric.dumazet@gmail.com, jengelh@medozas.de
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi!

This patch set merges ipt_LOG and ip6t_LOG and adds ring buffer support
to xt_LOG.

Using "--ring" a user can create LOG rules which log messages into
one or more ring buffers.
Each ring buffer is represented as pipe-like file in
/proc/net/netfilter/xt_LOG_ring/.

Ring buffer support can be enabled/disabled using
CONFIG_NETFILTER_XT_TARGET_LOG_RING.

Changes since v1:
 - Merged ipt_LOG and ip6t_LOG
 - Implemented ring buffer support as part of xt_LOG.

[PATCH 1/6] Netfilter: Merge ipt_LOG and ip6_LOG into xt_LOG
[PATCH 2/6] ring_buffer: Export for_each_buffer_cpu()
[PATCH 3/6] xt_log: Make printk() in sb_close() optional
[PATCH 4/6] Netfilter: xt_LOG: Implement ring buffer support
[PATCH 5/6] iptables: Merge libip6t_LOG and libipt_LOG into
[PATCH 6/6] iptables: xt_LOG: Add ring buffer support

Any feedback is welcome!

Thanks,
//richard
