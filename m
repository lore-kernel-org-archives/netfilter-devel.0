From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 3/19]: prearation of removing skb_linearize()
Date: Mon, 25 Oct 2004 02:48:52 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4D74.8000605@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000805040005050006000701"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000805040005050006000701
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Use skb_header_pointer in ip6_tables.c, change argument order
of matches/targets to match IPv4, multiple fixes.



--------------000805040005050006000701
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/19 02:13:27+02:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_rt.c
#   2004/10/19 02:13:00+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_owner.c
#   2004/10/19 02:13:00+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_multiport.c
#   2004/10/19 02:13:00+02:00 yasuyuki.kozakai@toshiba.co.jp +3 -4
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_mark.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_mac.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_limit.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_length.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_ipv6header.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_hl.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -1
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_hbh.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_frag.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_eui64.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_esp.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_dst.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_ah.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -2
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_MARK.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -1
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_LOG.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +1 -1
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_tables.c
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +122 -132
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv6/ip6_tables.h
#   2004/10/19 02:12:59+02:00 yasuyuki.kozakai@toshiba.co.jp +8 -4
#   [NETFILTER]: prearation of removing skb_linearize()
#      
#   This patch uses skb_header_pointer() so that packets can be parsed even though
#   skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
#   yet. We can remove it after changing all match/target modules.
#      
#   Moreover ...
#       - I deleted the optimization not to parse IPv6 extension header
#         many time from previous patch. I'll send the patch to do this
#         separately.
#       - fixed the bug that "offset" argument of match functions are always 0.
#       - deleted "hdr" and "datalen" argument and added "protoff" argument
#         to match functions. "protoff" means the offset to Layer 4 protocol
#         header.
#       - the argument order of target function is changed likely IPv4 modules.
#         This prevents user from meeting kernel panic when they use old
#         match modules.
#       - changed {tcp,udp,icmp6}_match(). These functions became very similar
#         to codes in ip_tables.c again.
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
--- a/include/linux/netfilter_ipv6/ip6_tables.h	2004-10-22 03:37:28 +02:00
+++ b/include/linux/netfilter_ipv6/ip6_tables.h	2004-10-22 03:37:28 +02:00
@@ -355,13 +355,15 @@
 
 	/* Return true or false: return FALSE and set *hotdrop = 1 to
            force immediate packet drop. */
+	/* Arguments changed since 2.6.9, as this must now handle
+	   non-linear skb, using skb_header_pointer and
+	   skb_ip_make_writable. */
 	int (*match)(const struct sk_buff *skb,
 		     const struct net_device *in,
 		     const struct net_device *out,
 		     const void *matchinfo,
 		     int offset,
-		     const void *hdr,
-		     u_int16_t datalen,
+		     unsigned int protoff,
 		     int *hotdrop);
 
 	/* Called when user tries to insert an entry of this type. */
@@ -386,11 +388,13 @@
 
 	const char name[IP6T_FUNCTION_MAXNAMELEN];
 
-	/* Returns verdict. */
+	/* Returns verdict. Argument order changed since 2.6.9, as this
+	   must now handle non-linear skbs, using skb_copy_bits and
+	   skb_ip_make_writable. */
 	unsigned int (*target)(struct sk_buff **pskb,
-			       unsigned int hooknum,
 			       const struct net_device *in,
 			       const struct net_device *out,
+			       unsigned int hooknum,
 			       const void *targinfo,
 			       void *userdata);
 
