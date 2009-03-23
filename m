From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Fwd: Re: Re: [PATCH 2.4.37] iptables: handle IPT_RETURN from
 	user target]
Date: Mon, 23 Mar 2009 13:23:20 +0100
Message-ID: <49C77F38.50503@trash.net>
References: <49C12888.3000907@expand.com> <49C12911.2080507@trash.net> <412e6f7f0903230126x3ee972b5se1005cc3b5895bce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: haimdaniel@gmail.com, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <412e6f7f0903230126x3ee972b5se1005cc3b5895bce@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Changli Gao wrote:
> I posted this patch before. I am glad to see someone has the same
> requirement as me. It is useful when implementing ACL. Such as these
> statements:
> 
> if (x_cond) {
>    do_x;
> } else if (y_cond) {
>   do_y;
> } else if (z_cond) {
>   do_z;
> }
> 
> Because the current iptables doesn't support multi-targets, we have to
> do this kinds of things in a dirty way.

We don't add changes that are not needed in the mainline kernel itself.
I'm not interested in this change until someone also posts a patch to
actually make use of it.
