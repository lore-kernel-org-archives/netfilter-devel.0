From: "zeinali" <zeinali@iomco.com>
Subject: RE: netfilter-devel digest, Vol 1 #309 - 6 msgs
Date: Sun, 2 Feb 2003 08:06:00 +0330
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000901c2ca74$962c54e0$190da8c0@iomco.com>
References: <20030201232700.1610.36555.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20030201232700.1610.36555.Mailman@kashyyyk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

help

Many Thanks & Best Regards
         Behnam Zeinali
      www.maadiran.com



-----Original Message-----
From: netfilter-devel-admin@lists.netfilter.org
[mailto:netfilter-devel-admin@lists.netfilter.org] On Behalf Of
netfilter-devel-request@lists.netfilter.org
Sent: 2003/02/02 02:57 ?.?
To: netfilter-devel@lists.netfilter.org
Subject: netfilter-devel digest, Vol 1 #309 - 6 msgs


Send netfilter-devel mailing list submissions to
	netfilter-devel@lists.netfilter.org

To subscribe or unsubscribe via the World Wide Web, visit
	https://lists.netfilter.org/mailman/listinfo/netfilter-devel
or, via email, send a message with subject or body 'help' to
	netfilter-devel-request@lists.netfilter.org

You can reach the person managing the list at
	netfilter-devel-admin@lists.netfilter.org

When replying, please edit your Subject line so it is more specific than
"Re: Contents of netfilter-devel digest..."


Today's Topics:

   1. Re: iptables u32 match patch-o-matic (attempt) (Laszlo Valko)
   2. Re: conntrack hash function comparison (Don Cohen)
   3. Re: conntrack hash function comparison (Patrick Schaaf)
   4. Re: conntrack hash function comparison (Don Cohen)
   5. Re: conntrack hash function comparison (Harald Welte)
   6. Re: conntrack hash function comparison (Don Cohen)

--__--__--

Message: 1
Date: Sat, 1 Feb 2003 01:23:05 +0100
From: Laszlo Valko <valko@linux.karinthy.hu>
To: Harald Welte <laforge@gnumonks.org>
Cc: Don Cohen <don-netf@isis.cs3-inc.com>,
netfilter-devel@lists.netfilter.org
Subject: Re: iptables u32 match patch-o-matic (attempt)

On Fri, Jan 31, 2003 at 11:16:45AM +0100, Harald Welte wrote:
> On Wed, Jan 29, 2003 at 07:28:57AM -0800, Don Cohen wrote:
> I also disagree with Laszlo. We don't need cross-architecture 
> compatibility of those structures anyway.
> 
> >  > > +struct ipt_u32_test
> >  > > +{
> >  > > +	u_int8_t nnums;
> >  > > +	struct ipt_u32_location_element location[U32MAXSIZE+1];
> >  > > +	u_int8_t nvalues;
> >  > > +	struct ipt_u32_value_element value[U32MAXSIZE+1];
> >  > > +};
> > 
> > In this one case at least it might help to put the two 8's together,

> > right?
> 
> yes, it should. depending on compiler and archtiecture, though.

Ok, but please understand that gcc will not do any packing on x86 or any
RISC platforms by default. And since this is part of the platform ABI,
the default behaviour is a fairly stable thing. This boils down to
saying that whatever you use (u_int8_t or u_int32_t), it will not
matter, the compiler will generate the same structure for all major
platforms of Linux (x86, alpha, sparc for sure).

Of course, this whole debate is akin to splitting a hair into two... :)

Regards,
Laszlo



> --
> Live long and prosper
> - Harald Welte / laforge@gnumonks.org
http://www.gnumonks.org/
>
========================================================================
====
> GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O-
M- 
> V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)




--__--__--

Message: 2
From: don-netf@isis.cs3-inc.com (Don Cohen)
Date: Fri, 31 Jan 2003 16:41:28 -0800
To: Harald Welte <laforge@gnumonks.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel@lists.netfilter.org
Subject: Re: conntrack hash function comparison

Harald Welte writes:
 > not that I totally disagree with rehashing being a good idea... but
