From: "Sumit Pandya" <sumit@elitecore.com>
Subject: Delition of rule after altering data in check/match entry
Date: Mon, 14 Jul 2003 21:01:22 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <02b201c34a1c$faef6ac0$010f430a@elitecore7>
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

Hi All,
    In a netfilter match or check extension at the time of rule-insertion,
If I update any data passed along
    1> void *matchinfo (argument to matchentry) or
    2> void *targinfo  (argument to checkentry)
Then I'm not able to delete same inserted rule.
    Is there something regarding caching of the data? Does It require to
notify iptables somewhere about this change?
Thanks,
-- Sumit
