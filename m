From: Wang Jian <lark@linux.net.cn>
Subject: About matching
Date: Thu, 07 Apr 2005 00:12:19 +0800
Message-ID: <20050407000158.02AA.LARK@linux.net.cn>
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

I haven't looked into code on how these two rules are evaluated


iptables <match rule 1> -j CONNMARK --set-mark value/mask
iptables <match rule 1> -j RETURN


How many times the match rule 1 is evaluated when matched? If two, then
the second time is waste of CPU cycle.

Then think these three

iptables <match rule 1> -j CONNMARK --set-mark value/mask
iptables <match rule 1> -j CONNMARK --restore --mask mask
iptables <match rule 1> -j RETURN

Are there any optimization for such case?


-- 
  lark
