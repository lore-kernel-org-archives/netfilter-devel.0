From: gypsy <gypsy@iswest.com>
Subject: Reverse the behavior change of -L option?
Date: Sat, 19 Feb 2005 23:48:53 -0800
Message-ID: <421840E5.2F11BB81@iswest.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

Since 1.3.0 none of the scripts I parse the output of 'iptables -nvL'
works anymore because the order has changed from INPUT FORWARD OUTPUT
USER to alphabetical.  How do I revert back to the prior behavior?

gypsy
