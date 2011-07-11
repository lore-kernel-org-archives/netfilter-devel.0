From: =?ISO-8859-1?Q?Fran=E7ois?= Delawarde
	<fdelawarde@wirelessmundi.com>
Subject: HFSC warning issue
Date: Mon, 11 Jul 2011 11:26:52 +0200
Message-ID: <1310376412.8036.134.camel@luna.madrid.commsmundi.com>
Reply-To: fdelawarde@wirelessmundi.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.wirelessmundi.com ([91.121.102.180]:47263 "EHLO
	mail.wirelessmundi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1GKJxn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:53:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I'm having the same HFSC issues as described here:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D631945

Some user reports that he made it work by reverting this patch:
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
blobdiff;f=3Dnet/sched/sch_hfsc.c;h=3D47496098d35c2876cd0b5a88e1365922c=
c369ce9;hp=3Dabd904be428717462395d62adb682023e64e17a5;hb=3D3b2eb6131e2f=
6ff646abb0fc69648179b8b70216;hpb=3D9c01ae58d4fee39e2af5b1379ee5431dd585=
cf62


Is this the correct solution? Any "clean" patch I could test that would
resolve this issue?

Thanks,
=46ran=C3=A7ois.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
