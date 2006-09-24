From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ip_conntrack_tuple and marks
Date: Sun, 24 Sep 2006 05:14:00 +0200
Message-ID: <4515F7F8.9030000@netfilter.org>
References: <451448A9.6000407@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <451448A9.6000407@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> Hi,
> 
> is it possible to add a nfmark field to ip_conntrack_tuple
> so that only packets with a certain mark set are matched to
> a connection? I'm trying to filter/nat multiple independent
> connections with same ip/proto/port tuples on both sides
> and the only distinguishing property of the different
> connections is their nfmark. Using NOTRACK doesn't help
> because it can only exclude packets from tracking, not
> match packets to different expectations.

Could the connmark match/target be what you need?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
