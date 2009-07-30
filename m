From: Bruno Moreira Guedes <thbmatrix@gmail.com>
Subject: Re: Modifying packets in userspace using libnetfilter_queue
Date: Thu, 30 Jul 2009 13:54:55 -0300
Message-ID: <3fdd6ce00907300954y6d574251k64a9c5fee7e9719d@mail.gmail.com>
References: <5BB67BF4A0D4544A918C2FD76487A1E13D8944D6@USNAVSXCHMBSB2.ndc.alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Srinivasan, Suman (Suman)** CTR **"
	<suman.srinivasan@alcatel-lucent.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:35736 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZG3Qyz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:54:55 -0400
Received: by an-out-0708.google.com with SMTP id d40so1935819and.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2009 09:54:56 -0700 (PDT)
In-Reply-To: <5BB67BF4A0D4544A918C2FD76487A1E13D8944D6@USNAVSXCHMBSB2.ndc.alcatel-lucent.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2009/7/30 Srinivasan, Suman (Suman)** CTR **
<suman.srinivasan@alcatel-lucent.com>:
> Hi all,
>
> Sorry for this elementary question, but I am new to the world of pack=
et modification. I browsed the recent netfilter-devel archives and coul=
dn't find much on this topic.
>
> I am trying to modify TCP packets in userspace. I know it is ineffici=
ent to do it in userspace, but I just need a prototype to test for now.
>
> I couldn't find much documentation on doing this, except for the docu=
mentation on the following URL, the nfqnl_test.c file and some modifica=
tions on some mailing lists:
> http://www.nufw.org/doc/libnetfilter_queue/
>
> I have gotten this far:
> 1. Have set up iptables rules to send the TCP packets I want to inter=
cept down a NFQUEUE queue.
> 2. Am able to use nfqnl_test.c to receive and print out packet info.
> 3. Used netinet/tcp.h and sample code to check TCP headers
> 4. Able to print out TCP payload using TCP and IP header information
> 5. Able to modify the TCP payload (or at least the copy)
>
> However, the modified packets are not really being transmitted! I ass=
ume this is because I am getting a copy of the packets or the packet da=
ta. Other than getting/setting the TCP and payload data, the rest of th=
e code to intercept the packet is still the basic nfqnl_test.c code.

When I've done it the problem was the checksum. Try to verify if this
is correct :)

>
> How do I actually modify the packet in userspace so that it is sent o=
ut over the network?

You send it by calling nfq_set_verdict and passing in the last two
arguments the packet length and the pointer to packet. Of course, you
must accept the packet.

>
> Also, if I modify the TCP packets and add more data to the payload, w=
hat would I change? I assume that I would only have to change the follo=
wing:
>
> - TCP payload length
> - Checksum
> - IP length (?, would I have to touch this field)
>

The best problem I had with this in the past was the checksum. Check
if your checksum is being right calculated by recalculating the
checksum of a packet you already know the right sum, or running
tcpdump -v.

Remember: anywhere you change you need to recalculate the TCP
pseudo-header(TCP over IPV4 if it's the case) checksum, and if you
change the IP header you also need to recompute the IP checksum.

> Is there anything else that I am not thinking of?
>
> By the way, the documentation available out there is a little hard fo=
r a newcomer to the world of iptables/netfilter. I'm getting a little l=
ost with all the talk about libipq, libiptc, etc. Is there any document=
ation on the history of iptables/netfilter and which libraries have bee=
n retired or are still active?

http://www.netfilter.org/projects/index.html
I think you getting from there you'll using the active.

>
> Sorry for this long e-mail.
>
> Thank you,
> Suman
>
> --
> Falun Gong: www.falundafa.org | www.faluninfo.net
> Peaceful meditation faces persecution in mainland China
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

And also, if you change some headers you'll need to care about
connection tracking(my elbow hurts right now because of it).

I also thanks if you successfully do NAT at user-space and say me how!!

[]'s
--Bruno Moreira Guedes
A boring child
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
