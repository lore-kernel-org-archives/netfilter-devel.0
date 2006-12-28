From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] libnfnetlink and iface conversion to string
Date: Thu, 28 Dec 2006 18:39:17 +0100
Message-ID: <45940145.3020003@netfilter.org>
References: <1167257854.31765.21.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1167257854.31765.21.camel@localhost>
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

Eric Leblond wrote:
> I'm currently working on NuFW where I try to do iface conversion from
> integer to string to be able to filter "naturally" on interfaces.
> 
> For now, it is impossible to do this conversion from either
> libnetfilter_queue or libnfnetlink. But there is two files in
> libnfnetlink (iftable.c and rntl.c) which have been put here by Harald
> to provide this conversion (if I remember correctly an old mail from
> Harald).
> 
> It was a long time ago and I don't know if it still planned to modify
> libnfnetlink to include this feature. Or, would it be a better choice to
> create a new library dedicated to this conversion.

Interesting question. Since this is related with the rtnetlink
subsystem, I'm unsure that this feature naturally belongs to
libnfnetlink nor to libnetfilter_queue.

However, IMO libnetfilter_queue should provide enough features to let
userspace apps implement filtering without requiring extra dependencies.
BTW, what are the benefits of dumping the index instead of the interface
name in this particular case?

Patrick?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
