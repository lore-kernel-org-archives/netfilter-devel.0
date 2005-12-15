From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/8] dump ID and mark in conntrack events
Date: Thu, 15 Dec 2005 01:49:57 +0100
Message-ID: <43A0BDB5.8090101@trash.net>
References: <439422AC.5080704@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <439422AC.5080704@netfilter.org>
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

Pablo Neira Ayuso wrote:
> 
> ------------------------------------------------------------------------
> 
> Dump the ID and the mark in events. This info is useful for the userspace 
> clients.

I agree on dumping the mark, but do we really want to dump the ID?
That prevents us from getting rid of it even if figgure out a nicer
way to do the dumping.
