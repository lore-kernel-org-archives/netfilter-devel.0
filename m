From: Nathan Harold <nharold@google.com>
Subject: Re: [PATCH 00/18] xfrm: Add compat layer
Date: Fri, 27 Jul 2018 09:48:06 -0700
Message-ID: <CADhJOfam+cY8uD4XTGvZSEFQdAgTu49G6cg6c64NJoP3bNuBmw@mail.gmail.com>
References: <20180726023144.31066-1-dima@arista.com> <20180726084959.pzjvflfjq6a76du6@breakpoint.cc>
 <20180727073747.h27dtojlnmc3k25v@gauss3.secunet.de> <1532700173.2679.18.camel@arista.com>
 <20180727141936.uze6ohordx7ue3no@breakpoint.cc> <1532703111.2679.20.camel@arista.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0000000000007e0a350571fde1eb"
Cc: Florian Westphal <fw@strlen.de>,
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
        Greg Kroah-Hartman <gregkh@linuxfou
To: Dmitry Safonov <dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1532703111.2679.20.camel@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--0000000000007e0a350571fde1eb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

*We (Android) are very interested in removing the restriction for 32-bit
userspace processes accessing xfrm netlink on 64-bit kernels. IPsec support
is required to pass Android conformance tests, and any manufacturer wishing
to ship 32-bit userspace with a recent kernel needs out-of-tree changes
(removing the compat_task check) to do so.That said, it=E2=80=99s not diffi=
cult to
work around alignment issues directly in userspace, so maybe we could just
remove the check and make this the caller's responsibility? Here=E2=80=99s =
an
example of the workaround currently in the Android
tree:https://android.googlesource.com/platform/system/netd/+/refs/heads/mas=
ter/server/XfrmController.h#257
<https://android.googlesource.com/platform/system/netd/+/refs/heads/master/=
server/XfrmController.h#257>We
could also employ a (relatively simple) solution such as the one above in
the uapi XFRM header itself, though it would require a caller to declare
the target kernel ABI at compile time. Maybe that=E2=80=99s not unthinkable=
 for an
uncommon case?-Nathan*

On Fri, Jul 27, 2018 at 7:51 AM, Dmitry Safonov <dima@arista.com> wrote:

> On Fri, 2018-07-27 at 16:19 +0200, Florian Westphal wrote:
> > Dmitry Safonov <dima@arista.com> wrote:
> > > 1. It will double copy netlink messages, making it O(n) instead of
> > > O(1), where n - is number of bind()s.. Probably we don't care much.
> >
> > About those bind() patches, I don't understand why they are needed.
> >
> > Why can't you just add the compat skb to the native skb when doing
> > the multicast call?
> >
> > skb_shinfo(skb)->frag_list =3D compat_skb;
> > xfrm_nlmsg_multicast(net, skb, 0, ...
>
> Oh yeah, sorry, I think I misread the patch - will try to add compat
> skb in the multicast call.
>
> --
> Thanks,
>              Dmitry
>

--0000000000007e0a350571fde1eb
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><b style=3D"font-weight:normal" id=3D"gmail-docs-internal-=
guid-e4b05990-dca1-4f17-94c5-d2141c339ad6"><p dir=3D"ltr" style=3D"line-hei=
ght:1.38;margin-top:0pt;margin-bottom:0pt"><span style=3D"font-size:11pt;fo=
nt-family:Arial;color:rgb(0,0,0);background-color:transparent;font-weight:4=
00;font-style:normal;font-variant:normal;text-decoration:none;vertical-alig=
n:baseline;white-space:pre-wrap">We (Android) are very interested in removi=
ng the restriction for 32-bit userspace processes accessing xfrm netlink on=
 64-bit kernels. IPsec support is required to pass Android conformance test=
s, and any manufacturer wishing to ship 32-bit userspace with a recent kern=
el needs out-of-tree changes (removing the compat_task check) to do so.</sp=
an></p><br><p dir=3D"ltr" style=3D"line-height:1.38;margin-top:0pt;margin-b=
ottom:0pt"><span style=3D"font-size:11pt;font-family:Arial;color:rgb(0,0,0)=
;background-color:transparent;font-weight:400;font-style:normal;font-varian=
t:normal;text-decoration:none;vertical-align:baseline;white-space:pre-wrap"=
>That said, it=E2=80=99s not difficult to work around alignment issues dire=
ctly in userspace, so maybe we could just remove the check and make this th=
e caller&#39;s responsibility? Here=E2=80=99s an example of the workaround =
currently in the Android tree:</span></p><p dir=3D"ltr" style=3D"line-heigh=
t:1.38;margin-top:0pt;margin-bottom:0pt"><a href=3D"https://android.googles=
ource.com/platform/system/netd/+/refs/heads/master/server/XfrmController.h#=
257" style=3D"text-decoration:none"><span style=3D"font-size:11pt;font-fami=
ly:Arial;color:rgb(17,85,204);background-color:transparent;font-weight:400;=
font-style:normal;font-variant:normal;text-decoration:underline;vertical-al=
ign:baseline;white-space:pre-wrap">https://android.googlesource.com/platfor=
m/system/netd/+/refs/heads/master/server/XfrmController.h#257</span></a></p=
><br><p dir=3D"ltr" style=3D"line-height:1.38;margin-top:0pt;margin-bottom:=
0pt"><span style=3D"font-size:11pt;font-family:Arial;color:rgb(0,0,0);backg=
round-color:transparent;font-weight:400;font-style:normal;font-variant:norm=
al;text-decoration:none;vertical-align:baseline;white-space:pre-wrap">We co=
uld also employ a (relatively simple) solution such as the one above in the=
 uapi XFRM header itself, though it would require a caller to declare the t=
arget kernel ABI at compile time. Maybe that=E2=80=99s not unthinkable for =
an uncommon case?</span></p><br><p dir=3D"ltr" style=3D"line-height:1.38;ma=
rgin-top:0pt;margin-bottom:0pt"><span style=3D"font-size:11pt;font-family:A=
rial;color:rgb(0,0,0);background-color:transparent;font-weight:400;font-sty=
le:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;=
white-space:pre-wrap">-Nathan</span></p></b><br></div><div class=3D"gmail_e=
xtra"><br><div class=3D"gmail_quote">On Fri, Jul 27, 2018 at 7:51 AM, Dmitr=
y Safonov <span dir=3D"ltr">&lt;<a href=3D"mailto:dima@arista.com" target=
=3D"_blank">dima@arista.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On Fri, 2018-07-27 at 16:1=
9 +0200, Florian Westphal wrote:<br>
&gt; Dmitry Safonov &lt;<a href=3D"mailto:dima@arista.com">dima@arista.com<=
/a>&gt; wrote:<br>
&gt; &gt; 1. It will double copy netlink messages, making it O(n) instead o=
f<br>
&gt; &gt; O(1), where n - is number of bind()s.. Probably we don&#39;t care=
 much.<br>
&gt; <br>
&gt; About those bind() patches, I don&#39;t understand why they are needed=
.<br>
&gt; <br>
&gt; Why can&#39;t you just add the compat skb to the native skb when doing=
<br>
&gt; the multicast call?<br>
&gt; <br>
&gt; skb_shinfo(skb)-&gt;frag_list =3D compat_skb;<br>
&gt; xfrm_nlmsg_multicast(net, skb, 0, ...<br>
<br>
</div></div>Oh yeah, sorry, I think I misread the patch - will try to add c=
ompat<br>
skb in the multicast call.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-- <br>
Thanks,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Dmitry<br>
</font></span></blockquote></div><br></div>

--0000000000007e0a350571fde1eb--
