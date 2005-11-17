From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
Subject: Re: problems with libnetfilter_conntrack / cntl_test
Date: Thu, 17 Nov 2005 04:21:43 +0100
Message-ID: <200511170421.43664.pluto@agmk.net>
References: <200511161439.04498.pluto@agmk.net>
	<200511161809.25277.pluto@agmk.net> <437BDF1B.1050107@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <437BDF1B.1050107@eurodev.net>
Content-Disposition: inline
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

Dnia czwartek, 17 listopada 2005 02:38, Pablo Neira napisa=C5=82:
> Pawe=C5=82 Sikora wrote:
> > Dnia =C5=9Broda, 16 listopada 2005 16:44, napisa=C5=82e=C5=9B:
> >>Pawel Sikora wrote:
> >>>I have installed a 2.6.14.2 kernel + grsecurity-2.1.7-2.6.14.2-$late=
st,
> >>>libnfnetlink-0.0.13 and libnetfilter_conntrack-0.0.28.
> >>>
> >>>./ctnl_test fails:
> >>>
> >>>Test for libnetfilter_conntrack
> >>>
> >>>NFNETLINK answers: Invalid argument
> >>>TEST 1: create conntrack (-22)
> >>>TEST 2: dump conntrack table and reset (-22)
> >>>TEST 3: dump conntrack table (-22)
> >>>TEST 4: get conntrack (-22)
> >>>TEST 5: update conntrack (-22)
> >>>NFNETLINK answers: Invalid argument
> >>>TEST 6: delete conntrack (-22)
> >>>nfnl_open: bind(netlink): Operation not permitted
> >>>Can't open handler
> >>>Test failed with error -2. Errors=3D7
> >>>
> >>>Is this a grsec issue?
> >>
> >>Hard to say, my last contact with grsec was years ago. That output is
> >>kind of weird. Could you try reverting the grsec patch?
> >
> > currently I get the same error on 2.6.14.2 without grsec on root acco=
unt.
> > first failure occurs at first call of nfnl_talk().
>
> There's nothing wrong in nfnl_talk. It is the kernel that is returning
> -EINVAL to userspace. (...)

sorry for the noise, /me is brainless :)
`modprobe ip_conntrack_netlink` solved problem.

--=20
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke
