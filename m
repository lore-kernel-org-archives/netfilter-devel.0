From: Wang Jian <lark@linux.net.cn>
Subject: bidirectional CONNMARK?
Date: Wed, 09 Mar 2005 13:26:19 +0800
Message-ID: <20050309124806.A55C.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
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

Hi folks,

What is the CONNMARK's purpose? I think it is to reduce rule traversal,
like this:

# iptables -A PREROUTING -t mangle \
   -m connmark --mark 0xEF000000/0xFF000000 -j CONNMARK --restore-mark

# iptables -A PREROUTING -t mangle <matching rule 1-1> -j CONNMARK --set-mark 0xEF000001
# iptables -A PREROUTING -t mangle <matching rule 1-2> -j CONNMARK --set-mark 0xEF000001
# iptables -A PREROUTING -t mangle <matching rule 1-3> -j CONNMARK --set-mark 0xEF000001
# iptables -A PREROUTING -t mangle <matching rule 2-1> -j CONNMARK --set-mark 0xEF000002
# iptables -A PREROUTING -t mangle <matching rule 3-1> -j CONNMARK --set-mark 0xEF000003
<snip a lot of rules>

But an issue occurs, when we want to set 2 different marks for a single
session in two directions.

When doing QoS control as an router between two or more interfaces,
bi-directional control is neccessary. Since nfmark is the most
convenient way to classify packet, should we extend CONNMARK to support
two marks?

Comment on this issue is welcome.

If it is a good idea, I will provide a patch for it.




-- 
  lark
