From: "jon hale" <jon.h.hale@gmail.com>
Subject: Re: Does policy routing based on owner-gid really work?
Date: Wed, 3 Sep 2008 15:52:37 -0700
Message-ID: <abe9c56e0809031552o11f1bb8ctccc5aac5bbc9d6e@mail.gmail.com>
References: <abe9c56e0808221638m35d2af7bu3535099e55e6c786@mail.gmail.com>
	 <48BBEAC3.8040801@trash.net>
	 <abe9c56e0809021144g12be20fcue4c6c336dc47eea8@mail.gmail.com>
	 <20080903142225.GA28695@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Eric Leblond" <eric@inl.fr>, "jon hale" <jon.h.hale@gmail.com>,
	"Patrick McHardy" <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:46325 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYICWwi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:52:38 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2970438rvb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Sep 2008 15:52:37 -0700 (PDT)
In-Reply-To: <20080903142225.GA28695@khasse.inl.fr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Well I tried adding the CONNMARK line that you suggest.
I then try a simple ftp from here to there of a 2 byte file.

I run tcpdumps on both the ppp0 and eth0 interfaces catching all of
the packets that are going out to "there".

What I see is that when my machine (here) is responding to the Fin
packet sent by the server that this goes out eth0. When I thought that
I had configured it otherwise.
All other packets until that point seem happy to go out ppp0.

Here is the end of my tcpdump for ppp0 (sorry about the newlines):
15:19:55.751793 IP here.56122 > there.31436: P 1:3(2) ack 1 win 183
<nop,nop,timestamp 5883109 3768519952>
15:19:55.751818 IP here.56122 > there.31436: F 3:3(0) ack 1 win 183
<nop,nop,timestamp 5883109 3768519952>
15:19:55.937661 IP there.31436 > here.56122: . ack 3 win 49232
<nop,nop,timestamp 3768519990 5883109>
15:19:55.938657 IP there.31436 > here.56122: . ack 4 win 49232
<nop,nop,timestamp 3768519990 5883109>
15:19:55.939657 IP there.31436 > here.56122: F 1:1(0) ack 4 win 49232
<nop,nop,timestamp 3768519991 5883109>
************************1
15:19:55.944660 IP there.ftp > here.49902: P 99:123(24) ack 14 win
49232 <nop,nop,timestamp 3768519991 5883109>
15:19:55.944700 IP here.49902 > there.ftp: . ack 123 win 216
<nop,nop,timestamp 5883302 3768519991>
15:19:59.324588 IP there.31436 > here.56122: F 1:1(0) ack 4 win 49232
<nop,nop,timestamp 3768520328 5883109>
*************************2
15:20:05.364448 IP there.31436 > here.56122: R 3806895453:3806895453(0) win 0

While on eth0 the following two packets went out:
15:19:55.939675 IP here.56122 > there.31436: . ack 3806895454 win 183
<nop,nop,timestamp 5883297 3768519991>
15:19:59.324628 IP here.56122 > there.31436: . ack 1 win 183
<nop,nop,timestamp 5886681 3768519991>

Looks like they are both acking the FIN sent by the server.

Any ideas on why this packet would go out the "wrong" interface?
Suggestions on how I may continue to debug this?
Thank you for your time,
-jon


On Wed, Sep 3, 2008 at 7:22 AM, Eric Leblond <eric@inl.fr> wrote:
> Hello,
>
> On Tuesday, 2008 September  2 at 11:44:18 -0700, jon hale wrote:
>> On Mon, Sep 1, 2008 at 6:14 AM, Patrick McHardy <kaber@trash.net> wrote:
>> > jon hale wrote:
>> >>
>> >> I have a problem when I combine owner-gid, fwmark, and iproute2.
>> >> I am starting to wonder if I can really get there from here.
>> >>
>> >> Synopsis:
>> >>       I have been trying to set up policy routing based upon the group id
>> >>       of the process sending the packets.
>> >>
>> >>       It works for most packets, but there is some scenario that happens
>> >> at
>> >>       the end of every ftp upload, where the packet goes out the wrong
>> >>       interface and gums up the works.
>> >
>> > The stack may send packets that don't belong to the original socket.
>> > You need to use CONNMARK to make sure all packets of a connection
>> > are marked similar.
>> >
>> Hmm, I thought I was using CONNMARK
>> I do have the iptables command:
>>       iptables -t mangle -A OUTPUT -j CONNMARK --save-mark
>>
>> Is there something else I need as well?
>
> maybe:
> iptables -t mangle -A PREROUTING -j CONNMARK --restore-mark
>
> BR,
> --
> Eric Leblond
> INL: http://www.inl.fr/
> NuFW: http://www.nufw.org/
>
