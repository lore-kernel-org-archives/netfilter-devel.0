From: Scott MacKay <scottmackay@yahoo.com>
Subject: Kernel 2.6 conntrack defragment of IP packets
Date: Fri, 25 Jun 2004 04:16:41 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040625111641.42357.qmail@web13908.mail.yahoo.com>
References: <Pine.LNX.4.33.0406251305390.11001-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.33.0406251305390.11001-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hiyas,
   I was wondering, for the 2.6 kernel is there any
different in how conntrack defragments non TCP/non UDP
IP packets?
    I have a userspace QUEUE app which works fine
using 2.4.18 but has some issues with the 2.6.5 and
2.6.7 kernels.  When the packet goes above ~2360
bytes, the end of the packet is bad.  It is weird
because the data (as seen from a hexdump in the
userspace app) is fine, right up to that mark and
works ok under 2.4.x.  The only other change I made
was capturing the packet in PREROUTING mangle instead
of INPUT, but that looks to be after conntrack is done
with the data.  If the traffic is UDP, it seems to
work fine...

-Scott


		
__________________________________
Do you Yahoo!?
Yahoo! Mail Address AutoComplete - You start. We finish.
http://promotions.yahoo.com/new_mail 
