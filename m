From: jmzhou.ml@gmail.com
Subject: double-free bug and a question
Date: Thu, 14 Sep 2006 16:29:19 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609141621400.27445@mariner.cs.ucdavis.edu>
Reply-To: Jingmin Zhou <zhouji@cs.ucdavis.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Apology if this has been reported. Here's the way to reproduce the crash:

# iptables -A INPUT --protocol udp -m multiport --dports 65530:65535 -m multiport --sport 53:67 -j ACCEPT
*** glibc detected *** double free or corruption (!prev): 0x08055160 ***
Abort (core dumped)

# iptables -A INPUT --protocol udp -m multiport --dports 65530:65535 -m multiport --sports 53:67 -j ACCEPT
Bad argument `53:67'
Try `iptables -h' or 'iptables --help' for more information.

$ iptables --version
iptables v1.3.5


What I want to do is to define multiple ports for both source and 
destination in a single iptables rule. Is there any way to do it?
Thanks!

Best regards,

Jingmin

____________________________________________________________
The future is not set.  There is no fate but what we make
for ourselves.             - Terminator II, Judgement Day
