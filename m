From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: Made ct_sync running with 2.6.15.4...
Date: Mon, 20 Mar 2006 15:25:17 +0100
Message-ID: <20060320142517.GB11306@galois.math.uni-paderborn.de>
References: <20060311033122.GA23805@galois.math.uni-paderborn.de>
	<200603192258.27950@krak>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <200603192258.27950@krak>
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

Am Sonntag, den 19. M=E4rz hub KOVACS Krisztian folgendes in die Tasten:

Hi!

> On Saturday 11 March 2006 04:31, Maximilian Wilhelm wrote:
> > I saw that the patches and the module code were written for kernel
> > version 2.6.10 and experienced rather big trouble patching kernel
> > version 2.6.15.4 :-/

>   Sure, the linux-2.6 branch in Subversion is pretty old and largely=20
> unmaintained. The whole ct_sync project is pretty much dead.

Hmm, sad. :-(
It's a great software and working very well in my test net here.

> > The only thing I'm worrying about were many ct entries I produced by
> > nmap -sP <net behing the firewall>
> > which did not vanish after 10++ hours. I had to reboot to get rid of
> > the connections.

>   This is a known problem, at least back when I was doing some testing=20
> with ct_sync I experienced the same. Unfortunately I did not manage to=20
> find the cause of this bug...



> > What I did:

>   A few generic comments about the attached patches: don't send per-fil=
e=20
> patches. Divide your changes into logically structured patches. If it's=
=20
> not possible or not very meaningful (just as in this case) then send a=20
> single diff appliable using 'patch -p1'.

Ok, noticed :)
(This was the first time I hacked something as large as ct_sync/netfilter=
.)

>   Another thing is that you've pretty much garbled the quilt patchset. =
For=20
> example ct_notifier_pkt.patch is not necessary anymore for 2.6.14 and u=
p,=20
> so you should have removed that patch completely from the tree instead =
of=20
> just removing basically everything from that patch.=20

Ok, I did so now.
I will provide a new patch and place it at [42]=20

As I said, I'm not into the code and don't anything about earlier
changes in the netfilter code.
That's the reason I wanted someone with more knowledege to have a look
at my patches. :)

> pf_packet.patch is=20
> also similar, although it is still a bit different as it's not included=
=20
> in mainline kernel and thus a forward-port would be necessary to provid=
e=20
> the same functionality.

Any suggestions what to be done here?

> > I would like someone who knows this code better than me (Harald?) to
> > have a look at my changes and comment on it.
> > As an absolutly newbie in C and netfilter code I'm hoping I did not
> > too much bad things :)

>   No, not at all, after all it _seems_ to be working for you :)

Yes, pretty well :)

>   However, merging these changes to SVN would still need some more work=
.=20
> As the number of people working on ct_sync is very close to zero at the=
=20
> moment, I think that all effort should be concentrated on a single bran=
ch=20
> of the code. Because Harald has already put significant effort into=20
> providing support for active-active setups I think that we should try a=
nd=20
> get the linux-2.6-multigroup branch working first. Holger Eitzenberger=20
> was also doing some tests using that version and provided multiple fixe=
s=20
> for problems he had found.

>   So I don't think we should put significant amount of work into updati=
ng=20
> the old 2.6.10 branch. Instead, please give the -multigroup branch a tr=
y=20
> and provide feedback.

Ok, I will give it a try.

> Of course if you think you have the time to prepare=20
> an easily-committable patch for the linux-2.6 branch of ct_sync I'll be=
=20
> more than happy to update the SVN repository.

What has to be done to achieve an "easily-committable patch"?
If you give me some hints about which patches aren't used anymore
I will remove them

> I'm just unwilling to spend=20
> a significant amount of time updating that old branch.

Sure.

[42] http://vvv.barbarossa.name/files/ct_sync

Ciao
Max
--=20
|           |                 Follow the white penguin.
|  |\/|  |  |-----------------------------------------------------------.
|  |  |/\|  |  Rechnerbetrieb Mathematik  |   Meine Baustellen:  TSM    |
|           |  Universitaet Paderborn     |   Hostmaster, Linux, LDAP   |=
=20
