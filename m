From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: Re:RPC patch creates kernel panic
Date: Fri, 02 Apr 2004 09:51:11 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404012351.i31NpBg10856@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I guess that'll make error reproduction straight forward.  I'll try and take a
look at the problem this weekend.



----- Original Message -----
>From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
>To: "Ian Latter" <Ian.Latter@mq.edu.au>
>Subject:  Re: Re:RPC patch creates kernel panic
>Date: Thu, 01 Apr 2004 17:30:06 -0500
>
> I'll have to see what I can dig up.  I recall there is a very extensive
> document on how Microsoft makes use of DCE somewhere on their public
> archives.
> 
> Regarding my kernel panics, they were all very simple; they occurred on
> boot! As soon as I remove RPC from the kernel, I can boot again - John
> 
> On Thu, 2004-04-01 at 18:34, Ian Latter wrote:
> > Hello John,
> > 
> > 
> >   Thank you for this report.
> > 
> >   The RPC conntrack helper was written to support ONC RPC - 
> > typically used on Unix hosts - where as Windows uses DCE RPC. 
> > When I last looked at that module, I tried to find technical 
> > information on the differences of the two, and was unable to 
> > find any - but had the impression from what I could find that the 
> > two weren't compatible.
> > 
> >   Whether or not the module recieves valid/invalid traffic, it shouldn't
> > crash - and I want to fix that. 
> > 
> >   However, if you have access to documentation on DCE RPC 
> > protocol/standards then please forward that/them through, as any 
> > such documentation would be useful for broadening support.
> > 
> >   On the report details; what was typically on both sides of the 
> > filtering engine (Windows 2000 Server on the server side and
> > Windows XP Pro on the client side?) and do you have any idea
> > what type of activity was performed at the time of the crash?
> > (Ie, is there any way that I can repeat the fault directly?)
> > 
> > 
> > 
> > Thanks again for your time and info, John.
> > 
> > 
> > 
> > 
> > 
> > ----- Original Message -----
> > >From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
> > >To: <netfilter-devel@lists.netfilter.org>
> > >Subject:  RPC patch creates kernel panic
> > >Date: Thu, 01 Apr 2004 16:03:11 -0500
> > >
> > > I would imagine the RPC patch developers are well aware of this but I
> > > have consistently generated kernel panics when using the RPC patch. 
> > > This was the case using RedHat with several different kernels > 2.4.18
> > > and patch-o-matic-20030107 (I believe).
> > > 
> > > I thought I would give patch-o-matic-20031219 a try on SUSE with kernel
> > > 2.4.25 from kernel.org patched with StrongSWAN 2.0.1 (FreeS/WAN
> > > successor) to see if it behaved any better.  Alas, the same problem.
> > > 
> > > We have neither the skills nor time to contribute code to this patch but
> > > it is important for us especially for our support of Microsoft shops
> > > with their pervasive use of services spawned off of the port mapper on
> > > 135/tcp.  If there is anything we can do to help outside of development
> > > such as testing, please let us know - John
> > > -- 
> > > John A. Sullivan III
> > > Chief Technology Officer
> > > Nexus Management
> > > +1 207-985-7880
> > > john.sullivan@nexusmgmt.com
> > > ---
> > > If you are interested in helping to develop a GPL enterprise class
> > > VPN/Firewall/Security device management console, please visit
> > > http://iscs.sourceforge.net
> > > 
> > > 
> > > 
> > 
> > --
> > Ian Latter
> > Internet and Networking Security Officer
> > Macquarie University
> -- 
> Open Source Development Corporation
> Financially Sustainable open source development
> http://www.opensourcedevelopmentcorp.com
> 
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
