From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Mon, 13 Jan 2003 23:56:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301132356.32182.bdschuym@pandora.be>
References: <3E1DEF2D.4080703@fugmann.dhs.org> <200301122314.17191.bdschuym@pandora.be> <3E22F02E.8060800@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
In-Reply-To: <3E22F02E.8060800@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 13 January 2003 17:58, Anders Fugmann wrote:
> Take two on conversion from MOD_INC/DEC_USAGE_COUNT.
>
> This version removes all MOD_INC_USAGE_COUNT and MOD_DEC_USAGE_COUNT, a=
s
> this is done automatically by the kernel itself.
>
> Whenever a module count is incremented and error can arise if the modul=
e
> is currently beeing loaded or unloaded. I treat this error by returning
> -EAGAIN, to signal that the operation should be retried.
>
> Attached it the patch against 2.5.56. It's only for IPv4, and will awai=
t
> comment on this before convering IPv6.

I see that other files than ip_tables.c use MOD_{INC,DEC}_USE_COUNT. I ca=
n=20
only say that for ip_tables.c (and arp_tables.c I guess) these are no lon=
ger=20
needed. It could be that simply removing these from another file (like=20
ip_nat_standalone.c) could cause kernel panics. For example, the bridge c=
ode=20
uses these two macro's too and just removing them will cause a kernel pan=
ic=20
when removing a bridge device that is still used...
These changes should be well-thought of...
Also, use correct spelling and don't overcomment stuff...
You seem to be adding/changing code too, f.e. in arp_tables.c:

-           (newinfo->number > oldinfo->initial_entries))
-               __MOD_INC_USE_COUNT(t->me);
-       else if (t->me && (oldinfo->number > oldinfo->initial_entries) &&
-                (newinfo->number <=3D oldinfo->initial_entries))
-               __MOD_DEC_USE_COUNT(t->me);
+
+       /* Now decrement count by two if nessesary. */
+       if ((oldinfo->number > oldinfo->initial_entries) ||=20
+           (newinfo->number <=3D oldinfo->initial_entries))=20
+               module_put(t->me);
+       if ((oldinfo->number > oldinfo->initial_entries) &&
+           (newinfo->number <=3D oldinfo->initial_entries))
+               module_put(t->me);

Is that equivalent?

--=20
cheers,
Bart
