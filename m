From: Thomas S. Valsted <thomas@valsted.dk>
Subject: Packet duplication on bridge?
Date: Thu, 16 Jan 2003 02:42:21 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E18Yz4a-0003q2-00@kashyyyk.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

I am running an iptables bridge with 3 interfaces and I need a way to duplicate a packet 
based on an firewall rule.
When the firewall finds a packet from host 1 to host 2 on interface A, then it should 
route the packet to interface B AND C without altering it.
Likewise the other way, when the firewall finds a packet from host 2 to host 1 on 
interface B, then it should route the packet to interface A AND C without altering it.
I have not been able to find any way to do this yet, but it should be possible anyhow.
The firewall is as said earlier running in bridge mode which can not be changed, so NAT 
features seems impossible.
Do someone here have an idea to how this can be done?
