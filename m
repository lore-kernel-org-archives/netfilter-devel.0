From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: patch-o-matic-ng release candidate in cvs
Date: Mon, 10 May 2004 00:56:58 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405100054570.15313-100000@filer.marasystems.com>
References: <20040509221941.GA11533@pcw.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy TARREAU <willy@w.ods.org>
In-Reply-To: <20040509221941.GA11533@pcw.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 10 May 2004, Willy TARREAU wrote:

> Yes it can (and does) affect the binary size, because the compiler knows how
> to merge strings. I reduced by about 1.5 kB the binary size of one of my
> program by changing all __FILE__ ":" __FUNCTION__ ":" to 
> "%s:%s" __FILE__, __FUNCTION__ because in the first case

Right. I kind of assumed you used the same formats.. if you changed the 
formats then yes.

> Anyway, this is a good news since it means that your patch works ;-)

Still your patch.. I only modified it slightly ;-)

Regards
Henrik
