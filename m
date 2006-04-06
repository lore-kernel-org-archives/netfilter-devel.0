From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 01/12]: Add helper functions for mass hook
	registration/unregistration
Date: Thu, 06 Apr 2006 18:10:02 +0200
Message-ID: <44353D5A.2040301@trash.net>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
	<20060406100453.17409.47998.sendpatchset@localhost.localdomain>
	<200604061542.k36FgRVL032443@usagi.ingate.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030507040104090807080309"
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jones Desougi <jones@ingate.com>
In-Reply-To: <200604061542.k36FgRVL032443@usagi.ingate.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030507040104090807080309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jones Desougi wrote:
>>+err:
>>+	if (i > 0)
>>+		nf_unregister_hooks(reg, i - i);
> 
>                                          ^^^^^
> 
>>+	return err;
>>+}
> 
> 
> That should make it a nice noop. :-)
> Change the line to:
> +		nf_unregister_hooks(reg, i);

One typo and one thinko, good catch. I wonder why it didn't crash
in my tests, I did try unloading and reloading.

Corrected patch attached.

--------------030507040104090807080309
Content-Type: text/plain;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: Add helper functions for mass hook registration/unregistration

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3bf0d209e539917efcc5286b8f1cab2856ebdd49
tree 4c5840cf32ee69cc6138534d24c4d43a23fad557
parent 32a976a8703b098e898a9a13f9ddcabbf654e7d8
author Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:32:05 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:32:05 +0200

 include/linux/netfilter.h |    2 ++
 net/netfilter/core.c      |   28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 412e52c..5aa9316 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -110,6 +110,8 @@ struct nf_info
 /* Function to register/unregister hook points. */
 int nf_register_hook(struct nf_hook_ops *reg);
 void nf_unregister_hook(struct nf_hook_ops *reg);
+int nf_register_hooks(struct nf_hook_ops *reg, unsigned int n);
+void nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n);
 
 /* Functions to register get/setsockopt ranges (non-inclusive).  You
    need to check permissions yourself! */
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 1ceb1a6..5c7143e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -63,6 +63,34 @@ void nf_unregister_hook(struct nf_hook_o
 }
 EXPORT_SYMBOL(nf_unregister_hook);
 
+int nf_register_hooks(struct nf_hook_ops *reg, unsigned int n)
+{
+	unsigned int i;
+	int err = 0;
+
+	for (i = 0; i < n; i++) {
+		err = nf_register_hook(&reg[i]);
+		if (err)
+			goto err;
+	}
+	return err;
+
+err:
+	if (i > 0)
+		nf_unregister_hooks(reg, i);
+	return err;
+}
+EXPORT_SYMBOL(nf_register_hooks);
+
+void nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++)
+		nf_unregister_hook(&reg[i]);
+}
+EXPORT_SYMBOL(nf_unregister_hooks);
+
 unsigned int nf_iterate(struct list_head *head,
 			struct sk_buff **skb,
 			int hook,

--------------030507040104090807080309--