in
 > the case you add this 'small piece of code', you also introduce a new
 > vulnerability: If somebody can provoke the firewall to rehash all the
 > time ;(
The counter argument is that if they can do that then they have a way
of causing lots of connections to go into the same bucket, and allowing
that to happen is (at least in the extreme case) much worse than
rehashing.  Obviously it's also bad to rehash too eagerly.
I think the only question is where to put the threshold.

It's reasonable to make that threshold read/writable via /proc.


--__--__--

Message: 3
Date: Sat, 1 Feb 2003 07:57:01 +0100
From: Patrick Schaaf <bof@bof.de>
To: Don Cohen <don-netf@isis.cs3-inc.com>
Cc: Harald Welte <laforge@gnumonks.org>,
  Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
  netfilter-devel@lists.netfilter.org
Subject: Re: conntrack hash function comparison

On Fri, Jan 31, 2003 at 04:41:28PM -0800, Don Cohen wrote:
> Harald Welte writes:
>  > not that I totally disagree with rehashing being a good idea... but
in
>  > the case you add this 'small piece of code', you also introduce a
new
>  > vulnerability: If somebody can provoke the firewall to rehash all
the
>  > time ;(
> The counter argument is that if they can do that then they have a way
> of causing lots of connections to go into the same bucket, and
allowing
> that to happen is (at least in the extreme case) much worse than
> rehashing.  Obviously it's also bad to rehash too eagerly.
> I think the only question is where to put the threshold.

I imagine that instead of, or in addition to, a threshold on list
lengths, I would like to have a "minimum time between rehashings" knob,
set to e.g. one hour. That way, the cost is guaranteed independant of
packet arrival rate. And, to practically disable rehashing, that knob
can be set to an immensely large value.

Hmm. Maybe even with a printk() 10 (N) minutes in advance, telling the
admin "I think I'm going to rehash a bit, soon".

No. Forget about all that.

1) metrics in /proc, including a "max list length during the last hour"
   statistic.
2) one read/writable /proc entry, containing an integer: the number of
   hash buckets. This is missing right now, anyway (have to grep the
   boot messages). Make it writable, and rehash exactly when a write
   changes the hash bucket count.

This way, the policy (when to rehash) is safely in user space, the
kernel gives mechanism, only - just like it should.

What do you think?

best regards
  Patrick


--__--__--

Message: 4
From: don-netf@isis.cs3-inc.com (Don Cohen)
Date: Fri, 31 Jan 2003 23:58:37 -0800
To: Patrick Schaaf <bof@bof.de>
Cc: Harald Welte <laforge@gnumonks.org>,
   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel@lists.netfilter.org
Subject: Re: conntrack hash function comparison

Patrick Schaaf writes:
 > On Fri, Jan 31, 2003 at 04:41:28PM -0800, Don Cohen wrote:
 > > Harald Welte writes:
 > >  > not that I totally disagree with rehashing being a good idea...
but in
 > >  > the case you add this 'small piece of code', you also introduce
a new
 > >  > vulnerability: If somebody can provoke the firewall to rehash
all the
 > >  > time ;(
 > > The counter argument is that if they can do that then they have a
way
 > > of causing lots of connections to go into the same bucket, and
allowing
 > > that to happen is (at least in the extreme case) much worse than
 > > rehashing.  Obviously it's also bad to rehash too eagerly.
 > > I think the only question is where to put the threshold.
 > 
 > I imagine that instead of, or in addition to, a threshold on list
 > lengths, I would like to have a "minimum time between rehashings"
knob,
 > set to e.g. one hour. That way, the cost is guaranteed independant of
 > packet arrival rate. And, to practically disable rehashing, that knob
 > can be set to an immensely large value.

I don't understand the utility of such a control.
Why should you rehash if the table is doing ok?
Conversely, if it's not, why should you suffer for an hour?

 > 1) metrics in /proc, including a "max list length during the last
hour"
 >    statistic.
not very practical if you think about it
More reasonable: longest bucket length since last rehash
If you really want to take the time to look at such things, I'd suggest
a list of lengths of all buckets.

 > 2) one read/writable /proc entry, containing an integer: the number
of
 >    hash buckets. This is missing right now, anyway (have to grep the
 >    boot messages). Make it writable, and rehash exactly when a write
 >    changes the hash bucket count.
It's currently a module parameter?  Not that it would be so hard to
change it at run time, but is that really so useful?
You could unload the module and reload it with a different parameter.  
If the complaint is that you then lose the data, I suggest using the
proc file to save and restore (copy the /proc data to a real file, then
copy it back after unload/reload).  That would even let you save and 
restore over a reboot.


 > This way, the policy (when to rehash) is safely in user space, the
 > kernel gives mechanism, only - just like it should.
/proc control over the rehash threshold (max bucket size) seems like
an appropriate "control over policy".  
Whereas a user space program doing something to cause a rehash seems
to me to be a bad choice.  (For one thing, when the kernel gets into 
trouble the user space program might never have a chance to run.)


--__--__--

Message: 5
Date: Sat, 1 Feb 2003 09:37:03 +0100
From: Harald Welte <laforge@gnumonks.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
Cc: Patrick Schaaf <bof@bof.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org
Subject: Re: conntrack hash function comparison


--K6Vt3zCKtaqyTnPU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2003 at 11:58:37PM -0800, Don Cohen wrote:

> not very practical if you think about it
> More reasonable: longest bucket length since last rehash
> If you really want to take the time to look at such things, I'd
suggest
> a list of lengths of all buckets.

I think that whas what Jozsef really meant.

