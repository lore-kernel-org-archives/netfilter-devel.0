From: "Sreenivasa Poleboyina" <smurthy@vet.ksu.edu>
Subject: A Newb
Date: Wed, 24 Sep 2003 00:02:16 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000c01c38259$064f0cd0$03fea8c0@SMURTHY>
References: <20030924042855.16435.80088.Mailman@netfilter-sponsored-by.noris.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello All,
Am new to this group and I want to be part of the development. Any place to
start ?
Sorry for such a newb mail.
Any suggestions appreciated.
Sreenivasa

----- Original Message ----- 
From: <netfilter-devel-request@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Sent: Tuesday, September 23, 2003 11:28 PM
Subject: netfilter-devel digest, Vol 1 #661 - 8 msgs


> Send netfilter-devel mailing list submissions to
> netfilter-devel@lists.netfilter.org
>
> To subscribe or unsubscribe via the World Wide Web, visit
> https://lists.netfilter.org/mailman/listinfo/netfilter-devel
> or, via email, send a message with subject or body 'help' to
> netfilter-devel-request@lists.netfilter.org
>
> You can reach the person managing the list at
> netfilter-devel-admin@lists.netfilter.org
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of netfilter-devel digest..."
>
>
> Today's Topics:
>
>    1. Re: New Version (1.13) of PPTP conntrack/nat helper (Harald Welte)
>    2. [PATCH]: Don't call ip_conntrack_put with ip_conntrack_lock held
(Patrick McHardy)
>    3. A humble proposal (Daniel Chemko)
>    4. Re: New Version (1.13) of PPTP conntrack/nat helper (Wim Ceulemans)
>    5. Re: [PATCH 2.4] fix ipt_REJECT when used in OUTPUT (David S. Miller)
>    6. using libipq to create a router (Eduardo Costa)
>    7. Re: using libipq to create a router (Henrik Nordstrom)
>    8. Re: using libipq to create a router (Eduardo Costa)
>
> --__--__--
>
> Message: 1
> Date: Tue, 23 Sep 2003 16:49:24 +0200
> From: Harald Welte <laforge@netfilter.org>
> To: Wim Ceulemans <wim.ceulemans@able.be>
> Cc: Netfilter Development Mailinglist
<netfilter-devel@lists.netfilter.org>,
> Netfilter Mailinglist <netfilter@lists.netfilter.org>
> Subject: Re: New Version (1.13) of PPTP conntrack/nat helper
>
>
> --Gs9iBZf6UKWgztis
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> Content-Transfer-Encoding: quoted-printable
>
> On Tue, Sep 23, 2003 at 03:38:15PM +0200, Wim Ceulemans wrote:
> > Hi Harald
> >=20
> > Thanks for the patch.
> >=20
> > I tried patch-o-matic-20030922 with kernel 2.4.22 and connection to the=
> =20
> > PPTP server seems to work reliable now. Before this patch, connecting=20
> > from a winxp machine did  succeed one out of 2 times, now it always=20
> > succeeds.
> >=20
> > However, I also tried forwarding port 1723 and gre to a pptp server=20
> > (win2000) behind the firewall. And there seems to be a problem with=20
> > forwarding of the gre protocol. The connection to port 1723 behind
the=20
> > firewall succeeeds, but I don't see gre packets pass the firewall. I=20
> > added these rules:
> >=20
> > iptables -t nat -A  PREROUTING -p TCP -d <wanip> --dport 1723 -j DNAT=20
> > --to <winip>:1723
> > iptables -t nat -A  PREROUTING -p GRE -d <wanip> -j DNAT --to <winip>
>
> This is _not_ how it works.  Please just DNAT the 1723/tcp connection.
> The gre connection is DNAT'ed accordingly (just like with any other nat
> helper).  so please skip the second rule
>
> > iptables -A FORWARD -p TCP -d <winip> --dport 1723 -j ACCEPT
> > iptables -A FORWARD -p GRE -d <winip> -j ACCEPT
>
> Those are not stateful rules.  You should make sure that you only
accept=20
> ESTABLISHED and RELATED gre.  Otherwise weird problems might occur.
>
> If it still doesn't work, please check if you have enabled
> CONFIG_IP_NF_NAT_LOCAL or not.  (try it with and without).
>
> If it still doesn't work, please enable debugging (set the '#if 0' to
> '#if 1' in ip_conntrack_pptp.c and ip_nat_pptp.c, ignore the compiler
> warnings and send me the syslog excerpt of _one_ failing session.
>
> > Regards
> > Wim
>
> --=20
> - Harald Welte <laforge@netfilter.org>
http://www.netfilter.org/
>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
> =3D
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
>
> --Gs9iBZf6UKWgztis
> Content-Type: application/pgp-signature
> Content-Disposition: inline
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.2 (GNU/Linux)
>
> iD8DBQE/cF10XaXGVTD0i/8RAm0iAJ9cx/hhhY/uSXBafnurDlP9doI/zACdGF0M
> iLMkJrNCFyd4mwdPiRWSOEo=
> =I5MG
> -----END PGP SIGNATURE-----
>
> --Gs9iBZf6UKWgztis--
>
>
> --__--__--
>
> Message: 2
> Date: Tue, 23 Sep 2003 17:54:41 +0200
> From: Patrick McHardy <kaber@trash.net>
> To: Harald Welte <laforge@netfilter.org>
> CC: Netfilter Development Mailinglist
<netfilter-devel@lists.netfilter.org>
> Subject: [PATCH]: Don't call ip_conntrack_put with ip_conntrack_lock held
>
> This is a multi-part message in MIME format.
> --------------020208090104070402030009
> Content-Type: text/plain; charset=us-ascii; format=flowed
> Content-Transfer-Encoding: 7bit
>
> This patch changes destroy_conntrack so ip_conntrack_put for the master
> conntrack
> is called without the ip_conntrack_lock held. There is currently no
> situation in which
> destroy_conntrack could be called with a conntrack that has a master
> with a refcount
> of 1 so it is not a problem now (at least I couldn't spot one) but it
> seems right anyway.
>
> Best regards,
> Patrick
>
>
> --------------020208090104070402030009
> Content-Type: text/plain;
>  name="2.4-destroy-conntrack.diff"
> Content-Transfer-Encoding: 7bit
> Content-Disposition: inline;
>  filename="2.4-destroy-conntrack.diff"
>
> # This is a BitKeeper generated patch for the following project:
> # Project Name: Linux kernel tree
> # This patch format is intended for GNU patch command version 2.5 or
higher.
> # This patch includes the following deltas:
> #            ChangeSet 1.1136  -> 1.1137
> # net/ipv4/netfilter/ip_conntrack_core.c 1.26    -> 1.27
> #
> # The following is the BitKeeper ChangeSet Log
> # --------------------------------------------
> # 03/09/23 kaber@trash.net 1.1137
> # [NETFILTER]: Don't call ip_conntrack_put with ip_conntrack_lock held
> # --------------------------------------------
> #
> diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c
b/net/ipv4/netfilter/ip_conntrack_core.c
> --- a/net/ipv4/netfilter/ip_conntrack_core.c Tue Sep 23 17:35:29 2003
> +++ b/net/ipv4/netfilter/ip_conntrack_core.c Tue Sep 23 17:35:29 2003
> @@ -308,7 +308,7 @@
>  static void
>  destroy_conntrack(struct nf_conntrack *nfct)
>  {
> - struct ip_conntrack *ct = (struct ip_conntrack *)nfct;
> + struct ip_conntrack *ct = (struct ip_conntrack *)nfct, *master = NULL;
>   struct ip_conntrack_protocol *proto;
>
>   DEBUGP("destroy_conntrack(%p)\n", ct);
> @@ -335,11 +335,14 @@
>   /* can't call __unexpect_related here,
>   * since it would screw up expect_list */
>   list_del(&ct->master->expected_list);
> - ip_conntrack_put(ct->master->expectant);
> + master = ct->master->expectant;
>   }
>   kfree(ct->master);
>   }
>   WRITE_UNLOCK(&ip_conntrack_lock);
> +
> + if (master)
> + ip_conntrack_put(master);
>
>   DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
>   kmem_cache_free(ip_conntrack_cachep, ct);
>
> --------------020208090104070402030009--
>
>
>
> --__--__--
>
> Message: 3
> Subject: A humble proposal
> Date: Tue, 23 Sep 2003 09:13:21 -0700
> From: "Daniel Chemko" <dchemko@smgtec.com>
> To: <netfilter@lists.netfilter.org>,
> <netfilter-devel@lists.netfilter.org>
>
> I have been researching some possible extensions to the Netfilter
> environment, and something has become very necessary for my current
> environment. The following proposal outlines what I wish to implement. I
> am wondering if anyone would find value in this. Plus, I look forward to
> feedback so that I may improve my ideas.
>
>
> Problem:
>
> When you need to have internet services open to the internet, some of
> them are inherently insecure, such as FTP, SMB, etc. Even if the
> protocols have built in encryption, there is still a chance that the
> protocol can be compromised.
>
> Also, I have a VPN connection into my internal network. I want anyone
> connecting to be forced to authenticate to access mission-critical
> components of the system, keeping them safe unless the user themselves
> need to do emergency work on these servers.
>
> Related:
>
> While looking into PAM support for various Hardware Tokens, I can
> across, pam_iptables. This allows one to login to a SSH, Telnet, or
> whatever PAM supported daemon is installed with the module. Once
> authenticated, the user has full TCP/IP access to the machine. Once the
> SSH session has been closed, so does the iptables rule for access to the
> system.
>
> Suggestion:
>
> I would like to take pam_iptables and expand it beyond its simple
> structure. Features will include:
>
> - Getting rid of the requirement to keep SSH open the whole time
> - Create a daemon that keeps track of the sessions, instead of worrying
> about the lifetime of the PAM session
> - Allow iptables or any command to be executed once successful
> authentication has occurred
> - Customize the executed commands based on user/groups to give more fine
> grained control over who has what protocol access
> - Ability to expire sessions based on:
> - Upload/Download Quotas
> - Time in the system
> - Time idling on all services
> - Line Hang-up (VPN disconnect)
> - Other events that I can't think up on the spot
>
> Since PAM returns the originating IP address of the request, most of the
> rule functionality can be used to discriminate on a host level. I don't
> think many people would have a problem with this. The only side effect
> here is that a user behind a NAT'd network accessing the system opens
> the services to everyone behind that host. This is unavoidable.
>
> I have seen some of this functionality in Checkpoint, and I think that
> it would be immensely useful in the iptables community if it is adopted.
>
>
>
> --__--__--
>
> Message: 4
> Date: Tue, 23 Sep 2003 18:25:40 +0200
> From: Wim Ceulemans <wim.ceulemans@able.be>
> To: Harald Welte <laforge@netfilter.org>
> CC: Netfilter Development Mailinglist
<netfilter-devel@lists.netfilter.org>,
>    Netfilter Mailinglist <netfilter@lists.netfilter.org>
> Subject: Re: New Version (1.13) of PPTP conntrack/nat helper
>
> This is a multi-part message in MIME format...
>
> ------------=_1064334337-13531-58
> Content-Type: text/plain; charset=us-ascii; format=flowed
> Content-Transfer-Encoding: 7bit
> Content-Disposition: inline
>
> Harald
>
> I now just dnatted the 1723/tcp connection.
>
> If I switch CONFIG_IP_NF_NAT_LOCAL off, the forwarding to a pptp server
> behind the firewall works.
> If switch it on, I don't see any gre packet behind the firewall, so it
> does not work.
>
> However, with CONFIG_IP_NF_NAT_LOCAL on I have had two freezes (firewall
> completely stuck and I had to switch it on and off).
>
> Regards
> Wim
>
> Harald Welte wrote:
>
> >On Tue, Sep 23, 2003 at 03:38:15PM +0200, Wim Ceulemans wrote:
> >
> >
> >>Hi Harald
> >>
> >>Thanks for the patch.
> >>
> >>I tried patch-o-matic-20030922 with kernel 2.4.22 and connection to the
> >>PPTP server seems to work reliable now. Before this patch, connecting
> >>from a winxp machine did  succeed one out of 2 times, now it always
> >>succeeds.
> >>
> >>However, I also tried forwarding port 1723 and gre to a pptp server
> >>(win2000) behind the firewall. And there seems to be a problem with
> >>forwarding of the gre protocol. The connection to port 1723 behind the
> >>firewall succeeeds, but I don't see gre packets pass the firewall. I
> >>added these rules:
> >>
> >>iptables -t nat -A  PREROUTING -p TCP -d <wanip> --dport 1723 -j DNAT
> >>--to <winip>:1723
> >>iptables -t nat -A  PREROUTING -p GRE -d <wanip> -j DNAT --to <winip>
> >>
> >>
> >
> >This is _not_ how it works.  Please just DNAT the 1723/tcp connection.
> >The gre connection is DNAT'ed accordingly (just like with any other nat
> >helper).  so please skip the second rule
> >
> >
> >
> >>iptables -A FORWARD -p TCP -d <winip> --dport 1723 -j ACCEPT
> >>iptables -A FORWARD -p GRE -d <winip> -j ACCEPT
> >>
> >>
> >
> >Those are not stateful rules.  You should make sure that you only accept
> >ESTABLISHED and RELATED gre.  Otherwise weird problems might occur.
> >
> >If it still doesn't work, please check if you have enabled
> >CONFIG_IP_NF_NAT_LOCAL or not.  (try it with and without).
> >
> >If it still doesn't work, please enable debugging (set the '#if 0' to
> >'#if 1' in ip_conntrack_pptp.c and ip_nat_pptp.c, ignore the compiler
> >warnings and send me the syslog excerpt of _one_ failing session.
> >
> >
> >
> >>Regards
> >>Wim
> >>
> >>
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
> ------------=_1064334337-13531-58--
>
>
> --__--__--
>
> Message: 5
> Date: Tue, 23 Sep 2003 12:43:48 -0700
> From: "David S. Miller" <davem@redhat.com>
> To: Harald Welte <laforge@netfilter.org>
> Cc: diadon@isfera.ru, netfilter-devel@lists.netfilter.org,
>         linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2.4] fix ipt_REJECT when used in OUTPUT
>
> On Mon, 22 Sep 2003 14:21:59 +0200
> Harald Welte <laforge@netfilter.org> wrote:
>
> > On Mon, Sep 22, 2003 at 02:02:05AM -0700, David S. Miller wrote:
> >
> > > Already pushed to Marcelo, just send me the fix I should apply
> > > on top once you have this issue solved.
> >
> > Ok, here goes the (confirmed to be working) fix. TIA.
>
> Applied, thanks.
>
>
> --__--__--
>
> Message: 6
> Date: Tue, 23 Sep 2003 22:25:10 +0000
> From: Eduardo Costa <ecosta@tpk.com.br>
> To: netfilter-devel@lists.netfilter.org
> Subject: using libipq to create a router
>
> Hi, there !
>
> I want to create a little program to route connections with libipq and
> nat table.
>
> Something like that: client connects with master server, but it will
> only route this connection to another computer.
>
> Pretty simple, but I need this info to create something bigger. I tried
> to change the IP header packet, but somehow it only worked with ICMP. I
> guess it's a problem with nat/conntrack, but there's no example mixing
> conntrack and libipq.
>
> BTW, I don't want to make a kernel module and a libipt_XXX.so, because I
> think it's a solution bigger than the problem.
>
> Thanks in advance,
> Eduardo Costa
>
>
>
> --__--__--
>
> Message: 7
> Date: Wed, 24 Sep 2003 03:36:40 +0200 (CEST)
> From: Henrik Nordstrom <hno@marasystems.com>
> To: Eduardo Costa <ecosta@tpk.com.br>
> cc: netfilter-devel@lists.netfilter.org
> Subject: Re: using libipq to create a router
>
> On Tue, 23 Sep 2003, Eduardo Costa wrote:
>
> > Pretty simple, but I need this info to create something bigger. I tried
> > to change the IP header packet, but somehow it only worked with ICMP. I
> > guess it's a problem with nat/conntrack, but there's no example mixing
> > conntrack and libipq.
>
> You can't NAT non-trivial protocols via libipq unless you are implementing
> the full conntrack+nat in your application and not using the kernel
> conntrack/nat support at all (must not be loaded into the kernel). Any NAT
> done via libipq does not play well together with conntrack and the
> iptables nat engine is completely unaware of your packet modifications.
>
> For NAT together with iptables conntrack/nat you really need to use kernel
> modules in the nat iptable.
>
> Regards
> Henrik
>
>
>
> --__--__--
>
> Message: 8
> Date: Tue, 23 Sep 2003 22:45:54 +0000
> From: Eduardo Costa <ecosta@tpk.com.br>
> To: Henrik Nordstrom <hno@marasystems.com>
> Cc: netfilter-devel@lists.netfilter.org
> Subject: Re: using libipq to create a router
>
> So, what happens if I want to NAT a trivial protocol, like HTTP ?
>
> BTW, is there any "hello world" example for conntrack ? I've played
> creating kernel modules pretty easy, but the documentation about
> creating new routing nat targets are poor. The only good examples are
> 'masquerade' and 'redirect', but they lack comments.
>
> Thanks,
> Eduardo Costa
>
> Henrik Nordstrom wrote:
>
> >You can't NAT non-trivial protocols via libipq unless you are
implementing
> >the full conntrack+nat in your application and not using the kernel
> >conntrack/nat support at all (must not be loaded into the kernel). Any
NAT
> >done via libipq does not play well together with conntrack and the
> >iptables nat engine is completely unaware of your packet modifications.
> >
> >For NAT together with iptables conntrack/nat you really need to use
kernel
> >modules in the nat iptable.
> >
> >Regards
> >Henrik
> >
> >
> >
> >
> >
>
>
>
>
>
> --__--__--
>
> _______________________________________________
> netfilter-devel mailing list
> netfilter-devel@lists.netfilter.org
> https://lists.netfilter.org/mailman/listinfo/netfilter-devel
>
>
> End of netfilter-devel Digest
