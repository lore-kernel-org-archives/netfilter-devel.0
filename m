From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH NF_CONNTRACK 1/9]: Fix multiple problems with TCP
 window tracking
Date: Tue, 24 May 2005 10:53:02 +0900 (JST)
Message-ID: <200505240153.j4O1r3aa008625@toshiba.co.jp>
References: <200505230617.j4N6HROa027617@toshiba.co.jp>
	<200505231546.58751.michal@rokos.info>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: michal@rokos.info
In-Reply-To: <200505231546.58751.michal@rokos.info>
	<42377F54.8070408@trash.net>
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


Hi, Michal,

From: Michal Rokos <michal@rokos.info>
Date: Mon, 23 May 2005 15:46:58 +0200

> Hello,
> 
> >>>>> "YK" == Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> writes:
> YK>
> YK> This patch follows the recent changes to ip_conntrack.
> YK>
> 
> could I ask you against what is this patch?
> 
> I'm using 
> http://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/nf_conntrack and 
> I'm getting rejects when applying this patch...

Patrick prepared bk tree for submission as follows and I have been
sending patches to him since then to avoid duplicated work and
inconsistency between svn and his tree.

From: Patrick McHardy <kaber@trash.net>
Subject: nf_conntrack tree
Date: Wed, 16 Mar 2005 01:35:32 +0100

> I'm working on getting nf_conntrack ready for submission. To make it
> easier for people to participate, I've exported my tree through
> bitkeeper and as plain patch. It currently contains nf_conntrack as
> found in pomng plus a couple of ported ip_conntrack fixes:
> 
> bk://numenor.coreworks.de/nf-2.6-nfct
> http://numenor.coreworks.de/~kaber
> 
> The tree and the diff will be kept up-to-date when changes are made.

In this time, I applied
	http://numenor.coreworks.de/~kaber/nf_conntrack-03052005_01.diff

to cloned linus tree at 2005/05/22 00:37(JST: +9:00) before making their
patches.

Which tree should I try to keep to update ?

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