>  > 2) one read/writable /proc entry, containing an integer: the number
of
>  >    hash buckets. This is missing right now, anyway (have to grep
the
>  >    boot messages). Make it writable, and rehash exactly when a
write
>  >    changes the hash bucket count.
> It's currently a module parameter? =20

yes, it is. =20

> Not that it would be so hard to
> change it at run time, but is that really so useful?

Especially in the case where it is not a kernel module ;)

> You could unload the module and reload it with a different parameter.
=20
> If the complaint is that you then lose the data, I suggest using the
> proc file to save and restore (copy the /proc data to a real file,
then
> copy it back after unload/reload).  That would even let you save
and=20
> restore over a reboot.

no way. no way. no way.
sorry, but read the various discussions about the /proc/ip_conntrack
interface in general, think about all the data that is not printed (like
references to currently in-kernel packets, connection between
expectations and master connection, ...  lots of those issues are
relevant for conntrack failover as well.  This is only viable via
ctnetlink, which is not part of the stock kernel yet.

>  > This way, the policy (when to rehash) is safely in user space, the
>  > kernel gives mechanism, only - just like it should.
> /proc control over the rehash threshold (max bucket size) seems like
> an appropriate "control over policy". =20
> Whereas a user space program doing something to cause a rehash seems
> to me to be a bad choice.  (For one thing, when the kernel gets
into=20
> trouble the user space program might never have a chance to run.)

yes, I agree.  and that's why i like the idea of a 'min rehash interval'
proc parameter.  If you set this to '0', kernel will rehash never.  '1'
means maximum of one rehash per second, ...

--=20
- Harald Welte / laforge@gnumonks.org
http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so
long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--K6Vt3zCKtaqyTnPU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+O4cvXaXGVTD0i/8RAhvxAJoCl7Sdjn0Ow14tP+wpRbaeR3FL5wCgipnO
wOOtExlsljk8DjVj9J7xQW4=
=JxKS
-----END PGP SIGNATURE-----

--K6Vt3zCKtaqyTnPU--


--__--__--

Message: 6
From: don-netf@isis.cs3-inc.com (Don Cohen)
Date: Sat, 1 Feb 2003 11:05:54 -0800
To: Harald Welte <laforge@gnumonks.org>
Cc: Patrick Schaaf <bof@bof.de>, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu>,
   netfilter-devel@lists.netfilter.org
Subject: Re: conntrack hash function comparison

Harald Welte writes:

 > > Not that it would be so hard to change [hash table size]
     at run time, but is that really so useful?
 > Especially in the case where it is not a kernel module ;)

Well, then you need a way to initialize it.  Is there a standard
solution to this problem?  Or is the inability to choose such values
just the penalty you pay for choosing Y instead of M?

 > > You could unload the module and reload it with a different
parameter.  
 > > If the complaint is that you then lose the data, I suggest using
the
 > > proc file to save and restore (copy the /proc data to a real file,
then
 > > copy it back after unload/reload).  That would even let you save
and 
 > > restore over a reboot.
 > 
 > no way. no way. no way.
 > sorry, but read the various discussions about the /proc/ip_conntrack
 > interface in general, think about all the data that is not printed
(like
 > references to currently in-kernel packets, connection between
 > expectations and master connection, ...  lots of those issues are
 > relevant for conntrack failover as well.  This is only viable via
 > ctnetlink, which is not part of the stock kernel yet.

This was meant as a general suggestion, not specific to conntrack.

I don't know all the details specific to conntrack.  It seems
surprising that you couldn't save all relevant state via /proc.
Even more so if you think you could do it with netlink.
The stuff above suggests that you're worried about highly volatile
state, but the suggestion is meant only for "stable" states.  
It makes sense to remember connections across a reboot (if it doesn't 
take too long), not packets.  You'd have to effectively disable
networking (so there are no packets to save) before saving state.  

I plan to try it for my module that does conntrack-like things.

 > >  > This way, the policy (when to rehash) is safely in user space,
the
 > >  > kernel gives mechanism, only - just like it should.
 > > /proc control over the rehash threshold (max bucket size) seems
like
 > > an appropriate "control over policy".  
 > > Whereas a user space program doing something to cause a rehash
seems
 > > to me to be a bad choice.  (For one thing, when the kernel gets
into 
 > > trouble the user space program might never have a chance to run.)
 > 
 > yes, I agree.  and that's why i like the idea of a 'min rehash
interval'
 > proc parameter.  If you set this to '0', kernel will rehash never.
'1'
 > means maximum of one rehash per second, ...

I think I finally understand what this is all about.
It's not to automatically rehash after time t, but rather to 
make sure you don't spend all of your time rehashing. 
This seems reasonable.



--__--__--

_______________________________________________
netfilter-devel mailing list
netfilter-devel@lists.netfilter.org
https://lists.netfilter.org/mailman/listinfo/netfilter-devel


End of netfilter-devel Digest
