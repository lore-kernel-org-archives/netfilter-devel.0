From: "Vishwas Manral" <Vishwas@sinett.com>
Subject: TCP small Fragments
Date: Wed, 16 Feb 2005 02:49:26 -0800
Message-ID: <BB6D74C75CC76A419B6D6FA7C38317B2628B73@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-class: urn:content-classes:message
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

Hi folks,

=20

IP packets containing TCP payload can be fragmented. Firewalls have
checks on TCP flags to check if there are illegal combinations of TCP
flags. However if the TCP header in the IP packet itself is fragmented,
it may not be easy to track such a packet.

=20

What is the default behavior for such packets in which the TCP header
itself is not completely there (I know a lot of hosts crash on getting
such packets)?=20

=20

Thanks,

Vishwas

=20

=20
