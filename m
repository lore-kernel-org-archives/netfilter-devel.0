From: Jeff Hall <hall@vdata.com>
Subject: Re: PPTP connection tracking and Poptop on same box
Date: Thu, 4 Sep 2003 19:57:49 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.56.0309041955470.10914@shemp.vdata.com>
References: <3F542C4E.1000307@netbox.biz> <Pine.GSO.4.56.0309031853090.10914@shemp.vdata.com>
 <3F56E2E2.5040007@netbox.biz> <Pine.GSO.4.56.0309040327250.10914@shemp.vdata.com>
 <3F572D27.3090104@able.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Menno Smits <menno@netbox.biz>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wim Ceulemans <wim.ceulemans@able.be>
In-Reply-To: <3F572D27.3090104@able.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Inactivity timeout?

On Thu, 4 Sep 2003, Wim Ceulemans wrote:

> Hi
>
> I had some problems with GRE not passing through to a server behind the
> firewall.
> I then used kernel 2.4.22 and the latest pom snapshot
> (patch-o-matic-20030831) with iptables 1.2.8
> and gre passed through.
>
> However, after testing I notice now that although PPTP connections to a
> win2000 server behind the
> firewall work, that the connection is not reliable. After 3 to 4 minutes
> the connection is closed for
> some unknown reason and people have to re-establish the connection.
>
> Anyone experiencing this problem also?
>
> Regards
> Wim
>
> Jeff Hall wrote:
>
> >  On Thu, 4 Sep 2003, Menno Smits wrote:
> >
> >  > Hi Jeff,
> >  >
> >  > Thanks for your quick reply.
> >  >
> >  > Jeff Hall wrote:
> >  > > I experienced some of these problems also trying to get 2.4.20 working
> >  > > with PoPToP and making outgoing connections from PCs behind the PoPToP
> >  > > server. Take a look at my messages dated March 2,3,20,21 and
> >  > > April 8 of this year in the netfilter-devel archives. With the patches
> >  > > in those messages I have multiple sessions connecting to a PoPToP server
> >  > > running on my firewall server and can make at least one outgoing
> >  > > connection from a PC behind that server (I didn't test making multiple
> >  > > outgoing connections but I believe that will also worked based on some
> >  > > tests I ran months ago). I also successfully tested running a PPTP client
> >  > > on the PoPToP server.
> >  >
> >  > I've read those posts before but I went over them again just to make
> >  > sure I hadn't missed anything.
> >  >
> >  > I checked the patches in your posts against a POM patched 2.4.20 kernel
> >  > I used to use here which exhibits the same problems as my 2.4.21 kernel.
> >  > I can't even find where your patches to ip_conntrack_pptp.c could be
> >  > applied! (even when trying to apply the patch manually). Key lines which
> >  > surround your changes simply don't exist in my tree. I was using POM out
> >  > of CVS from a few months ago in that kernel. What POM version are you
> >  > using? Which POM patches are you using?
> >  >
> >I started with the 20030107 POM but then added individual patches I
> >needed from the CVS archives. I tried to detail them as clearly as possible
> >in the March 2nd and 3rd memos. I'm afraid that is the best I can do now
> >after 6 months.  I'll send you the fully patched sources I'm using in a
> >personal message. I hope you find them useful. I'll send you anything
> >dated newer than when I ran the 20030107 POM against the 2.4.20 base.
> >  > I'm thinking I might try a vanilla kernel with the bare minimum of
> >  > patches to support PPTP conntrack. Knowing what POM version and patches
> >  > you're using would be useful for me so I can try and duplicate your setup.
> >  >
> >  > > I have not (at least knowingly) modified the connection MTU, MRU, or
> >  > > TCPMSS and while I occassionally get the 'out of order' messages from
> >  > > pptpd the connection seems to recover. I'm using PoPToP v 1.1.3-2 with a
> >  > > patch to generate unique call ids.
> >  >
> >  > Actually the MTU/MRU/TCPMSS stuff was to deal with "GRE: Discarding
> >  > duplicate packet" problems not 'out of order packet" problems like I
> >  > originally stated (it was a while ago). I removed these workarounds
> >  > today just to make sure that these had nothing to do with the problems
> >  > I'm having. Connection attempts seemed to behave in just the same way
> >  > (unreliably), and I started getting lots of "GRE: Discarding duplicate
> >  > packet" messages when a connection did establish and data was transferred.
> >  >
> >I consistently receive one "GRE: Discarding duplicate packet" message per
> >connection. But it never causes any problem so I've never pursued the cause.
> >I see on Sourceforge that the single message problem is due to an initial-
> >zation error in pptpgre.c (see the diff 1.4 vs 1.3). I've never had a problem
> >with multiple "duplicate..." errors. Possibly they are due to the kernel
> >delivering GRE packets to the wrong pptpd process.
> >  > Today I also made sure that the pptpd version I'm using (1.1.4) has the
> >  > callid patch and it definitely does. I modified it to log the callids
> >  > its using and it uses different ids for each connection, so no issue
> >  > there. Besides, that only becomes important once you have multiple
> >  > clients involved and so far in my testing there's only one.
> >  >
> >  >
> >  >
> >  > Menno
> >  >
> >  >
> >Good luck.
> >
> >
> >
>
>
> --
> Wim Ceulemans
> R&D Engineer
>
> Secure Internet Communication with aXs Guard
>
> Able NV
> Leuvensesteenweg 282 - B-3190 Boortmeerbeek - Belgium
> Phone: + 32 15 50.44.00 - Fax: + 32 15 50.44.09
> E-mail: wim.ceulemans@able.be
>
>
>
> --
> Security check on this e-mail has been done by aXs GUARD
> (http://www.axsguard.com)
>
>
