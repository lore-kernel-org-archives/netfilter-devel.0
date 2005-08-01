From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/7] Fix expectation leak
Date: Mon, 01 Aug 2005 21:52:50 +0200
Message-ID: <42EE7D92.5020401@trash.net>
References: <42EE5633.9030307@eurodev.net> <42EE57EF.4070807@trash.net>
	<42EE5EC4.5090303@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
        Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42EE5EC4.5090303@eurodev.net>
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

Pablo Neira wrote:
> Yes, but the refcount is incremented twice ;). Please apply.

There is one reference for the list and one for the timer. Both are
needed since the timer deletion can race with the timer. The one
for the list is dropped in __ip_ct_expect_unlink_destroy, the one
for the timer after it has been successfully removed.
