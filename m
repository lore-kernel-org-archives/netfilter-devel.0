From: Alfonso Presa <AlfPresa@msn.com>
Subject: Getting the current RTT for an active connection
Date: Wed, 28 Apr 2004 01:46:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1083109593.15705.11.camel@Fallen.FAMILIA>
Mime-Version: 1.0
Content-Type: text/plain
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

I'm trying to develop an iptables extension that needs to get the rtt
for an already established connection. Is there any "eassy" way to do
this through a conntrack module, or do I have to meassure the delay time
between each packet and it's ACK?

I'm newie in programming modules for the kernel, so I would apreciate
any kind of help ,explanations and advices you can give me.

Thanks a lot.

Alfonso
