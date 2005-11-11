From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ip_conntrack_netlink & nf_conntrack
Date: Fri, 11 Nov 2005 14:33:02 +0100
Message-ID: <43749D8E.8070501@eurodev.net>
References: <Pine.LNX.4.64.0511111417130.7120@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0511111417130.7120@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> Since we now have nf_conntrack included in 2.6.15 and
> ip_conntrack_netlink is a part of ip_conntrack, I'm wonder if there are
> any plans for porting ip_conntrack_netlink into nf_conntrack
> (nf_conntrack_netlink)?

Yes. I'll post a patch of such porting soon.

-- 
Pablo
