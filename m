From: "jon hale" <jon.h.hale@gmail.com>
Subject: Re: Does policy routing based on owner-gid really work?
Date: Tue, 2 Sep 2008 11:44:18 -0700
Message-ID: <abe9c56e0809021144g12be20fcue4c6c336dc47eea8@mail.gmail.com>
References: <abe9c56e0808221638m35d2af7bu3535099e55e6c786@mail.gmail.com>
	 <48BBEAC3.8040801@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:36661 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbYIBSoT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:44:19 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2385497rvb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Sep 2008 11:44:18 -0700 (PDT)
In-Reply-To: <48BBEAC3.8040801@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 1, 2008 at 6:14 AM, Patrick McHardy <kaber@trash.net> wrote:
> jon hale wrote:
>>
>> I have a problem when I combine owner-gid, fwmark, and iproute2.
>> I am starting to wonder if I can really get there from here.
>>
>> Synopsis:
>>       I have been trying to set up policy routing based upon the group id
>>       of the process sending the packets.
>>
>>       It works for most packets, but there is some scenario that happens
>> at
>>       the end of every ftp upload, where the packet goes out the wrong
>>       interface and gums up the works.
>
> The stack may send packets that don't belong to the original socket.
> You need to use CONNMARK to make sure all packets of a connection
> are marked similar.
>
Hmm, I thought I was using CONNMARK
I do have the iptables command:
      iptables -t mangle -A OUTPUT -j CONNMARK --save-mark

Is there something else I need as well?
Thank you for responding,
-jon
