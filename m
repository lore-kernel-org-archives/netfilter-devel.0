From: Samuel =?iso-8859-1?Q?D=EDaz_Garc=EDa?= <samueldg@arcoscom.com>
Subject: Re: Patch-o-matic cleanup
Date: Tue, 4 Apr 2006 10:54:43 +0200 (CEST)
Message-ID: <40106.195.55.244.106.1144140883.squirrel@www.arcoscom.com>
References: <443165AA.4030509@trash.net>
Reply-To: samueldg@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <443165AA.4030509@trash.net>
To: "Patrick McHardy" <kaber@trash.net>
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

Patrick, after the last "cleanup" (18/9/2005?), many patches were removed
and 2.4/2.6 compatibility broken, for example the "condition" match over
2.6 or CONNMARK over 2.4.

I think, that if devteam are going to invert time to "cleanup" pomng,
would be fantastic that old ussefull and broken patches (or teorically
merged into kernel main base) must be reviewed.

For example, you put pptp_conntrack to be deleted, but I used it into 2.4
kernel versions, where it isn't into mainline.

That are the ticks I think you will need to take care of.

Good work, regards.

-- 
Samuel Díaz García
ArcosCom Wireless, S.L.L.

CIF: B11828068
c/ Romero Gago, 19
Arcos de la Frontera
11630 - Cadiz

http://www.arcoscom.com

mailto:samueldg@arcoscom.com
msn: samueldg@arcoscom.com

Tlfn.: 956 70 13 15
Fax:   956 70 34 83


El Lun, 3 de Abril de 2006, 20:12, Patrick McHardy escribió:
> Following (quite late) the decision taken at the netfilter workshop to
> clean up the pomng repository by removing old patches and moving some
> patches out of the netfilter repository, I've started by removing the
> obsolete ipsec* patches and the policy match. Both have been merged
> and were pretty outdated.
>
> If noone can name good reasons against it, I will also remove the
> following patches in a few days:
>
> - NETLINK: obsolete
> - NETMAP: in mainline for a long time
> - TRACE: don't recall the reason, but its on my list :)
> - comment: in mainline
> - conntrack_locking: seriously outdated, if someone wants to resurrect
>   this patch he can use the history
> - dropped_table: also don't recall the reason
> - goto: in mainline
> - ipq_vmark: obsoleted by nfnetlink_queue
> - mport: mainline multiport supports all of its features
> - netfilter-docbook: outdated
> - owner-socketlookup: unfixable broken
> - pool: obsoleted by ipset
> - pptp-conntrack-nat: in mainline now, patches are missing critical
>   fixes
> - unclean: bad idea
>
>
