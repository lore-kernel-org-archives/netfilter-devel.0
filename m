From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: iptables and external processes
Date: Tue, 17 Feb 2004 18:30:59 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077060658.2011.19.camel@ca.gts.nexusmgmt.com>
References: <Pine.LNX.4.44.0402172303080.3844-100000@filer.marasystems.com>
	 <20040217161130.K27680@tempest.prismnet.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Allen Francom <aef@prismnet.com>, Henrik Nordstrom <hno@marasystems.com>,
   netfilter-devel@lists.netfilter.org
In-Reply-To: <20040217161130.K27680@tempest.prismnet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thank you very much for such a quick response.  QUEUE may do exactly
what we need.  I have always approached iptables as a user and so have
not paid much attention to the Hacking-How-To.  That's why I'll probably
need to find someone to do this :-)

We are looking to set up a light-weight user authentication service for
wireless.  We know the Nu-FW folks have done a good job of creating a
robust user authentication service but we think that we can take some of
the practices we have learned from using the excellent Qt toolkit to
create a simple client service that will pre-authenticate to a Linux
wireless access-point.

The pre-authentication will create some custom chains ala the ISCS
paradigm.  When combined with ISCS's ability to centrally managed
complex security on thousands of iptables gateways
(http://iscs.sourceforge.net), we think we will have a very powerful
wireless solution (and another triumph for Linux/iptables :-)  ).

We already do this for users using IPSec tunnels and identified via
X.509 certificates.  The missing piece was being able to do this for
users sending packets in the clear and identified via AD, NDS, LDAP,
RADIUS and SecureID in a way that both allows NAT and prevents address
spoofing.

That's where the packet processing comes in.  We know what we have to do
to have iptables confirm that the packet is not spoofed and to track the
NAT.  We just needed to find a way to pass that decision back to
iptables to know whether to pass the packet on to the chains that were
built in the pre-authentication or to drop the packet as a spoof. 
Assuming that I have the client part and logic straight, does this seem
feasible? I take from the little I read about QUEUE that this is quite
possible.  Thanks again - John

On Tue, 2004-02-17 at 17:13, Allen Francom wrote:
> I thought it was possible to actually change the packet
> and send the packet back in again ?
> 
> Just rule processing stops once -J QUEUE happens ?
> 
> There are also some other tools like Snort and Hogwash
> and probably a few more by now that have different
> capabilities for inspecting packets.
> 
> FYI
> -AEF
> 
> On Tue, 17 Feb 2004, Henrik Nordstrom wrote:
> > On Tue, 17 Feb 2004, John A. Sullivan III wrote:
> >
> > > It would solve a very difficult problem for us if we could jump a packet
> > > to a chain based upon the decision of a process external to iptables.
> >
> > The QUEUE function is pretty similar to this. Only difference is that the
> > verdict from QUEUE is final for the hook.
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
