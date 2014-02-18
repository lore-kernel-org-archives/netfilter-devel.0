From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH 2/6] rule: allow to print sets in plain format
Date: Tue, 18 Feb 2014 01:54:43 +0000
Message-ID: <20140218015443.GE12893@macbook.localnet>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
 <20140217231816.19943.70578.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54757 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaBRBys (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:54:48 -0500
Content-Disposition: inline
In-Reply-To: <20140217231816.19943.70578.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 12:18:17AM +0100, Arturo Borrero Gonzalez wrote:
> Allow to print sets with or without format.
> 
> This is useful in situations where we want to print exactly the same the user
> typed (IOW, in one single line, and with family/table info).

I like that, I wanted to make the indentation level variable anyway to
avoid deep indentation for set only output. Also I was considering a
pretty print function that neatly aligned all members.

Small note: we never know for sure we're generating what the user typed.
He might have used line continuations, bitwise operators etc.


> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -90,21 +90,30 @@ struct set *set_lookup(const struct table *table, const char *name)
>  	return NULL;
>  }
>  
> -void set_print(const struct set *set)
> +static void do_set_print(const struct set *set, const char *tab,
> +			 const char *nl, const char *family, const char *table)

Maybe encapsulate the tab/nl arguments into a struct. That will reduce
the needed changes when the indentation level is added.

Regarding newlines - it serves to purposes that probably need to be
handled differently.

- set family table name {\n

In this case its just for better readability.

- type bla\n

In this case its for making the output parsable. The parser expects
a stmt_seperator, which can be either \n or ;.

So I guess we need both a nl and a seperator argument.

Furthermore, I think a char (instead of a char *) should do fine.
