From: Meg <root@server.titansoft.ru>
Subject: iptables question (libipq)
Date: Mon, 3 Jan 2005 23:54:19 +0500
Message-ID: <1806955717.20050103235419@server.titansoft.ru>
Reply-To: Meg <root@server.titansoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi All

   I have
   -t nat -A PREROUTING -j QUEUE   (1)
   -t nat -A PREROUTING -i eth1 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3128 (2)

     in (1) i want to analyze packet and send it to (2)
     and i have problem in ipq_set_verdict();

-- 
Best regards
 Meg                          mailto:root@server.titansoft.ru
