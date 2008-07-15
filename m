From: "wang feng" <feng.wangs@gmail.com>
Subject: wrong result with conntrack_create, expect_create
Date: Tue, 15 Jul 2008 10:29:01 +0200
Message-ID: <6cb26d8b0807150129m30c71f89o4def08f1623d287d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:55857 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbYGOI3C convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:29:02 -0400
Received: by rv-out-0506.google.com with SMTP id k40so5882118rvb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Jul 2008 01:29:01 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
I have done some test based on the libnetfilter_conntrack-0.0.96,someth=
ing is
wrong with the samples under utils:

conntrack_create:
 TEST: create conntrack (0)(Success)
it should create a conntrack with src:1.1.1.1, dst:2.2.2.2
but: conntrack_get:
ipv4     2 tcp      6 98 src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D=
0 packets=3D0
bytes=3D0 [UNREPLIED] src=3D0.0.0.0 dst=3D0.0.0.0 sport=3D0 dport=3D0 p=
ackets=3D0 bytes=3D0
mark=3D0 use=3D2

expect_create:
TEST: add master conntrack (0)(Success)
TEST: create expectation (-1)(Invalid argument)

I have debugged, the parameters passed to the api are not wrong, someth=
ing in
nflink(nfnl_query) perhaps not works...

see also bug#548,someone can help me to debug to see what happen with
it? thanks...

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
