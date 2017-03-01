From: Fabian Franz <s1410239008@students.fh-hagenberg.at>
Subject: Re: nft authentication
Date: Wed, 1 Mar 2017 09:14:17 +0100
Message-ID: <79f454c1-a8ef-5043-35f5-90d83447dc83@students.fh-hagenberg.at>
References: <e7b26751-8914-e32e-0760-c300bf217b50@students.fh-hagenberg.at>
 <20170228232451.GA24798@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay02-mailcontrol.conova.com ([217.196.144.162]:49308 "EHLO
        relay02-mailcontrol.conova.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751704AbdCAIPs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 03:15:48 -0500
In-Reply-To: <20170228232451.GA24798@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Mr. Westphal,

yes it is academic and what I want to do is user id matching on
non-local users (which means I need to connect the IP address with an
user id or something like that). What I want is to keep the full match
together, nf_queue is a target.
It should be my last year project but it seems to be impossible to
finalize due to a lack of documentation. An alternative Method would be
keeping an array of structs with IP addresses and user IDs in the kernel
and use those.

However this way I can see what is going on in the userspace application.

The problem ist, that I cannot get a correct rule reated in nft (auth or
numbers after it are always underlined)

For example all of those fail:

* auth

* auth 1

* auth user 1

* auth 1 1

so I think it cannot find the auth module or something other goes wrong.


lsmod says that it looks ok:

nft_auth               16384  0
nft_reject_inet        16384  1
...
nf_tables              65536  30
nf_tables_inet,nf_tables_ipv4,nf_tables_ipv6,...,nft_auth,...


NFT always ends up with an error like this one:

update link layer protocol context:
 link layer          : inet <-
 network layer       : none
 transport layer     : none

<cmdline>:1:28-33: Evaluate
add rule inet filter input auth 1 accept
                           ^^^^^^
$auth $1

<cmdline>:1:28-33: Evaluate
add rule inet filter input auth 1 accept
                           ^^^^^^
$auth $1

<cmdline>:1:28-31: Evaluate
add rule inet filter input auth 1 accept
                           ^^^^
$auth

Stack now 0 1
Cleanup: popping nterm input (: )
<cmdline>:1:28-31: Error: No symbol type information
add rule inet filter input auth 1 accept


created using this command:

nft --debug all add rule inet filter input auth 1 accept


I hope this helps you to understand the error.


Am 2017-03-01 um 00:24 schrieb Florian Westphal:
> Fabian Franz <s1410239008@students.fh-hagenberg.at> wrote:
>> I am working on my module but I cannot get the match visible to the nft
>> tool. Could you please give me a hint, what is wrong in the code? I have
>> uploaded it to my web server: http://files.fabian-franz.eu/nft_auth.c
> I do not know what 'visible to the nft tool' means.
> No 'obvious' mistake in the register department.
>
> My only comment is that it looks like you are re-inventing the wheels
> we already have, such as nf_log and nf_queue.
>
> If this is a learning exercise, fine, but we have real missing
> functionality that could be added instead.
>
> If this targets upstream, you should really discuss what problem wants
> to be solved.  The building blocks we already have should be enough
> to do uid based authentication.
>
> (something like
>  nf_log/queue -> userspace daemon -> query -> update nft set w. uid)


