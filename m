From: "Qiang" <qzhang@endeavorsystems.net>
Subject: Enlarge packet size in target & fragmentation {Virus Scanned}
Date: Tue, 20 Apr 2004 13:45:04 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404201749.i3KHn3Fq022374@localhost.localdomain>
References: <200404191423.i3JENZFq003381@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <200404191423.i3JENZFq003381@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


If I enlarge a skb in a target at prerouting (after conntrack), when the
modified packet exceeds the size of MTU, the packet is lost, but it is fine
when packet size is smaller, any ideas?  Conntrack should have taken care of
the fragmentation?
Q
