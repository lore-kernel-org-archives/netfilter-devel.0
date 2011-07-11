From: Michal Soltys <soltys@ziu.info>
Subject: Re: HFSC warning issue
Date: Mon, 11 Jul 2011 13:56:33 +0200
Message-ID: <4E1AE4F1.6030905@ziu.info>
References: <1310376412.8036.134.camel@luna.madrid.commsmundi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, 631945@bugs.debian.org,
	kaber@trash.net
To: fdelawarde@wirelessmundi.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tha.ppgk.com.pl ([77.252.116.179]:15614 "EHLO tha.ppgk.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988Ab1GKMCe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2011 08:02:34 -0400
In-Reply-To: <1310376412.8036.134.camel@luna.madrid.commsmundi.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

W dniu 11.07.2011 11:26, Fran=C3=A7ois Delawarde pisze:
> Hi all,
>=20
> I'm having the same HFSC issues as described here:
>=20
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D631945
>=20
> Some user reports that he made it work by reverting this patch:
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
blobdiff;f=3Dnet/sched/sch_hfsc.c;h=3D47496098d35c2876cd0b5a88e1365922c=
c369ce9;hp=3Dabd904be428717462395d62adb682023e64e17a5;hb=3D3b2eb6131e2f=
6ff646abb0fc69648179b8b70216;hpb=3D9c01ae58d4fee39e2af5b1379ee5431dd585=
cf62
>=20
>=20
> Is this the correct solution? Any "clean" patch I could test that wou=
ld
> resolve this issue?
>=20
> Thanks,
> Fran=C3=A7ois.
>=20

Hmmm,

This commit in mention is the patch I submitted=20
a while ago, namely:

http://kerneltrap.org/mailarchive/linux-netdev/2010/8/30/6284141

Whole rationale and short discussion regarding the=20
change is in that thread.=20

In a nutshell - it fixed certain scenario which could cause=20
bursty traffic, but the change is just a minor adjustment. Let=20
me sit a bit on this thing, and why it manages to trigger that=20
warning ...

=46or a quick fix - reverting that commit should be perfectly=20
safe - there were no other patches related to this one.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
