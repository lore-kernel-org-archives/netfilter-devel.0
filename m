From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 13:48:49 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206251336540.4927-100000@blackhole.kfki.hu>
References: <01df01c21c38$fd695440$0489cb8a@etbx180>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Don Cohen <don-nf@isis.cs3-inc.com>,
	<netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
In-Reply-To: <01df01c21c38$fd695440$0489cb8a@etbx180>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 25 Jun 2002, Jean-Michel Hemstedt wrote:

> > > not only: a crashed endpoint breaking the tcp sequence causes also
> > > garbage entries in conntrack (known issue).
> >
> > Did I miss something? What do you mean by this "known issue" above?
> > I don't understand what do you refer.
>
> I refer to "conntrack timeout too big" 22 May 2001:
>
> |> On Tue, 22 May 2001, Ramin Alidousti wrote:
> |>
> |> > Shouldn't tcp conntrack detect a RST or FIN and remove the entry?
> |> > For udp, it's more difficult/impossible.
> |>
> |> Normally yes. But for a strange reason, not all connections send a RST or
> |> FIN. Or, if they do send a RST, conntrack doesn't detect it.
> |
> |If they don't send a RST or FIN they are not closed (or only half-closed).
> |So it would be _more_ than buggy to delete them.
> |
> |And if there is a RST packet, conntrack will detect it, believe me.
> |
> |> Anyway, in good old ipchains, I had the possibility to set those timeouts
> |> with -M -S options. Even if all tcp connections would send a RST or FIN at
> |
> |yes, please go to the mailinglist archives and look for extensive discussions
> |about the timeouts.
> |
> |general conclusion: we don't want to add more buttons than needed. conntrack
> |is supposed to work, if it doesn't work, we need to fix it.
> |
> |- Harald Welte
>
> The reasonning behind conntrack (and its timeouts), is that the outside
> world is reliable... (isn't it?)
> But packet loss, power failures, sudden crashes, reboots ,and even DoS
> attacks (or P2P softwares behaving close to DoS) are common enought to
> reconsider this approach, i think.

The subject of the thread was misleading: the timeout value is actually
sometimes too small and conntrack entries expire too early (and thus
subsequent packets are not detected as belonging to an already existing
connection, NAT may fail, etc).

All your examples above - except DoS - handled pretty well by conntrack.
However, in the case of DoS, according to your proposal, conntrack
timeouts should be decreased. However that would hurt even more normal
traffic and conntrack could not function reliably.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
