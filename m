From: Ulysses Almeida <munky@maluco.com.br>
Subject: libipq/payload doubt
Date: Wed, 19 May 2004 02:20:32 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040519062032.GA32401@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  First, thanks to all, for last answers, I think I am starting to
understand how I can handle with libipq.

  But yet, I have some doubts:

  What I could see from ip_queue.c, ipq_packet_msg->payload, comes
from skb->data. Where can i find (which files) where skb->data is
filled. 'Cose till now, I don't know what info I can get from
ipq_packet_msg->payload.

  I alredy create my first daemon with libipq, I mixed libipq man
example, intercept.c (from netfilter cvs), and get some ideas from
tcp_ipv4.c (kernel). This daemon, just look for tcp packges, and print
some infos on stdout. It's printing IP src and dst address, and now
i'm trying to print src and dst TCP port address, but, I don't know
why, when I print those info, I can't get expected ports. port 80 is
showed as 20480.

  Do I have to convert something before printing in human readable
format?

  The source is on http://www.glug.ucdb.br/~ulysses/first.c

  Thanks in advance (again).

  []s

-- 
    .~.  Ulysses Almeida
   / V \  munky@maluco.com.br
 / (   ) \  Seja livre, use GNU/Linux! 
   ^^-^^
