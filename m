From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] RANGEMARK target
Date: Fri, 31 Oct 2003 15:38:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031031143849.GE21066@sunbeam.de.gnumonks.org>
References: <20030921222853.GA30961@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0310232237350.1079-100000@w-vkashyap95.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mJm6k4Vb/yFcL9ZU"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Vivek Kashyap <vivk@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0310232237350.1079-100000@w-vkashyap95.beaverton.ibm.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--mJm6k4Vb/yFcL9ZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2003 at 02:57:28PM -0800, Vivek Kashyap wrote:
> I wanted to MARK packets dynamically within a certain range.=20

Ok, thanks for this contribution.

> Please comment. I'll then update with necessary changes and also
> add ip6t_* target.=20

I'm going to comment inline.

> +struct rangemarkinfo {
> +    struct ipt_entry_target t;
> +    struct ipt_rangemark_target_info rangemark;

please adhere to the kernel CodingStyle (tabulator indent, 8char).

> +static void
> +print_rangemark(struct ipt_rangemark_target_info *r)
> +{
> +    printf("Base:   %lu %lx\n", r->base, r->base);
> +    printf("Limit:  %lu %lx\n", r->limit, r->limit);
> +    printf("rsize:  %lu %lx\n", r->rsize, r->rsize);
> +    printf("skipvalue:  %lu %lx\n", r->skip, r->skip);
> +    printf("mask:  %lu %lx\n", r->mask, r->mask);
> +    printf("policy: %d\n", r->policy);
> +    printf("op:     %d\n", r->op);
> +}

you'd have to try to be less verbose and not use newlines in the
printout.  the print() function will be called for every rule when you
do a 'iptables -L'.

> +/* Saves the union ipt_targinfo in parsable form to stdout. */
> +static void
> +save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
> +{
> +    struct ipt_rangemark_target_info *rinfo =3D
> +        (struct ipt_rangemark_target_info *)target->data;
> +
> +    print_rangemark(rinfo);
> +}

this is not correc.t  save() has to save it in exactly the same format
(i.e. gnu-longoppts like --base) so that a later call to parse() can
parse it again.

> @@ -5,7 +5,7 @@
>  # header files are present in the include/linux directory of this iptabl=
es
>  # package (HW)
>  #
> -PF_EXT_SLIB:=3Dah connlimit conntrack dscp ecn esp helper icmp iprange l=
ength limit mac mark multiport owner physdev pkttype realm rpc standard sta=
te tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK =
MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TO=
S TRACE TTL ULOG=20
> +PF_EXT_SLIB:=3Dah connlimit conntrack dscp ecn esp helper icmp iprange l=
ength limit mac mark multiport owner physdev pkttype realm rpc standard sta=
te tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK =
MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TO=
S TRACE TTL ULOG RANGEMARK
> =20

instead of adding it to the makefile, we use a conditional compile
mechanism.  Please look at the '.*-test' files in the extensions
subdirectory as an example.

> +enum rangemark_policy {
> +	RANGEMARK_POLICY_RANDOM =3D 1,
> +	RANGEMARK_POLICY_PORTHASH,
> +};

in the kernel, you really should follow linux/Documentation/CodingStyle

> +unsigned short
> +rangemark_hash(unsigned short s, unsigned short d)

please try to use architecture independent fixed-size data types.  The
kernel is compiled on various architectures, ...  so if you want an
unsigned 16bit number, please use 'u_int16_t' or __u16.

> +        case RANGEMARK_POLICY_PORTHASH:
> +            /*
> +             * Skip non IP packets=20
> +             */
> +            iptr =3D (void *)(*pskb)->nh.iph;
> +            if ((((struct iphdr *)iptr)->version !=3D 6) &&=20
> +                    (((struct iphdr *)iptr)->version !=3D 4)){
> +                return IPT_CONTINUE;

an iptables target can only be called from ip_tables.  And ip_tables is
ipv4 specific, so it's guaranteed that you only receive IPv4 packets.

> +#endif /*_IPT_RANGEMARK_H_target*/

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mJm6k4Vb/yFcL9ZU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/onP5XaXGVTD0i/8RAjQHAKCo4XjGRojc7KimEFlkWm/wPx5DbQCgqPLR
/WZCWiLhqV6BkSCBMkcEHR8=
=OQXo
-----END PGP SIGNATURE-----

--mJm6k4Vb/yFcL9ZU--
