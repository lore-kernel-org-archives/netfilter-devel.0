From: Giacomo <delleceste@gmail.com>
Subject: Re: REGISTERING with netfilter hooks - strange behaviour
Date: Mon, 30 Jul 2007 09:52:51 +0200
Message-ID: <885896af0707300052k4e36f085w63b8780b9c660304@mail.gmail.com>
References: <885896af0707260804l18b7019ai399026d0a8906fe4@mail.gmail.com>
	<20070730074414.GA10785@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070730074414.GA10785@sch.bme.hu>
Content-Disposition: inline
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

Good morning and thanks.
I think i solved getting the tcp/udp header in PRE/IN by  means of the


p_tcphead =3D skb_header_pointer(skb, iph->ihl * 4,
=09=09=09sizeof(tcphead), &tcphead);

where iph is obtained by ip_hdr(skb);



Thank you!

Giacomo





2007/7/30, KOVACS Krisztian <hidden@sch.bme.hu>:
>
>   Hi,
>
> On cs, j=FAl 26, 2007 at 05:04:37 +0200, Giacomo wrote:
> > /* THIS IS THE CALLBACK registered by nf_register_hook() */
> > unsigned int
> > deliver_process_by_direction(unsigned int hooknum,
> >               struct sk_buff **skb,
> >               const struct net_device *in,
> >               const struct net_device *out,
> >               int (*okfn) (struct sk_buff *))
> > {
> >       struct tcphdr* tcph;
> >       struct iphdr *iph;
> >       if(*skb !=3D NULL)
> >       {
> >               iph =3D (struct iphdr*) skb_network_header(*skb);
> >               if(iph !=3D NULL)
> >               {
> >                       if (iph->protocol =3D=3D IPPROTO_TCP)
> >                       {
> >                               tcph =3D (struct tcphdr
> >                               *)skb_transport_header(*skb);
> >                               printk("SOURCE: %d - DEST: %d ",
> >                                      ntohs(tcph->source),
> >                                      ntohs(tcph->dest) );
> >                       }
> >               }
> >       }
> >
> >
> > /* THE printk() writes  values  that look like they were uninitialized =
*/
> > THe same happens with
> >
> > ip_hdr(*skb)
> > and tcp_hdr();
> >
> > This happens in NF_PRE and NF_IN
>
>   I guess the transport header pointer is not initialized properly when
> you're checking for it. I don't exactly know how it behaves after
> Arnaldo's changes, but skb->th.* used to be invalid on PREROUTING.
>
> --
> KOVACS Krisztian
>
>


--=20
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

IPFIREwall (http://www.giacomos.it/ipfire) viene presentato
all'Universita` degli Studi di Udine, il 28 ottobre, in occasione del
Linux Day 2006:
http://iglu.cc.uniud.it/linuxday

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
