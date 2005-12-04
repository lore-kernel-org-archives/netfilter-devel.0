From: Patrick McHardy <kaber@trash.net>
Subject: Re: SNAT from multiple interfaces with the same IP?
Date: Mon, 05 Dec 2005 00:41:25 +0100
Message-ID: <43937EA5.9000004@trash.net>
References: <4392E148.7010102@gmx.net> <43930BEF.9000602@trash.net>
	<20051204153729.GA5617@eychenne.org> <43931301.1040109@trash.net>
	<20051204233557.GB5617@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20051204233557.GB5617@eychenne.org>
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

Herve Eychenne wrote:
> On Sun, Dec 04, 2005 at 05:02:09PM +0100, Patrick McHardy wrote:
> 
>>- The incoming interface is not known anymore in POST_ROUTING
> 
> Sorry, but... why? (that was my question indeed)

In the input path the incoming interface is stored in the skb
in skb->dev. On the output path (POST_ROUTING) it contains the
outgoing interface. This might actually be changeable with not
too much effort, one of my IPsec patches already reorders the
POST_ROUTING hook.

>>- Locally generated packets don't even have an incoming interface
> 
> So what?
> If you could use -i, then locally generated packets wouldn't match
> (that's not a problem because you would do it on purpose).
> If you don't, it would work as it used to till now.

Yes, that wouldn't be problem.
