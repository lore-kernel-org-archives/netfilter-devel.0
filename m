From: Patrick McHardy <kaber@trash.net>
Subject: nf_conntrack tree
Date: Wed, 16 Mar 2005 01:35:32 +0100
Message-ID: <42377F54.8070408@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
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

I'm working on getting nf_conntrack ready for submission. To make it
easier for people to participate, I've exported my tree through
bitkeeper and as plain patch. It currently contains nf_conntrack as
found in pomng plus a couple of ported ip_conntrack fixes:

bk://numenor.coreworks.de/nf-2.6-nfct
http://numenor.coreworks.de/~kaber

The tree and the diff will be kept up-to-date when changes are made.

In my opinion the most important issue at this time is making
ip_conntrack matches and targets work properly with nf_conntrack and
adding their IPv6 equivalents. Before doing the IPv6 part, I would like
to get sorted out if we can share the IPv4 matches/targets between
ip_conntrack and nf_conntrack.

Regards
Patrick
