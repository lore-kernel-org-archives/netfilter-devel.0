From: Diego Woitasen <diegows@linux.org.ar>
Subject: connbytes: wrong depends on Kconfig
Date: Sun, 04 Sep 2005 01:36:46 -0300
Message-ID: <1125808606.32363.1.camel@ceci.ws.ar>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

depends on IP_NF_CONNTRACK_ACCT && IP_NF_IPTABLES

sould be replaced by

depends on IP_NF_CT_ACCT && IP_NF_IPTABLES

The first is not working in new kernels.

regards,
	diegows
