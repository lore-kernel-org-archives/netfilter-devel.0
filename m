From: larsbj@birdstep.com (=?iso-8859-1?q?Lars_Gullik_Bj=F8nnes?=)
Subject: Support for ip-ranges.
Date: Fri, 08 Aug 2003 13:28:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <m3n0ekpevv.fsf@tyfon.gullik.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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


Are there support for matching on ip ranges in iptables now?

I am thinking of something like:

  --match iprange --iprange-begin 192.168.10.23 --iprange-end 192.168.11.15

Have this been thought of or is it something that would
be interesting?

-- 
	Lgb
