From: Thomas Mader <thezema@gmail.com>
Subject: Re: remove connections notification by conntrack?
Date: Fri, 22 Sep 2006 15:19:46 +0200
Message-ID: <200609221519.52127.thezema@gmail.com>
References: <200609221359.22676.thezema@gmail.com>
	<4513DE12.4020305@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3276687.dvyzsV35Gr";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4513DE12.4020305@netfilter.org>
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

--nextPart3276687.dvyzsV35Gr
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Could you post the code?

struct conn_id {
	int id;
	struct list_head elem;
	struct list_head tstamps;
};

struct conn_stamp {
	double stamp;
	struct list_head elem;
};

static LIST_HEAD(list);

void destroyed_connect(struct ip_conntrack *conntrack) {
	printk("destroy id %u\n", conntrack->id);
}

static int match(const struct sk_buff *skb,
                 const struct net_device *in,
                 const struct net_device *out,
		 const struct xt_match *match,
                 const void *matchinfo,
                 int offset,
		 unsigned int protoff,
                 int *hotdrop)
{
=2E....
	proto =3D ip_conntrack_proto_find_get(skb->nh.iph->protocol);


	if (ip_ct_get_tuple(skb->nh.iph, skb, skb->nh.iph->ihl*4, &tuple,proto)) {

		h =3D ip_conntrack_find_get(&tuple, NULL);
		if (h) {
			//printk("dstp: %u\n", ntohs(h->tuple.dst.u.udp.port) );
			ipct =3D tuplehash_to_ctrack(h);
			if (ipct) {
				int found_id =3D 0;
				struct conn_stamp *new_stamp;
				connection_id =3D ipct->id;

				if(!list_empty(&list)) {
					struct conn_id *p;
				=09
					list_for_each_entry(p, &list, elem) {
						if (connection_id =3D=3D p->id) {
							found_id =3D 1;
							new_stamp =3D (struct conn_stamp*)kmalloc(sizeof(struct conn_stamp),=
=20
GFP_KERNEL);
							if(!new_stamp) {
								printk("new_stamp not allocated!\n");
								return 1;
							}
						=09
							new_stamp->stamp =3D sec;
							list_add_tail(&new_stamp->elem, &p->tstamps);
							printk("new tstamp added to already existing id %d\n", p->id);
							break;
						}
					}
				}
				if(!found_id) {
					struct conn_id* new_id =3D (struct conn_id*)kmalloc(sizeof(struct conn=
_id),=20
GFP_KERNEL);
					if(!new_id) {
						printk("new_id not allocated!\n");
						return 1;
					}
				=09
					new_id->id =3D connection_id;
					INIT_LIST_HEAD(&new_id->elem);
					list_add_tail(&new_id->elem, &list);
				=09
					new_stamp =3D (struct conn_stamp*)kmalloc(sizeof(struct conn_stamp),=20
GFP_KERNEL);
					if(!new_stamp) {
						printk("new_stamp not allocated!\n");
						return 1;
					}
						=09
					new_stamp->stamp =3D sec;
					INIT_LIST_HEAD(&new_id->tstamps);
					list_add_tail(&new_stamp->elem, &new_id->tstamps);
					printk("new tstamp added to new created id %d\n", new_id->id);
				}
			}
		}
	}
=2E....
   return 1;
}

int notify(struct notifier_block *nb, unsigned long ul, void *v) {
	printk("We have been notified!\n");=09
=09
	return 0;
}

struct notifier_block nb =3D { notify, &nb, 1 };=20


static int __init init(void)
{
	need_conntrack();
	ip_conntrack_register_notifier(&nb);
	ip_conntrack_destroyed =3D destroyed_connect;

	return ipt_register_match(&ipaddr_match);
}

--nextPart3276687.dvyzsV35Gr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iQIVAwUARRPi9xjLzKnHCDEhAQLRRQ/+Jqlq4bntOP7BIbA2Zuey5HxG3xU+WRBE
XlidrZ5PgQxD2RGjO12hca+JveUMX6HgHA6/s4oghHPYdE6ZnquU6S8cToDgzRNn
DlsdOq9KaqL/4MIp0MA/MLE8rjPlwOywMjcgGVG71FFOZ3rjlEImVnI7bqOxRYte
kl0HVd5Y5BKjrYTjDhlJHUWiNqcMNWpOpc+YlSKBcJq5zBHFM3C0uw8y7ldNkGS6
hFK+hSY093Ojz5aRKzKyuEETh9KfvFyIjujiS3p2NgGESiHmhFivxJgehBK6dEuI
uoW1n4aw1KR36HWLeaKJWiorQJwRG7Pliuh/VeJ/+yT9BC9sonlC2O975XWVBlXs
kXmRoxXQpVnfxbHbjx/AmYwz2uMZ/ENGh9DwP0zpiIKPRbCZZUuSiu1mOgR6WGGE
mOa/WuQft2dZuWGmDZ7xbnxMxLnZHZdXH1tvBQdLqijJ/NkWDkvXAM+eJhnNOCwj
TPt8dmnYZhOE/Dk7NGWEq/arjuRBba6/kL0xp3Z6YJ0YNTs5ZqeaeQ3a2WcskMzT
jJy9DKUGyLf4qkzLD9sDB33B8K3clgN4uESovWyBReFV1Cf5g7I/lLlK07hrIHRh
7oFGgSfKj7UP58FI4dLmv40PHzVVuPr6TsvAG8gLW1Hmo7xjiqzuoBjpvZ3R7/6N
KiEpbCIGVw4=
=7+og
-----END PGP SIGNATURE-----

--nextPart3276687.dvyzsV35Gr--
