From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Transparent proxying patch update in POM-NG
Date: Mon, 07 Jun 2004 15:23:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1086614615.1863.17.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

  Thanks to Jozsef Kadlecsik, the tproxy patch has been updated to 1.9.6
in pom-ng. Now pom-ng is in sync with the latest tproxy version.

  There were some important fixes:

- related conntracks are registered only when they're confirmed
- it is possible to share mark-only sockrefs: more than one socket bound
to the same local address can be assigned as mark-only
- dereferencing of related connections is fixed

  Warning: The 1.9.x branch is a development version of tproxy, and is
not binary compatible with 1.2.x.

  As always, any feedback would be highly appreciated.

-- 
 Regards,
   Krisztian KOVACS
