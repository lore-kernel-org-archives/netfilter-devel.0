From: Dmitry Mishin <dim@openvz.org>
Subject: [RFC][PATCH] compat_uint64_t type
Date: Mon, 17 Apr 2006 14:59:09 +0400
Message-ID: <200604171459.13312.dim@openvz.org>
References: <444132C1.1020604@trash.net> <44425DAE.3040007@trash.net>
	<20060416.222435.02924300.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_BU3QEC2uUi+sQbZ"
Cc: schwab@suse.de, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	dev@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060416.222435.02924300.davem@davemloft.net>
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

--Boundary-00=_BU3QEC2uUi+sQbZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch introduces compat_uint64_t type, which is required for proper 
handling different alignment of structures, containing u64 objects, on 
compatible with ia32 64bit platforms and others.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
Acked-of-by: Kirill Korotaev <dev@openvz.org>
 
On Monday 17 April 2006 09:24, David S. Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Sun, 16 Apr 2006 17:07:26 +0200
>
> > David S. Miller wrote:
> > > A struct containing a u64 has to be 64-bit aligned on at least sparc64
> > > and ppc64, both of which use the compat layer for 32-bit programs, so
> > > I think it's quite clear this will have to be implemented differently.
> >
> > Do these alignment requirements also hold for 32bit compiled programms?
>
> Yes, it does.
>
> > This is what we need to match with compat_xt_counters.
>
> This issue is exactly why the compat layer requirements are so wildly
> different between "x86_64/ia64 --> ia32" and all other compat
> situations.
>
> ia32 doesn't have the 64-bit alignment requirement for structures
> containing u64 objects, whereas every other 32-bit platform does.

-- 
Thanks,
Dmitry.

--Boundary-00=_BU3QEC2uUi+sQbZ
Content-Type: text/plain; charset="iso-8859-1";
	name="diff-ms-net-netfilter-compat-20060417"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="diff-ms-net-netfilter-compat-20060417"

diff --git a/include/asm-ia64/compat.h b/include/asm-ia64/compat.h
index 40d01d8..3e6417b 100644
--- a/include/asm-ia64/compat.h
+++ b/include/asm-ia64/compat.h
@@ -34,6 +34,8 @@ typedef s32		compat_long_t;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 
+typedef u64 __attribute__((aligned(4)))	compat_uint64_t;
+
 struct compat_timespec {
 	compat_time_t	tv_sec;
 	s32		tv_nsec;
diff --git a/include/asm-mips/compat.h b/include/asm-mips/compat.h
index 986511d..f95640f 100644
--- a/include/asm-mips/compat.h
+++ b/include/asm-mips/compat.h
@@ -38,6 +38,8 @@ typedef s32		compat_long_t;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 
+typedef u64		compat_uint64_t;
+
 struct compat_timespec {
 	compat_time_t	tv_sec;
 	s32		tv_nsec;
diff --git a/include/asm-parisc/compat.h b/include/asm-parisc/compat.h
index 289624d..312829d 100644
--- a/include/asm-parisc/compat.h
+++ b/include/asm-parisc/compat.h
@@ -33,6 +33,8 @@ typedef s32	compat_long_t;
 typedef u32	compat_uint_t;
 typedef u32	compat_ulong_t;
 
+typedef u64	compat_uint64_t;
+
 struct compat_timespec {
 	compat_time_t		tv_sec;
 	s32			tv_nsec;
diff --git a/include/asm-powerpc/compat.h b/include/asm-powerpc/compat.h
index aacaabd..e90fa22 100644
--- a/include/asm-powerpc/compat.h
+++ b/include/asm-powerpc/compat.h
@@ -36,6 +36,8 @@ typedef s32		compat_long_t;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 
+typedef u64		compat_uint64_t;
+
 struct compat_timespec {
 	compat_time_t	tv_sec;
 	s32		tv_nsec;
diff --git a/include/asm-s390/compat.h b/include/asm-s390/compat.h
index 356a0b1..1b8c7f7 100644
--- a/include/asm-s390/compat.h
+++ b/include/asm-s390/compat.h
@@ -35,6 +35,8 @@ typedef s32		compat_long_t;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 
+typedef u64		compat_uint64_t;
+
 struct compat_timespec {
 	compat_time_t	tv_sec;
 	s32		tv_nsec;
diff --git a/include/asm-sparc64/compat.h b/include/asm-sparc64/compat.h
index c73935d..6adc10c 100644
--- a/include/asm-sparc64/compat.h
+++ b/include/asm-sparc64/compat.h
@@ -34,6 +34,8 @@ typedef s32		compat_long_t;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 
+typedef u64		compat_uint64_t;
+
 struct compat_timespec {
 	compat_time_t	tv_sec;
 	s32		tv_nsec;
diff --git a/include/asm-x86_64/compat.h b/include/asm-x86_64/compat.h
index b37ab82..4d7eb9c 100644
--- a/include/asm-x86_64/compat.h
+++ b/include/asm-x86_64/compat.h
@@ -36,6 +36,8 @@ typedef s32		compat_long_t;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 
+typedef u64 __attribute__((aligned(4)))	compat_uint64_t;
+
 struct compat_timespec {
 	compat_time_t	tv_sec;
 	s32		tv_nsec;
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index f6bdef8..558125c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -361,7 +361,7 @@ struct compat_xt_entry_target
 
 struct compat_xt_counters
 {
-	u_int32_t cnt[4];
+	compat_uint64_t pcnt, bcnt;
 };
 
 struct compat_xt_counters_info

--Boundary-00=_BU3QEC2uUi+sQbZ--
