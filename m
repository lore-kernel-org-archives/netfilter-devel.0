From: zhongyu <xxx@mail.goldenhope.com.cn>
Subject: a patch for conntrack_tuple
Date: Fri, 14 Jan 2005 11:52:44 +0800
Message-ID: <BF65C818-65DF-11D9-9545-000A95B170F8@mail.goldenhope.com.cn>
References: <20050111102202.99FD6A90F2@mail.goldenhope.com.cn>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20050111102202.99FD6A90F2@mail.goldenhope.com.cn>
To: netfilter-devel@lists.netfilter.org
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

##################begin##########################################
--- include/linux/netfilter_ipv4/ip_conntrack_tuple.h   27 Nov 2003 
12:42:40 -0000      1.2
+++ include/linux/netfilter_ipv4/ip_conntrack_tuple.h   10 Jan 2005 
04:28:28 -0000
@@ -50,13 +50,37 @@
                         u_int64_t all;

                         struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
                                 u_int16_t port;
+#elif defined (__BIG_ENDIAN_BITFIELD)
+                               u_int32_t pad1;
+                               u_int16_t pad2;
+                               u_int16_t port;
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
                         } tcp;
                         struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+                               u_int16_t port;
+#elif defined (__BIG_ENDIAN_BITFIELD)
+                               u_int32_t pad1;
+                               u_int16_t pad2;
                                 u_int16_t port;
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
                         } udp;
                         struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+                               u_int8_t type, code;
+#elif defined (__BIG_ENDIAN_BITFIELD)
+                               u_int32_t pad1;
+                               u_int16_t pad2;
                                 u_int8_t type, code;
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
                         } icmp;
                         struct {
                                 u_int16_t protocol;
################end#######################
The function hash_conntrack use the low 16 bits of tuple->dst, but in 
big-endian system
the port infomation is in high 16 bits. So the destination port on 
big-endian system was
ignored. This caused hash collision. The patch above fixed this problem 
:-)

static u_int32_t
hash_conntrack(const struct ip_conntrack_tuple *tuple)
{
#if 0
         dump_tuple(tuple);
#endif
         return (jhash_3words(tuple->src.ip,
                              (tuple->dst.ip ^ tuple->dst.protonum),
                              (tuple->src.u.all | (tuple->dst.u.all << 
16)),
                              ip_conntrack_hash_rnd) % 
ip_conntrack_htable_size);
}
