From: Ulysses Almeida <munky@maluco.com.br>
Subject: LVS HA
Date: Fri, 23 Apr 2004 00:07:11 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040423040711.GA13648@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: lvs-users@LinuxVirtualServer.org
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

Hi all, 

  I was thinking about HA and LVS on this situation:

  Every packet that my LVS recives, and needs to retransmit to any Real
Server, I'd like to replicate to a Backup LVS server. 

  For this task, I wonder to implement in NF_PREROUTING NetFilter hook
and NF_QUEUE. I would send the packet to user space, and with a daemon
on user space, I create a copy of this packet and send to another
daemon on Backup LVS, while the original packet goes back to kernel
space to finish its journey. So if LVS fails, the daemon on Backup LVS
could reinject the pending packets on kernel again, with libipq (can
this reinjection be done?)  and no one(Real Servers and clients) would
notice the fail.

  My doubts:

  - Can the reinjection be done on Backup LVS, from user space with
  some kernel interface? Maybe with libipq, and the same iptables
  queue?

  - If yes, what happens with ip connection track? 'Cose we're talking
  about packets from an alredy established connection.

  - All this crazy idea is possible? Or should I quit, and put myself
  on a hospital for insane people?

  I'm a kernel networking (developer) beginner, so I'm kind of lost
yet. Any idea or correction will be very appreciated.

  Thanks.

--
    .~.  Ulysses Almeida
   / V \  munky@maluco.com.br
 / (   ) \  Seja livre, use GNU/Linux! 
   ^^-^^
