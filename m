From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Tue, 14 Jan 2003 00:53:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301140053.04301.bdschuym@pandora.be>
References: <3E1DEF2D.4080703@fugmann.dhs.org> <200301132356.32182.bdschuym@pandora.be> <3E233BE7.7010205@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
In-Reply-To: <3E233BE7.7010205@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 13 January 2003 23:21, Anders Fugmann wrote:
> I see. The question is if it is actually a problem. If the bridging cod=
e
> uses anything from ip_nat_standalone, then module count would be
> automatically incremented? This needs to be examined.

I was just giving an example... The bridge code has nothing to do with=20
iptables for this.

> > These changes should be well-thought of...
> > Also, use correct spelling and don't overcomment stuff...
>
> Overcommit? Please elaborate on that.

for example:
-                       __MOD_INC_USE_COUNT(ct_helper->me);
+                       /* Double check, but we need to know if the modul=
e=20
+                          is available */
+                       if (! try_module_get(ct_helper->me))
+                               return -EAGAIN;

Originally there was no comment here and I don't see a need to add one no=
w...

> > You seem to be adding/changing code too, f.e. in arp_tables.c:
> >
> > -           (newinfo->number > oldinfo->initial_entries))
> > -               __MOD_INC_USE_COUNT(t->me);
> > -       else if (t->me && (oldinfo->number > oldinfo->initial_entries=
) &&
> > -                (newinfo->number <=3D oldinfo->initial_entries))
> > -               __MOD_DEC_USE_COUNT(t->me);
> > +
> > +       /* Now decrement count by two if nessesary. */
> > +       if ((oldinfo->number > oldinfo->initial_entries) ||
> > +           (newinfo->number <=3D oldinfo->initial_entries))
> > +               module_put(t->me);
> > +       if ((oldinfo->number > oldinfo->initial_entries) &&
> > +           (newinfo->number <=3D oldinfo->initial_entries))
> > +               module_put(t->me);
> >
> > Is that equivalent?
>
> No. In the old code __MOD_INC_USE_COUNT would always succeed. As
> try_module_get can return an error, the module count is incremented
> before the above code in order to handle the posibility of not beeing
> able to increment the module count. The logic decrements the module
> count after the operation by one, if the number of new rules is equal t=
o
> or lower than the number of old rules, and decrement again if it's
> actually lower. So the logic is changed in order to handle possible
> errors from try_module_put. If all suceeds the module_count is set
> correctly, othervice module count is not touched at all.

Can't you just change=20

if (t->me && (oldinfo->number <=3D oldinfo->initial_entries) &&
    (newinfo->number > oldinfo->initial_entries))
=09__MOD_INC_USE_COUNT(t->me);
else if (t->me && (oldinfo->number > oldinfo->initial_entries) &&
            (newinfo->number <=3D oldinfo->initial_entries))
=09__MOD_DEC_USE_COUNT(t->me);

into

if (t->me && (oldinfo->number <=3D oldinfo->initial_entries) &&
    (newinfo->number > oldinfo->initial_entries)) {
=09if (!try_module_get(t->me)) {
=09=09ret =3D -EAGAIN;
=09=09goto free_newinfo_counters_untrans_unlock;
=09}
} else if (t->me && (oldinfo->number > oldinfo->initial_entries) &&
            (newinfo->number <=3D oldinfo->initial_entries))
=09module_put(t->me);

Try not to add new logic if it's not necessary...

--=20
cheers,
Bart
