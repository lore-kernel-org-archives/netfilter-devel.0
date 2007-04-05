From: "Manish Jain" <manish.jain@globallogic.com>
Subject: sendto failed
Date: Thu, 5 Apr 2007 17:09:12 +0530
Message-ID: <00bf01c77777$0865a080$dd2d10ac@synapse.com>
References: <1175763250.19021.17.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1175763250.19021.17.camel@henriknordstrom.net>
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

We have some rate limiting rules on OUTPUT side on our box, so if a daemon
tries to send message beyond a limit, sendto() starts failing. Can we find
out from return value or errno that we had failed because of firewall.

Best Regards,
Manish Jain
