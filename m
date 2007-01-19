From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Patch 2/2] libnetfilter_queue and iface conversion to string
Date: Fri, 19 Jan 2007 16:25:34 +0100
Message-ID: <45B0E2EE.1060500@trash.net>
References: <1167257854.31765.21.camel@localhost>	
	<45940145.3020003@netfilter.org>
	<1167349247.15420.13.camel@localhost>	
	<20070107142607.GC13543@prithivi.gnumonks.org>	
	<1168296086.12298.6.camel@localhost>	
	<20070109115120.GX7655@prithivi.gnumonks.org>	
	<1169162676.8926.14.camel@localhost>
	<1169163191.8926.20.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Vincent Deffontaines <vincent@inl.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1169163191.8926.20.camel@localhost>
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

Eric Leblond wrote:
> Index: src/libnetfilter_queue.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- src/libnetfilter_queue.c	(r=C3=A9vision 6737)
> +++ src/libnetfilter_queue.c	(copie de travail)
> @@ -419,6 +419,31 @@
>  	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, u_int=
32_t));
>  }
> =20
> +char* nfq_get_indev_name(struct nfq_data *nfad)
> +{
> +	u_int32_t ifindex =3D nfq_get_indev(nfad);
> +	return nlif_index_2name(ifindex);
> +}
> +

This might appear annoying, but I don't like inconsistency since
it distracts me. So char * please, as in the parameters or in
the other functions in this file.
