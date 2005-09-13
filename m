From: Eric Leblond <eric@inl.fr>
Subject: ipq problem on PPC 64 bits arch
Date: Tue, 13 Sep 2005 16:10:38 +0200
Message-ID: <1126620638.20081.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
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

Hi,

We were not able to have libipq working on a PPC 64 (openpower from IBM)
running RHEL4 :
	linux HOST 2.6.9-5.EL #1 SMP DATE ppc64 ppc64 ppc64
iptables has been compiled from latest source (1.3.3).

Application (nufw) is able to get the message (an IPV4 queued packet)
but when it try get the version contained in the payload if failed :
	((struct iphdr*) msg->payload)->version
returns 0.

We try to set
	CFLAGS+=3D-DIPT_MIN_ALIGN=3D8 -DKERNEL_64_USERSPACE_32
which was not set by Makefile. But there were no result.

BR,
--=20
=C9ric Leblond, eleblond@inl.fr
T=E9l=E9phone : 01 44 89 46 40, Fax : 01 44 89 45 01
INL, http://www.inl.fr
