From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Out-of-band user authentication (was A Humble Proposal)
Date: Fri, 03 Oct 2003 07:08:38 -0400
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <1065179318.1903.17.camel@jasiiitosh.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

	This is the problem that forced us to postpone out-of-band user
authentication for the ISCS project (http://iscs.sourceforge.net).  We
do exactly as Harald describes, i.e., create a VPN tunnel so that the
traffic can be associated with one and only one user even if they use
NAT-Traversal and then dynamically create rules for that user when the
tunnel is established (and destroy them when the tunnel is torn down).
	However, we really want to move to where the NuFW team is going with a
broader range of out-of-band user authentication methods.  Has anyone
investigated how the SSL VPN vendors do this? They must confront the
same issues.
	It might be a "fat" solution, i.e., the SSL client application may
intercept all the network calls to encapsulate the packet and there is a
server component to decrypt and assess the packet after it emerges
approved from the connection tracking table.  I really have no idea.
	There are also non-encrypted applications for this means of out-of-band
user authentication such as providing network level user authentication
on a private LAN or WAN, i.e., not exposed to the Internet.  Of course,
how does one turn on the authentication method for only non-Internet
traffic.
	I'd love to see these issues resolved.  Good luck to all working on
them - John

-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
---
If you are interested in helping to develop a GPL enterprise class
VPN/Firewall/Security device management console, please visit
http://iscs.sourceforge.net 

Date: Thu, 2 Oct 2003 21:51:32 +0200
From: Harald Welte <laforge@netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Subject: Re: A humble proposal

On Tue, Sep 23, 2003 at 09:13:21AM -0700, Daniel Chemko wrote:
=20
> I would like to take pam_iptables and expand it beyond its simple
> structure. Features will include:
> [...]

Feel free to implement those features.

> Since PAM returns the originating IP address of the request, most of
the
> rule functionality can be used to discriminate on a host level. I
don't
> think many people would have a problem with this. The only side effect
> here is that a user behind a NAT'd network accessing the system opens
> the services to everyone behind that host. This is unavoidable.

I personally don't believe in this kind of 'security'.  The only way to
do this in a really secure way is to open a VPN tunnel to your firewall
and do the authentication related to the VPN protocol used.   Your
firewall ruleset can then have seperate rules for packets coming from
the VPN or packets outside of the VPN sessions.
