From: "Chip Schweiss" <chip@innovates.com>
Subject: CLASSIFY target
Date: Fri, 16 Feb 2007 15:47:11 -0600
Message-ID: <E09867F2FE69EC47B0A631E3183C62C97BA7@exchange.innovates>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

Is there a technical reason why the CLASSIFY target can only be called
from the POSTROUTING chain of the mangle table? =20

It seems rather wasteful to repeat all the logic necessary to classify a
packet in the POSTROUTING chain that in most case will already be done
in the filter table.  Besides, in my testing the overhead of classifying
packets in the mangle table seems to be many magnitudes greater than in
the filter table.

Would it be possible to simply remove the checks if the rule is being
added in the POSTROUTING chain of mangle table from the kernel &
iptables sources and have the CLASSIFY target work from the filter
table?

Chip Schweiss
