From: prashantkumar dhotre <prashantkumardhotre@gmail.com>
Subject: EPOLLERR on memory mapped netlink socket
Date: Mon, 23 Jan 2017 09:20:23 +0530
Message-ID: <CA+VDgmP9MigJxiN5snFmLdHw7cydr4JbnBDDPwzex0Tszqgaag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:36624 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750712AbdAWDuY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Jan 2017 22:50:24 -0500
Received: by mail-qt0-f182.google.com with SMTP id k15so103347122qtg.3
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Jan 2017 19:50:24 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi experts,
I am new to netlink sockets.
In my app , I am  getting EPOLLERR in epoll_wait() on netlink socket
continuously.
epoll just notifies that there is a read event on socket (it does not
tell if it is read or epollerr).
What could be cause of this and what EPOLLERR on memory mapped netlink
socket mean.is this Other side of netlink (kernel side) closed
connection ?even if kernel side closed connection why non-stop
repeated EPOLLERR s on netlink sockets ?
What action should we take in such cases ? just close the socket  or
call getsockopt(SO_ERROR) to retrieve the pending error state from the
socket and just continue without closing socket?

how do we detect if kernel side closed the connection ?
My understanding is :
if we get read event notification from epoll on memory mapped netlink
socket and in RX ring if the frame is neither NL_MMAP_STATUS_VALID and
nor NL_MMAP_STATUS_COPY then we can conclude that this is a 'close()'
from remote kernel socket and I can close connection by calling
close() on my netlink socket.
Is above understanding correct ?

Please
