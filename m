From: =?UTF-8?Q?Richard_M=c3=b6rbitz?= <richard.moerbitz@tu-dresden.de>
Subject: Adding element to interval map consumes entire memory
Date: Sun, 11 Dec 2016 15:20:16 +0100
Message-ID: <044c1296-0e35-4224-459f-3482691a3462@tu-dresden.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout6.zih.tu-dresden.de ([141.30.67.75]:35757 "EHLO
        mailout6.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753521AbcLKOmh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Dec 2016 09:42:37 -0500
Received: from mail.zih.tu-dresden.de ([141.76.14.4])
        by mailout6.zih.tu-dresden.de with esmtps (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.84_2)
        (envelope-from <richard.moerbitz@tu-dresden.de>)
        id 1cG4zB-00022T-MS
        for netfilter-devel@vger.kernel.org; Sun, 11 Dec 2016 15:20:17 +0100
Received: from p5dc302bc.dip0.t-ipconnect.de ([93.195.2.188] helo=[192.168.2.103])
        by server-50.mailclusterdns.zih.tu-dresden.de with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (envelope-from <richard.moerbitz@tu-dresden.de>)
        id 1cG4zB-0002sX-1P
        for netfilter-devel@vger.kernel.org; Sun, 11 Dec 2016 15:20:17 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

first of all: the build in use is the current master
(c89a0801d07740eff531412fe35ea2c9faad82b0).

We have a test setup running which consists of one table ("nat2") and an
interval mapping ("subnettoip") of the type ipv4_addr -> ipv4_addr. The
mapping is quite large (~16000 elements). One requirement of the system
is that elements can be added and deleted during runtime.

With that map constructed, adding a new element is not possible. NFT
will terminate during reallocation, because no memory is left.

GDB trace:
http://pastebin.com/s7eyNEsH

Valgrind leak check:
http://pastebin.com/fkG5UQig

Note that the test machine only has 2 GB of RAM, 1.6 of which are
consumed by nft. So one question is: is it even possible to have enough
memory in the final system, such that the required operation can be
performed?

The second question would be: why is it necessary to allocate that much
memory? As I have found out by reading the code, all map elemtents are
cached before performing the operation; they are even sorted. Is that
really necessary for operations like adding map entries?

Kind regards
Richard
