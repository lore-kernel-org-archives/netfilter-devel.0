From: Henrik Nordstrom <hno@marasystems.com>
Subject: nat/conntrack helper locking problem?
Date: Thu, 20 Nov 2003 10:55:09 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311201050350.2112-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Whenever I load/unload the ftp or irc nat/conntrack helpers with NF_DEBUG
enabled in 2.4.22 with current p-o-m base I receive the following warning:

ASSERT ip_conntrack_core.c:632 &ip_conntrack_lock not readlocked
ASSERT ip_conntrack_core.c:632 &ip_conntrack_lock not readlocked

Is this something to worry about or just a corner case which will not 
cause any problems?

Regards
Henrik
