From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Delete nfcache use in ip_table
Date: Fri, 06 May 2005 17:24:38 +0200
Message-ID: <427B8C36.4060000@trash.net>
References: <427A469D.8030305@eurodev.net> <427A49F6.2090607@trash.net>
	<427AB976.8040402@eurodev.net>
	<427B151F.4040101@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <427B151F.4040101@outerspace.dyndns.org>
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

Jonas Berlin wrote:
> Would it be possible (and would it make sense) using #ifdefs to only
> have those NFC_* visible to userspace? Or would that break something too?

Possible sure (#ifndef __KERNEL__), but what would the gain be?

Regards
Patrick
