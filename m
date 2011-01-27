From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 03/13] bitmap:ip set type support
Date: Thu, 27 Jan 2011 10:06:17 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101270959100.24591@blackhole.kfki.hu>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-4-git-send-email-kadlec@blackhole.kfki.hu>
 <4D3EE6B6.8090008@trash.net> <alpine.DEB.2.00.1101252229250.19648@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:58088 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab1A0JGT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jan 2011 04:06:19 -0500
In-Reply-To: <alpine.DEB.2.00.1101252229250.19648@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 25 Jan 2011, Jozsef Kadlecsik wrote:

> > > +			} else
> > > +				goto nla_put_failure;
> > > +		}
> > > +		NLA_PUT_IPADDR4(skb, IPSET_ATTR_IP,
> > > +				htonl(map->first_ip + id * map->hosts));
> > > +		ipset_nest_end(skb, nested);
> > > +	}
> > > +	ipset_nest_end(skb, atd);
> > > +	/* Set listing finished */
> > > +	cb->args[2] = 0;
> > > +	return 0;
> > > +
> > > +nla_put_failure:
> > > +	nla_nest_cancel(skb, nested);
> > > +	ipset_nest_end(skb, atd);
> > > +	return 0;
> > 
> > Doesn't this need to return an errno value to indicate that the
> > dump is incomplete?

The success return code was there because in general we reach there when 
the message gets full. However it does not mean an incomplete dump: the 
last partially dumped element is cancelled, the outer nesting is finished 
and we send the success code.

The nla_put_failure label name can be misleading but I cannot do much 
about it: NLA_PUT_* relies on it.

In rare cases we can reach there when it's a true error: I add the 
necessary check and return a proper error code.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
