From: Balazs Scheidler <bazsi@balabit.hu>
Subject: oops in replace_in_hashes
Date: Fri, 25 Jul 2003 10:57:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725085731.GA5776@balabit.hu>
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

I've stumbled into a similar oops in replace_in_hashes  that somebody else
has already reported. It was suggested to move to 2.4.21 but it still
Oopses. It was also suggested to use the latest netfilter patches from
patch-o-matic, because a refcounting bug was introduced in 2.4.21.

I checked out those patches and it seemed to me that they are only relevant
if conntrack and/or nat helpers are in use.

In our situation we do not have _any_ helpers loaded, only TPROXY generates
dynamic NAT mappings as they are needed. Is it possible that the reference
counting problem affects us?

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
