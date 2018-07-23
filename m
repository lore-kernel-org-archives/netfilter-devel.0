From: shaochun chen <cscnull@gmail.com>
Subject: Re: [PATCH] netlink: fix memory leak of dump
Date: Mon, 23 Jul 2018 18:34:36 +0800
Message-ID: <CAKDdixBBd08eKvk-hJtwPy46u2uzihRCh_KdEMF3xG1ZJ6oNsg@mail.gmail.com>
References: <20180722143354.23722-1-cscnull@gmail.com> <20180722163925.gdfkndldatsoae6x@breakpoint.cc>
 <20180722.100755.19840167505550163.davem@davemloft.net> <20180722180910.wcwhantwpm2nfxet@breakpoint.cc>
 <20180723091551.mwhltw4ujm4bylvj@salvia> <20180723092818.ztsfsnqzxgzrauim@breakpoint.cc>
 <CAKDdixCx5za07R9KdyohsZjJqzdTpE3mR1+4TwY5xjeBGVeTjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0000000000002769a70571a8310b"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
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
In-Reply-To: <CAKDdixCx5za07R9KdyohsZjJqzdTpE3mR1+4TwY5xjeBGVeTjg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--0000000000002769a70571a8310b
Content-Type: text/plain; charset="UTF-8"

I have a question: we will try_module_get in __netlink_dump_start(),
but why we need to call try_module_get again in  nft_netlink_dump_start ??

2018-07-23 17:52 GMT+08:00 shaochun chen <cscnull@gmail.com>:

