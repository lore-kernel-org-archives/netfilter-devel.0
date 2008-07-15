From: "wang feng" <feng.wangs@gmail.com>
Subject: some way to use NF_CT_EXPECT_PERMANENT in userspace
Date: Tue, 15 Jul 2008 18:34:41 +0200
Message-ID: <6cb26d8b0807150934u14798afaj9c4be6472091b116@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:39233 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373AbYGOQen convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:34:43 -0400
Received: by rn-out-0910.google.com with SMTP id k40so1569864rnd.17
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Jul 2008 09:34:42 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
from api the attributes we can set for expectation only inclusive
src,dst ip,port, and timeout, but from the kernel code like infunction
"nf_ct_find_expectation" there is  also a structure named
"nf_conntrac_expect" with flags settings with NF_CT_EXPECT_PERMANENT
which enable a permanent expectation, can the userland api in some
ways to enable this feature too?
wbr,
--=20
=46eng Wang
=46akult=E4t 5: Informatik, Elektrotechnik und Informationstechnik
Universit=E4t Stuttgart
Handy: +49 179 1403215
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
