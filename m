From: nf@hipac.org
Subject: [NF-HIPAC] Performance test results available
Date: Thu, 26 Sep 2002 00:03:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200209260003.10724.nf@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter <netfilter@lists.netfilter.org>,
 Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

We now have the results of some basic performance tests available on our =
web=20
page. The test compares the performance of the iptables filter table to t=
he=20
performance of nf-hipac. Results are pretty impressive :-)

You can find the performance test results on our web page http://www.hipa=
c.org
The releases can be downloaded from http://sourceforge.net/projects/nf-hi=
pac/

For people who don't know nf-hipac yet:
nf-hipac aims to become a drop-in replacement for the iptables packet=20
filtering module. It implements a novel framework for packet classificati=
on=20
which uses an advanced algorithm to reduce the number of memory lookups p=
er=20
packet. The module is ideal for environments where large rulesets and/or
high bandwidth networks are involved.

Enjoy,

+-----------------------+----------------------+
|   Michael Bellion     |     Thomas Heinz     |
| <mbellion@hipac.org>  |  <creatix@hipac.org> |
+-----------------------+----------------------+
