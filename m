From: "David Laight" <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3/3] netfilter: x_tables: fix ordering of jumpstack allocation and table update
Date: Wed, 23 Oct 2013 10:45:04 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B73A2@saturn3.aculab.com>
References: <1382519724-3953-1-git-send-email-pablo@netfilter.org> <1382519724-3953-4-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>,
	<netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <1382519724-3953-4-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> Subject: [PATCH 3/3] netfilter: x_tables: fix ordering of jumpstack allocation and table update
...
> Meanwhile, CPU0 is handling the network receive path and ends up in
> ipt_do_table, resulting in:
> 
> 	private = table->private;
> 
> 	[...]
> 
> 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
> 
> On weakly ordered memory architectures, the writes to table->private
> and newinfo->jumpstack from CPU1 can be observed out of order by CPU0.
> Furthermore, on architectures which don't respect ordering of address
> dependencies (i.e. Alpha), the reads from CPU0 can also be re-ordered.

Which reads might be out of order?
AFAICT they are strongly sequenced because they second depends on the
value read by the first.
So I don't see why the read barrier is needed.

I presume the above code is tied to a single cpu.

...
> 
> -	table->private = newinfo;
>  	newinfo->initial_entries = private->initial_entries;
> +	/*
> +	 * Ensure contents of newinfo are visible before assigning to
> +	 * private.
> +	 */
> +	smp_wmb();
> +	table->private = newinfo;

Those writes were in the wrong order on all systems.
Also gcc needs to be told not to reorder the writes even on non-smp
systems (if the code might be pre-empted).
So an asm volatile (:::"memory") is needed there even if no specific
synchronisation instruction is needed.

	David
