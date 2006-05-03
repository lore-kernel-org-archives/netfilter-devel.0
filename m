From: Amin Azez <azez@ufomechanic.net>
Subject: Re: ipt_recent patch
Date: Wed, 03 May 2006 12:41:49 +0100
Message-ID: <445896FD.60409@ufomechanic.net>
References: <dt51lh$b63$1@sea.gmane.org>
	<43F9EA77.4060208@ufomechanic.net>	<44096532.2070000@trash.net>
	<440DAB6B.4020208@ufomechanic.net>	<440ECB1B.4070507@trash.net>
	<4415B019.6050409@ufomechanic.net>
	<20060322142636.GF4474@ns.snowman.net>
	<445878C2.9080400@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <445878C2.9080400@ufomechanic.net>
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

I actually think ipt_recent wants merging with ipt_set, by causing
ipt_set to maintain the insert time and refresh time of each set member.

What do you think? It will require taking the design behind ipt_recents
combine hash/list structure but I would suggest using a linked list
instead of an array to hold the time-ordered list.

Sam

Amin Azez wrote:
> Stephen Frost wrote:
>
>   
>> I don't really see the use-case for these new options...  Perhaps if it
>> was combined with an IP mask of some kind, ie: packets from 5 IPs in the
>> same /24 in the last 60 seconds, or some such.  That could also be
>> accomplished by providing a way to tell ipt_recent to look for a mask
>> instead of individual IPs though.  ie: For this table, consider any IPs
>> in the same /24 to be the 'same' IP.
>>
>> Anyway, they don't really affect how the module works as they just add
>> additional ways to check on the data stored in the tables, so I'm not
>> strongly against them just don't entirely see the point.
>>     
>
>
> I agree that a mask ought also to be supplied, as /32 is equivalent to
> the same-ip anyway.
>
> Are you content to make that modification or do you wish me to?
> I won't be able to do so for  week or two.
>
> Sam
>   
