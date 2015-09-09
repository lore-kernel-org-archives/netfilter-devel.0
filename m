From: Wilmer van der Gaast <wilmer@gaast.net>
Subject: Re: Mixed IPv4+IPv6 sets
Date: Wed, 09 Sep 2015 11:08:18 +0100
Message-ID: <55F00512.7080209@gaast.net>
References: <55EC8B7F.4040303@gaast.net> <20150907185025.GB17921@salvia> <CAOkSjBjvRbCufHSwOayAnVvgrwYwaijhXAsUfbLWqzu+1fBXxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from roy.gaast.net ([80.101.33.21]:39838 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbbIIKIU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 06:08:20 -0400
In-Reply-To: <CAOkSjBjvRbCufHSwOayAnVvgrwYwaijhXAsUfbLWqzu+1fBXxA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry, I had sent a response to Pablo's request but forgot to hit
Reply-to-All. :-( Strangely Thunderbird did not show the message in
sent-mail at the time but it's there now, I'll repost it for the archives.

On 08-09-15 09:21, Arturo Borrero Gonzalez wrote:
> 
> I guess Wilmer is talking about multi-datatype sets (IPv4 and IPv6
> mixed addresses). That would be a nice feature indeed.
> 
Correct. And what I had noticed is that a file with mixed static (or
anon you call it?) sets (the ones with a $-prefixed name that as far as
I can tell can not be modified later and are expanded at parsing time)
is accepted if the sets are not used. Just none of the matches are very
happy with it since there's no multi-datatype matcher?

> @Wilmer: AFAIK thats not possible by now. It would require some
> changes in the kernel.

In the other message I have a workaround suggestion that would allow for
the mixed set in the file and just IPv4- and IPv6-specific references to
it. How reasonable would that be?


Kind regards,

Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
