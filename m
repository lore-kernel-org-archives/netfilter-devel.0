From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] NAT for unreplied connections
Date: Wed, 5 Jun 2002 08:26:31 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206050826.31479@henrik.marasystems.com>
References: <3CFC7DCA.9030801@snapgear.com> <200206041501.06434.hno@marasystems.com> <3CFD67F7.5000801@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Philip Craig <philipc@snapgear.com>,
	netfilter-devel@lists.samba.org
In-Reply-To: <3CFD67F7.5000801@snapgear.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 05 June 2002 03:23, Philip Craig wrote:

> A solution might be to add a MASQUERADE rule for the slip
> interface, and bring the slip down once I know the ppp is up.  So
> in general I need to ensure that there is always MASQUERADE rule
> for the current route that an outgoing packet will take, and to
> bring the old interface down if there is a route change. This is
> still kind of a workaround for the problem, but if it works then I
> think that's good enough.

It should be sufficient to just have some MASQUERADE rule anywhere I 
think. MASQUERADE does not seem to care what rules you have installed 
when reacting on interface changes.. It will simply react on any 
interface being brought down or ip address deleteions.

What you need to make sure to make it work is that the SLIP interface 
is brought down or at least that there is an ip address deleted from 
the interface SLIP interface... i.e. the following should do in the 
ppp-up script even if you like to keep the slip interface around:

  ip addr add 1.1.1.1/32 dev slip0
  ip addr del 1.1.1.1/32 dev slip0

> I'd thought at first that this wouldn't be too much of a problem
> for TCP... it would just look to the server like two separate
> connections were being initiated, and the first one would never be
> established.  I agree that it's not very good behavior though.

The problem is that your approach may cause this kind of problem at 
any time if there is more than one computer involved (including the 
NAT gateway itself), not only when there is interface changes.

  Computer A is in contact server X on port 80, using port 1234 as 
source port.
  Computer B tries to contact server X on port 80, also using port 
1234 as source port.
  Server X is slow in responding, causing retransmissions

  B sends SYN, NAT assigns it port 5678 as 1234 is occupied.
  B retransmits, NAT reassigns B to port 4325 as 1234 is still 
occupied and there has been other changes in current port usage 
between the two SYN packets from B..

And this is only one case. There is more.

Regards
Henrik
