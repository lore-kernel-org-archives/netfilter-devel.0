From: Patrick McHardy <kaber@trash.net>
Subject: Re: again oops: conntrack & 2.6.14-git14
Date: Sun, 20 Nov 2005 18:43:13 +0100
Message-ID: <4380B5B1.9040506@trash.net>
References: <43760B97.9010603@fliegl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <43760B97.9010603@fliegl.de>
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

Deti Fliegl wrote:
> This time it seems that I cought the oops in the right place. It's still 
> happening somewhere in the conntrack code:

I can't see how this can happen, but I'm looking at 2.6.15-rc2.
Can you please test again with 2.6.15-rc2 and without ipt_ipp2p
and other external patches?
