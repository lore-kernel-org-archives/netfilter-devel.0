From: Philipp =?iso-8859-1?q?G=FChring?= <pg@futureware.at>
Subject: Table-based branching
Date: Mon, 5 Apr 2004 15:08:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404051508.15935.pg@futureware.at>
Reply-To: pg@futureware.at
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
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

Hi!

I am working on a scalable captive Portal Gateway software.
I have several huge networks (/20) that have to be managed individually per=
 IP=20
address.
=46or every IP adress I have to store in a table, whether that IP Address i=
s=20
allowed or not yet allowed.
When an IP address is allowed, it either has to be router or NATed, dependi=
ng=20
on the network address.

When an IP address is not allowed, all Traffic has to be redirected to the=
=20
captive portal on the firewall.

My idea now is to have different rule tables for allowed and disallowed IP=
=20
addresses, and special kernel module that branches into either rule table.
That module contains a large Bit-Array in kernel memory to store for every =
IP=20
addresse whether it is allowed or disallowed.

Has anyone done that before (or something similar)?

Is it a bad idea to do it that way?

Many greetings,
Philipp G=FChring
