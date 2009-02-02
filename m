From: "Giant Sand Fan's" <rampxxxx@gmail.com>
Subject: Re: Reverse Nat and ICMP packet
Date: Mon, 2 Feb 2009 18:16:55 +0100
Message-ID: <417f50830902020916y401dd931g6b906e1b5e7d0f7a@mail.gmail.com>
References: <417f50830901291159ma6ad4dbm454abc04f66e94e6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:3829 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZBBRQ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:16:56 -0500
Received: by fg-out-1718.google.com with SMTP id 16so653791fgg.17
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Feb 2009 09:16:55 -0800 (PST)
In-Reply-To: <417f50830901291159ma6ad4dbm454abc04f66e94e6@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I answer to myself.

The problem was that our hook that do the unpack was after -less
priority , higher number- that conntrack -both in prerouting- so in
the back the packet was a different one that the one conntrack saves.

The solution, just put with a priority NF_IP_PRI_CONNTRACK+1 .

Thanks.


2009/1/29 Giant Sand Fan's <rampxxxx@gmail.com>:
> Hi:
>
>
> I've a netfilter module that unpack a icmp packet and then there is a
> NAT to internet but in the back there is a problem the NAT don't do
> anything in prerouting.
> The question is the reverse is done with a match for address and what
> else? , i cannot no see it. I supposse that the macht is not done and
> then the reverse is not done too, perhaps the id or sequence fields of
> icmp are involved too.
>
> Any clue, thanks anyway.
>
>
>
>
> --
> Please avoid sending me Word or PowerPoint attachments.
> See http://www.gnu.org/philosophy/no-word-attachments.html
>



-- 
Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html
