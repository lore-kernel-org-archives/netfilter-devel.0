From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 0/5]: Netfilter fixes
Date: Thu, 14 Oct 2004 02:18:27 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <416DC5D3.80607@trash.net>
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

the following five patches fix a stale proc entry,
bogus module dependencies in ipfwadm.ko and multiple
bugs in ip6tables matches.

You can pull all changes from bk://212.42.230.204/nf-2.6

Regards
Patrick


ChangeSet@1.2169, 2004-10-14 01:06:10+02:00, yasuyuki.kozakai@toshiba.co.jp
  [NETFILTER]: Fix multiple bugs in ip6t_frag.c
 
  The first patch fixes following bugs in ip6t_frag.c,
 
    - Wrong cast the pointer to extension header.
    - header length of Fragment Header is statically 8 octets.
      Then the option "--frag-len" doesn't make sense.
    - There are endian issues where using frag->info.
    - Reserved fields are not 2 bit but 8bit + 2 bit. (see RFC2460)
 
  Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.2168, 2004-10-14 01:04:09+02:00, yasuyuki.kozakai@toshiba.co.jp
  [NETFILTER]: Fix checks in ip6t_multiport.c
 
  The first patch fixes following bugs in ip6t_multiport.c,
 
    - missing check the size of the preference data.
    - IP6T_INV_PROTO should check with not ip->flags but ip->invflags.
 
  Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.2167, 2004-10-14 01:00:37+02:00, yasuyuki.kozakai@toshiba.co.jp
  [NETFILTER]: Fix multiple bugs in ip6rt.c
 
  The first patch fixes the following bugs
 
    - Wrong cast the pointer to extension header.
    - "Segments Left" field in Routing Header isn't treated as 1 octet.
 
  Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.2166, 2004-10-14 00:57:06+02:00, okir@suse.de
  [NETFILTER]: Don't export common symbols from ipfwadm.ko
 
  Exported kernel symbols ip_conntrack_count and ip_conntrack_tcp_update 
were
  showing up both in ip_conntrack.ko and ipfwadm.ko, causing bogus 
dependencies
  in modules.dep.
 
  Signed-off-by: Olaf Kirch <okir@suse.de>
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.2165, 2004-10-14 00:55:09+02:00, pablo@eurodev.net
  [NETFILTER]: Fix removing invalid proc file
 
  Signed-off-by: Pablo Neira <pablo@eurodev.net>
  Signed-off-by: Patrick McHardy <kaber@trash.net>
