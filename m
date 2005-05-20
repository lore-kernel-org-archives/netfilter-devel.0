From: Pawel Sikora <pluto@agmk.net>
Subject: the latest h323 module doesn't build.
Date: Fri, 20 May 2005 13:42:27 +0200
Message-ID: <200505201342.27652.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

gcc4 reports an error:

  CC [M]  net/ipv4/netfilter/ip_conntrack_standalone.o
In file included from net/ipv4/netfilter/ip_conntrack_standalone.c:34:
include/linux/netfilter_ipv4/ip_conntrack.h:161:
error: field 'ct_h225_info' has incomplete type

i don't see a definition of ip_ct_h225_master struct
in svn/linux-2.6.11 subdir. `rm ip_conntrack.h.ladd` fixes problem.

-- 
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke
