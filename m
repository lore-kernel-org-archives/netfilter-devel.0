From: Patrick Schaaf <bof@bof.de>
Subject: Re: ip(6)_tables.h: return type difference in ip(6)t_get_target
Date: Fri, 9 Sep 2005 12:17:34 +0200
Message-ID: <20050909101734.GC24509@oknodo.bof.de>
References: <20050909090358.GB24509@oknodo.bof.de>
	<8277.192.35.17.24.1126260158.squirrel@mail.piranho.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henning Peters <hpeters@math.uni-goettingen.de>
Content-Disposition: inline
In-Reply-To: <8277.192.35.17.24.1126260158.squirrel@mail.piranho.net>
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

> return (struct ip6t_entry_target *) ((void *)e + e->target_offset);

I'd write this as

return (struct ip6t_entry_target *) (((char *)e) + e->target_offset);

Two reasons:

First, cast to void* is a gcc C (and maybe C++, dunno) extension.
If you have to cast the result to the correct type, anyway, you
can as well use "char *".

Second, by putting "(char *)e" in an additional set of braces,
the reader of the code need not think about precedence of
cast vs. addition, i.e. the meaning of the construct is
more obvious.

best regards
  Patrick
