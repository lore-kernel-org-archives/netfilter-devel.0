From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: TCPLAG still requires iptables version 1.2.3
Date: Fri, 11 Mar 2005 12:39:27 +0100
Message-ID: <1110541167.14794.6.camel@scaramouche>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
To: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
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

iptables/extensions/libipt_TCPLAG.c requires the iptables version
to be 1.2.3 and thus will compile, but not run:

static struct iptables_target targ =3D
{
next:	          0,
name:             "TCPLAG",
version:          "1.2.3",
size:             IPT_ALIGN( sizeof( struct ipt_tcplag )),
...

Changing "1.2.3" to IPTABLES_VERSION does the trick.
Could you change this in svn please?

Thanks,
Torsten L=FCttgert <t.luettgert@pressestimmen.de>
