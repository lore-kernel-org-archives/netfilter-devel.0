From: Max Kellermann <max@duempel.org>
Subject: [POM] h323-conntrack-nat: please delete ip_conntrack_h323.c
Date: Wed, 14 Sep 2005 20:29:03 +0200
Message-ID: <20050914182903.GA3247@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net
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

Hi,

while porting the h323-conntrack-nat module to Linux 2.6.13, I noticed
that the old files ip_conntrack_h323.c were not deleted from the
patch-o-matic subversion repository.  Please delete from trunk:

 patchlets/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c
 patchlets/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c

.. these files were split up into ip_conntrack_h323_core.c,
ip_conntrack_h323_h225.c, ip_conntrack_h323_h245.c.

Max
