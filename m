From: "Vishwas Manral" <Vishwas@sinett.com>
Subject: RE: Help: Netfilter Rule database
Date: Wed, 16 Mar 2005 04:42:08 -0800
Message-ID: <BB6D74C75CC76A419B6D6FA7C38317B26A273E@sinett-sbs.SiNett.LAN>
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

After some head scratching, I managed to figure out my way around the
code. We register socket options in the kernel and call the action as a
result of the setsockopt system call which is used by libiptc.=20

Thanks,
Vishwas
-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of
Vishwas Manral
Sent: Tuesday, March 15, 2005 9:47 AM
To: netfilter-devel@lists.netfilter.org
Subject: Help: Netfilter Rule database

Hi,

Could someone tell me how rules get stored in the various chains in the
ipTables module in the kernel? Any pointer to the code or documentation
would help.

I know NETLINK_FIREWALL sockets are used for transferring packets to
user space. What do we use for transferring iptables rules to the kernel
from the user space?

Thanks,
Vishwas

-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of
Vishwas Manral
Sent: Monday, March 14, 2005 4:44 PM
To: netfilter-devel@lists.netfilter.org
Subject: Netfilter Rule database

Hi,

I have been trying to understand the iptables code.=20

I was able to understand to some extent the code in the netfilter
directory, but have been unable to understand how the user and the
kernel space interaction happen for the rules (not for the packets).
Also where and how the rules are stored in the kernel? Any pointer to
the file I need to look at would be helpful.

Thanks,
Vishwas
