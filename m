From: Patrick McHardy <kaber@trash.net>
Subject: Lost patches
Date: Fri, 12 May 2006 09:27:41 +0200
Message-ID: <446438ED.3080304@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
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

I have the ungood feeling that I somehow managed to loose a couple
of patches I had originally queued for 2.6.17 but then delayed them
to 2.6.18. I couldn't find anything in the archives, but if anyone
has sent me patches that aren't already in mainline and are not in
the list below please resend or point me to the first submission.
Thanks.


Eric Leblond:
      [NETFILTER]: conntrack: add fixed timeout flag in connection tracking

Patrick McHardy:
      [NETFILTER]: Remove some useless casts
      [NETFILTER]: {ip,nf}_conntrack_ftp: small optimization
      [NETFILTER]: NAT: avoid unnecessary tuple inversions
      [NETFILTER]: x_tables: add SCTP/DCCP support to
hashlimit/multiport/CLUSTERIP
      [NETFILTER]: {ip,nf}_conntrack: make checksumming optional
      [NETFILTER]: x_tables: add quota match
      [NETFILTER]: ctnetlink: fix NAT configuration
      [NETFILTER]: ctnetlink: fix conntrack mark change notifications
      [NETFILTER]: x_tables: add statistic match
      [NETFILTER]: ctnetlink: change table dumping not to require an
unique ID
