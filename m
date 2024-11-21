Received: from forward103d.mail.yandex.net (forward103d.mail.yandex.net [178.154.239.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EBF17BD3;
	Thu, 21 Nov 2024 06:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732172162; cv=none; b=eqlj047Gln8Eo/WdH7xBjA6jxQtMEWmRS+FFNdyDwgnMohVb2D9NqWrGvUgAs258pUII+hh65wt82fDqZmCUptiYMV62f6GMFd0VT2nLJulsaBcb2NZgQsD+0vR1c22ZryDzKf1+xhiWu8Bducsdm6n5iSt2eJLx1NJLPcAmiBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732172162; c=relaxed/simple;
	bh=GLii2frKD9x7FPiK1G0f7JDEgHc9t6uBkw0PobU46ko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C6r8d0qOBQRa0OrPvoc1cHXQrwVk3KKrThgHfei6R5jF6UHpzarz3lwMIYgEDd4ryaRlCpm6LDLMOha5mgflCPNhNlrAd2jNsoylFcDCfHSZjmWiH5uHCCQW/idEX3ZMr+v7/ZqGzI82M1xC67KSpuGYrMKdJNWSiKNXhIGKtVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=uPQn9YXT; arc=none smtp.client-ip=178.154.239.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="uPQn9YXT"
Received: from mail-nwsmtp-smtp-production-main-57.myt.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-57.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:261a:0:640:f38:0])
	by forward103d.mail.yandex.net (Yandex) with ESMTPS id 9FA6160AED;
	Thu, 21 Nov 2024 09:55:50 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-57.myt.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id ktMkOQ0OrW20-c90DpCJS;
	Thu, 21 Nov 2024 09:55:49 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1732172149; bh=AXmYk6X46szuXa9djGvmRkOxEe21duBYrU5olBNg0r8=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=uPQn9YXTVWZJT2EOEhlquRZtnMDGvgHSjTJuU+BJMFSUMDC/wqdefVIxxiCPp2ChM
	 vCxvEKSIoe895SMnV/0TGg0sGw1p6/MAHWe0oSl/5Gf4f2ricBCMu0w8RDdjG8uRT5
	 IL6s8YHjxpRuft5ji+fCY2tW+CXhkFuQAJNuBOmY=
Authentication-Results: mail-nwsmtp-smtp-production-main-57.myt.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+6c8215822f35fdb35667@syzkaller.appspotmail.com
Subject: [PATCH] netfilter: x_tables: fix LED ID check in led_tg_check()
Date: Thu, 21 Nov 2024 09:55:42 +0300
Message-ID: <20241121065542.1060207-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.47.0

