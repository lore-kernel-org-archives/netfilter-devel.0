From: Sadin Nurkic <sadin.nurkic@gmail.com>
Subject: pptp conntrack fails on server call id != 0
Date: Fri, 4 Nov 2005 19:32:21 +1100
Message-ID: <b857c6de0511040032r75046c68s47a48b950f610191@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I'm looking for pointers on how to exactly to debug this myself, so
any help on this would be greatly appreciated.

The setup is as follows: many PPTP clients behind a linux server doing
NAT. This server is exclusively setup to only do NAT for PPTP
connections, so majority of time there is only TCP 1723 and GRE
flowing through the server.


Basically, I'm seeing that some packets sent from the PPTP server are
not appropriately NATed back to the original handset address. The TCP
stream works fine, but the GRE packets don't get the NAT.

The correlation that I can see in the traces is that if the PPTP
server call-id is set to 0 by the server, then the call would work.
However if for some unknown reason this call-id is not set to 0, then
the call (NAT-ing) does not occur so the call fails. It seems random
that the call-id gets set to 0 on the server side, but I do see in the
TCP trace that there is a correct call-id exchange in the control
connection.

Also occassionaly I get:
kernel: ip_conntrack_pptp: error during exp_gre

Please let me know what information you need or what debugging I can
perform to see which part of the code fails here.

Kernel is final 2.6.14, with iptables-1.3.3.

Regards,
Sadin Nurkic
