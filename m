From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: /etc/sysconfig/iptables format
Date: Sun, 24 Nov 2002 15:14:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200211241514.21874.bdschuym@pandora.be>
References: <Pine.LNX.4.44.0211200005530.5235-100000@azalea.cs.jmu.edu> <200211241328.57401.bdschuym@pandora.be> <20021124115252.GD14672@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20021124115252.GD14672@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sunday 24 November 2002 12:52, Patrick Schaaf wrote:
> Hello Bart,
>
> > I'd like your opinion about the way ebtables makes atomically writing=
 a
> > complete table to the kernel, possible.
>
> [description of "reference file manipulation" approach to construct tab=
les]

I changed to another mail alias and forgot to subscribe with that alias t=
o=20
this list, so that's probably why my first mail hasn't arrived yet.

> I like the scheme! May I have it for iptables, too, please?

It shouldn't be too difficult. I'll try next week.

> Why do I like it? Using the reference file, permits test-construction
> of an arbitrary rule set, with full rule consistency / error checking,
> and inspection of the result, without modifying the runtime rule set
> in any way. That's a great help when extending / modifying rule sets.

Yes, what I didn't mention in the other mail is that the command --atomic=
-save=20
saves the kernel table into the file, so then you can add rules in that f=
ile=20
to eventually atomically update the kernel.

> I have a small proposal to augment the idea: as an alternative to
> specifying the reference file on the command line, could you define
> a "standard environment variable" which, when set, gives the name
> of the reference file to use? That way, one could run "rule set
> construction scripts" completely unchanged, i.e. without fiddling
> with the commandline of all the ??tables-commands in the scripts.
> Just give something different in the environment before calling
> the initial construction script.

Good suggestion, I wonder why I didn't think of that.

--=20
cheers,
Bart
