From: Diego Woitasen <diegows@linux.org.ar>
Subject: contrack and packets with error
Date: Tue, 03 May 2005 23:06:59 -0300
Message-ID: <1115172419.4363.8.camel@ceci.ws.ar>
Mime-Version: 1.0
Content-Type: text/plain
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

Reading the conntrack code, i see that conntrack return NF_ACCEPT when a
packet is erroneous (proto->error() returns -1), so the packet is
ignored by conntrack but continues traversing the protocol stack.

The question is, why netfilter does not discard the packet?

regards,
	diegows
