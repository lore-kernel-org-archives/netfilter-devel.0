From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: ct_sync for Linux 2.6.10
Date: Tue, 11 Jan 2005 00:22:19 +0100
Message-ID: <1105399340.2948.29.camel@krak.odu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter-failover list <netfilter-failover@lists.netfilter.org>
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


  Hi,

  After some more hacking on ct_sync, I've finally committed the Linux
2.6 version to a separate branch in the Netfilter SVN repository. The
README file and the example scripts have been updated to reflect the
numerous changes I've made while doing the porting and some
restructuring. The changes include:

      * some important parameters of ct_sync can be tuned on-the-fly
        using sysctl; the path under /proc has changed as well (see
        README for more information)
      * the required patchset touching core Netfilter parts has been
        substantially simplified (many thanks to Pablo Neira for his new
        per-packet conntrack notifiers patch)
      * loadable module arguments have changed, the only mandatory
        parameter is 'syncdev'
      * the internal NOTRACK hook can be disabled (although this is not
        recommended and may cause severe problems if used without the
        necessary NOTRACK rules in place)

  All the code can be found in the SVN repository at:

  http://svn.netfilter.org/netfilter/branches/netfilter-ha/linux-2.6

or alternatively in my public GNU Arch (tla) archive here:

  http://people.netfilter.org/hidden/archives/2005-public

  To simplify the lengthy and complicated kernel patching procedure
using quilt, I've created a single patch of the current ct_sync snapshot
for Linux 2.6.10, it's available here:

  http://people.netfilter.org/hidden/ct_sync/snapshots/

  As always, I have to point out that this version of ct_sync has had
very limited testing until now, so it's still experimental quality code
not recommended for production systems.

-- 
  Krisztian Kovacs
