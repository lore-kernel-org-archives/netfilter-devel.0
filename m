From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 0/12]: netfilter update
Date: Tue, 21 Sep 2004 05:20:28 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9DFC.701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi Dave,

following are 12 mostly random netfilter patches for 2.6.
You can also pull all changes from bk://212.42.230.204/2.6-netfilter

Regards
Patrick


ChangeSet@1.1935.1.12, 2004-09-20 11:55:28+02:00, kaber@coreworks.de
  [NETFILTER]: add comment match
 
  2.4 version by Brad Fisher <brad@info-link.net>
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1935.1.11, 2004-09-20 11:54:00+02:00, kaber@coreworks.de
  [NETFILTER]: Fix invalid return values in sctp_new
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1935.1.10, 2004-09-20 11:52:16+02:00, kaber@coreworks.de
  [NETFILTER]: Fix two broken assertions
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1935.1.9, 2004-09-19 18:18:43+02:00, gandalf@wlug.westbo.se
  [NETFILTER]: Cleanup ctstat
 
  This patch simply adds a macro to increase the statistics.
  And it changes icmp_error to error in struct ip_conntrack_stat in order
  to adopt to the tcp-windowtracking changes.
 
  Based on patch by Pablo Neira.
 
  Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1935.1.8, 2004-09-19 18:08:05+02:00, kaber@coreworks.de
  [NETFILTER]: lookup sockets for incoming packets in ipt_owner
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1935.1.7, 2004-09-19 16:28:21+02:00, kaber@coreworks.de
  [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1935.1.6, 2004-09-19 15:33:35+02:00, kaber@coreworks.de
  [NETFILTER]: Use u_int16_t for initialized/num_manips in struct 
ip_nat_info
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1935.1.5, 2004-09-19 15:29:24+02:00, kaber@coreworks.de
  [NETFILTER]: kill struct nf_ct_info, saves five pointers per conntrack
 
  The relationship of the skb to the conntrack is stored in a new field
  in the skb.
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1935.1.4, 2004-09-19 00:05:29+02:00, kaber@coreworks.de
  [NETFILTER]: kill struct ip_nat_hash, saves two pointers per conntrack
 
  The back-pointer is not needed when using list.h macros.
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1935.1.3, 2004-09-18 23:44:40+02:00, rusty@rustcorp.com.au
  [NETFILTER]: Shuffle conntrack structure for better cacheline behavior
 
  Every time we walk the conntrack hashtable list, we hit the same
  cacheline that is dirtied by the use of the conntrack
  entry. Shuffling these entries to the end should help this
  (sizeof(struct ip_conntrack)) > cacheline size).
 
  Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1935.1.2, 2004-09-18 23:27:31+02:00, laforge@netfilter.org
  [NETFILTER]: add sysctl to read out the number of current connections
 
  Apparently a lot of scripts use a construct like
          "cat /proc/net/ip_conntrack | wc -l"
  which has a negative impact on system performance due to all the locking
  required.
 
  Signed-off-by: Harald Welte <laforge@netfilter.org>
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1935.1.1, 2004-09-18 23:18:23+02:00, rusty@rustcorp.com.au
  [NETFILTER]: Don't try to do any random dropping since we now use 
jenkins hash
 
  Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
  Signed-off-by: Patrick McHardy <kaber@trash.net>
