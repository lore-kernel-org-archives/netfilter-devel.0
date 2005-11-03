From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Fix output of conntrack -L/conntrack -L -i
Date: Thu, 03 Nov 2005 02:22:20 +0100
Message-ID: <4369664C.2070506@eurodev.net>
References: <Pine.LNX.4.63.0511022014570.22508@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.63.0511022014570.22508@bizon.gios.gov.pl>
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
> Attached (and inlined) patch fixes output of conntrack -L/conntrack -L
> -i by removing space character after last field. Now it should be 100%
> compatible with /proc/net/ip_conntrack.

Thanks for the hint. I've applied a different patch to SVN that handles
this issue more cleanly IMHO. Applied together with some pending
changes, please refresh your working copy.

-- 
Pablo