> allocate memory in ->start(),  it's not convenient for users.
> if call ->done() isn't ok for clean memory when netlink_dump_start() fail,
> maybe we should have another function ->clean() to clean memory.
>
> 2018-07-23 17:28 GMT+08:00 Florian Westphal <fw@strlen.de>:
>
>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > > diff --git a/net/netfilter/nf_tables_api.c
>> b/net/netfilter/nf_tables_api.c
>> > > --- a/net/netfilter/nf_tables_api.c
>> > > +++ b/net/netfilter/nf_tables_api.c
>> > > @@ -5010,6 +5013,22 @@ nft_obj_filter_alloc(const struct nlattr *
>> const nla[])
>> > >     return filter;
>> > >  }
>> > >
>> > > +static int nf_tables_dump_obj_start(struct netlink_callback *cb)
>> > > +{
>> > > +   const struct nlattr * const *nla = cb->data;
>>
>> On-Stack input.
>> I can't see how its wrong, ->start() happens from same context as
>> netlink_dump_start so its valid.
>>
>> > > +   struct nft_obj_filter *filter = NULL;
>> > > +
>> > > +   if (nla[NFTA_OBJ_TABLE] ||
>> > > +       nla[NFTA_OBJ_TYPE]) {
>> > > +           filter = nft_obj_filter_alloc(nla);
>> > > +           if (IS_ERR(filter))
>> > > +                   return -ENOMEM;
>> > > +   }
>> > > +
>> > > +   cb->data = filter;
>>
>> And this replaced the on-stack input with dynamically
>> allocated one, which will be free'd via ->done().
>>
>> > >  /* called with rcu_read_lock held */
>> > >  static int nf_tables_getobj(struct net *net, struct sock *nlsk,
>> > >                         struct sk_buff *skb, const struct nlmsghdr
>> *nlh,
>> > > @@ -5028,21 +5047,13 @@ static int nf_tables_getobj(struct net *net,
>> struct sock *nlsk,
>> > >
>> > >     if (nlh->nlmsg_flags & NLM_F_DUMP) {
>> > >             struct netlink_dump_control c = {
>> > > +                   .start = nf_tables_dump_obj_start,
>> > >                     .dump = nf_tables_dump_obj,
>> > >                     .done = nf_tables_dump_obj_done,
>> > >                     .module = THIS_MODULE,
>> > > +                   .data = (void *)nla,
>> >
>> > You cannot do this.
>> >
>> > nla is allocated in this stack.
>>
>> Yes.
>>
>> > the nla will not be available in the second recv(), it won't be there.
>>
>> Its replaced in ->start().
>>
>> As David pointed out, once ->start() returns 0 we set cb_running, i.e.
>> only after successful ->start() netlink core will call ->dump() again.
>>
>> So I see no problem setting ->data to onstack cookie and then
>> duplicating it to heap via kmemdup in ->start().
>>
>> As far as I can see netlink core offers all functionality already,
>> so we only need to switch netfilter to make use of it.
>>
>> If you disagree please let me know, otherwise I will cook up
>> a patch along this pattern for net/netfilter/*.
>>
>> Thanks.
>>
>
>

--0000000000002769a70571a8310b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I have a question: we will try_module_get in=C2=A0<span st=
yle=3D"color:rgb(0,0,0);font-size:13.3333px">__netlink_dump_start(),</span>=
<div><span style=3D"color:rgb(0,0,0);font-size:13.3333px">but why we need t=
o call=C2=A0<span style=3D"color:rgb(34,34,34);font-size:14px;background-co=
lor:rgb(255,255,255);text-decoration-style:initial;text-decoration-color:in=
itial;float:none;display:inline"><span>try_module_get again in=20

<span style=3D"color:rgb(0,0,0);font-size:13.3333px;background-color:rgb(25=
5,255,255);text-decoration-style:initial;text-decoration-color:initial;floa=
t:none;display:inline"><span>=C2=A0</span></span><span style=3D"text-decora=
tion-style:initial;text-decoration-color:initial;background-color:rgb(255,2=
55,255);float:none;display:inline">nft_netlink_dump_start<span>=C2=A0</span=
></span>??</span></span></span></div></div><div class=3D"gmail_extra"><br><=
div class=3D"gmail_quote">2018-07-23 17:52 GMT+08:00 shaochun chen <span di=
r=3D"ltr">&lt;<a href=3D"mailto:cscnull@gmail.com" target=3D"_blank">cscnul=
l@gmail.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"l=
tr">allocate memory in -&gt;start(),=C2=A0 it&#39;s not convenient for user=
s.<div>if call -&gt;done() isn&#39;t ok for clean memory when netlink_dump_=
start() fail,</div><div>maybe we should have another function -&gt;clean() =
to clean memory.</div></div><div class=3D"HOEnZb"><div class=3D"h5"><div cl=
ass=3D"gmail_extra"><br><div class=3D"gmail_quote">2018-07-23 17:28 GMT+08:=
00 Florian Westphal <span dir=3D"ltr">&lt;<a href=3D"mailto:fw@strlen.de" t=
arget=3D"_blank">fw@strlen.de</a>&gt;</span>:<br><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex"><span>Pablo Neira Ayuso &lt;<a href=3D"mailto:pablo@netfilter.org" tar=
get=3D"_blank">pablo@netfilter.org</a>&gt; wrote:<br>
&gt; &gt; diff --git a/net/netfilter/nf_tables_api.<wbr>c b/net/netfilter/n=
f_tables_api.<wbr>c<br>
&gt; &gt; --- a/net/netfilter/nf_tables_api.<wbr>c<br>
&gt; &gt; +++ b/net/netfilter/nf_tables_api.<wbr>c<br>
&gt; &gt; @@ -5010,6 +5013,22 @@ nft_obj_filter_alloc(const struct nlattr *=
 const nla[])<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0return filter;<br>
&gt; &gt;=C2=A0 }<br>
&gt; &gt;=C2=A0 <br>
&gt; &gt; +static int nf_tables_dump_obj_start(struc<wbr>t netlink_callback=
 *cb)<br>
&gt; &gt; +{<br>
&gt; &gt; +=C2=A0 =C2=A0const struct nlattr * const *nla =3D cb-&gt;data;<b=
r>
<br>
</span>On-Stack input.<br>
I can&#39;t see how its wrong, -&gt;start() happens from same context as<br=
>
netlink_dump_start so its valid.<br>
<span><br>
&gt; &gt; +=C2=A0 =C2=A0struct nft_obj_filter *filter =3D NULL;<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0if (nla[NFTA_OBJ_TABLE] ||<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0nla[NFTA_OBJ_TYPE]) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0filter =3D nft_obj_filt=
er_alloc(nla);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ERR(filter))<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0return -ENOMEM;<br>
&gt; &gt; +=C2=A0 =C2=A0}<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0cb-&gt;data =3D filter;<br>
<br>
</span>And this replaced the on-stack input with dynamically<br>
allocated one, which will be free&#39;d via -&gt;done().<br>
<span><br>
&gt; &gt;=C2=A0 /* called with rcu_read_lock held */<br>
&gt; &gt;=C2=A0 static int nf_tables_getobj(struct net *net, struct sock *n=
lsk,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0struct sk_buff *skb, const struct nlmsghdr *nlh,<br=
>
&gt; &gt; @@ -5028,21 +5047,13 @@ static int nf_tables_getobj(struct net *n=
et, struct sock *nlsk,<br>
&gt; &gt;=C2=A0 <br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0if (nlh-&gt;nlmsg_flags &amp; NLM_F_DUMP) {<br=
>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct netlink_dum=
p_control c =3D {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.start =3D nf_tables_dump_obj_start,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0.dump =3D nf_tables_dump_obj,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0.done =3D nf_tables_dump_obj_done,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0.module =3D THIS_MODULE,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.data =3D (void *)nla,<br>
&gt; <br>
&gt; You cannot do this.<br>
&gt; <br>
&gt; nla is allocated in this stack.<br>
<br>
</span>Yes.<br>
<span><br>
&gt; the nla will not be available in the second recv(), it won&#39;t be th=
ere.<br>
<br>
</span>Its replaced in -&gt;start().<br>
<br>
As David pointed out, once -&gt;start() returns 0 we set cb_running, i.e.<b=
r>
only after successful -&gt;start() netlink core will call -&gt;dump() again=
.<br>
<br>
So I see no problem setting -&gt;data to onstack cookie and then<br>
duplicating it to heap via kmemdup in -&gt;start().<br>
<br>
As far as I can see netlink core offers all functionality already,<br>
so we only need to switch netfilter to make use of it.<br>
<br>
If you disagree please let me know, otherwise I will cook up<br>
a patch along this pattern for net/netfilter/*.<br>
<br>
Thanks.<br>
</blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--0000000000002769a70571a8310b--
