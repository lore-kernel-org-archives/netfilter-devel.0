From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH?] Fix getorigdst() in ip_conntrack_core.c on 2.4.22-ac2
Date: Thu, 11 Sep 2003 08:13:03 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309110809220.11007-100000@filer.marasystems.com>
References: <20030910212715.80212.qmail@web40906.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Chapman <kakadu_croc@yahoo.com>
In-Reply-To: <20030910212715.80212.qmail@web40906.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 10 Sep 2003, Brad Chapman wrote:

> Hmmmm, OK. Does that mean that the tuple can't be allocated on the stack

It can (and should), but you only allocated a uninitialized pointer not 
the tuple.. The *tuple needs to point at something before you try to 
assign it's members some values..

> static void ip_ct_tuple_blank(struct ip_conntrack_tuple *tuple)
> {
>          tuple->src.u.all = 0;
>          tuple->dst.u.all = 0;
> }

This is the intended semantics of the macro, but due to a missing 
parantesis in the macro it is not how it ends up..

Regards
Henrik
