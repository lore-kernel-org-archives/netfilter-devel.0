From: "zhaoyao" <zhaoyao@harbournetworks.com>
Subject: Re: Re: READ_LOCK?
Date: Wed, 7 Jan 2004 9:27:14 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E1Ae2Yv-0006R4-Ei@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
 netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte,=C4=FA=BA=C3=A3=A1

Yes,as you know in 2.4 or 2.6, bh is similar to softirq, 
WRITE_LOCK is write_lock_bh(&a)
if u write_lock_bh(&a), obviously other cpu can't enter this=
 critical region, 
but already in softirq, why lock bh again. softirq can't=
 reenter.
so lock bh is not useful.
>On Sun, Jan 04, 2004 at 02:53:03PM +0800, zhaoyao wrote:
>> netfilter-devel,hello!
>> In init_conntrack, why will READ_LOCK or WRITE_LOCK, we'are=
 already in
>> bh, why lock it again?
>
>ip_conntrack is part of netfilter, which in turn is part of the=
 2.4.x
>and 2.6.x kernel.  Both 2.4 and 2.6 kernel series don't have a=
 'bottom
>half' for the network stack anymore.  Instead, softirq's are=
 used.
>Softirq's are fully parallelized, i.e. they can run on any=
 number of
>cpu's simultaneously.
>
>> ????????????????????2004-01-04
>
>-- 
>- Harald Welte <laforge@netfilter.org>            =
 http://www.netfilter.org/
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  "Fragmentation is like classful addressing -- an interesting=
 early
>   architectural error that shows how much experimentation was=
 going
>   on while IP was being designed."                    -- Paul=
 Vixie

=3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D
=09=09=09

=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=D6=C2
=C0=F1=A3=A1
 
=09=09=09=09 
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1zhaoyao
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1zhaoyao@harbournetworks.com
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A12004-01-07
