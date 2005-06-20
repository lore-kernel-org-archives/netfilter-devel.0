From: "Alex" <alex_oz@gmx.net>
Subject: Clusterip: What about Cluster-side ARP-requests
Date: Mon, 20 Jun 2005 21:15:59 +0200 (MEST)
Message-ID: <31236.1119294959@www15.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

Hi folks,

as far as I can see from the CLUSTERIP source all ARP-Responses are
manipulated so that the clients have a multicast MAC - ClusterIP mapping in
their ARP-caches. But what about ARP-requests from the nodes itself? Such a
request is not mangled by the module and thus contains the original
non-cluster-MAC.
This changes the clients ARP entry to a non multicast-MAC.
I reproduced this case and pinged a two node cluster (kernel-2.6.10). After
a while node 2
makes an arp request using the NIC's MAC and not the Cluster's MAC. From
that moment the other node doesn't see any cluster traffic.
Do I have any missconception?

-- 
Weitersagen: GMX DSL-Flatrates mit Tempo-Garantie!
Ab 4,99 Euro/Monat: http://www.gmx.net/de/go/dsl
