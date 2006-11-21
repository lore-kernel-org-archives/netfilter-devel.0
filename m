From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC] XML output for libnetfilter_conntrack
Date: Tue, 21 Nov 2006 14:58:55 +0100
Message-ID: <4563061F.4080904@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>
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

Hi,

I'm about to complete the new API for libnetfilter_conntrack, it
includes the possibility to dump conntrack entries in XML besides of the
classic output similar to the primitive /proc interface. An example of
the XML layout is the following:

/*
 * XML output sample:
 *
 * <conntrack>
 * 	<tuple direction="original">
 * 		<layer3 protonum="2" protoname="ipv4">
 * 			<src>192.168.0.1</src>
 * 			<dst>192.168.0.2</dst>
 * 		</layer3>
 * 		<layer4 protonum="16" protoname"udp">
 * 			<sport>80</sport>
 * 			<dport>56665</dport>
 * 		</layer4>
 * 	</tuple>
 * 	<tuple direction="reply">
 * 		<layer3 protonum="2" protoname="ipv4">
 * 			<src>192.168.0.2</src>
 * 			<dst>192.168.0.1</dst>
 * 		</layer3>
 * 		<layer4 protonum="16" protoname="udp">
 * 			<sport>80</sport>
 * 			<dport>56665</dport>
 * 		</layer4>
 * 	</tuple>
 * 	<meta>
 * 		<protocol>
 * 			<tcp>
 * 				<state>ESTABLISHED</state>
 * 			</tcp>
 * 		</protocol>
 * 		<timeout>100</timeout>
 * 		<status><assured>yes</assured></status>
 * 		<counters direction="original">
 * 			<bytes>10</bytes>
 * 			<packets>1</packets>
 * 		</counters>
 * 		<counters direction="reply">
 *			<bytes>5029</bytes>
 * 			<packets>12</packets>
 * 		</counters>
 * 	</meta>
 * </conntrack>
 */

Comments welcome,

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
