From: "Niki Denev" <ndenev@gmail.com>
Subject: Re: iptables hashlimit ipmask support
Date: Thu, 28 Feb 2008 23:45:08 +0200
Message-ID: <2e77fc10802281345t2c1298adla22e6eb06db1e2fa@mail.gmail.com>
References: <2e77fc10802281140i59eee398t794a429db006b22a@mail.gmail.com>
	 <Pine.LNX.4.64.0802282141420.4324@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:29858 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbYB1VpM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:45:12 -0500
Received: by wr-out-0506.google.com with SMTP id c48so5429052wra.23
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Feb 2008 13:45:09 -0800 (PST)
In-Reply-To: <Pine.LNX.4.64.0802282141420.4324@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 28, 2008 at 10:44 PM, Jan Engelhardt
<jengelh@computergmbh.de> wrote:
>
> On Feb 28 2008 21:40, Niki Denev wrote:
> >
> >Recently i needed to be able to do exactly what iptables with hashlimit does,
> >but instead of hashing by IP i wanted it to hash on arbitrary network mask.
> >So, i've hacked up this, and i hope that you could find it useful.
>
> Such has already been merged by me for 2.6.25.
>
> >P.S. : There is no ipv6 support, and the manpage is not updated to
> >reflect the new hashlimit option --hashlimit-ipmask
>
> I also had added that.
>
> >P.S.2: I know that this probably can be done with connlimit, but
> >hashlimit can also do limiting on the destination ip (dstip mode)
> >which i think is not possible with connlimit.
>
> Connlimit works on connection tuples, so would be equal to
>  --hashlimit-mode srcip,dstip,srcport,dstport
>

I haven't noticed that there is already support for this. Thanks.


 -- Niki

-- 
Nikolay Denev        ICDSoft Ltd.
System Administrator  http://www.icdsoft.com/
m: 359-888-952-352
p: 1-617-544-3022
