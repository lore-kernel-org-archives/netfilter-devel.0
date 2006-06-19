From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] entry_data
Date: Mon, 19 Jun 2006 19:34:47 +0200
Message-ID: <4496E037.2000706@trash.net>
References: <200606050029.08602.max@nucleus.it> <448FD0F6.3010506@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <448FD0F6.3010506@anduras.de>
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

Sven Anders wrote:
> Massimiliano Hofer schrieb:
> 
>>Hi,
>>here is my proposed patch for an API change that supports entry specific data.
>>
>>As explained in my previous posts the purpose of this patch is to give matches 
>>the opportunity to store entry specific data. Several matches already achieve 
>>this reserving some space in the data fields, but these come from userspace 
>>and I don't think it is the Right Way(TM) to do it.
> 
> 
> Does this mean we can reuse these fields for other puroposes without breaking
> compatibility with iptables?

Yes, userspace ignores these fields. I still haven't really made up my
mind about this patch yet. I don't like the void ** approach very much,
but I didn't got around to thinking about something better yet. Please
stay patient with me :)

> I'm particularly interested in adding a negation to the "limit" match and I
> think the match is using one of these special data fields...
> 
>  > /* Ugly, ugly fucker. */
>  >  struct xt_rateinfo *master;
> 
> If this gives us the possibility to add the negation, who do we distinguish
> between the old and new limit version. In other words: Who do we reach a maximum
> compatibility?

IIRC userspace zeroes this field, so you could just do the usual
"0 -> no inversion, 1 -> inversion" thing and it would behave
correctly for both old and new userspace. But you need check
yourself if this is indeed true, I'm not really sure.
