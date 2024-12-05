Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783AFD26D;
	Thu,  5 Dec 2024 00:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733358554; cv=none; b=a8DmUOanPfFZkVsxTuX8dldzVLG/UoBoktu52lrWMeapSb/ELdbnU5HGvghEZ4jjwIIb/rA+hA4F2fRPA05ZD4EGw+o5TmxqdCrLU+AAO7M3oRwuIc4XDieHCowp5e7Qa6CE5gFb+luwW6m9tLbrFn4AQZ+qjNl4ELVpYuDFMfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733358554; c=relaxed/simple;
	bh=hFk7DcrCWku1f8Amlp053OgJaZqRDekiB+fJXOGIWn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sf2yZZwzcLb4787KhRHKyIsSZVtAwgIcYz6MOnsTwMvex4NG+aaYb4YtMuEPIT6JGmVNW2yQRpbqSRI4BgkPdDYTfqxbSVptPLE5GCJmBp9nB1rir1YjQ7yKNkiP/ozs7P1Hm1voJa5Ka0bS8CY3rCoqbOPXrYTpXJxWgqyHFIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 2/6] netfilter: x_tables: fix LED ID check in led_tg_check()
Date: Thu,  5 Dec 2024 01:28:50 +0100
Message-Id: <20241205002854.162490-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241205002854.162490-1-pablo@netfilter.org>
References: <20241205002854.162490-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dmitry Antipov <dmantipov@yandex.ru>

Syzbot has reported the following BUG detected by KASAN:

BUG: KASAN: slab-out-of-bounds in strlen+0x58/0x70
Read of size 1 at addr ffff8881022da0c8 by task repro/5879
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x241/0x360
 ? __pfx_dump_stack_lvl+0x10/0x10
 ? __pfx__printk+0x10/0x10
 ? _printk+0xd5/0x120
 ? __virt_addr_valid+0x183/0x530
 ? __virt_addr_valid+0x183/0x530
 print_report+0x169/0x550
 ? __virt_addr_valid+0x183/0x530
 ? __virt_addr_valid+0x183/0x530
 ? __virt_addr_valid+0x45f/0x530
 ? __phys_addr+0xba/0x170
 ? strlen+0x58/0x70
 kasan_report+0x143/0x180
 ? strlen+0x58/0x70
 strlen+0x58/0x70
 kstrdup+0x20/0x80
 led_tg_check+0x18b/0x3c0
 xt_check_target+0x3bb/0xa40
 ? __pfx_xt_check_target+0x10/0x10
 ? stack_depot_save_flags+0x6e4/0x830
 ? nft_target_init+0x174/0xc30
 nft_target_init+0x82d/0xc30
 ? __pfx_nft_target_init+0x10/0x10
 ? nf_tables_newrule+0x1609/0x2980
 ? nf_tables_newrule+0x1609/0x2980
 ? rcu_is_watching+0x15/0xb0
 ? nf_tables_newrule+0x1609/0x2980
 ? nf_tables_newrule+0x1609/0x2980
 ? __kmalloc_noprof+0x21a/0x400
 nf_tables_newrule+0x1860/0x2980
 ? __pfx_nf_tables_newrule+0x10/0x10
 ? __nla_parse+0x40/0x60
 nfnetlink_rcv+0x14e5/0x2ab0
 ? __pfx_validate_chain+0x10/0x10
 ? __pfx_nfnetlink_rcv+0x10/0x10
 ? __lock_acquire+0x1384/0x2050
 ? netlink_deliver_tap+0x2e/0x1b0
 ? __pfx_lock_release+0x10/0x10
 ? netlink_deliver_tap+0x2e/0x1b0
 netlink_unicast+0x7f8/0x990
 ? __pfx_netlink_unicast+0x10/0x10
 ? __virt_addr_valid+0x183/0x530
 ? __check_object_size+0x48e/0x900
 netlink_sendmsg+0x8e4/0xcb0
 ? __pfx_netlink_sendmsg+0x10/0x10
 ? aa_sock_msg_perm+0x91/0x160
 ? __pfx_netlink_sendmsg+0x10/0x10
 __sock_sendmsg+0x223/0x270
 ____sys_sendmsg+0x52a/0x7e0
 ? __pfx_____sys_sendmsg+0x10/0x10
 __sys_sendmsg+0x292/0x380
 ? __pfx___sys_sendmsg+0x10/0x10
 ? lockdep_hardirqs_on_prepare+0x43d/0x780
 ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
 ? exc_page_fault+0x590/0x8c0
 ? do_syscall_64+0xb6/0x230
 do_syscall_64+0xf3/0x230
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
...
 </TASK>

Since an invalid (without '\0' byte at all) byte sequence may be passed
from userspace, add an extra check to ensure that such a sequence is
rejected as possible ID and so never passed to 'kstrdup()' and further.

Reported-by: syzbot+6c8215822f35fdb35667@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6c8215822f35fdb35667
Fixes: 268cb38e1802 ("netfilter: x_tables: add LED trigger target")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_LED.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index f7b0286d106a..8a80fd76fe45 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -96,7 +96,9 @@ static int led_tg_check(const struct xt_tgchk_param *par)
 	struct xt_led_info_internal *ledinternal;
 	int err;
 
-	if (ledinfo->id[0] == '\0')
+	/* Bail out if empty string or not a string at all. */
+	if (ledinfo->id[0] == '\0' ||
+	    !memchr(ledinfo->id, '\0', sizeof(ledinfo->id)))
 		return -EINVAL;
 
 	mutex_lock(&xt_led_mutex);
-- 
2.30.2

