From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re: Hash table implementation
Date: Mon, 23 Jul 2012 18:31:05 +0200 (CEST)
Message-ID: <1f2ikbu.dcd9f8508a506924131bf976a787522f@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "kernelnewbies" <kernelnewbies@kernelnewbies.org>,
	"netfilter-devel" <netfilter-devel@vger.kernel.org>
To: "Arif Hossain" <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:54176 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab2GWQbJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jul 2012 12:31:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>Subject: Hash table implementation
>
>Hi,
>
>This commit shows that jenkins hash
>function(http://en.wikipedia.org/wiki/Jenkins_hash_function) is
>implemented in kernel :
>
>commit 60d509c823cca21e77d537bd356785f7cfe8f0d1
>Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>Date:   Fri Dec 3 02:39:01 2010 +0000
>
>    The new jhash implementation
> <snip>
>
>I could not find any good documentation describing how to use it. Only
>thing i could do is to read codes which uses it, like 

Have a look in the include file it self  linux-3.5.0/include/linux/jhash.h
every function is well documented there.

/Hans

