From: Thomas Mader <thezema@gmail.com>
Subject: Re: remove connections notification by conntrack?
Date: Sun, 15 Oct 2006 15:01:19 +0200
Message-ID: <200610151501.28715.thezema@gmail.com>
References: <200609221359.22676.thezema@gmail.com>
	<200609241151.31689.thezema@gmail.com>
	<4516A577.7080802@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4482964.s9ILhiBKR6";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4516A577.7080802@netfilter.org>
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

--nextPart4482964.s9ILhiBKR6
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Pablo,
we figured out what the problem was some time ago, sorry for the delay. We=
=20
forgot to put it back as you said earlier.
We want to publish our code soon here on the mailinglist to finish this top=
ic=20
and to help others with our code as an example but we don't find out how to=
=20
send ICMP packets from kernelspace.
Maybe you or somebody else could point us to some code example or something=
 so=20
we can implement it? We searched the kernel code and the net for examples b=
ut=20
we wasn't successful at finding working examples.
We want to send an ICMP echo request to the destination of the UDP flows an=
d=20
measure the round-trip-time with the returning echo reply.
Here is something of what we tried to send such a request.

									struct sk_buff *buf;
									struct iphdr* iph =3D (struct iphdr*)kmalloc(sizeof(struct iphdr),=
=20
GFP_KERNEL);
									struct icmphdr* icmph =3D (struct icmphdr*)kmalloc(sizeof(struct=20
icmphdr), GFP_KERNEL);
									if (!iph || !icmph)
										printk("Could not allocate iph or icmph\n");
							=09

									buf =3D alloc_skb(sizeof(struct iphdr) + sizeof(struct icmphdr)+=20
2*(skb->dev->addr_len+4)
											                                 + LL_RESERVED_SPACE(skb->dev),=
=20
GFP_ATOMIC);

									//buf =3D dev_alloc_skb(sizeof(struct iphdr) + sizeof(struct icmph=
dr));
									if(!buf)
										printk("error\n");
								=09
									skb_reserve(buf, LL_RESERVED_SPACE(skb->dev));
									buf->nh.iph =3D buf->data;
									icmph =3D (struct icmphdr *) skb_put(buf,sizeof(struct iphdr) +=20
sizeof(struct icmphdr) + 2*(skb->dev->addr_len+4));
									buf->dev =3D skb->dev;
									buf->protocol =3D htons(ETH_P_IP);
									buf->sk =3D skb->sk;
								=09
									icmph->type =3D ICMP_ECHO; //8
									icmph->code =3D ICMP_ECHO; //0
									icmph->checksum =3D 0;
									icmph->un.echo.id =3D connection_id;
									icmph->un.echo.sequence =3D 0;
								=09
									iph->version =3D 4;
									iph->ihl =3D 5;
									iph->tos =3D 0;
									iph->tot_len =3D sizeof(struct iphdr) + sizeof(struct icmphdr);
									iph->id =3D htons(0);
									iph->frag_off =3D 0;
									iph->ttl =3D 64;
									iph->protocol =3D IPPROTO_ICMP;
	//								iph->check //in_cksum((unsigned short *)ip, sizeof(struct iphdr)=
);
									iph->saddr =3D skb->nh.iph->daddr;
									iph->daddr =3D skb->nh.iph->saddr;

	//								buf.mac.raw =3D
	//								buf.cb =3D NULL;

									buf->h.icmph =3D icmph;
									buf->nh.iph =3D iph;
								=09
									p->echo_request =3D 1;*/
									//TODO send ICMP echo request
									// We are getting a warning for the first arg here, dunno why
									//icmp_send(buf, 8, 0, 0);
									//icmp_send(buf, ICMP_ECHO , ICMP_ECHO , 0);
									skb->sk =3D icmp_socket->sk;
									icmp_send(skb, ICMP_ECHO, ICMP_ECHO, 0);
									//kfree(buf);
									//kfree(iph);
									//kfree(icmph);

