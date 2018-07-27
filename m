From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 00/18] xfrm: Add compat layer
Date: Fri, 27 Jul 2018 10:09:50 -0700
Message-ID: <9907339A-4CBE-4F5C-88CB-A1C6DBCB4CED@amacapital.net>
References: <20180726023144.31066-1-dima@arista.com> <20180726084959.pzjvflfjq6a76du6@breakpoint.cc> <20180727073747.h27dtojlnmc3k25v@gauss3.secunet.de> <1532700173.2679.18.camel@arista.com> <20180727141936.uze6ohordx7ue3no@breakpoint.cc> <1532703111.2679.20.camel@arista.com> <CADhJOfam+cY8uD4XTGvZSEFQdAgTu49G6cg6c64NJoP3bNuBmw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: multipart/alternative;
        boundary=Apple-Mail-F0CF300A-221A-4558-94AF-78ADCD92F052
Content-Transfer-Encoding: 7bit
Cc: Dmitry Safonov <dima@arista.com>, Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Safonov <0x7f454c46@gmail.com>, netdev@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-efi@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        G
To: Nathan Harold <nharold@google.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CADhJOfam+cY8uD4XTGvZSEFQdAgTu49G6cg6c64NJoP3bNuBmw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--Apple-Mail-F0CF300A-221A-4558-94AF-78ADCD92F052
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable



> On Jul 27, 2018, at 9:48 AM, Nathan Harold <nharold@google.com> wrote:
>=20
> We (Android) are very interested in removing the restriction for 32-bit us=
erspace processes accessing xfrm netlink on 64-bit kernels. IPsec support is=
 required to pass Android conformance tests, and any manufacturer wishing to=
 ship 32-bit userspace with a recent kernel needs out-of-tree changes (remov=
ing the compat_task check) to do so.
>=20
> That said, it=E2=80=99s not difficult to work around alignment issues dire=
ctly in userspace, so maybe we could just remove the check and make this the=
 caller's responsibility? Here=E2=80=99s an example of the workaround curren=
tly in the Android tree:
> https://android.googlesource.com/platform/system/netd/+/refs/heads/master/=
server/XfrmController.h#257
>=20
> We could also employ a (relatively simple) solution such as the one above i=
n the uapi XFRM header itself, though it would require a caller to declare t=
he target kernel ABI at compile time. Maybe that=E2=80=99s not unthinkable f=
or an uncommon case?
>=20

Could there just be an XFRM2 that is entirely identical to XFRM for 64-bit u=
serspace but makes the 32-bit structures match?  If there are a grand total o=
f two or so userspace implementations, that should cover most use cases. L

