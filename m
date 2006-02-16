From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] Fix expectaction mask dumping, take #3
Date: Thu, 16 Feb 2006 21:11:01 +0100
Message-ID: <43F4DC55.8030405@trash.net>
References: <43EFF176.3070505@netfilter.org> <43F44794.1080203@trash.net>
	<20060216100504.GI15587@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060216100504.GI15587@sunbeam.de.gnumonks.org>
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
> On Thu, Feb 16, 2006 at 10:36:20AM +0100, Patrick McHardy wrote:
> 
> 
>>I'm not sure I understand. The new attribute still contains the same
>>value as the netlink header, doesn't it? So userspace should currently
>>have at least two possibilities to get the correct value:
>>
>>- use the value from the netlink header
>>- use the value from the tuple that comes with the mask, as the first
>>  part of your patch does. This seems most logically to me since the
>>  mask and the tuple belong together.
> 
> 
> I still dream about a connection with one end in ipv4 space and the
> other in ipv6.  If we ever want to cover such a model, then the tuple
> needs to include l3num.

Yes, but until then it looks totally redundant. Since the bandwidth
of netlink is limited, I think we shouldn't add new attributes without
really needing them.