best regards,
Thomas

On Sunday 24 September 2006 17:34, you wrote:
> Thomas Mader wrote:
> > On Sunday 24 September 2006 05:10, Pablo Neira Ayuso wrote:
> >> events & IPCT_DESTROY
> >>
> >>> 		printk("We have been notified that connection %d was deleted!\n",
> >>> ct->id); }
> >>>
> >>> 	return 0;
> >>> }
> >>>
> >>>
> >>> static struct notifier_block ctnl_notifier =3D {
> >>> 	.notifier_call =3D ipaddr_conntrack_event,
> >>> };
> >>>
> >>>
> >>> static int __init init(void)
> >>> {
> >>> 	int ret;
> >>> 	need_conntrack();
> >>> 	ret =3D ip_conntrack_register_notifier(&ctnl_notifier);
> >>> 	if (ret < 0) {
> >>> 		printk("ipaddr_init: cannot register notifier.\n");
> >>> 		goto err_unreg_notifier;
> >>> 	}
> >>> 	//ip_conntrack_destroyed =3D destroyed_connect;
> >>>
> >>> 	printk(KERN_CRIT "init!\n");
> >>>    	return ipt_register_match(&ipaddr_match);
> >>>
> >>> err_unreg_notifier:
> >>> 		ip_conntrack_unregister_notifier(&ctnl_notifier);
> >>> 		return 1;
> >>> }
> >>>
> >>> But the problem remains the same. It works for TCP and I get properly
> >>> notified about those but not about UDP.
> >>
> >> Try with what I told you above and let me know if it works
> >
> > No it doesn't. I tried "events & IPCT_DESTROY" already and it didn't
> > work. Now I tested it once again with same result.
>
> Works fine here with the toy module attached:
>
> Sep 24 17:30:52 Decadence kernel: protonum=3D17
> Sep 24 17:31:26 Decadence last message repeated 2 times
> Sep 24 17:31:47 Decadence kernel: protonum=3D6

--nextPart4482964.s9ILhiBKR6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iQIVAwUARTIxKBjLzKnHCDEhAQJ1mg//cLGIYN1qGXesuRUz7M2w88wRa1BVhryO
Y8atooRyzDUjQh6B7NPBfTro1+Px8KcaA2D9kYocT6ZTE7l0FWoIBo5I8Lw3sIx2
EV2C91fFMIvQQdIQ1ffo9GFwqDy5LwzEEIqQ/J7na2nM7s8qcTSNNu/66uqCKkW+
xieeWprCzfAxpiC3og9kDy71WpF6S+CRwa9wujgEARXRnspPW8E80o7IImXmR4FO
/Ck5Niz42douAHITX/xbqUNWPcGMKkL/caWEAL0ixWuGWCp0CAiS8GTdrQDKmsbg
q+WVDBumCwdNcEmx86H1Q5XfCjItQ2BLljJnHAeJBNdBJDZUPOsjSVBKcmNxGIb+
07+EN/CRqOM8ZvMEA4TiDmYLz0nr1YwzTbrqmAKC93j/G3v7ylvx3DPn1eeyAokc
uYOAYUPMPduaOaQVlcSe850gl2b/DDeptPUZ4iaWmoGhgDKIPOwS06FGEGqTDW5b
pA57UsDS64/wKXdhocEyhJRDgg+0nirzDizxWjr+5BgWV1mFErDsR3qmLstbupfR
12yu80HchwIOuPPA8ES+ADebEfDIdYJQ7Eq6y/Rf9Zg31dBf8vlm2nssxgXTMM80
RTd0kr/+psyoWuGYvyIFYAudsLXT93IqAqTW0hFv14OxYmCRYEfFnCDJQwjORRLA
Ddz30Je0Ccw=
=xWLY
-----END PGP SIGNATURE-----

--nextPart4482964.s9ILhiBKR6--
