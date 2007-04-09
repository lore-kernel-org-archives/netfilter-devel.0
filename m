From: "Manish Jain" <manish.jain@globallogic.com>
Subject: ICMP Land Attack
Date: Mon, 9 Apr 2007 17:23:32 +0530
Message-ID: <007a01c77a9d$b2727c50$dd2d10ac@synapse.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: 
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

Hello,

We are experiencing ICMP Land Attach (ICMP packet with [source ip = dest ip]
&& [source mac == dest mac]).

Do we have any standard mechanism to counter this attach using
iptable/ipsets? Or any other suggestion?

Whether it is possible to write iptable rule saying "source ip == dest ip"
instead of specifying hard-coded values? 

Any pointers will be appreciated.

Best Regards,
Manish Jain
