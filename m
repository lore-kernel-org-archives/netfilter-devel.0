From: "Glover George" <dime@gulfsales.com>
Subject: RE: MSN Messenger ALG
Date: Fri, 28 Jun 2002 12:40:38 -0500
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <001301c21eca$edb3b600$7200a8c0@blue>
References: <20020628170403.GB11348@pc.ilinx>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "'Brian J. Murrell'" <80b664d7b3eb11641a57346257febc3d@interlinx.bc.ca>,
	<netfilter-devel@lists.samba.org>
In-Reply-To: <20020628170403.GB11348@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> On Fri, Jun 28, 2002 at 08:46:57AM -0500, Glover George wrote:
> >
> > UPnP is finishing up a security mechanism to add on to the UPnP spec
for
> > version 1.0,
> 
> Any pointers to these mechanisms?  I can't think of anything that
> would work, in real life.  The issue is who can a UPnP gateway trust?
> In the definition of "who" is "who is running the app?", as well as
> "what is the app?" among other quesitons.

The only pointers I can give is if you can't trust the apps on the
system, the just hold off on making it work for a business like
environment, or somewhere where you're really worried about it.  It
works great for home networks, which for the moment is all it should be
intended for.  I make no claims that someone should use this in a
productive environment where security is at the utmost concern.

That said, I am planning on adding some port/ip verifications, but
that's not the best solution.  The best solution is to wait for the
security aspects of UPnP to be implemented in the spec, and then for
Microsoft to catch up (which as we've seen with the file transfer option
in Messenger, has taken them ridiculously far too long  - since 4.0 to
now, it's still not fixed).

Maybe I should start prefixing these emails out with, if this is for a
home network, but be sure to read the SECURITY doc included in the
distribution.


> 
> It seems that everybody wants this UPnP gateway for MSN Messenger, but
> in my security policy, MS applications are automaticlly excluded from
> using the UPnP gateway due to MS's constant obvious disregard for
> security in favour of doing whatever they need to to make things work.
> 
> > and version 2.0 of UPnP is not far off, so security
> > mechanisms are being put in place.
> 
> Again, anything I can read?
>

It takes Microsoft years to do anything, as well as process my
application to the UPnP members forums.  I'm in contact with the guys at
Thomson Multimedia (formerly owned by Alcatel) who does the modems and
routers, who is currently a member, and he has notified me of it.  Trust
me, I'm taking this up as a college research project (UPnP on linux) and
it won't just go away.  We'll be including Linux's 2 cents in there, for
whatever good it will do.

 
> > But for the moment, AS WITH
> > ANYTHING, if you take proper precautions to ensure that your rules
in
> > iptables will prevent any untrusted machines
> 
> Machines is not so much the issue as apps on those machines.  I am not
> giving an MS machine access to the gateway because there is a trusted
> app on it that wants to use the gateway when there are also untrusted
> apps on the same machine or easily installable on the same machine.
> 
> Security for a UPnP gateway needs to be more fine grained than just
> trusting machines.
> 

I agree.  Some form of authentication between the apps and the gateway.

> > from access UPnP gateway in
> > the first place, then you don't have these problems.  Sure an app
could
> > request it, but so what?  An app could fake itself into being h.323
as
> > well.
> 
> Right.  It is this faking that needs to be addressed.  How do I
> know that an app that is claiming to be "trusted app foo" really is
> foo.
> 
