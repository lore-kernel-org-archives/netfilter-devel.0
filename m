From: Patrick McHardy <kaber@trash.net>
Subject: iptables extension removal
Date: Mon, 11 Dec 2006 20:20:53 +0100
Message-ID: <457DAF95.2050203@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090502070305050004050702"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------090502070305050004050702
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

We have decided to remove extension for obsolete/out-of-tree
patches from iptables, moving the extensions for patches
maintained in pom or external repositories to the individual
patchlets and deleting the rest.

Attached is the list of affected extensions. The only one
belonging to an externally maintained patch is connlimit, the
others are all either obsoleted or belong to patches that have
already been deleted.

I'll take care of the pom extensions in the next time. For
anyone interested in maintaining an extension externally, just
add the extension and all required files to a new directory
"iptables" below the patchlet directory and send us the URL.
I'll keep the non-pom extensions around for a month before
deleting them.


--------------090502070305050004050702
Content-Type: text/plain;
 name="list"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="list"

libip6t_condition.c		keep for now, might get merged soon
libip6t_fuzzy.c			delete
libip6t_nth.c			delete
libip6t_random.c		delete
libip6t_ROUTE.c			move to pom
libip6t_TRACE.c			delete
libipt_account.c		delete
libipt_BALANCE.c		delete
libipt_childlevel.c		delete
libipt_condition.c		keep for now, might get merged soon
libipt_connlimit.c		patch maintainer/delete
libipt_connrate.c		delete
libipt_dstlimit.c		delete
libipt_FTOS.c			delete
libipt_fuzzy.c			delete
libipt_IPMARK.c			delete
libipt_iprange.c		move to pom
libipt_ipv4options.c		move to pom
libipt_IPV4OPTSSTRIP.c		move to pom
libipt_mport.c			delete
libipt_NETLINK.c		delete
libipt_nth.c			delete
libipt_osf.c			delete
libipt_psd.c			delete
libipt_random.c			delete
libipt_record_rpc.c		delete
libipt_ROUTE.c			move to pom
libipt_rpc.c			delete
libipt_TARPIT.c			move to pom
libipt_TCPLAG.c			delete
libipt_time.c			delete
libipt_TRACE.c			delete
libipt_u32.c			move to pom
libipt_XOR.c			delete

--------------090502070305050004050702--
