From: Patrick McHardy <kaber@trash.net>
Subject: Re: masquerade & ipsec
Date: Wed, 05 Jul 2006 18:51:11 +0200
Message-ID: <44ABEDFF.5010005@trash.net>
References: <44A6FDDE.8050805@seclark.us> <44ABDC15.9050606@trash.net>
	<44ABE469.7000001@seclark.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen.Clark@seclark.us
In-Reply-To: <44ABE469.7000001@seclark.us>
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

Stephen Clark wrote:
> Patrick McHardy wrote:
> 
>> You can use the policy match to exclude the packets that should
>> be handled by IPsec from masquerading. Or simple do it by
>> address.
>>
>>  
>>
> Thanks for the response.
> 
> I figured out how to do during the time between my post 7/1/06 and when
> it showed on list 7/5/06 ( can anyone tell me why it takes so long for
> post to the netfilter-devel list, when I post to linux-kernel it shows
> up within a few minutes ).

As a non-subscriber your posts are held until the list moderator
approves them. Usually he's pretty quick.

> When I worked for Data General we used call this the UTF ( Universal
> Time Filter ) hopefully
> the customer had figured out his problem by the time we got back to him.

:)
