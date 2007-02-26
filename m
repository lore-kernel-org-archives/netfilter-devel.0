From: topi <topi23@gmail.com>
Subject: netfilter capturing in promisc mode
Date: Mon, 26 Feb 2007 15:42:27 +0100
Message-ID: <20070226154227.7d943e09@neser.elpiset.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

hello,

i'm programming a netfilter-based module to gather statistics for RTP
flows in a network, although this can be done in user space i'm
planning to get the module doing a 'distributed' firewalling based on
external information (from VoIP infrastructure)  

i thought that setting the device to promiscuous mode will let me to
capture in the netfilter hook every packet (not only those destined to
the host), but i'm not getting packets into the hook except if they are
directed to it.

i've seen that there's a 'promisc' patch (for Linux 2.4) at:

 http://caia.swin.edu.au/cv/szander/netfilter.html

but i'm not sure if this feature is available for netfilter in
Linux 2.6, can you point me on this?

i need to get this working as fast as possible, so i need to know if
what i'm asking is feasible.

after that, i will start rethinking my architecture so i'm guessing
it's possible to do everything in user space using conntrack and
netlink sockets (i'm not sure about what will be needed)

my future work will be directed to get a VoIP monitoring tool for
linux-based routers (if i can it will be in user space, otherwise a
mixed kernel/user space)

thanks in advance for your help,

topi
