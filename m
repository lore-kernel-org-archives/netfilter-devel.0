From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/6] netfilter: nf_conntrack: Fix possible possible crash on module loading.
Date: Mon,  9 Jul 2018 19:19:03 +0200
Message-ID: <20180709171904.2460-6-pablo@netfilter.org>
References: <20180709171904.2460-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180709171904.2460-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

Loading the nf_conntrack module with doubled hashsize parameter, i.e.
	  modprobe nf_conntrack hashsize=12345 hashsize=12345
causes NULL-ptr deref.

If 'hashsize' specified twice, the nf_conntrack_set_hashsize() function
will be called also twice.
The first nf_conntrack_set_hashsize() call will set the
'nf_conntrack_htable_size' variable:

	nf_conntrack_set_hashsize()
		...
		/* On boot, we can set this without any fancy locking. */
		if (!nf_conntrack_htable_size)
			return param_set_uint(val, kp);

But on the second invocation, the nf_conntrack_htable_size is already set,
so the nf_conntrack_set_hashsize() will take a different path and call
the nf_conntrack_hash_resize() function. Which will crash on the attempt
to dereference 'nf_conntrack_hash' pointer:

	BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
	RIP: 0010:nf_conntrack_hash_resize+0x255/0x490 [nf_conntrack]
	Call Trace:
	 nf_conntrack_set_hashsize+0xcd/0x100 [nf_conntrack]
	 parse_args+0x1f9/0x5a0
	 load_module+0x1281/0x1a50
	 __se_sys_finit_module+0xbe/0xf0
	 do_syscall_64+0x7c/0x390
	 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fix this, by checking !nf_conntrack_hash instead of
!nf_conntrack_htable_size. nf_conntrack_hash will be initialized only
after the module loaded, so the second invocation of the
nf_conntrack_set_hashsize() won't crash, it will just reinitialize
nf_conntrack_htable_size again.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3465da2a98bd..3d5280425027 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2043,7 +2043,7 @@ int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp)
 		return -EOPNOTSUPP;
 
 	/* On boot, we can set this without any fancy locking. */
-	if (!nf_conntrack_htable_size)
+	if (!nf_conntrack_hash)
 		return param_set_uint(val, kp);
 
 	rc = kstrtouint(val, 0, &hashsize);
-- 
2.11.0
