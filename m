From: Kiran Kumar Immidi <immidi@spymac.com>
Subject: NAT question
Date: Wed, 30 Jun 2004 05:36:02 -0600 (MDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040630113602.963604C052@spy10.spymac.net>
Reply-To: immidi@spymac.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: netfilter-devel@lists.netfilter.org
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
  When packets are being masqueraded from multiple machines through a NAT=
 box,
how would the response be identified as part of a particular connection. =
So, if
we have (identical, as regards port numbers and dest ip address) packets =
from A
and B snatted at C, how is the reply (to C) identified as belonging to ei=
ther A
or B? There does not seem to be any information in the packet to distingu=
ish it.
Regards,
Kiran Kumar Immidi

---- Cool Things Happen When Mac Users Meet! Join the community in Boston=
 this July: www.macworldexpo.com
