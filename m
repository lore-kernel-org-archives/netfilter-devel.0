From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: ct_sync 0.16 released
Date: Tue, 31 Aug 2004 23:23:18 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040831212317.GA12913@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-failover@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

  I've finally completed the recovery code in ct_sync, in theory the code
in CVS should be able to:

  - re-send missing packets to the slaves if the missing packets are
    available in the backlog of the master
  - initiate a complete re-sync if recovery by re-sending packets is
    impossible

  Unfortunately I was able to give it only the most basic testing, so
probably there are a lot of problems with the code. Testers are welcome,
as always. I've created a tarball version of ct_sync as well, so that
checking out the CVS is not the only possible way to get the code. ct_sync
0.16 is available from

  http://people.netfilter.org/hidden/ct_sync/ct_sync-0.16.tar.bz2

or you can check out the ctsync_0_16 revision from the CVS.

  The 0.16 release includes the new connection mark integration code, so
please take the time and read the section of the README file describing
the use of the connmark features. Beginning with 0.16, you have to
explicitly mark conntrack entries to be replicated; the default behaviour
has changed since 0.15.

  Some feedback would be appreciated, especially with respect to the new
recovery features.

-- 
 KOVACS Krisztian
