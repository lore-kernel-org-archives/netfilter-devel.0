From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the netfilter tree
Date: Wed, 17 May 2017 13:45:36 +1000
Message-ID: <20170517134536.3ce21d47@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:44507 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751045AbdEQDpj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 23:45:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

After merging the netfilter tree, today's linux-next build (i386
defconfig) failed like this:

net/netfilter/x_tables.c: In function 'xt_match_to_user':
net/netfilter/x_tables.c:303:13: error: implicit declaration of function 'COMPAT_XT_ALIGN' [-Werror=implicit-function-declaration]
    C_SIZE ? COMPAT_XT_ALIGN(C_SIZE) :  \
             ^
net/netfilter/x_tables.c:310:9: note: in expansion of macro 'XT_DATA_TO_USER'
         XT_DATA_TO_USER(u, m, match, 0);
         ^

Caused by commit

  324318f0248c ("netfilter: xtables: zero padding in data_to_user")

In the !CONFIG_COMPAT case C_SIZE will always be zero, but the compiler
is still looking for the macro :-(

I added this cludge patch (I am sure it can be done better):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 17 May 2017 13:36:26 +1000
Subject: [PATCH] netfilter: xtables: fix for zero padding in data_to_user

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/netfilter/x_tables.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d17769599c10..2b1785993a92 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -296,12 +296,20 @@ int xt_data_to_user(void __user *dst, const void *src,
 }
 EXPORT_SYMBOL_GPL(xt_data_to_user);
 
+#ifdef CONFIG_COMPAT
 #define XT_DATA_TO_USER(U, K, TYPE, C_SIZE)				\
 	xt_data_to_user(U->data, K->data,				\
 			K->u.kernel.TYPE->usersize,			\
 			C_SIZE ? : K->u.kernel.TYPE->TYPE##size,	\
 			C_SIZE ? COMPAT_XT_ALIGN(C_SIZE) :		\
 				 XT_ALIGN(K->u.kernel.TYPE->TYPE##size))
+#else
+#define XT_DATA_TO_USER(U, K, TYPE, C_SIZE)				\
+	xt_data_to_user(U->data, K->data,				\
+			K->u.kernel.TYPE->usersize,			\
+			C_SIZE ? : K->u.kernel.TYPE->TYPE##size,	\
+			C_SIZE ? : XT_ALIGN(K->u.kernel.TYPE->TYPE##size))
+#endif
 
 int xt_match_to_user(const struct xt_entry_match *m,
 		     struct xt_entry_match __user *u)

-- 
Cheers,
Stephen Rothwell
