From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Sat, 22 May 2004 00:56:07 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405220040040.28306-100000@filer.marasystems.com>
References: <40AE2929.4040408@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira <pablo@eurodev.net>, Jozsef Kadlecsik <kadlec@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40AE2929.4040408@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 May 2004, Patrick McHardy wrote:

> I missed that question. It's probably not neccessary, we will get a
> small race when zapping conntracks, but according to this comment in
> unreplied() we already have one anyway.

What I thought.. a __set_bit should be sufficient here, right?

Is there any good description somewhere on how these memory barriers 
works and when they are needed, or more precisely what is the difference 
between set_bit and __set_bit in terms of when/how/why each should be 
used?

But in this case there is many races.. a test_bit followed  by a set_bit 
is not atomic unles governed by a surrounding lock independent of if 
there is memory barriers of not around the operations, and the flushing of 
unconfirmed sessions is inherently racy anyway without strict locking. If 
there is strict locking then memory barriers in the set_bit should be 
completely irrelevant. Right?

Regards
Henrik
