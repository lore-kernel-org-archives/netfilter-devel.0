From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/7] Fix a deadlock in new_conntrack
Date: Mon, 01 Aug 2005 19:21:07 +0200
Message-ID: <42EE5A03.8030409@trash.net>
References: <42EE564E.1090308@eurodev.net> <42EE58D7.9010005@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42EE58D7.9010005@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
>>Fix a deadlock during conntrack creation. ip_conntrack_lock is unlocked
>>twice.
> 
> 
> Please keep the exit paths at the end by adding a out: label.

Don't bother, they aren't at the end right now :)
