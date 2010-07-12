From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: netfilter hook/tuple question
Date: Mon, 12 Jul 2010 12:23:41 +0930
Message-ID: <201007121223.42052.rusty@rustcorp.com.au>
References: <AANLkTikanogevLAZ30XgK7oV4bijuTz5lZdkznWlisuC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Huascar Tejeda <htejeda@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:60408 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab0GLCxr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:53:47 -0400
In-Reply-To: <AANLkTikanogevLAZ30XgK7oV4bijuTz5lZdkznWlisuC@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 9 Jul 2010 05:08:52 am Huascar Tejeda wrote:
> Hello Rusty Russell,
> 
> I'm starting to learn about netfilter hooks programming and I have a small
> question. Is it possible to see the packets in my hook even if it already is
> in a tuple?

Hi Huascar,

   Sorry for the delayed response.  This question might have been better
directed at the netfilter-devel mailing list.

> My hook reads HTTP requests looking for QueryStrings. it's running in a
> linux gateway and I have these scenarios:
> 
>  - From a linux client: if I access google.com I can see the request for the
> first time, but since Linux re-uses source-port I don't see it again in my
> hook.
>  - From a windows client: it works very well cause windows always use
> different source-port so it is handled as a new connection every time.
> 
> Here is my code: http://codepad.org/T6SESSRg

AFAICT, this should work...  It's pretty simple.

Rusty.
