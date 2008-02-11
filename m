From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: iptables + geoip
Date: Mon, 11 Feb 2008 03:54:26 -0500
Message-ID: <dd45289d0802110054t1ceeb84fk53f6b9a086bdd8ca@mail.gmail.com>
References: <13602.193.36.79.206.1202718656.squirrel@webmail.tdd.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: rob@thirddimensiondesign.co.uk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.242]:48758 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722AbYBKIy2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:54:28 -0500
Received: by hs-out-2122.google.com with SMTP id 54so3850123hsz.5
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Feb 2008 00:54:27 -0800 (PST)
In-Reply-To: <13602.193.36.79.206.1202718656.squirrel@webmail.tdd.org.uk>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Robert,

Can you tell me the exact rule syntax you used ?

p.s. I'm actually updating geoip so it use the xtables framework,

cheers,

Nicolas Bouliane

On Feb 11, 2008 3:30 AM, Robert Bruce <rob@thirddimensiondesign.co.uk> wrote:
> Hello
>
> I tried to send this to the developers of geoip, but the email got
> returned to me. I can't put this on bugzilla as it is down at the
> moment...
>
> Original Email:
>
> Hi Guys
>
> I've just tried to install geoip with iptables 1.4.0, everything is fine
> until I try to add a rule which uses the geoip module and I get a
> Segmentation fault. So I did some digging, compiled with -g for gdb and
> found that the problem is on line 229 as match is passed in with an
> address to 0x0.
>
> I dunno how to fix that though..
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
