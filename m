From: Ulysses Almeida <munky@maluco.com.br>
Subject: Libipq sequence doubt
Date: Mon, 25 Oct 2004 19:47:30 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041025234729.GA3141@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  I have a doubt about packets sequence, on libipq.

  I have queue hooked on net PREROUTING and POSTROUTING. And my linux
box is a router. If two nodes (A and B) on my intranet, sends one
packet each, at the same time. Packet from host A arrives on my
machine, and goes to QUEUE hooked by PREROUTING. What can i expect?
Packet from host A arrives POSTROUTING before B arrives on PREROUTING,
or isn't it syncronous.

  Other libipq question, can I mark packets on userspace? Do this packet
need to be queued by mangle? If yes, do I need to update any other
value?

  Thanks in advance.

-- 
    .~.  Ulysses Almeida
   / V \  munky@maluco.com.br
 / (   ) \  Seja livre, use GNU/Linux! 
   ^^-^^
