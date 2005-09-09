From: "Henning Peters" <hpeters@math.uni-goettingen.de>
Subject: Re: ip(6)_tables.h: return type difference in ip(6)t_get_target
Date: Fri, 9 Sep 2005 12:55:20 +0200 (CEST)
Message-ID: <45913.192.35.17.24.1126263320.squirrel@mail.piranho.net>
References: <20050909090358.GB24509@oknodo.bof.de><8277.192.35.17.24.1126260158.squirrel@mail.piranho.net>
	<20050909101734.GC24509@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20050909101734.GC24509@oknodo.bof.de>
To: "Patrick Schaaf" <bof@bof.de>
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

>> return (struct ip6t_entry_target *) ((void *)e + e->target_offset);
>
> I'd write this as
>
> return (struct ip6t_entry_target *) (((char *)e) + e->target_offset);

I agree.

Henning
