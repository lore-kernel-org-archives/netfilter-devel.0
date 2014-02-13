From: Duncan Eastoe <duncaneastoe@gmail.com>
Subject: Re: Netfilter Extension Development Queries
Date: Thu, 13 Feb 2014 20:50:44 +0000
Message-ID: <CAECcapgTKYWT+z+TwPXv33k3Q3iJ2hC6wOr9wOuzGzVKPTF_ew@mail.gmail.com>
References: <CAECcapiTOutsUuaukD7uzuXtLeJTmqua4jhzZFZZ735OQ+L9dA@mail.gmail.com>
 <52FBEFC3.1030706@chello.at> <CAOkSjBhV_vXwa55v2D9cNFii8ZH-nHWS0m1SU2Y9d83GfLQ=7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: mart.frauenlob@chello.at,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:40283 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaBMUvF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:51:05 -0500
Received: by mail-ve0-f176.google.com with SMTP id jx11so1728154veb.7
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Feb 2014 12:51:04 -0800 (PST)
In-Reply-To: <CAOkSjBhV_vXwa55v2D9cNFii8ZH-nHWS0m1SU2Y9d83GfLQ=7A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 February 2014 23:03, Mart Frauenlob <mart.frauenlob@chello.at> wrote:
> Not that I'm a developer...
> There's only TCPOPTSTRIP in main iptables.

Yes, I haven't been able to find the IPV4OPTSTRIP patch anywhere. If
it had been, it might have been good to extend it for my needs.

On 12 February 2014 23:03, Mart Frauenlob <mart.frauenlob@chello.at> wrote:
> there is work in progress on a compat-layer:
> http://git.netfilter.org/iptables-nftables/
> which should transparently *translate* the syntax (if implemented in
> nftables).

Does this translate iptables rule syntax to nftables syntax or is it
an API compatibility layer?

On 12 February 2014 22:56, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> I (personally) would bet to write the extension natively using the new
> framework.
> I'm sure it would be nice to discuss how your new feature could be
> achieved using nftables (using existing expressions or maybe new
> ones).

So I would be correct in saying that the Netfilter hooks/API no longer
work with nftables?
If so, is there any good documentation for writing extensions for
nftables? I have found docs such as
(http://inai.de/documents/Netfilter_Modules.pdf) for netfilter.

Thank you both for your replies

Best regards,
Duncan
