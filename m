From: "Shipman, Jeffrey E" <jeshipm@sandia.gov>
Subject: TCP/IP checksums and changing destination address
Date: Fri, 14 Jun 2002 08:03:38 -0600
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <03781128C7B74B4DBC27C55859C9D73809840639@es06snlnt>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "'netfilter-devel@lists.samba.org'" <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I'm currently writing a netfilter module to modify
some options in TCP packets. Currently, I'm just
trying to learn a bit about it so I've written a
module that 1) Sets the PSH flag in all TCP packets
and 2) Modifies the destination address to be the
source address.

I wrote a small function that uses tcp_v4_check()
and ip_fast_csum() to recalculate the checksums
on the packets. If I set the PSH flag, it works
great. All of my packets have it set and everything
works as normal. However, if I try to modify the
destination address to the source address, I
can send out SYNs, but I never get SYN/ACKs back
from the remote machine (myself).

So, I have a couple questions:

1) Do I really need my own function to wrap around
those other two checksum functions or is there already
a wrapper-type function to do this?

2) How can I fix the problem with setting the destination
address to the source address? Is there some option or
flag I'm missing?

Thanks in advance.

Jeff Shipman - CCD
Sandia National Laboratories
(505) 844-1158 / MS-1372
