From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_hashlimit.c: expire's type overflow when showing
 tuples at bad moment.
Date: Tue, 01 Feb 2005 15:20:20 +0100
Message-ID: <41FF9024.3070101@trash.net>
References: <41F2FE92.6020603@cookinglinux.org>
	<20050201132915.GJ6878@sunbeam.de.gnumonks.org>
	<41FF877D.4080309@trash.net>
	<20050201135423.GS6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Samuel Jean <sj-netfilter@cookinglinux.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050201135423.GS6878@sunbeam.de.gnumonks.org>
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

>On Tue, Feb 01, 2005 at 02:43:25PM +0100, Patrick McHardy wrote:
>  
>
>>We also have this problem in ip_conntrack_standalone. I think the best
>>fix would be to use %d for time deltas.
>>
>
>ACK.   we should never have times larger than five days anyway... way
>less than the negative maximum of 32bit.
>
ipt_hashlimit already uses %ld. Samuel, what problem are you seeing 
exactly ?
Is it negative times or wrapped times ?

Regards
Patrick
