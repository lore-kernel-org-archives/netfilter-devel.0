From: shaochun chen <cscnull@gmail.com>
Subject: Re: [PATCH] netlink: fix memory leak of dump
Date: Mon, 23 Jul 2018 10:05:18 +0800
Message-ID: <CAKDdixA8x=xKuoVCYE5SRL8P9i-uUmcYSsyQrcvM9rnaaubnuw@mail.gmail.com>
References: <20180722143354.23722-1-cscnull@gmail.com> <20180722163925.gdfkndldatsoae6x@breakpoint.cc>
 <20180722.100755.19840167505550163.davem@davemloft.net> <20180722180910.wcwhantwpm2nfxet@breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="000000000000c682c60571a113f2"
Cc: David Miller <davem@davemloft.net>, pablo <pablo@netfilter.org>,
        kadlec <kadlec@blackhole.kfki.hu>,
        "johannes.berg" <johannes.berg@intel.com>, jason <Jason@zx2c4.com>,
        ktkhai <ktkhai@virtuozzo.com>,
        "lucien.xin" <lucien.xin@gmail.com>,
        "xiyou.wangcong" <xiyou.wangcong@gmail.com>,
        dsahern <dsahern@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        tom <tom@quantonium.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180722180910.wcwhantwpm2nfxet@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--000000000000c682c60571a113f2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

allocate memory in cb->start(), which means passing 'static' variable
through control->data,
then allocate memory in cb->start() according to cb->data (cb->data is
equal to control->data now),
and set the memory back to cb->data which will be used in cb->dump().
It's a bit complicated=EF=BC=8C please see nf_tables_getset.

2018-07-23 2:09 GMT+08:00 Florian Westphal <fw@strlen.de>:

