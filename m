From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [PATCH] linux tproxy support
Date: Mon, 3 Jun 2002 17:58:15 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020603155815.GA27696@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I've released my new release of the Linux transparent proxy patch. It is
available at:

http://www.balabit.hu/en/downloads/tproxy/

or 

http://www.balabit.hu/downloads/tproxy/linux-2.4/cttproxy-2.4.18-02.tar.gz

It features:
* test programs for listening on/connecting from foreign addresses (TCP)
* a kernel patch against vanilla 2.4.18
  (it includes my last ICMP translation fix)

I've included the README file, which outlines its use below.

TODO:
* when the socket is closed, the entry assigned to the socket should be
  deleted. Sadly the only solution is to patch the core to notify tproxy
  about this event, so the assigned entry can be deleted.
* receiving UDP packets on a foreign address should work, but sending from
  foreign address doesn't work, as it also needs heavy patching in the
  kernel.

README:

How it works?
-------------

Within the tproxy module in the kernel there's a table describing the
relationship between local sockets and non-local IP address/port pairs. A
local socket is referenced by its local IP/port, therefore all sockets to be
used for transparent proxy purposes must be bound to a local IP prior
anything can be done.

To connect from, or listen on a foreign address an entry to this table must
be added.

To add a translation table entry, create a socket (bind it to a local
interface), and call the setsockopt IP_TPROXY_ASSIGN at level SOL_IP with a
structure describing the nonlocal address (struct in_tproxy).

If this setsockopt succeeds, specify what you want to do with the given
socket, by calling IP_TPROXY_FLAGS with the combination of the bits in
in_tproxy.h:

/* bitfields in IP_TPROXY_FLAGS */
#define ITP_CONNECT  0x00000001
#define ITP_LISTEN   0x00000002
#define ITP_ONCE     0x00010000

ITP_CONNECT means you want to initiate a connection, ITP_LISTEN means you
want to accept connections on the foreign address specified in
IP_TPROXY_ASSIGN.

ITP_ONCE means that this translation is to be performed only once, and then
it should be removed from the table atomically. You usually want to specify
ITP_ONCE with ITP_CONNECT, and may specify ITP_ONCE for listening socket
when only one connection is to be accepted. (FTP data connection for
example)

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
