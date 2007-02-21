From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Dump mark even if event is a DESTROY event
Date: Wed, 21 Feb 2007 13:51:30 +0100
Message-ID: <45DC4052.2010305@netfilter.org>
References: <1171964721.26768.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1171964721.26768.4.camel@localhost.localdomain>
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

Hi Eric,

Eric Leblond wrote:
> Mark is scarcely dump by nfnetlink_conntrack event handler. As it can be
> used to test that a connection is part of a given subset, I think it
> should be almost always dumped.

I don't see why you may need the mark in the destroy message. You can 
keep a cache in userspace with the connections that belong to a certain 
subset and their marks, then if the mark changes, move such connection 
the a different subset. It doesn't make sense to me the idea of 
including the mark in the destroy message since such mark didn't change 
with regards to the previous event delivered.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
