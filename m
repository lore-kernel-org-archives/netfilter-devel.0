From: "Allain Yoann" <Yoann.Allain@thomson.net>
Subject: RE: [PATCH] IPSec decrypted transport mode packets goes through
	LOCAL_IN
Date: Wed, 4 May 2005 11:19:28 +0200
Message-ID: <9C1918067C3BC14C9C351C206D8A843737301F@rennsmail03.eu.thmulti.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Allain Yoann" <Yoann.Allain@thomson.net>,
	<netfilter-devel@lists.netfilter.org>
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


I hope this ascii art will be better:

+--------------+                            +-----------+
|              |                            |           |
|   SERVER     |                            |  CLIENT   |
|              | IPSec channel only for ftp |           |
|   ftp    =
<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> telnet |
|            | |      transport mode        |           |
|   telnet <-+ |                            |           |
+--------------+                            +-----------+

...=20
Sorry for not being a great ascii artist

Yoann
