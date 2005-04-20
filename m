From: Wang Jian <lark@linux.net.cn>
Subject: A top 10 statistics module?
Date: Wed, 20 Apr 2005 20:40:20 +0800
Message-ID: <20050420200757.03A9.LARK@linux.net.cn>
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

I have a customer who needs functionality that list top 10 hosts 
(listener or talker). It normally done in userspace, but in this case,
the 10 hosts is for a tc class. Moreover, it is expected that 2 or more
tc classes' top 10 are collected at the same time.

So I think this is better handled in kernel space, because the classid
and/or nfmark is only seen in kernel space.

The idea is that a rule like

 -m mark --mark 0x1 -j TOPHOST --count 10 --name FILENAME

will collect top10 IPs (using conntrack flow account) and export the
information under /proc/net/stat/top10/FILENAME based on the source
address. (You may need add -i to indicate the direction)

Of course, the top10 can be used to match any other criteria beside the
nfmark. It can even collect top10 of all traffic.

Top10 is used to monitor a while and then disabled. It could be expensive,
but is useful to investigate.

I will implement it anyway to complete the task, but before I code, I am
willing to listen to any one who has comment and suggestion.


-- 
  lark
