From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: REGISTERING with netfilter hooks - strange behaviour
Date: Mon, 30 Jul 2007 09:44:14 +0200
Message-ID: <20070730074414.GA10785@sch.bme.hu>
References: <885896af0707260804l18b7019ai399026d0a8906fe4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <885896af0707260804l18b7019ai399026d0a8906fe4@mail.gmail.com>
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


  Hi,

On cs, j=FAl 26, 2007 at 05:04:37 +0200, Giacomo wrote:
> /* THIS IS THE CALLBACK registered by nf_register_hook() */
> unsigned int
> deliver_process_by_direction(unsigned int hooknum,
> 		struct sk_buff **skb,
> 		const struct net_device *in,
> 		const struct net_device *out,
> 		int (*okfn) (struct sk_buff *))
> {
> 	struct tcphdr* tcph;
> 	struct iphdr *iph;
> 	if(*skb !=3D NULL)
> 	{
> 		iph =3D (struct iphdr*) skb_network_header(*skb);
> 		if(iph !=3D NULL)
> 		{
> 			if (iph->protocol =3D=3D IPPROTO_TCP)
> 			{
> 				tcph =3D (struct tcphdr=20
> 				*)skb_transport_header(*skb);
> 				printk("SOURCE: %d - DEST: %d ",
> 				       ntohs(tcph->source),=20
> 				       ntohs(tcph->dest) );
> 			}
> 		}
> 	}
>=20
>=20
> /* THE printk() writes  values  that look like they were uninitialized =
*/
> THe same happens with
>=20
> ip_hdr(*skb)
> and tcp_hdr();
>=20
> This happens in NF_PRE and NF_IN

  I guess the transport header pointer is not initialized properly when
you're checking for it. I don't exactly know how it behaves after
Arnaldo's changes, but skb->th.* used to be invalid on PREROUTING.

--=20
KOVACS Krisztian
