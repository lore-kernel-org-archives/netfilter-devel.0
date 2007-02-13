From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/7] Remove debugging messages from nfnetlink
Date: Tue, 13 Feb 2007 11:46:57 +0100
Message-ID: <45D19721.2050209@trash.net>
References: <45D0EE1F.6060400@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45D0EE1F.6060400@netfilter.org>
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

This doesn't apply, it seems like you generated the patches
against a kernel tree without Yoshifuji's whitespace cleanup.
Please rediff and resend (the faster the better if we want
to get this in 2.6.21). I'll just comment on the patches for
now.

Pablo Neira Ayuso wrote:
> [PATCH] Remove debugging messages from nfnetlink
> 
> Remove early debugging messages from nfnetlink

Looks good, I'll also happily apply similar patches for other
netfilter files.
