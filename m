From: fender <frozenspot@gmail.com>
Subject: Re: [update] port knocking match extension
Date: Tue, 2 Sep 2008 15:58:53 -0300
Message-ID: <7e36c7130809021158x522c6c41o8530a8721a90a5d9@mail.gmail.com>
References: <7e36c7130808272128l22aa701by97169ca79312dc82@mail.gmail.com>
	 <48B6482C.2010408@gmail.com>
	 <7e36c7130808311057u7993e5b1q870a7f37cfa95b68@mail.gmail.com>
	 <hpeob4lg94q4b9dcuhostiogl93lddelgv@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: "Andrew Schulman" <andrex@alumni.utexas.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:64974 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbYIBS6y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:58:54 -0400
Received: by gxk9 with SMTP id 9so5587679gxk.13
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Sep 2008 11:58:53 -0700 (PDT)
In-Reply-To: <hpeob4lg94q4b9dcuhostiogl93lddelgv@4ax.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, Sep 1, 2008 at 3:58 PM, Andrew Schulman
<andrex@alumni.utexas.net> wrote:
>> Thank you for your suggestion. I don't know what xtable is, but I'll
>> check it out.
>
> xtables-addons, actually.  http://jengelh.medozas.de/projects/xtables/

I took a look at xtables-addons, and I think that we don't need it for
now. In fact, you don't need to recompile kernel and iptables to get
our extension working. The Makefile of this port knocking extension
allows you to compile and install without any extra steps. You need to
download the kernel and iptables sources, and after that you have to
do "make and make install".

Regards,

-- 
Federico

/*
 * J. Federico Hernandez Scarso (fender) {frozenspot; at; gmail; dot; com;}
 * GPG PubKey: wwwkeys.eu.pgp.net key 6AE78BF2
 * FP: 26AB 7A1B C2C4 70F8 0E7D C3F4 9736 5CE2 6AE7 8BF2
 */
