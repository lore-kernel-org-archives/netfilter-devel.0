From: Markus Schaber <markus.schaber@student.uni-ulm.de>
Subject: Problem with IP-Pools
Date: Thu, 28 Nov 2002 16:29:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021128162921.2b2a721d.markus.schaber@student.uni-ulm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm using the IP Pools extension form Patch-O-matic, and now have the
problem that it tends to kill the machine on SMP. (I just killed our
backup firewall two times this day...)

The symptoms are that a "ippools -n blah" with an already existing pool
blah sometimes hangs, eating up more and more processor time, and
the process cannot be killed even with SIGKILL. "shutdown -r" and
"reboot" also refuse to work (they shut down most services, but don't
actually reboot the machine). The machine gets more and more sloppy, and
after about 2 or 3 minutes, it doesn't respond on network and local
serial console.

I suspect there's a race condition on SMP.

I mailed Patrick Schaaf (the creator of the iptables patch), and he said
that he never tested it on SMP, and currently doesn't have time to look
into it.

He pointed me to this list and told me that Joackim Axelsson has a
modified version, but didn't publish it yet.

Can anyone help or reproduce this problem? Is Joackim here?

Thanks,
Markus
-- 
Markus Schaber - http://www.schabi.de/

Schabi's Flohmarkt unter http://schabi.de/flohmarkt
