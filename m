From: Alistair Tonner <Alistair@nerdnet.ca>
Subject: ip_conntrack_irc.c & ip_nat_irc.c DEBUG.
Date: Sat, 22 May 2004 15:29:53 -0400
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <200405221529.53743.Alistair@nerdnet.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org


	I'm having an issue with natting and conntracking IRC DCC sends. I wanted to 
	enable DEBUG in nat_irc and conntrack_irc.  However setting 
	if 1
	#define DEBUGP ......

	results in the build of either module failing for numerous errors, 
	kernel 2.6.3  (gentoo) and iptables 1.2.9.

	Any suggestions on where to find known fixes folks?

	Alistair Tonner.
