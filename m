From: "Dave Hawkes" <daveh@cadlink.com>
Subject: ECN target in cvs broken?
Date: Sun, 2 Jun 2002 22:38:07 -0400
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <000f01c20aa7$b1aee300$3e08a8c0@davehh>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I think there may be a typo in the ECN code recently commited to CVS

line 12 in ipt_ecn.h

is

#include <linux/netfilter_ipv4/ipt_dcsp.h>

should be(?)

#include <linux/netfilter_ipv4/ipt_dscp.h>

Dave Hawkes
