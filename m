From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH 1/4] TCPMSS: dont drop packets
Date: Thu, 25 May 2006 09:42:39 +1000
Message-ID: <4474EF6F.8060102@snapgear.com>
References: <20060524040441.111049000@snapgear.com>	<20060524040950.838105000@snapgear.com>
	<447486FA.8010206@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <447486FA.8010206@trash.net>
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

On 05/25/2006 02:16 AM, Patrick McHardy wrote:
> philipc@snapgear.com wrote:
>> The test case that caused problems was syn packet containing data.
> 
> That seems to be an invalid testcase.

I'm not sure if any stacks send or accept this in practice, but it is
allowed by RFC 793, see second paragraph in section 3.4.  Please correct
me if this is no longer valid.


> I don't think its a good idea to change this long standing behaviour.
> The next incarnation of iptables will support user-supplied verdicts
> for non-terminal targets, but until then it seems reasonable to say
> "user said do x, can't do it, so drop".

Sounds reasonable to me.
