From: "Banerjee, Debabrata" <dbanerje@akamai.com>
Subject: RE: [PATCH] Fix handling of verdicts after NF_QUEUE
Date: Tue, 12 Dec 2017 00:36:35 +0000
Message-ID: <3187cfae08f34dd89201f0d2265ab306@usma1ex-dag1mb2.msg.corp.akamai.com>
References: <20171211233024.18303-1-dbanerje@akamai.com>
 <20171212002318.GA7681@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "David S . Miller" <davem@davemloft.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To: 'Pablo Neira Ayuso' <pablo@netfilter.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171212002318.GA7681@salvia>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> On Mon, Dec 11, 2017 at 06:30:24PM -0500, Debabrata Banerjee wrote:
> > +	} else {
> > +		/* Implicit handling for NF_STOLEN, as well as any other
> > +		 * non conventional verdicts.
> > +		 */
> > +		ret =3D 0;
>=20
> Another possibility (more simple?) would be this:
>=20
> int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state) {
>         struct nf_hook_entry *entry;
>         unsigned int verdict;
> -       int ret =3D 0;
> +       int ret;
>=20
>         entry =3D rcu_dereference(state->hook_entries);
> next_hook:
> +       ret =3D 0;
>=20
> Basically, make sure ret is set to zero when jumping to the next_hook lab=
el.

Many ways to fix it, but I thought including the comment was appropriate.
Happy to change it if we want simpler instead.

-Deb
