From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: H.323 helper: fix sequence extension parsing
Date: Tue, 23 May 2006 11:20:06 +0200
Message-ID: <4472D3C6.6020305@trash.net>
References: <44719685.6000906@trash.net>
	<BAY109-DAV65DAA6039C77B3C71892DB39B0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jing Min Zhao <zhaojingmin@users.sourceforge.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV65DAA6039C77B3C71892DB39B0@phx.gbl>
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

Jing Min Zhao wrote:
> This is really a stupid bug. Thank you, Patrick.
> 
>> Doesn't really fix the crash I was seeing, but does hide it away :)
> 
> 
> Can you please explain why? As I understand, it should've fixed
> the crash.

I think the reason why it make the crash go away is because the
packets contained a long stream of malformed unknown extensions.
When the son pointer went past the array of field_t elements it
hit the next array, which contained elements marked STOP, so it
aborted parsing and didn't got to the point where it would have
noticed the malformed extensions. By changing it not to run past
the array it aborted properly, hiding the real reason for the
crash (my other patch).
