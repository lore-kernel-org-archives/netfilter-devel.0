From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_hashlimit.c: expire's type overflow when showing
 tuples at bad moment.
Date: Tue, 01 Feb 2005 14:43:25 +0100
Message-ID: <41FF877D.4080309@trash.net>
References: <41F2FE92.6020603@cookinglinux.org>
	<20050201132915.GJ6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Samuel Jean <sj-netfilter@cookinglinux.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050201132915.GJ6878@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>On Sat, Jan 22, 2005 at 08:32:02PM -0500, Samuel Jean wrote:
>
>>Name: Expire's type overflow when showing tuples at bad moment.
>>Status: Tested under Linux 2.6.6 uml patched.
>>Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
>>
>>When garbage collector runs slow enough, we have a chance to print
>>expired tuples before they get freed. We see weird expiry time.
>>
>
>Thanks.  Patrick, please put this patch in your pending queue.
>
We also have this problem in ip_conntrack_standalone. I think the best
fix would be to use %d for time deltas.

Regards
Patrick
