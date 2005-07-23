From: Patrick McHardy <kaber@trash.net>
Subject: Re: [stable] [NETFILTER 1/5]: Fix deadlock in ip6_queue
Date: Sat, 23 Jul 2005 06:29:21 +0200
Message-ID: <42E1C7A1.8030405@trash.net>
References: <42E0A1C6.3040300@trash.net> <20050722195252.GA19034@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg KH <greg@kroah.com>
In-Reply-To: <20050722195252.GA19034@kroah.com>
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

Greg KH wrote:
> On Fri, Jul 22, 2005 at 09:35:34AM +0200, Patrick McHardy wrote:
> 
>>Hi Dave,
>>
>>following are a couple of patches for 2.6.13. I've CCed
>>stable@kernel.org on all patches that I think should also
>>go in -stable.
> 
> -stable only received 3 of these, is that correct?

Yes, the others fixed one unimportant bug and one bug introduced in
2.6.13-rc.

> I'll hold off on adding these to the queue until they go into mainline.
> When that happens, could you please let us know?

They just hit Linus's tree.

Regards
Patrick
