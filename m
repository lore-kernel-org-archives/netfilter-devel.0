From: Vivek Kashyap <kashyapv@us.ibm.com>
Subject: Re: [PATCH] RANGEMARK target
Date: Fri, 31 Oct 2003 09:44:46 -0800 (Pacific Standard Time)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.WNT.4.44.0310310942460.1752-100000@w-vkashyap95.des.sequent.com>
References: <20031031143849.GE21066@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Vivek Kashyap <vivk@us.ibm.com>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031031143849.GE21066@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

OK Thanks. Will resubmit after correcting.

Vivek


On Fri, 31 Oct 2003, Harald Welte wrote:

> On Mon, Oct 27, 2003 at 02:57:28PM -0800, Vivek Kashyap wrote:
> > I wanted to MARK packets dynamically within a certain range.
>
> Ok, thanks for this contribution.
>
> > Please comment. I'll then update with necessary changes and also
> > add ip6t_* target.
>
> I'm going to comment inline.
>
> > +struct rangemarkinfo {
> > +    struct ipt_entry_target t;
> > +    struct ipt_rangemark_target_info rangemark;
>
> please adhere to the kernel CodingStyle (tabulator indent, 8char).
>
> > +static void
> > +print_rangemark(struct ipt_rangemark_target_info *r)
> > +{
> > +    printf("Base:   %lu %lx\n", r->base, r->base);
> > +    printf("Limit:  %lu %lx\n", r->limit, r->limit);
> > +    printf("rsize:  %lu %lx\n", r->rsize, r->rsize);
> > +    printf("skipvalue:  %lu %lx\n", r->skip, r->skip);
> > +    printf("mask:  %lu %lx\n", r->mask, r->mask);
> > +    printf("policy: %d\n", r->policy);
> > +    printf("op:     %d\n", r->op);
> > +}
>
> you'd have to try to be less verbose and not use newlines in the
> printout.  the print() function will be called for every rule when you
> do a 'iptables -L'.
>
> > +/* Saves the union ipt_targinfo in parsable form to stdout. */
> > +static void
> > +save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
> > +{
> > +    struct ipt_rangemark_target_info *rinfo =
> > +        (struct ipt_rangemark_target_info *)target->data;
> > +
> > +    print_rangemark(rinfo);
> > +}
>
> this is not correc.t  save() has to save it in exactly the same format
> (i.e. gnu-longoppts like --base) so that a later call to parse() can
> parse it again.
>
> > @@ -5,7 +5,7 @@
> >  # header files are present in the include/linux directory of this iptables
> >  # package (HW)
> >  #
> > -PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
> > +PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG RANGEMARK
> >
>
> instead of adding it to the makefile, we use a conditional compile
> mechanism.  Please look at the '.*-test' files in the extensions
> subdirectory as an example.
>
> > +enum rangemark_policy {
> > +	RANGEMARK_POLICY_RANDOM = 1,
> > +	RANGEMARK_POLICY_PORTHASH,
> > +};
>
> in the kernel, you really should follow linux/Documentation/CodingStyle
>
> > +unsigned short
> > +rangemark_hash(unsigned short s, unsigned short d)
>
> please try to use architecture independent fixed-size data types.  The
> kernel is compiled on various architectures, ...  so if you want an
> unsigned 16bit number, please use 'u_int16_t' or __u16.
>
> > +        case RANGEMARK_POLICY_PORTHASH:
> > +            /*
> > +             * Skip non IP packets
> > +             */
> > +            iptr = (void *)(*pskb)->nh.iph;
> > +            if ((((struct iphdr *)iptr)->version != 6) &&
> > +                    (((struct iphdr *)iptr)->version != 4)){
> > +                return IPT_CONTINUE;
>
> an iptables target can only be called from ip_tables.  And ip_tables is
> ipv4 specific, so it's guaranteed that you only receive IPv4 packets.
>
> > +#endif /*_IPT_RANGEMARK_H_target*/
>
> --
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
>

__

Vivek Kashyap
Linux Technology Center, IBM
