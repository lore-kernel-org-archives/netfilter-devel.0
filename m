From: Wang Jian <lark@linux.net.cn>
Subject: --in-interface and --out-interface issue on bridge
Date: Thu, 21 Apr 2005 15:41:58 +0800
Message-ID: <20050421151458.03C6.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
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

Hi,

During my test, I find that --in-interface doesn't work as I expected.

  web server -- (eth0--br0--eth1)  -- web client


# iptables -t mangle -A PREROUTING -i eth0 -p tcp --sport 80 \
	-j MARK --set-mark 1

doesn't set mark to 1.

I google a while and read some pages that use such a rule for bridged
firewall.

# iptables -A FORWARD --in-interface eth0 --out-interface eth1 \
	-j ACCEPT

I test this rule and fail

# iptables -t mangle -A FORWARD -i eth0 -p tcp --sport 80 \
	-j MARK --set-mark 1

If I removed -i eth0 or use -i br0 instead, then the mark is set.

I looked into net/core/dev.c and net/bridge/* and didn't get clue about
this.

kernel is vanilla 2.6.11 with bridge packet filtering on.


-- 
  lark
