From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: chain_cache
Date: Thu, 20 May 2004 17:24:42 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405201705320.7143-100000@filer.marasystems.com>
References: <40AC9EDB.9080604@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur Akan <akan@aiqa.com>
In-Reply-To: <40AC9EDB.9080604@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 May 2004, Ozgur Akan wrote:

> I commit my daily work on netfilter to http://netfilter.blogspot.com  
> There is  useful information for  poeple who are interested in netfilter 
> and want to learn netfilter internals step by step (actually with my 
> steps ;) )

After reading this I understand why you ask about chain_cache.

The task you are amiming at (detect duplicate rules) purely involves
modifying libiptc and requires a reasonable understanding of libiptc as 
you need to find the previous rule when inserting a new rule.. This is 
unfortunately not as easy as it may sound as the rules is managed in-place 
in their binary format and all you have is the offset where the new rule 
should be inserted.

The best place for to detect this is probably TC_INSERT_ENTRY. There you 
have a somewhat reasonable view of the chain in question and access to the 
binary rule representations.

Regards
Henrik
