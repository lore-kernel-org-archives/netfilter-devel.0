From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: [Bug]: (some) ICMP replies marked as invalid.
Date: Tue, 27 May 2003 23:17:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED3D5F3.4080605@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

The rule:
	iptables -I OUTPUT -m state --state INVALID -j DROP
(all other chains empty with policy accept), results in ICMP replies to
tracetoute being dropped.

Is dropping invalid packets on the output chain not recommended, or is 
the code determining if a packet is invalid broken?

Regards
Anders Fugmann
