From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: IPC performance
Date: Thu, 26 Feb 2004 19:51:19 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <006f01c3fc45$b3cc27b0$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This question is a bit off the topic of specifically Netfilter but does
anyone know of any information that outlines the relative performance
tradeoff of performing various types of local Unix IPC. For instance using
TCP/UDP or RAW sockets across a loopback compared to communicating by local
domain sockets? Is there much of a difference in performance?

Thanks. Any info appreciated.

Andrew.
