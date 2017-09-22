From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH v2] netfilter: xt_socket: Restore mark from full sockets
 only
Date: Thu, 21 Sep 2017 18:09:30 -0600
Message-ID: <edf29b9f6c0924c53de486defb8875f8@codeaurora.org>
References: <1506031687-21319-1-git-send-email-subashab@codeaurora.org>
 <1506038499.29839.156.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45216 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbdIVAJb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2017 20:09:31 -0400
In-Reply-To: <1506038499.29839.156.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-09-21 18:01, Eric Dumazet wrote:
> On Thu, 2017-09-21 at 16:08 -0600, Subash Abhinov Kasiviswanathan 
> wrote:
>> An out of bounds error was detected on an ARM64 target with
>> Android based kernel 4.9. This occurs while trying to
>> restore mark on a skb from an inet request socket.
>> 
>> BUG: KASAN: slab-out-of-bounds in socket_match.isra.2+0xc8/0x1f0 
>> net/netfilter/xt_socket.c:248
>> Read of size 4 at addr ffffffc06a8d824c by task syz-fuzzer/1532
>> CPU: 7 PID: 1532 Comm: syz-fuzzer Tainted: G        W  O    4.9.41+ #1
>> Call trace:
> 
>> 
>> v1->v2: Change socket_mt6_v1_v2_v3() as well as mentioned by Eric
>> 
>> Fixes: a94070000388 ("netfilter: xt_socket: prepare for 
>> TCP_NEW_SYN_RECV support")
> 
> When my commit was written (Mon Mar 16 21:06:17 2015 -0700), this
> XT_SOCKET_RESTORESKMARK code was not there yet.
> 
> 
> The bug was added in commit 01555e74bde5 ("netfilter: xt_socket: add
> XT_SOCKET_RESTORESKMARK flag")  which came later (Mon Jun 15 18:40:43
> 2015 -0600)
> 
> Please put a correct Fixes: tag, thanks.
> 

Sure, I'll update that in v3.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
