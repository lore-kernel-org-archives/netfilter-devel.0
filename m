From: Andy Polyakov <appro@fy.chalmers.se>
Subject: iptables performance under 2.6.0[-test9]
Date: Mon, 27 Oct 2003 17:10:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9D4370.99795B87@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

I tried to deploy 2.6.0[-test9] iptables to masquarade an private
interace. Strangely enough ip_conntrack.ko module seems to affect
performance of *some* TCP connections. More specific I found that
performance of certain TCP connections (netscape mail rebuilding index
of an large IMAP mailbox in my case) is *reproducibly* unacceptable
(minutes vs. normal 15-20 seconds). In the course of troubleshooting I
started to unload iptables modules one by one, and after 'rmmod
ip_conntrack,' performance became normal. I don't know if it's
essential, but performance is not affected if I deploy ipchains instead
of iptables for equivalent setup. Oh! Those affected TCP connections are
*not* masqueraded and are "bound" to primary interface. I'm looking for
triggering factors now (what's so special about netscape mail rebuilding
mailbox index), but I figured that meanwhile it might worth asking
people on this list if this resembles any other problem report. Does it?
A.
