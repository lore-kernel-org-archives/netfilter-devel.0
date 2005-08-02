From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/7] Fix expectation leak
Date: Tue, 02 Aug 2005 23:45:38 +0200
Message-ID: <42EFE982.5030702@trash.net>
References: <42EE5633.9030307@eurodev.net> <42EE57EF.4070807@trash.net>
	<42EE5EC4.5090303@eurodev.net> <42EE7D92.5020401@trash.net>
	<42EF699E.9060901@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42EF699E.9060901@eurodev.net>
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
> Patrick McHardy wrote:
> 
>> Pablo Neira wrote:
>>
>>> Yes, but the refcount is incremented twice ;). Please apply.
>>
>>
>> There is one reference for the list and one for the timer. Both are
>> needed since the timer deletion can race with the timer. The one
>> for the list is dropped in __ip_ct_expect_unlink_destroy, the one
>> for the timer after it has been successfully removed.
> 
> 
> OK, in that case the following patch should fix the hung that I'm
> experimenting while trying to remove ip_conntrack. It happens if there's
> an expectation pending to be confirmed. It seems that we forgot to drop
> the refcount when removing a conntrack the list, unlink_expect doesn't
> actually do it. So, in this case the correct call must be
> __ip_conntrack_expect_unlink_destroy instead of unlink_expect.

Seems like you missed a few. Whenever del_timer succeeds we need one
expect_put for the timer and need to call the reference-dropping
variant of unlink_expect. In the expectation timer we need to call
this variant too. This doesn't leave a single case where we use
the other one, so please add the expect_put to unlink_expect.
