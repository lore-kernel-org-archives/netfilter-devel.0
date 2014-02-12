From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: Netfilter Extension Development Queries
Date: Wed, 12 Feb 2014 23:56:17 +0100
Message-ID: <CAOkSjBhV_vXwa55v2D9cNFii8ZH-nHWS0m1SU2Y9d83GfLQ=7A@mail.gmail.com>
References: <CAECcapiTOutsUuaukD7uzuXtLeJTmqua4jhzZFZZ735OQ+L9dA@mail.gmail.com>
 <52FBEFC3.1030706@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Duncan Eastoe <duncaneastoe@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: mart.frauenlob@chello.at
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:53645 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaBLW4j convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:56:39 -0500
Received: by mail-lb0-f172.google.com with SMTP id c11so7641025lbj.17
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Feb 2014 14:56:38 -0800 (PST)
In-Reply-To: <52FBEFC3.1030706@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 February 2014 23:03, Mart Frauenlob <mart.frauenlob@chello.at> wr=
ote:
>> Also, regarding the switch to nftables from iptables. Will my approa=
ch
>> listed above work with iptables and nftables or is a different
>> approach required for nftables?
>
>
> there is work in progress on a compat-layer:
> http://git.netfilter.org/iptables-nftables/
> which should transparently *translate* the syntax (if implemented in
> nftables).
>

I (personally) would bet to write the extension natively using the new
framework.
I'm sure it would be nice to discuss how your new feature could be
achieved using nftables (using existing expressions or maybe new
ones).

regards
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
