From: "Swaroop Ashish" <sashish@novell.com>
Subject: How to implement attack detection?
Date: Tue, 06 Apr 2004 04:05:16 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <s0722c8c.085@prv-mail25.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi All,

I am new to Netfilter/Iptables and am trying to write a dummy firewall
with a skeleton Intrusion Detection System in it, using
Netfilter/Iptables for my Suse 9.0 distro. I noticed that we can specify
limits to incoming/outgoing packets for example if I am getting more
than 5 SYN packets from a particular IP address, I can block any further
SYN requests from that IP Address.

Now to write a Intrusion Detection System, how that limit counter is
exposed by Nefilter/Iptables and how can I use it in my userspace
firewall? So that I can easily check for the exposed counter and
drop/reject the packets or allow them.

Any help in this regard is highly appreciated.

Thanks
Ashish
