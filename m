From: "Paul Gallant" <papoux_gallant@hotmail.com>
Subject: Problem: cannot apply H.323 conntrack patch on Linux 2.6.11
Date: Mon, 7 Mar 2005 11:40:51 -0500
Message-ID: <BAY23-DAV14A747873B01A3FBC18EAAEE5F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
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

Dear Netfilter developers,

I downloaded the latest Linux 2.6.X kernel from kernel.org:
2.6.11 2005-03-02=20

I downloaded the latest iptables 1.3.0 from netfilter.org.

Then tried to apply Patch-o-Matic-ng-20050302 to add H.323 conntrack.

The patch does not apply... (It is specified that it requires: linux-2.6 =
>=3D 2.6.11)

It seems that ip_conntrack.h file structure changed and that there is no =
more "insert conntrack helper private data (expect) here" section =
anymore.

What should I do to resolve this issue?

Regards,

Paul Gallant
