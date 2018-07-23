From: shaochun chen <cscnull@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: move dumper state alloation into ->start
Date: Mon, 23 Jul 2018 19:18:43 +0800
Message-ID: <CAKDdixAatZkyAk9U_qEjke=dKkuCq3QKfRLs_RtiLC_DO7G+TQ@mail.gmail.com>
References: <20180723104714.24008-1-fw@strlen.de> <20180723110911.guinjwo5vglcyw2z@salvia>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="000000000000ea9f040571a8cead"
Cc: Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180723110911.guinjwo5vglcyw2z@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--000000000000ea9f040571a8cead
Content-Type: text/plain; charset="UTF-8"

conditions of dump isn't limit in nla, so if you replace cb->data with
cb->nla,
sometimes it's hard to implement user's dump().

2018-07-23 19:09 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:

> On Mon, Jul 23, 2018 at 12:47:14PM +0200, Florian Westphal wrote:
> > Shaochun Chen points out we leak dumper filter state allocations
> > stored in dump_control->data in case there is an error before netlink
> sets
> > cb_running (after which ->done will be called at some point).
> >
> > In order to fix this, add .start functions and do the allocations
> > there.
> >
> > ->done is going to clean up, and in case error occurs before
> > ->start invocation no cleanups need to be done anymore.
>
> LGTM. Thanks Florian
>
> BTW, probably we can add cb->nla with strict typing instead, so we
> don't need to use cb->data. This cb->nla would be only valid from
> .start().
>
> Then, set cb->nla to NULL after .start() is called. Just to make sure
> people don't make wrong assumptions and try to access this from the
> classic dump path?
>
> Just an idea.
>

--000000000000ea9f040571a8cead
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">conditions of dump isn&#39;t limit in nla, so if you repla=
ce cb-&gt;data with cb-&gt;nla,=C2=A0<div>sometimes it&#39;s hard to=C2=A0i=
mplement user&#39;s dump().</div></div><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">2018-07-23 19:09 GMT+08:00 Pablo Neira Ayuso <span di=
r=3D"ltr">&lt;<a href=3D"mailto:pablo@netfilter.org" target=3D"_blank">pabl=
o@netfilter.org</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span cl=
ass=3D"">On Mon, Jul 23, 2018 at 12:47:14PM +0200, Florian Westphal wrote:<=
br>
&gt; Shaochun Chen points out we leak dumper filter state allocations<br>
&gt; stored in dump_control-&gt;data in case there is an error before netli=
nk sets<br>
&gt; cb_running (after which -&gt;done will be called at some point).<br>
&gt; <br>
&gt; In order to fix this, add .start functions and do the allocations<br>
&gt; there.<br>
&gt; <br>
&gt; -&gt;done is going to clean up, and in case error occurs before<br>
&gt; -&gt;start invocation no cleanups need to be done anymore.<br>
<br>
</span>LGTM. Thanks Florian<br>
<br>
BTW, probably we can add cb-&gt;nla with strict typing instead, so we<br>
don&#39;t need to use cb-&gt;data. This cb-&gt;nla would be only valid from=
<br>
.start().<br>
<br>
Then, set cb-&gt;nla to NULL after .start() is called. Just to make sure<br=
>
people don&#39;t make wrong assumptions and try to access this from the<br>
classic dump path?<br>
<br>
Just an idea.<br>
</blockquote></div><br></div>

--000000000000ea9f040571a8cead--
