From: Balazs Scheidler <bazsi@balabit.hu>
Subject: new version of transparency patches released
Date: Tue, 29 Oct 2002 11:26:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021029102601.GA6159@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

I've finally prepared a downloadable version of my transparent proxy
patches. It's been in production on a firewall for a couple of months now,
and it proved to be quite stable, so let's call it a BETA version.

The question is how this could be integrated into netfilter someday? Should
it become a patch-o-matic extension? What about the patchlets touching the
kernel core? Advice on this matter is welcome.

The patch is available at http://www.balabit.hu/en/downloads/tproxy/ (the
link at the end of the page), and is released as a .tar.gz with the
following files:

README		-- a short intro to tproxy
iptables	-- iptables extension (a single TPROXY target, and a tproxy match)
patch_tree	-- a set of files to be applied to a kernel in alphabetical order
		   see details below
tests		-- a couple of test programs to show how to use the
		   functions provided by the patches, these might be
		   somewhat out of date, but should get you started

patch_tree details:

01_origaddrs.diff	-- a patch to make it possible to query the
			   original destination of an UDP packet via recvmsg()
			   This one touches the network core.

02_nfsockrelease.diff	-- This is an extension to nf_sockopts to allow a
			   callback to be called when a socket is released. 
			   It is tightly integrated to the way
			   set/getsockopt calls are delegated.
			   This one also touches the network core slightly.

03_snaticmpfix.diff	-- This is my fix for an SNAT icmp problem, as I
			   reported to this list a couple of times. This
			   should be fixed in stock netfilter as well.
			   (the bug can be triggered w/o this tproxy patch)

04_cttproxy-10.diff	-- the TPROXY patch itself. It defines a new table,
			   and installs a couple of hooks.

The only program I know of with for these patches is Zorp. Zorp GPL 1.4.6 or
above can be configure to run on a patched kernel like this. (Zorp 1.4.x
supports TCP only, Zorp 2 to be released RSN supports both TCP & UDP)

Here are the features I wanted to implement (excerpt from the web page):

Real transparent proxying requires the following three features from the IP stack of the computer it is running on:

   1. Redirect sessions destined to the outer network to a local process
      using a packet filter rule.

   2. Make it possible for a process to listen to connections on a foreign
      address.

   3. Make it possible for a process to initiate a connection with a foreign
      address as a source.

Excerpt from the README file:

How it works?
-------------

Within the tproxy module in the kernel there's a table describing the
relationship between local sockets and a non-local IP address/port pair. A
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