> -Nathan
>=20
>=20
>> On Fri, Jul 27, 2018 at 7:51 AM, Dmitry Safonov <dima@arista.com> wrote:
>> On Fri, 2018-07-27 at 16:19 +0200, Florian Westphal wrote:
>> > Dmitry Safonov <dima@arista.com> wrote:
>> > > 1. It will double copy netlink messages, making it O(n) instead of
>> > > O(1), where n - is number of bind()s.. Probably we don't care much.
>> >=20
>> > About those bind() patches, I don't understand why they are needed.
>> >=20
>> > Why can't you just add the compat skb to the native skb when doing
>> > the multicast call?
>> >=20
>> > skb_shinfo(skb)->frag_list =3D compat_skb;
>> > xfrm_nlmsg_multicast(net, skb, 0, ...
>>=20
>> Oh yeah, sorry, I think I misread the patch - will try to add compat
>> skb in the multicast call.
>>=20
>> --=20
>> Thanks,
>>              Dmitry
>=20

--Apple-Mail-F0CF300A-221A-4558-94AF-78ADCD92F052
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charset=3D=
utf-8"></head><body dir=3D"auto"><br><div><br>On Jul 27, 2018, at 9:48 AM, N=
athan Harold &lt;<a href=3D"mailto:nharold@google.com">nharold@google.com</a=
>&gt; wrote:<br><br></div><blockquote type=3D"cite"><div><div dir=3D"ltr"><b=
 style=3D"font-weight:normal" id=3D"gmail-docs-internal-guid-e4b05990-dca1-4=
f17-94c5-d2141c339ad6"><p dir=3D"ltr" style=3D"line-height:1.38;margin-top:0=
pt;margin-bottom:0pt"><span style=3D"font-size:11pt;font-family:Arial;color:=
rgb(0,0,0);background-color:transparent;font-weight:400;font-style:normal;fo=
nt-variant:normal;text-decoration:none;vertical-align:baseline;white-space:p=
re-wrap">We (Android) are very interested in removing the restriction for 32=
-bit userspace processes accessing xfrm netlink on 64-bit kernels. IPsec sup=
port is required to pass Android conformance tests, and any manufacturer wis=
hing to ship 32-bit userspace with a recent kernel needs out-of-tree changes=
 (removing the compat_task check) to do so.</span></p><br><p dir=3D"ltr" sty=
le=3D"line-height:1.38;margin-top:0pt;margin-bottom:0pt"><span style=3D"font=
-size:11pt;font-family:Arial;color:rgb(0,0,0);background-color:transparent;f=
ont-weight:400;font-style:normal;font-variant:normal;text-decoration:none;ve=
rtical-align:baseline;white-space:pre-wrap">That said, it=E2=80=99s not diff=
icult to work around alignment issues directly in userspace, so maybe we cou=
ld just remove the check and make this the caller's responsibility? Here=E2=80=
=99s an example of the workaround currently in the Android tree:</span></p><=
p dir=3D"ltr" style=3D"line-height:1.38;margin-top:0pt;margin-bottom:0pt"><a=
 href=3D"https://android.googlesource.com/platform/system/netd/+/refs/heads/=
master/server/XfrmController.h#257" style=3D"text-decoration:none"><span sty=
le=3D"font-size:11pt;font-family:Arial;color:rgb(17,85,204);background-color=
:transparent;font-weight:400;font-style:normal;font-variant:normal;text-deco=
ration:underline;vertical-align:baseline;white-space:pre-wrap">https://andro=
id.googlesource.com/platform/system/netd/+/refs/heads/master/server/XfrmCont=
roller.h#257</span></a></p><br><p dir=3D"ltr" style=3D"line-height:1.38;marg=
in-top:0pt;margin-bottom:0pt"><span style=3D"font-size:11pt;font-family:Aria=
l;color:rgb(0,0,0);background-color:transparent;font-weight:400;font-style:n=
ormal;font-variant:normal;text-decoration:none;vertical-align:baseline;white=
-space:pre-wrap">We could also employ a (relatively simple) solution such as=
 the one above in the uapi XFRM header itself, though it would require a cal=
ler to declare the target kernel ABI at compile time. Maybe that=E2=80=99s n=
ot unthinkable for an uncommon case?</span></p><br></b></div></div></blockqu=
ote><div><br></div><div>Could there just be an XFRM2 that is entirely identi=
cal to XFRM for 64-bit userspace but makes the 32-bit structures match? &nbs=
p;If there are a grand total of two or so userspace implementations, that sh=
ould cover most use cases. L</div><br><blockquote type=3D"cite"><div><div di=
r=3D"ltr"><b style=3D"font-weight:normal" id=3D"gmail-docs-internal-guid-e4b=
05990-dca1-4f17-94c5-d2141c339ad6"><p dir=3D"ltr" style=3D"line-height:1.38;=
margin-top:0pt;margin-bottom:0pt"><span style=3D"font-size:11pt;font-family:=
Arial;color:rgb(0,0,0);background-color:transparent;font-weight:400;font-sty=
le:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;w=
hite-space:pre-wrap">-Nathan</span></p></b><br></div><div class=3D"gmail_ext=
ra"><br><div class=3D"gmail_quote">On Fri, Jul 27, 2018 at 7:51 AM, Dmitry S=
afonov <span dir=3D"ltr">&lt;<a href=3D"mailto:dima@arista.com" target=3D"_b=
lank">dima@arista.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
><div class=3D"HOEnZb"><div class=3D"h5">On Fri, 2018-07-27 at 16:19 +0200, =
Florian Westphal wrote:<br>
&gt; Dmitry Safonov &lt;<a href=3D"mailto:dima@arista.com">dima@arista.com</=
a>&gt; wrote:<br>
&gt; &gt; 1. It will double copy netlink messages, making it O(n) instead of=
<br>
&gt; &gt; O(1), where n - is number of bind()s.. Probably we don't care much=
.<br>
&gt; <br>
&gt; About those bind() patches, I don't understand why they are needed.<br>=

&gt; <br>
&gt; Why can't you just add the compat skb to the native skb when doing<br>
&gt; the multicast call?<br>
&gt; <br>
&gt; skb_shinfo(skb)-&gt;frag_list =3D compat_skb;<br>
&gt; xfrm_nlmsg_multicast(net, skb, 0, ...<br>
<br>
</div></div>Oh yeah, sorry, I think I misread the patch - will try to add co=
mpat<br>
skb in the multicast call.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-- <br>
Thanks,<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Dmitry<br>
</font></span></blockquote></div><br></div>
</div></blockquote></body></html>=

--Apple-Mail-F0CF300A-221A-4558-94AF-78ADCD92F052--
