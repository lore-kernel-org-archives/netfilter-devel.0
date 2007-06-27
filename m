From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] Release libnetfilter_conntrack
Date: Wed, 27 Jun 2007 19:31:52 +0200
Message-ID: <46829F08.6030607@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010206010207070609020600"
Cc: lwn@lwn.net
To: netfilter-announce@lists.netfilter.org,
	netfilter <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------010206010207070609020600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi!

The netfilter project proudly presents libnetfilter_conntrack-0.0.80

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table.

This release includes accumulated bugfixes. See ChangeLog for more
details. Upgrade is recommended.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Happy tracking,

	Pablo (on behalf of the Netfilter Project)

-- 
"Países en desarrollo es el nombre con que los expertos designan a los
países arrollados por el desarrollo ajeno" -- Patas Arriba. La Escuela
del Mundo al Revés -- E. Galeano

--------------010206010207070609020600
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

libnetfilter_conntrack 0.0.80
======================================================================

Changes from 0.0.75:

- fix typo in snprintf_default.c 
	[Jozsef Kladecsik]

- Introduce NFCT_Q_CREATE_UPDATE: create conntrack, if it exists, update it
	[Pablo Neira Ayuso]

- nf[ct|exp]_snprintf behaves as snprintf C99
	[Pablo Neira Ayuso]

- introduce NFCT_SOPT_SETUP_* options to simplify object setup
	[Pablo Neira Ayuso]

- fix silly bug in nfct_getobjopt(..., NFCT_GOPT_IS_*NAT)
	[Pablo Neira Ayuso]

- fix invalid argument error: status flags may not be present in update message
	[Pablo Neira Ayuso]

- add support for 64 bits counters
	[Krzysztof Oledzki]

--------------010206010207070609020600--