> David Miller <davem@davemloft.net> wrote:
> > From: Florian Westphal <fw@strlen.de>
> > Date: Sun, 22 Jul 2018 18:39:25 +0200
> >
> > > 3. change meaning of ->done() so its always called once ->start()
> > >    was invoked (and returned 0), this requires audit of all
> > >    places that provide .done to make sure they won't trip.
> > >
> > > 3) seems to be what Tom intended when he added .start, so probably
> > > best to investigate that first.
> >
> > Hmmm...
> >
> > Any time ->start() succeeds, we set cb_running to true.
>
> Right.
>
> > From that point forward, ->done() will be called at some point at all
> > of the locations that check if cb_running is true and set it to false.
>
> Also right, thanks for pointing this out, I missed fact that netlink
> core restarts a dump after this.
>
> So 3) is already true which means we should try to see if we can move
> all dump-related extra magic into ->start().
>
> Shaochun, can you see if this is possible?
>
> Something along these lines (totally untested), which makes this
> a netfilter fix:
>
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.=
c
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5010,6 +5013,22 @@ nft_obj_filter_alloc(const struct nlattr * const
> nla[])
>         return filter;
>  }
>
> +static int nf_tables_dump_obj_start(struct netlink_callback *cb)
> +{
> +       const struct nlattr * const *nla =3D cb->data;
> +       struct nft_obj_filter *filter =3D NULL;
> +
> +       if (nla[NFTA_OBJ_TABLE] ||
> +           nla[NFTA_OBJ_TYPE]) {
> +               filter =3D nft_obj_filter_alloc(nla);
> +               if (IS_ERR(filter))
> +                       return -ENOMEM;
> +       }
> +
> +       cb->data =3D filter;
> +       return 0;
> +}
> +
>  /* called with rcu_read_lock held */
>  static int nf_tables_getobj(struct net *net, struct sock *nlsk,
>                             struct sk_buff *skb, const struct nlmsghdr
> *nlh,
> @@ -5028,21 +5047,13 @@ static int nf_tables_getobj(struct net *net,
> struct sock *nlsk,
>
>         if (nlh->nlmsg_flags & NLM_F_DUMP) {
>                 struct netlink_dump_control c =3D {
> +                       .start =3D nf_tables_dump_obj_start,
>                         .dump =3D nf_tables_dump_obj,
>                         .done =3D nf_tables_dump_obj_done,
>                         .module =3D THIS_MODULE,
> +                       .data =3D (void *)nla,
>                 };
>
> -               if (nla[NFTA_OBJ_TABLE] ||
> -                   nla[NFTA_OBJ_TYPE]) {
> -                       struct nft_obj_filter *filter;
> -
> -                       filter =3D nft_obj_filter_alloc(nla);
> -                       if (IS_ERR(filter))
> -                               return -ENOMEM;
> -
> -                       c.data =3D filter;
> -               }
>                 return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
>         }
>
>

--000000000000c682c60571a113f2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">allocate memory in cb-&gt;start(), which means passing &#3=
9;static&#39; variable through control-&gt;data,=C2=A0<div>then allocate me=
mory in cb-&gt;start() according to cb-&gt;data (cb-&gt;data is equal to co=
ntrol-&gt;data now),</div><div>and set the memory back to cb-&gt;data which=
 will be used in cb-&gt;dump().=C2=A0</div><div>It&#39;s a bit complicated=
=EF=BC=8C please see=C2=A0nf_tables_getset.</div></div><div class=3D"gmail_=
extra"><br><div class=3D"gmail_quote">2018-07-23 2:09 GMT+08:00 Florian Wes=
tphal <span dir=3D"ltr">&lt;<a href=3D"mailto:fw@strlen.de" target=3D"_blan=
k">fw@strlen.de</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span cl=
ass=3D"">David Miller &lt;<a href=3D"mailto:davem@davemloft.net">davem@dave=
mloft.net</a>&gt; wrote:<br>
&gt; From: Florian Westphal &lt;<a href=3D"mailto:fw@strlen.de">fw@strlen.d=
e</a>&gt;<br>
&gt; Date: Sun, 22 Jul 2018 18:39:25 +0200<br>
&gt; <br>
&gt; &gt; 3. change meaning of -&gt;done() so its always called once -&gt;s=
tart()<br>
&gt; &gt;=C2=A0 =C2=A0 was invoked (and returned 0), this requires audit of=
 all<br>
&gt; &gt;=C2=A0 =C2=A0 places that provide .done to make sure they won&#39;=
t trip.<br>
&gt; &gt; <br>
&gt; &gt; 3) seems to be what Tom intended when he added .start, so probabl=
y<br>
&gt; &gt; best to investigate that first.<br>
&gt; <br>
&gt; Hmmm...<br>
&gt; <br>
&gt; Any time -&gt;start() succeeds, we set cb_running to true.<br>
<br>
</span>Right.<br>
<span class=3D""><br>
&gt; From that point forward, -&gt;done() will be called at some point at a=
ll<br>
&gt; of the locations that check if cb_running is true and set it to false.=
<br>
<br>
</span>Also right, thanks for pointing this out, I missed fact that netlink=
<br>
core restarts a dump after this.<br>
<br>
So 3) is already true which means we should try to see if we can move<br>
all dump-related extra magic into -&gt;start().<br>
<br>
Shaochun, can you see if this is possible?<br>
<br>
Something along these lines (totally untested), which makes this<br>
a netfilter fix:<br>
<br>
diff --git a/net/netfilter/nf_tables_api.<wbr>c b/net/netfilter/nf_tables_a=
pi.<wbr>c<br>
--- a/net/netfilter/nf_tables_api.<wbr>c<br>
+++ b/net/netfilter/nf_tables_api.<wbr>c<br>
@@ -5010,6 +5013,22 @@ nft_obj_filter_alloc(const struct nlattr * const nla=
[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return filter;<br>
=C2=A0}<br>
<br>
+static int nf_tables_dump_obj_start(<wbr>struct netlink_callback *cb)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0const struct nlattr * const *nla =3D cb-&gt;dat=
a;<br>
<span class=3D"">+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct nft_obj_filter *filter =
=3D NULL;<br>
</span>+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (nla[NFTA_OBJ_TABLE] ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nla[NFTA_OBJ_TYPE]) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0filter =3D nft_obj_=
filter_alloc(nla);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ERR(filter))=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return -ENOMEM;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cb-&gt;data =3D filter;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+}<br>
+<br>
=C2=A0/* called with rcu_read_lock held */<br>
<span class=3D"">=C2=A0static int nf_tables_getobj(struct net *net, struct =
sock *nlsk,<br>
</span>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct sk_buff *skb, const struct nlmsghdr =
*nlh,<br>
@@ -5028,21 +5047,13 @@ static int nf_tables_getobj(struct net *net, struct=
 sock *nlsk,<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (nlh-&gt;nlmsg_flags &amp; NLM_F_DUMP) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct netlink_dump=
_control c =3D {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0.start =3D nf_tables_dump_obj_start,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 .dump =3D nf_tables_dump_obj,<br>
<span class=3D"">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .done =3D nf_tables_dump_obj_done,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 .module =3D THIS_MODULE,<br>
</span>+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0.data =3D (void *)nla,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (nla[NFTA_OBJ_TA=
BLE] ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nla[N=
FTA_OBJ_TYPE]) {<br>
<span class=3D"">-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct nft_obj_filter *filter;<br>
-<br>
</span>-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0filter =3D nft_obj_filter_alloc(nla);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (IS_ERR(filter))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0c.data =3D filter;<br>
<div class=3D"HOEnZb"><div class=3D"h5">-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return nft_netlink_=
dump_start_rcu(<wbr>nlsk, skb, nlh, &amp;c);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
</div></div></blockquote></div><br></div>

--000000000000c682c60571a113f2--
