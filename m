From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: routing table lookup
Date: Tue, 11 Oct 2016 20:28:55 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1610112023530.2014@nerf40.vanv.qr>
References: <CAJO99TmN17PiMGs87HY=Awy=-QAMVLsCzBbvXZFzL8HDTakH=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:54992 "EHLO ares41.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753760AbcJKS25 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Oct 2016 14:28:57 -0400
In-Reply-To: <CAJO99TmN17PiMGs87HY=Awy=-QAMVLsCzBbvXZFzL8HDTakH=A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2016-10-11 20:11, Bjørnar Ness wrote:

>Hello, netfilter-devel.
>
>Is it possible/planned to be able to do routing table lookup from
>within nftables?
>Thinking then of a routingtable like "set". This would be nice to be able to do
>early drop on bgp populated saddr based rtbl.

Well you can mark routes with realm numbers, and match on that. (In 
iptables, this was done with -m realm.) At least that is the idea. Not 
sure if the skb field that holds the information is already 
filled in before FORWARD (at which point I guess it will contain the 
dst realm anyway).
