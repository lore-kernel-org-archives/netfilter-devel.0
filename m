From: Harald Welte <laforge@netfilter.org>
Subject: [diadon@isfera.ru: Netfilter problem with new 2.4.22]
Date: Tue, 16 Sep 2003 15:48:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030916134802.GB677@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Md/poaVZ8hnGTzuv
Content-Type: multipart/mixed; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--U+BazGySraz5kW0T
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: X-Sieve: cmu-sieve 2.0
Return-path: <linux-kernel-owner+laforge=40gnumonks.org@vger.kernel.org>
Received: from vger.kernel.org ([67.72.78.212])
	by coruscant.gnumonks.org with esmtp (Exim 4.22)
	id 19zDBi-0003ov-1k
	for laforge@gnumonks.org; Tue, 16 Sep 2003 12:36:02 +0200
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S261840AbTIPK1p (ORCPT <rfc822;laforge@gnumonks.org>);
	Tue, 16 Sep 2003 06:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S261841AbTIPK1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2003 06:27:44 -0400
Received: from [80.80.104.119] ([80.80.104.119]:15488 "EHLO ns.ugavia.ru")
	by vger.kernel.org with ESMTP id S261840AbTIPK1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2003 06:27:43 -0400
Received: from isfera.ru (infotecs-gw [80.80.104.116])
	by ns.ugavia.ru (8.12.9/8.12.9) with ESMTP id h8GAhLYx000583
	for <linux-kernel@vger.kernel.org>; Tue, 16 Sep 2003 14:43:21 +0400
Message-ID: <3F66E46D.2060000@isfera.ru>
Date: Tue, 16 Sep 2003 14:22:37 +0400
From: Diadon <diadon@isfera.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.3) Gecko/20030312
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Netfilter problem with new 2.4.22
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
X-Spam-Score: -0.1 (/)

After installing 2.4.22
this chain doesn't work
$IPPROG -A OUTPUT -p tcp --dport 113 -j REJECT --reject-with tcp-reset

On 2.4.21 all works fine
In tcpdump on 2.4.21:
14:41:41.752557 somehost.auth > somehost1.32825: R 0:0(0) ack 217583467 
win 0 (DF)

In tcpdump on 2.4.22:
nothing.......


any ideas?

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

--U+BazGySraz5kW0T--

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/ZxSSXaXGVTD0i/8RAhQSAKCP2IvZ40zObOBdwNVOUCKTjhVDxQCgh0RP
OPF+YtdIKwsXlzLnCJ5svu0=
=WxuQ
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--
