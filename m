From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix dreaded "Unknown error 4294967295"
Date: Mon, 25 Sep 2006 11:35:45 +0200
Message-ID: <4517A2F1.6040307@trash.net>
References: <200609231343.32610.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, webmaster@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Denis Vlasenko <vda.linux@googlemail.com>
In-Reply-To: <200609231343.32610.vda.linux@googlemail.com>
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

Denis Vlasenko wrote:
> google.com gives 968 hits on 'iptables "Unknown error 4294967295"'.
> 
> The reason is that iptables sets errno
> to error return value of setsockopt(), which is always -1.

Thats already fixed in the current SVN version, which will be released
as 1.3.6 soon.