diff -Nru a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6_tables.c	2004-10-22 03:37:28 +02:00
@@ -158,14 +158,15 @@
 /* Returns whether matches rule or not. */
 static inline int
 ip6_packet_match(const struct sk_buff *skb,
-		 const struct ipv6hdr *ipv6,
 		 const char *indev,
 		 const char *outdev,
 		 const struct ip6t_ip6 *ip6info,
-		 int isfrag)
+		 unsigned int *protoff,
+		 int *fragoff)
 {
 	size_t i;
 	unsigned long ret;
+	const struct ipv6hdr *ipv6 = skb->nh.ipv6h;
 
 #define FWINV(bool,invflg) ((bool) ^ !!(ip6info->invflags & invflg))
 
@@ -216,9 +217,10 @@
 	/* look for the desired protocol header */
 	if((ip6info->flags & IP6T_F_PROTO)) {
 		u_int8_t currenthdr = ipv6->nexthdr;
-		struct ipv6_opt_hdr *hdrptr;
+		struct ipv6_opt_hdr _hdr, *hp;
 		u_int16_t ptr;		/* Header offset in skb */
 		u_int16_t hdrlen;	/* Header */
+		u_int16_t _fragoff = 0, *fp = NULL;
 
 		ptr = IPV6_HDR_LEN;
 
@@ -234,23 +236,41 @@
 				(currenthdr == IPPROTO_ESP))
 				return 0;
 
-	                hdrptr = (struct ipv6_opt_hdr *)(skb->data + ptr);
+			hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
+			BUG_ON(hp == NULL);
 
 			/* Size calculation */
 	                if (currenthdr == IPPROTO_FRAGMENT) {
+				fp = skb_header_pointer(skb,
+						   ptr+offsetof(struct frag_hdr,
+								frag_off),
+						   sizeof(_fragoff),
+						   &_fragoff);
+				if (fp == NULL)
+					return 0;
+
+				_fragoff = ntohs(*fp) & ~0x7;
 	                        hdrlen = 8;
 	                } else if (currenthdr == IPPROTO_AH)
-	                        hdrlen = (hdrptr->hdrlen+2)<<2;
+	                        hdrlen = (hp->hdrlen+2)<<2;
 	                else
-	                        hdrlen = ipv6_optlen(hdrptr);
+	                        hdrlen = ipv6_optlen(hp);
 
-			currenthdr = hdrptr->nexthdr;
+			currenthdr = hp->nexthdr;
 	                ptr += hdrlen;
 			/* ptr is too large */
 	                if ( ptr > skb->len ) 
 				return 0;
+			if (_fragoff) {
+				if (ip6t_ext_hdr(currenthdr))
+					return 0;
+				break;
+			}
 		}
 
+		*protoff = ptr;
+		*fragoff = _fragoff;
+
 		/* currenthdr contains the protocol header */
 
 		dprintf("Packet protocol %hi ?= %s%hi.\n",
@@ -292,9 +312,9 @@
 
 static unsigned int
 ip6t_error(struct sk_buff **pskb,
-	  unsigned int hooknum,
 	  const struct net_device *in,
 	  const struct net_device *out,
+	  unsigned int hooknum,
 	  const void *targinfo,
 	  void *userinfo)
 {
@@ -310,13 +330,12 @@
 	     const struct net_device *in,
 	     const struct net_device *out,
 	     int offset,
-	     const void *hdr,
-	     u_int16_t datalen,
+	     unsigned int protoff,
 	     int *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->data,
-				      offset, hdr, datalen, hotdrop))
+				      offset, protoff, hotdrop))
 		return 1;
 	else
 		return 0;
