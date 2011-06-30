From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter queue throughput slowdown
Date: Thu, 30 Jun 2011 17:15:00 +0200
Message-ID: <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
	 <1309340843.2532.112.camel@edumazet-laptop>
	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
	 <1309342096.2532.116.camel@edumazet-laptop>  <4E0C15A3.9050609@yandex.ru>
	 <1309416426.2532.119.camel@edumazet-laptop>  <4E0C278B.7010403@yandex.ru>
	 <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4E0C651A.1000300@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kuzin Andrey <kuzinandrey@yandex.ru>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64329 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1F3NPA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:15:00 -0400
Received: by wyg8 with SMTP id 8so1534595wyg.19
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jun 2011 06:14:59 -0700 (PDT)
In-Reply-To: <4E0C651A.1000300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 30 juin 2011 =C3=A0 13:59 +0200, Patrick McHardy a =C3=A9crit =
:

> Thanks Eric, I agree. Give us data and we'll fix it if really is a bu=
g.
>=20
> The fact that the timeout patch apparently helps indicates that some
> packets don't receive verdicts.

My rough guess is that this user application gets an error in its
nfq_set_verdict() call ( maybe a transient out of memory indication) an=
d
packet never gets its verdict.

libnetfilter_queue/utils/nfqnl_test.c is buggy in this regard : It
should at least log an error if nfq_set_verdict() fails, so that
programmer using nfqnl_test.c as a template is aware of a possible
problem here.


 utils/nfqnl_test.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index a554f2d..b7e0cf9 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -69,8 +69,13 @@ static int cb(struct nfq_q_handle *qh, struct nfgenm=
sg *nfmsg,
 	      struct nfq_data *nfa, void *data)
 {
 	u_int32_t id =3D print_pkt(nfa);
+	int res;
+
 	printf("entering callback\n");
-	return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
+	res =3D nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
+	if (res =3D=3D -1)
+		printf("nfq_set_verdict() error %d (packet stuck in queue !)\n", err=
no);
+	return res;
 }
=20
 int main(int argc, char **argv)


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
