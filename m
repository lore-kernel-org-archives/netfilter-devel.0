From: Patrick PIGNOL <patrick.pignol@gmail.com>
Subject: Re: EPOLLERR on memory mapped netlink socket
Date: Tue, 24 Jan 2017 07:52:22 +0100
Message-ID: <d725086d-af25-ce41-8151-1e26fe3b5d45@gmail.com>
References: <CA+VDgmP9MigJxiN5snFmLdHw7cydr4JbnBDDPwzex0Tszqgaag@mail.gmail.com>
 <CA+VDgmNutTGo6AmoszdNkP5yRVO2vyDnVC5Hzj5XXmLueSwEcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: prashantkumar dhotre <prashantkumardhotre@gmail.com>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33745 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdAXGwZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 01:52:25 -0500
Received: by mail-wm0-f68.google.com with SMTP id r144so32277641wme.0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 22:52:24 -0800 (PST)
In-Reply-To: <CA+VDgmNutTGo6AmoszdNkP5yRVO2vyDnVC5Hzj5XXmLueSwEcw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi !

I think nobody here will answer you.

Those who know the answer will not answer you because they think it's 
trivial or don't want to spend time to. And those who don't know it will 
not answer you because they do not want show they don't know the 
answer(like me).

I asked some help for 2 things a couple of days ago but I get no answer.

Best regards,

Patrick.

Le 23/01/2017 à 18:40, prashantkumar dhotre a écrit :
> Appreciate any help on this
> Thanks
>
>
> On Mon, Jan 23, 2017 at 9:20 AM, prashantkumar dhotre
> <prashantkumardhotre@gmail.com> wrote:
>> Hi experts,
>> I am new to netlink sockets.
>> In my app , I am  getting EPOLLERR in epoll_wait() on netlink socket
>> continuously.
>> epoll just notifies that there is a read event on socket (it does not
>> tell if it is read or epollerr).
>> What could be cause of this and what EPOLLERR on memory mapped netlink
>> socket mean.is this Other side of netlink (kernel side) closed
>> connection ?even if kernel side closed connection why non-stop
>> repeated EPOLLERR s on netlink sockets ?
>> What action should we take in such cases ? just close the socket  or
>> call getsockopt(SO_ERROR) to retrieve the pending error state from the
>> socket and just continue without closing socket?
>>
>> how do we detect if kernel side closed the connection ?
>> My understanding is :
>> if we get read event notification from epoll on memory mapped netlink
>> socket and in RX ring if the frame is neither NL_MMAP_STATUS_VALID and
>> nor NL_MMAP_STATUS_COPY then we can conclude that this is a 'close()'
>> from remote kernel socket and I can close connection by calling
>> close() on my netlink socket.
>> Is above understanding correct ?
>>
>> Please
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

