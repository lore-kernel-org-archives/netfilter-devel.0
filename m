From: shyam@india.tejasnetworks.com
Subject: Support for longest prefix IP address match in iptables?
Date: Fri, 28 Apr 2006 13:31:57 +0530 (IST)
Message-ID: <38539.192.168.20.50.1146211317.squirrel@pop-mail>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: nbasker@india.tejasnetworks.com
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

Hello:

We are using iptables v1.2.9 on Linux 2.4.20 kernel on
a powerpc based system.

We are using iptables to match the destination ip-addresses
using the command

iptables -t mangle -A POSTROUTING -d 10.12.13.14 -j MARK --set-mark=3D5
iptables -t mangle -A POSTROUTING -d 10.12.13.0/24 -j MARK --set-mark=3D7

We observe that the destination ip-address match based on the
option "-d" does not follow the longest prefix match. For example
we are seeing a command "ping 10.12.13.14" gets a mark value of 7
instead of 5.

Is this fixed in the subsequent release of "iptables" or
netfilter modules in Linux 2.4.

A link to the patch or the correct iptables version that can
support the above would be helpful.

Thanks
-Shyam
