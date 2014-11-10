From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [patch -mainline] netfilter: ipset: small potential read beyond
 the end of buffer
Date: Mon, 10 Nov 2014 15:27:51 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1411101526480.2913@blackhole.kfki.hu>
References: <20141107062140.GA10905@mwanda> <20141110142446.GA29586@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Popovich <popovich_sergei@mail.ru>,
	Masanari Iida <standby24x7@gmail.com>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	stephen hemminger <stephen@networkplumber.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernddel.org, kernel-janitors@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20141110142446.GA29586@salvia>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 10 Nov 2014, Pablo Neira Ayuso wrote:

> On Fri, Nov 07, 2014 at 09:21:40AM +0300, Dan Carpenter wrote:
> > We could be reading 8 bytes into a 4 byte buffer here.  It seems
> > harmless but adding a check is the right thing to do and it silences a
> > static checker warning.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > index 86f9d76..ac08a3f 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -1863,7 +1863,8 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
> >  	if (*op < IP_SET_OP_VERSION) {
> >  		/* Check the version at the beginning of operations */
> >  		struct ip_set_req_version *req_version = data;
> > -		if (req_version->version != IPSET_PROTOCOL) {
> > +		if (*len < sizeof(struct ip_set_req_version) ||
> > +		    req_version->version != IPSET_PROTOCOL) {
> >  			ret = -EPROTO;
> >  			goto done;
> 
> Thanks for catching up this.
> 
> >From other similar code in that location, I can see Jozsef is using
> this pattern:
> 
>                 if (*len != sizeof(struct ip_set_req_version)) {
>                         ret = -EINVAL;
>                         goto done;
>                 }
> 
> I think it would be good to stick to that for consistency. Thanks.

Absolutely, yes.

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