@@ -338,10 +357,8 @@
 	      void *userdata)
 {
 	static const char nulldevname[IFNAMSIZ];
-	u_int16_t offset = 0;
-	struct ipv6hdr *ipv6;
-	void *protohdr;
-	u_int16_t datalen;
+	int offset = 0;
+	unsigned int protoff = 0;
 	int hotdrop = 0;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
@@ -354,9 +371,6 @@
 		return NF_DROP;
 
 	/* Initialization */
-	ipv6 = (*pskb)->nh.ipv6h;
-	protohdr = (u_int32_t *)((char *)ipv6 + IPV6_HDR_LEN);
-	datalen = (*pskb)->len - IPV6_HDR_LEN;
 	indev = in ? in->name : nulldevname;
 	outdev = out ? out->name : nulldevname;
 
@@ -393,17 +407,19 @@
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
 		(*pskb)->nfcache |= e->nfcache;
-		if (ip6_packet_match(*pskb, ipv6, indev, outdev, 
-			&e->ipv6, offset)) {
+		if (ip6_packet_match(*pskb, indev, outdev, &e->ipv6,
+			&protoff, &offset)) {
 			struct ip6t_entry_target *t;
 
 			if (IP6T_MATCH_ITERATE(e, do_match,
 					       *pskb, in, out,
-					       offset, protohdr,
-					       datalen, &hotdrop) != 0)
+					       offset, protoff, &hotdrop) != 0)
 				goto no_match;
 
-			ADD_COUNTER(e->counters, ntohs(ipv6->payload_len) + IPV6_HDR_LEN, 1);
+			ADD_COUNTER(e->counters,
+				    ntohs((*pskb)->nh.ipv6h->payload_len)
+				    + IPV6_HDR_LEN,
+				    1);
 
 			t = ip6t_get_target(e);
 			IP_NF_ASSERT(t->u.kernel.target);
@@ -443,8 +459,8 @@
 					= 0xeeeeeeec;
 #endif
 				verdict = t->u.kernel.target->target(pskb,
-								     hook,
 								     in, out,
+								     hook,
 								     t->data,
 								     userdata);
 
@@ -459,11 +475,6 @@
 				((struct ip6t_entry *)table_base)->comefrom
 					= 0x57acc001;
 #endif
-				/* Target might have changed stuff. */
-				ipv6 = (*pskb)->nh.ipv6h;
-				protohdr = (u_int32_t *)((void *)ipv6 + IPV6_HDR_LEN);
-				datalen = (*pskb)->len - IPV6_HDR_LEN;
-
 				if (verdict == IP6T_CONTINUE)
 					e = (void *)e + e->next_offset;
 				else
@@ -1535,26 +1546,31 @@
 
 static int
 tcp_find_option(u_int8_t option,
-		const struct tcphdr *tcp,
-		u_int16_t datalen,
+		const struct sk_buff *skb,
+		unsigned int tcpoff,
+		unsigned int optlen,
 		int invert,
 		int *hotdrop)
 {
-	unsigned int i = sizeof(struct tcphdr);
-	const u_int8_t *opt = (u_int8_t *)tcp;
+	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
+	u_int8_t _opt[60 - sizeof(struct tcphdr)], *op;
+	unsigned int i;
 
 	duprintf("tcp_match: finding option\n");
+	if (!optlen)
+		return invert;
 	/* If we don't have the whole header, drop packet. */
-	if (tcp->doff * 4 < sizeof(struct tcphdr) ||
-	    tcp->doff * 4 > datalen) {
+	op = skb_header_pointer(skb, tcpoff + sizeof(struct tcphdr), optlen,
+				_opt);
+	if (op == NULL) {
 		*hotdrop = 1;
 		return 0;
 	}
 
-	while (i < tcp->doff * 4) {
-		if (opt[i] == option) return !invert;
-		if (opt[i] < 2) i++;
-		else i += opt[i+1]?:1;
+	for (i = 0; i < optlen; ) {
+		if (op[i] == option) return !invert;
+		if (op[i] < 2) i++;
+		else i += op[i+1]?:1;
 	}
 
 	return invert;
@@ -1566,27 +1582,31 @@
 	  const struct net_device *out,
 	  const void *matchinfo,
 	  int offset,
-	  const void *hdr,
-	  u_int16_t datalen,
+	  unsigned int protoff,
 	  int *hotdrop)
 {
-	const struct tcphdr *tcp;
+	struct tcphdr _tcph, *th;
 	const struct ip6t_tcp *tcpinfo = matchinfo;
-	int tcpoff;
-	u8 nexthdr = skb->nh.ipv6h->nexthdr;
 
-	/* To quote Alan:
+	if (offset) {
+		/* To quote Alan:
 
-	   Don't allow a fragment of TCP 8 bytes in. Nobody normal
-	   causes this. Its a cracker trying to break in by doing a
-	   flag overwrite to pass the direction checks.
-	*/
-
-	if (offset == 1) {
-		duprintf("Dropping evil TCP offset=1 frag.\n");
-		*hotdrop = 1;
+		   Don't allow a fragment of TCP 8 bytes in. Nobody normal
+		   causes this. Its a cracker trying to break in by doing a
+		   flag overwrite to pass the direction checks.
+		*/
+		if (offset == 1) {
+			duprintf("Dropping evil TCP offset=1 frag.\n");
+			*hotdrop = 1;
+		}
+		/* Must not be a fragment. */
 		return 0;
-	} else if (offset == 0 && datalen < sizeof(struct tcphdr)) {
+	}
+
+#define FWINVTCP(bool,invflg) ((bool) ^ !!(tcpinfo->invflags & invflg))
+
+	th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
+	if (th == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
@@ -1594,45 +1614,30 @@
 		return 0;
 	}
 
-	tcpoff = (u8*)(skb->nh.ipv6h + 1) - skb->data;
-	tcpoff = ipv6_skip_exthdr(skb, tcpoff, &nexthdr, skb->len - tcpoff);
-	if (tcpoff < 0 || tcpoff > skb->len) {
-		duprintf("tcp_match: cannot skip exthdr. Dropping.\n");
-		*hotdrop = 1;
-		return 0;
-	} else if (nexthdr == IPPROTO_FRAGMENT)
-		return 0;
-	else if (nexthdr != IPPROTO_TCP ||
-		 skb->len - tcpoff < sizeof(struct tcphdr)) {
-		/* cannot be occured */
-		duprintf("tcp_match: cannot get TCP header. Dropping.\n");
-		*hotdrop = 1;
-		return 0;
+	if (!port_match(tcpinfo->spts[0], tcpinfo->spts[1],
+			ntohs(th->source),
+			!!(tcpinfo->invflags & IP6T_TCP_INV_SRCPT)))
+		return 0;
+	if (!port_match(tcpinfo->dpts[0], tcpinfo->dpts[1],
+			ntohs(th->dest),
+			!!(tcpinfo->invflags & IP6T_TCP_INV_DSTPT)))
+		return 0;
+	if (!FWINVTCP((((unsigned char *)th)[13] & tcpinfo->flg_mask)
+		      == tcpinfo->flg_cmp,
+		      IP6T_TCP_INV_FLAGS))
+		return 0;
+	if (tcpinfo->option) {
+		if (th->doff * 4 < sizeof(_tcph)) {
+			*hotdrop = 1;
+			return 0;
+		}
+		if (!tcp_find_option(tcpinfo->option, skb, protoff,
+				     th->doff*4 - sizeof(*th),
+				     tcpinfo->invflags & IP6T_TCP_INV_OPTION,
+				     hotdrop))
+			return 0;
 	}
-
-	tcp = (struct tcphdr *)(skb->data + tcpoff);
-
-	/* FIXME: Try tcp doff >> packet len against various stacks --RR */
-
-#define FWINVTCP(bool,invflg) ((bool) ^ !!(tcpinfo->invflags & invflg))
-
-	/* Must not be a fragment. */
-	return !offset
-		&& port_match(tcpinfo->spts[0], tcpinfo->spts[1],
-			      ntohs(tcp->source),
-			      !!(tcpinfo->invflags & IP6T_TCP_INV_SRCPT))
-		&& port_match(tcpinfo->dpts[0], tcpinfo->dpts[1],
-			      ntohs(tcp->dest),
-			      !!(tcpinfo->invflags & IP6T_TCP_INV_DSTPT))
-		&& FWINVTCP((((unsigned char *)tcp)[13]
-			     & tcpinfo->flg_mask)
-			    == tcpinfo->flg_cmp,
-			    IP6T_TCP_INV_FLAGS)
-		&& (!tcpinfo->option
-		    || tcp_find_option(tcpinfo->option, tcp, datalen,
-				       tcpinfo->invflags
-				       & IP6T_TCP_INV_OPTION,
-				       hotdrop));
+	return 1;
 }
 
 /* Called when user tries to insert an entry of this type. */
@@ -1658,16 +1663,18 @@
 	  const struct net_device *out,
 	  const void *matchinfo,
 	  int offset,
-	  const void *hdr,
-	  u_int16_t datalen,
+	  unsigned int protoff,
 	  int *hotdrop)
 {
-	const struct udphdr *udp;
+	struct udphdr _udph, *uh;
 	const struct ip6t_udp *udpinfo = matchinfo;
-	int udpoff;
-	u8 nexthdr = skb->nh.ipv6h->nexthdr;
 
-	if (offset == 0 && datalen < sizeof(struct udphdr)) {
+	/* Must not be a fragment. */
+	if (offset)
+		return 0;
+
+	uh = skb_header_pointer(skb, protoff, sizeof(_udph), &_udph);
+	if (uh == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil UDP tinygram.\n");
@@ -1675,30 +1682,11 @@
 		return 0;
 	}
 
-	udpoff = (u8*)(skb->nh.ipv6h + 1) - skb->data;
-	udpoff = ipv6_skip_exthdr(skb, udpoff, &nexthdr, skb->len - udpoff);
-	if (udpoff < 0 || udpoff > skb->len) {
-		duprintf("udp_match: cannot skip exthdr. Dropping.\n");
-		*hotdrop = 1;
-		return 0;
-	} else if (nexthdr == IPPROTO_FRAGMENT)
-		return 0;
-	else if (nexthdr != IPPROTO_UDP ||
-		 skb->len - udpoff < sizeof(struct udphdr)) {
-		duprintf("udp_match: cannot get UDP header. Dropping.\n");
-		*hotdrop = 1;
-		return 0;
-	}
-
-	udp = (struct udphdr *)(skb->data + udpoff);
-
-	/* Must not be a fragment. */
-	return !offset
-		&& port_match(udpinfo->spts[0], udpinfo->spts[1],
-			      ntohs(udp->source),
-			      !!(udpinfo->invflags & IP6T_UDP_INV_SRCPT))
+	return port_match(udpinfo->spts[0], udpinfo->spts[1],
+			  ntohs(uh->source),
+			  !!(udpinfo->invflags & IP6T_UDP_INV_SRCPT))
 		&& port_match(udpinfo->dpts[0], udpinfo->dpts[1],
-			      ntohs(udp->dest),
+			      ntohs(uh->dest),
 			      !!(udpinfo->invflags & IP6T_UDP_INV_DSTPT));
 }
 
@@ -1748,14 +1736,18 @@
 	   const struct net_device *out,
 	   const void *matchinfo,
 	   int offset,
-	   const void *hdr,
-	   u_int16_t datalen,
+	   unsigned int protoff,
 	   int *hotdrop)
 {
-	const struct icmp6hdr *icmp = hdr;
+	struct icmp6hdr _icmp, *ic;
 	const struct ip6t_icmp *icmpinfo = matchinfo;
 
-	if (offset == 0 && datalen < 2) {
+	/* Must not be a fragment. */
+	if (offset)
+		return 0;
+
+	ic = skb_header_pointer(skb, protoff, sizeof(_icmp), &_icmp);
+	if (ic == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil ICMP tinygram.\n");
@@ -1763,13 +1755,11 @@
 		return 0;
 	}
 
-	/* Must not be a fragment. */
-	return !offset
-		&& icmp6_type_code_match(icmpinfo->type,
-					icmpinfo->code[0],
-					icmpinfo->code[1],
-					icmp->icmp6_type, icmp->icmp6_code,
-					!!(icmpinfo->invflags&IP6T_ICMP_INV));
+	return icmp6_type_code_match(icmpinfo->type,
+				     icmpinfo->code[0],
+				     icmpinfo->code[1],
+				     ic->icmp6_type, ic->icmp6_code,
+				     !!(icmpinfo->invflags&IP6T_ICMP_INV));
 }
 
 /* Called when user tries to insert an entry of this type. */
diff -Nru a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
--- a/net/ipv6/netfilter/ip6t_LOG.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_LOG.c	2004-10-22 03:37:28 +02:00
@@ -335,9 +335,9 @@
 
 static unsigned int
 ip6t_log_target(struct sk_buff **pskb,
-		unsigned int hooknum,
 		const struct net_device *in,
 		const struct net_device *out,
+		unsigned int hooknum,
 		const void *targinfo,
 		void *userinfo)
 {
diff -Nru a/net/ipv6/netfilter/ip6t_MARK.c b/net/ipv6/netfilter/ip6t_MARK.c
--- a/net/ipv6/netfilter/ip6t_MARK.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_MARK.c	2004-10-22 03:37:28 +02:00
@@ -20,9 +20,9 @@
 
 static unsigned int
 target(struct sk_buff **pskb,
-       unsigned int hooknum,
        const struct net_device *in,
        const struct net_device *out,
+       unsigned int hooknum,
        const void *targinfo,
        void *userinfo)
 {
diff -Nru a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
--- a/net/ipv6/netfilter/ip6t_ah.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_ah.c	2004-10-22 03:37:28 +02:00
@@ -45,8 +45,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
        struct ip_auth_hdr *ah = NULL;
diff -Nru a/net/ipv6/netfilter/ip6t_dst.c b/net/ipv6/netfilter/ip6t_dst.c
--- a/net/ipv6/netfilter/ip6t_dst.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_dst.c	2004-10-22 03:37:28 +02:00
@@ -60,8 +60,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
        struct ipv6_opt_hdr *optsh = NULL;
diff -Nru a/net/ipv6/netfilter/ip6t_esp.c b/net/ipv6/netfilter/ip6t_esp.c
--- a/net/ipv6/netfilter/ip6t_esp.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_esp.c	2004-10-22 03:37:28 +02:00
@@ -45,8 +45,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
 	struct ip_esp_hdr *esp = NULL;
diff -Nru a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
--- a/net/ipv6/netfilter/ip6t_eui64.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_eui64.c	2004-10-22 03:37:28 +02:00
@@ -24,8 +24,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
 
diff -Nru a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
--- a/net/ipv6/netfilter/ip6t_frag.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_frag.c	2004-10-22 03:37:28 +02:00
@@ -70,8 +70,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
        struct fraghdr *frag = NULL;
diff -Nru a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
--- a/net/ipv6/netfilter/ip6t_hbh.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_hbh.c	2004-10-22 03:37:28 +02:00
@@ -59,8 +59,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
        struct ipv6_opt_hdr *optsh = NULL;
diff -Nru a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
--- a/net/ipv6/netfilter/ip6t_hl.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_hl.c	2004-10-22 03:37:28 +02:00
@@ -20,7 +20,7 @@
 
 static int match(const struct sk_buff *skb, const struct net_device *in,
 		 const struct net_device *out, const void *matchinfo,
-		 int offset, const void *hdr, u_int16_t datalen,
+		 int offset, unsigned int protoff,
 		 int *hotdrop)
 {
 	const struct ip6t_hl_info *info = matchinfo;
diff -Nru a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
--- a/net/ipv6/netfilter/ip6t_ipv6header.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c	2004-10-22 03:37:28 +02:00
@@ -31,8 +31,7 @@
 		 const struct net_device *out,
 		 const void *matchinfo,
 		 int offset,
-		 const void *protohdr,
-		 u_int16_t datalen,
+		 unsigned int protoff,
 		 int *hotdrop)
 {
 	const struct ip6t_ipv6header_info *info = matchinfo;
diff -Nru a/net/ipv6/netfilter/ip6t_length.c b/net/ipv6/netfilter/ip6t_length.c
--- a/net/ipv6/netfilter/ip6t_length.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_length.c	2004-10-22 03:37:28 +02:00
@@ -23,8 +23,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
 	const struct ip6t_length_info *info = matchinfo;
diff -Nru a/net/ipv6/netfilter/ip6t_limit.c b/net/ipv6/netfilter/ip6t_limit.c
--- a/net/ipv6/netfilter/ip6t_limit.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_limit.c	2004-10-22 03:37:28 +02:00
@@ -57,8 +57,7 @@
 		const struct net_device *out,
 		const void *matchinfo,
 		int offset,
-		const void *hdr,
-		u_int16_t datalen,
+		unsigned int protoff,
 		int *hotdrop)
 {
 	struct ip6t_rateinfo *r = ((struct ip6t_rateinfo *)matchinfo)->master;
diff -Nru a/net/ipv6/netfilter/ip6t_mac.c b/net/ipv6/netfilter/ip6t_mac.c
--- a/net/ipv6/netfilter/ip6t_mac.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_mac.c	2004-10-22 03:37:28 +02:00
@@ -25,8 +25,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
     const struct ip6t_mac_info *info = matchinfo;
diff -Nru a/net/ipv6/netfilter/ip6t_mark.c b/net/ipv6/netfilter/ip6t_mark.c
--- a/net/ipv6/netfilter/ip6t_mark.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_mark.c	2004-10-22 03:37:28 +02:00
@@ -24,8 +24,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
 	const struct ip6t_mark_info *info = matchinfo;
diff -Nru a/net/ipv6/netfilter/ip6t_multiport.c b/net/ipv6/netfilter/ip6t_multiport.c
--- a/net/ipv6/netfilter/ip6t_multiport.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_multiport.c	2004-10-22 03:37:28 +02:00
@@ -53,15 +53,14 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
-	const struct udphdr *udp = hdr;
+	const struct udphdr *udp = (const struct udphdr *)(skb->data + protoff);
 	const struct ip6t_multiport *multiinfo = matchinfo;
 
 	/* Must be big enough to read ports. */
-	if (offset == 0 && datalen < sizeof(struct udphdr)) {
+	if (offset == 0 && skb->len - protoff < sizeof(struct udphdr)) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 			duprintf("ip6t_multiport:"
diff -Nru a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owner.c
--- a/net/ipv6/netfilter/ip6t_owner.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_owner.c	2004-10-22 03:37:28 +02:00
@@ -92,8 +92,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
 	const struct ip6t_owner_info *info = matchinfo;
diff -Nru a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
--- a/net/ipv6/netfilter/ip6t_rt.c	2004-10-22 03:37:28 +02:00
+++ b/net/ipv6/netfilter/ip6t_rt.c	2004-10-22 03:37:28 +02:00
@@ -47,8 +47,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
        struct ipv6_rt_hdr *route = NULL;

--------------000805040005050006000701--
