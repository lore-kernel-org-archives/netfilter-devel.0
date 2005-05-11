From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim] 2.6.12 compatibility
Date: Wed, 11 May 2005 23:21:15 +0200
Message-ID: <20050511212115.GA15286@roonstrasse.net>
References: <20050511195652.GA14386@roonstrasse.net> <428265DF.70300@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <428265DF.70300@trash.net>
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


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2005/05/11 22:06, Patrick McHardy <kaber@trash.net> wrote:
> I have this patch, but I can't recall if it worked correctly with it or
> not. It needs at least a couple #if KERNEL_VERSION > ... before it can
> be committed.

The required changes in addition to your patch were trivial - there
were 3 definitions missing. A patch is attached. My patch does not
need #ifKERNEL_VERSIONs, I guess.

nfsim/2.6.12-rc4 seems to run well now - my h323-conntrack-nat test
suite succeeds.

Max


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nfsim-2.6.12-defs.patch"

Wed May 11 23:06:19 CEST 2005  max@duempel.org
  * definitions for 2.6.12 compatibility
diff -rN -u old-nfsim-0/core/core.h new-nfsim-0/core/core.h
--- old-nfsim-0/core/core.h	2005-05-11 23:19:44.000000000 +0200
+++ new-nfsim-0/core/core.h	2005-05-11 23:05:37.000000000 +0200
@@ -76,7 +76,8 @@
 #define NF_STOLEN 2
 #define NF_QUEUE 3
 #define NF_REPEAT 4
-#define NF_MAX_VERDICT NF_REPEAT
+#define NF_STOP 5
+#define NF_MAX_VERDICT NF_STOP
 
 #define NF_MAX_HOOKS 8
 
diff -rN -u old-nfsim-0/kernelenv/include/kernelenv.h new-nfsim-0/kernelenv/include/kernelenv.h
--- old-nfsim-0/kernelenv/include/kernelenv.h	2005-05-11 23:19:45.000000000 +0200
+++ new-nfsim-0/kernelenv/include/kernelenv.h	2005-05-11 23:03:27.000000000 +0200
@@ -1130,6 +1130,9 @@
 #define MODULE_PARM_DESC(x,n) 
 #define module_param(name, type, perm)
 #define module_param_array(name, type, num, perm)
+#define module_param_call(name, set, get, arg, perm)
+
+struct kernel_param;
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,28)
 #define EXPORT_NO_SYMBOLS


--M9NhX3UHpAaciwkO--
