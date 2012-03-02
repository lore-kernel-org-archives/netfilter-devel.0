From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: patch in bugzilla
Date: Fri, 2 Mar 2012 17:42:09 +0100
Message-ID: <20120302164209.GA13687@1984>
References: <CAO88JF9FcBkjEs345hK4bOhQa1q-RuckkrLN9SKUUt3cWaLJKw@mail.gmail.com>
 <alpine.LNX.2.01.1202281409020.10284@frira.zrqbmnf.qr>
 <20120229125052.GA1115@1984>
 <20120229232739.GB3817@1984>
 <CAO88JF-=PTq2ZXaNWhE6mLKZY96y_fqCqxetNy-6h-Dwv3Ph3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: Jonh Wendell <jonh.wendell@vexcorp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54343 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757769Ab2CBQmS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Mar 2012 11:42:18 -0500
Content-Disposition: inline
In-Reply-To: <CAO88JF-=PTq2ZXaNWhE6mLKZY96y_fqCqxetNy-6h-Dwv3Ph3Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 01, 2012 at 05:07:57PM -0300, Jonh Wendell wrote:
> diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
> index 24cdbdb..b9a42c9 100644
> --- a/include/libiptc/libiptc.h
> +++ b/include/libiptc/libiptc.h
> @@ -74,7 +74,8 @@ int iptc_replace_entry(const xt_chainlabel chain,
>  		       struct xtc_handle *handle);
>  
>  /* Append entry `e' to chain `chain'.  Equivalent to insert with
> -   rulenum = length of chain. */
> +   rulenum = length of chain. Returns the position the entry was
> +   inserted or 0 if an error occurs */
>  int iptc_append_entry(const xt_chainlabel chain,
>  		      const struct ipt_entry *e,
>  		      struct xtc_handle *handle);
> diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
> index b191d5d..8df06d6 100644
> --- a/iptables/ip6tables.c
> +++ b/iptables/ip6tables.c
> @@ -698,7 +698,8 @@ append_entry(const xt_chainlabel chain,
>  			fw->ipv6.dmsk = dmasks[j];
>  			if (verbose)
>  				print_firewall_line(fw, handle);
> -			ret &= ip6tc_append_entry(chain, fw, handle);
> +			if (!ip6tc_append_entry(chain, fw, handle))
> +				ret = 0;
>  		}
>  	}
>

This requires also modifying the libversion numbers for libiptc since the
interface has changed.

IMO, libiptc has always remained an internal library, but it seems
some of you are using it to link your program to it.

Your patch will break other programs made by people like you that use
libiptc.

Jan?
