From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: src/dest wilcard matching
Date: Thu, 16 Sep 2004 10:01:53 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1095343313.2064.46.camel@localhost>
References: <54512.139.76.128.1.1095257166.squirrel@www.the-links.net>
	<200409161256.23156.apw@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, zack@the-links.net
In-Reply-To: <200409161256.23156.apw@shadowen.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2004-09-16 at 07:56, Andy Whitcroft wrote:
> On Wednesday 15 September 2004 15:06, Zachary Link wrote:
> > I am looking for the ability to use wilcards or regexp type matching for
> > source and destination fields.  Maybe this could be an extension or
> > something...
> >
> > For example
> > --source 172.*.*.1
> > or
> > --destination 10.[1-10].[10|20].1
> >
> > Picture, if you will, a situation where you had 1,000 offices all on
> > 10.x.y.0/24 networks.  All routers might be 10.x.y.1.  You might want to
> > give your network guys access to just those devices, and sysadmins access
> > to all servers at 10.x.y.10-19 or any other types of devices sitting on
> > these networks.
> >
> > So, the biggest hurdle I need to overcome is to allow arbitrary middle
> > octets while matching 1st and last octet.  I was looking through the docs
> > and I found that something like this could be done with the u32 extensions
> > (I think), but it would be very cumbersome, and not easy to use.  I also
> > took a look at the code and realized there is no way to do it myself as I
> > have no real knowledge of C (I'll look like an idiot here if that's not C
> > ;-).
> >
> > So, am I missing some existing functionality that would allow for that?
> > Or, does anyone have any desire to develop that sort of feature?
> 
> Well some of this is pretty easy.  The -s and -d matches are actually in the 
> form of an address and mask, the normal form is 1.2.3.4/N to match the left N 
> bits, but there is also a 1.2.3.4/255.0.0.255 form of the mask.  You could 
> use this for some of your stuff definatly.
> 
> iptables -A FORWARD -d 10.0.0.1/255.0.0.255 -j ACCEPT
> 
> If the ranges you have picked in each subnet are not simply maskable, ie say 
> 16-32 not 10-20 then you could use a user chain for that.  Something like the 
> following, untested but modelled on something which works. 
> 
> iptables -N adminguy
> iptables -A adminguy -d 10.0.0.10/255.0.0.255 -j ACCEPT
> [...]
> iptables -A adminguy -d 10.0.0.19/255.0.0.255 -j ACCEPT
> 
> iptables -N networkguy
> iptables -A networkguy -d 10.0.0.1/255.0.0.255 -j ACCEPT
> 
> Obviously you could then use source checks to pick in the original 
> selector ...
> 
> iptables -A FORWARD -s 1.2.3.0/24 -j networkguys
> iptables -A FORWARD -s 1.2.4.0/24 -j adminguy
> 
> -apw
The ISCS (http://iscs.sourceforge.net) approach is another option.  It
was designed exactly for these kinds of complex configurations without
having to go through all the creative but hard work you describe.  In
our situation, it might be 1000 offices from different clients with our
support staff in one client's office needing to access resources in
another client's office - and all without a lawsuit.

The advantage here of ISCS is that it will work on random address and on
a best match basis.  In other words, if someone outside of your control
violates your addressing scheme or the addressing scheme is not possible
in some oddball office, you can create any combination of addresses and
ports and group them into a Resource group.  Then grant the network
admins access to the routers, the Windows admins access to the Windows
boxes, the UNIX admins access to the UNIX devices, etc.

Best Match means you can get by with far fewer policies and not worry
about rule order.  In other words, you can grant your Help Desk access
to ping and VNC for every device on the 10.0.0.0/8 network but as soon
as you define a specific server on 10.1.1.6, they will no longer have
access to it unless you specifically grant it.

Even better, if your admins connect via VPN from home, they can preserve
their access with the same sophisticated restrictions through the entire
WAN based upon their ID without having to connect to each gateway or
obtain an internal IP address (we hate basing remote access security on
IP address :-)  ).

The details are in the various links on the web site.  Hope this helps.
-- 
John A. Sullivan III
Open Source Development Corporation
Financially sustainable open source development
http://www.opensourcedevel.com
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
