From: Frank Meerkoetter <meerkoetter@stud.fbi.fh-darmstadt.de>
Subject: Netfilter on an IXDP-2400/2800
Date: Mon, 15 Sep 2003 16:04:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030915140411.GA3166@mandark.chaos.lab>
Reply-To: meerkoetter@stud.fbi.fh-darmstadt.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello,

during the next 6 month i've maybe the possibility to play around with an 
intel network processor board [1].

The IXP-2400 is a processor based on the xscale architecture, running at 
600Mhz [2]. It contains among other things 8 io-processors, called 
microengines which are optimized for packet-processing. The setup will 
most probably have a quad gigabit ethernet card.

A first idea for a project was to modify the netfilter framework to make use
of the special hardware features of this platform.

Could someone please comment on the usefullness/feasibility of such a 
modification?

sincerely 
  Frank Meerkoetter

[1] an IXDP-2400 or even an IXDP-2800
[2] http://www.intel.com/design/network/products/npfamily/ixp2400.htm
