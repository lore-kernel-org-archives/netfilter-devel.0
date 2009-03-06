From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] ulogd 2.0.0beta3
Date: Fri, 06 Mar 2009 19:09:36 +0100
Message-ID: <49B166E0.7030201@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000001070104070304030700"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000001070104070304030700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents:

  * ulogd 2.0.0beta3

ulogd is a userspace logging daemon for netfilter/iptables related
logging. This includes per-packet logging of security violations,
per-packet logging for accounting purpose as well as per-flow logging.

ulogd comes in two flavours: ulogd-1.x has been around since 2000 and is
the stable series. All production systems should use the stable series
at this time. The 1.x series are frozen, do not expect new features into
this line. ulogd-2.x is currently in beta stage.

You can download them from:

http://www.netfilter.org/projects/ulogd/downloads.html
ftp://ftp.netfilter.org/pub/ulogd/

Regards,
Pablo

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------000001070104070304030700
Content-Type: text/plain;
 name="ChangeLog-ulogd-2.0.0beta3"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog-ulogd-2.0.0beta3"

Eric Leblond (32):
      NFLOG: remove unused option
      doc: update ulogd SGML documentation
      doc: update author credits and fix reference to closed ML
      config: remove obsolete global variables
      Modify usage of nflog_bind_pf function.
      Get rid of addressfamily variable in NFLOG input plugin
      Document group 0 usage and suppress address_family
      Add SCTP support to BASE plugin.
      SCTP support for PRINTPKT.
      Add SCTP support to MySQL and PGSQL output.
      Treat nice function return.
      Fix stop function of NFCT plugin.
      Don't free pluginstance when leaving
      Fix minor memory leak in NFLOG plugin.
      Call pluginstance stop function when exiting
      Add SIGINT to list of terminal signal.
      Unload plugins when quitting.
      Introduce config_stop() function
      Free stacks when exiting.
      Fix memory leak in destructor_nfct().
      Add valgrind compilation option.
      Add variable to force binding of nfnetlink_log.
      fix config file: MAC2STR has been renamed to HWHDR.
      Display logfile to check in case of error.
      Fix crash on IPv6 packet.
      HWHDR: Fix size of allocated string.
      Replace INCLUDES by AM_CPPFLAGS in Makefile.am.
      Display which keys are optional in info mode.
      Explicitely type PCAP input key.
      Add threshold and timeout option to NFLOG plugin.
      pgsql: fix type of mac_protocol and oob_protocol.
      Delete timer in destructor function.

Jan Engelhardt (5):
      build: compile fix
      Update .gitignore and remove install-sh
      build: use -avoid-version for modules
      build: resolve autotools suggestions to use AC_CONFIG_MACRO_DIR
      build: update configure.ac

Pablo Neira Ayuso (4):
      doc: update ulogd man-page
      NFCT: remove unused constant NFLOG_RMEM_DEFAULT
      add ukey_* function for key assignation
      build: bump version to 2.00beta3

Pierre Chifflier (13):
      hwhdr: fix segfault when RAW_MAC is NULL
      hwhdr: finish missing renaming
      pgsql: remove useless checkings
      Fix light memory error in parse_mac2str
      Link ulogd2 with libpthread
      Search for libdbi includes during configure
      Add new output plugin DBI
      PostgreSQL schema: drop useless constraints
      Allow plain INSERT instead of procedure
      DBI: lower column name before comparing to key
      PostgreSQL: allow local connections
      Flat SQL schema for PostgreSQL
      Flat SQL schema for MySQL

Thomas Jacob (1):
      Return true/false instead of ULOGD_IRET_OK/STOP


--------------000001070104070304030700--
