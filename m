From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: /etc/sysconfig/iptables format
Date: Sun, 24 Nov 2002 21:06:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200211242106.53340.bdschuym@pandora.be>
References: <Pine.LNX.4.44.0211241130360.17298-100000@azalea.cs.jmu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Arch Harris <netfilter02@jah.cs.jmu.edu>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0211241130360.17298-100000@azalea.cs.jmu.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sunday 24 November 2002 18:14, Arch Harris wrote:
> On Sun, 24 Nov 2002, Bart De Schuymer wrote:
> ( I wasn't sure to do a list reply or just a personal reply.  When in
> doubt, pick the narrow distribution.)
>
> For perspective, I am a netfilter novice, know nothing about ebtables, =
but
> have been hacking around unix for 30 years (starting with Bell labs
> version 6 on a PDP 11).  Some of the Harris "rules" for good system
> design that pertain to this issue (there are justifications, not presen=
ted
> here, for each one).
>
> 1. All configuration files should be located somewhere in /etc.
> 2. There is a fine line between a shell file being an "executable" and
>    being a config file.  IMHO, only shell files whose main purpose
>    is to set a bunch of environment variables or aliases are "config"
>    files.
> 3. Configuration issues should be specified in what I referred to above
>    as "config" files and should not be executable.
> 4. Config files, and only config files, should be in /etc (put the
> executables like those in /etc/rc.d in /sbin).
> 5. Whenever possible, config files whould be in "text" format.  Where
>    speed or other considerations make it necessary, it may be appropria=
te
>    to have something that converts the text to a more efficient binary
>    form.  But having the parallel binary is typically not worth the ext=
ra
>    complexity and unreliablity.
> 6. Every config file in /etc should be documented in "man" section 5.
>
> For netfiltering, we are talking about a configuration issue so there
> should be a config file.  That config file should be a non-executable
> file in text format.  (The /etc/sysconfig/iptables that is part of
> the redhat distribution satisfies those criteria, except the
> documentation.)  As a user, my only concern is maintaining the config
> file.  What happens from there is an implementation detail.

I see. Well, it is perfectly possible to use as config file the command l=
ine=20
parameters, without iptables (or ebtables) in front of it and then have s=
ome=20
script read every line of that config file and execute iptables <<line>>.
Not that I'd be the one to go write that script ;)

OK, before I try to do something like Patrick Schaaf requested, there sho=
uld=20
be more input from others. Like if Harald would accept this.

--=20
cheers,
Bart
