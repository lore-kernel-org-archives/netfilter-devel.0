From: Harald Welte <laforge@netfilter.org>
Subject: [BUG] Netfilter ipt_owner deadlock
Date: Mon, 17 May 2004 09:02:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040517070258.GD26147@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PHCdUe6m4AxPMzOu"
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


--PHCdUe6m4AxPMzOu
Content-Type: multipart/mixed; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline


--vEao7xgI/oilGqZ+
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

--vEao7xgI/oilGqZ+
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: Received: from ganesha.gnumonks.org ([unix socket])
	by ganesha (Cyrus v2.1.15-IPv6-Debian-2.1.15-0woody.1.0) with LMTP; Fri, 14 May 2004 17:21:59 +0200
X-Sieve: CMU Sieve 2.2
Return-path: <linux-net-owner@vger.kernel.org>
Received: from vger.kernel.org ([12.107.209.244])
	by ganesha.gnumonks.org with esmtp (Exim 4.30)
	id 1BOeVb-000894-K3
	for laforge@gnumonks.org; Fri, 14 May 2004 17:21:59 +0200
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S261610AbUENPU3 (ORCPT <rfc822;laforge@gnumonks.org>);
	Fri, 14 May 2004 11:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S261606AbUENPU2
	(ORCPT <rfc822;linux-net-outgoing>); Fri, 14 May 2004 11:20:28 -0400
Received: from websrv.werbeagentur-aufwind.de ([213.239.197.241]:60870 "EHLO
	mail.werbeagentur-aufwind.de") by vger.kernel.org with ESMTP
	id S261576AbUENPTL (ORCPT <rfc822;linux-net@vger.kernel.org>);
	Fri, 14 May 2004 11:19:11 -0400
Received: (qmail 7241 invoked by uid 1003); 14 May 2004 17:19:09 +0200
Received: from christophe@saout.de by websrv.werbeagentur-aufwind.de by uid 201 with qmail-scanner-1.20
 (clamuko: 0.70. spamassassin: 2.63.  Clear:RC:0(217.224.55.134):SA:0(-1.2/6.0):.
 Processed in 1.379949 secs); 14 Mai 2004 15:19:09 -0000
X-Spam-Status: No, hits=-1.2 required=6.0
Received: from pd9e03786.dip.t-dialin.net (HELO mail.cs.pocnet.net) (smtp@werbeagentur-aufwind.de@217.224.55.134)
  by websrv.werbeagentur-aufwind.de with AES256-SHA encrypted SMTP; 14 May 2004 17:19:08 +0200
Received: (qmail 22865 invoked from network); 14 May 2004 17:19:06 +0200
Received: from leto.cs.pocnet.net (192.168.80.6)
  by server.cs.pocnet.net with RC4-MD5 encrypted SMTP; 14 May 2004 17:19:06 +0200
Subject: [BUG] Netfilter ipt_owner deadlock
From: Christophe Saout <christophe@saout.de>
To: linux-net@vger.kernel.org
Content-Type: text/plain
Message-Id: <1084547945.16207.5.camel@leto.cs.pocnet.net>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.5.7 
Date: Fri, 14 May 2004 17:19:05 +0200
Content-Transfer-Encoding: 7bit
Sender: linux-net-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-net@vger.kernel.org
X-Spam-Score: -4.3 (----)

Hi,

there's a nasty problem with the ipt_owner netfilter code:

It does a spin_lock(&files->file_lock), sometimes from softirq context.
This can lead to deadlocks on SMP systems. The lock must not be taken
from softirq context because the rest of the kernel doesn't use
spin_lock_bh.

On a UP machine (that had an SMP compiled kernel) the machine repeatedly
locked up after approx. five minutes. SysRQ shows backtraces like fput
-> timer interrupt -> softirq -> ipv4 -> netfilter -> ipt_owner -> hang.

I don't see a clean solution for this (except for changing all the
spin_locks to spin_lock_bhs which I think is way too aggressive).

Any ideas?


-
To unsubscribe from this list: send the line "unsubscribe linux-net" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--vEao7xgI/oilGqZ+--

--PHCdUe6m4AxPMzOu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAqGOhXaXGVTD0i/8RAp/FAJ9CFQ5Cx40iSTc6c09i3st/hpDyQACdETmB
tQNC3583eNLGhBGIwLahSPE=
=8wkV
-----END PGP SIGNATURE-----

--PHCdUe6m4AxPMzOu--
