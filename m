From: Aleksandar Milivojevic <alex@milivojevic.org>
Subject: Filtering PPPoE
Date: Tue, 08 Aug 2006 10:32:45 -0500
Message-ID: <20060808103245.fen2mnkuyask004c@www.milivojevic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; DelSp=Yes; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-disposition: inline
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

I'm attempting to place transparent firewall (on a Linux host =20
configured as bridge) between ADSL modem and some servers.  The =20
servers and ADSL modem "speak" PPPoE.

Simplified diagram looks like this:

   +------+     +--------+     +---------+
   |ADSL  |     |bridge/ |     |server(s)|
   |modem |-----|firewall|-----|         |
   +------+     +--------+     +---------+

The problem I have is that Netfilter does not see PPPoE packets on the =20
bridge.  Similar thing on the server host(s), Netfilter (if server is =20
Linux host) doesn't see PPPoE, it just sees IP packets as they come =20
out of virtual PPP interface.  I can't place the firewall onto the =20
servers, and the servers must have external IP addresses assigned to =20
them.  I can't change the toplogy and move PPPoE endpoint infront of =20
the servers (and/or use NAT).

Is there any way of filtering IP traffic that is encapsulated inside =20
PPPoE on the bridge host?  I found some HOWTOs describing how to do it =20
with OpenBSD based bridge.  However, I'm unfamiliar with OpenBSD, and =20
would like to set this up using Linux solution if possible.

--=20
See Ya' later, alligator!
http://www.8-P.ca/
