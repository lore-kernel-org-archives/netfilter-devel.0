From: Anders Nilsson Plymoth <lanilsson@gmail.com>
Subject: Re: netfilter queue throughput slowdown
Date: Wed, 29 Jun 2011 11:55:39 +0200
Message-ID: <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com> <1309340843.2532.112.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60512 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1F2J4A convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:56:00 -0400
Received: by eyx24 with SMTP id 24so355453eyx.19
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2011 02:55:59 -0700 (PDT)
In-Reply-To: <1309340843.2532.112.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

Thanks for your reply.
Yes, I am sure I set the verdict, as right now I do it on all packets
by default.
I will try upgrading and see if it works. Do you know if commit
c463ac972315a0 solves the problem you mentioned?

Thanks,
Anders

On Wed, Jun 29, 2011 at 11:47 AM, Eric Dumazet <eric.dumazet@gmail.com>=
 wrote:
> Le mercredi 29 juin 2011 =E0 11:17 +0200, Anders Nilsson Plymoth a =E9=
crit :
>> Hi,
>>
>> I am using libnetfilter-queue on a router running Ubuntu 10.10 with
>> 2.6.35-28-generic. The problem I am having is that I am experiencing=
 a
>> very significant throughput slowdown whenever my NFQUEUE program is
>> running. This happens even when I use bare bone libnetfilter-queue
>> program that immediately issues an ACCEPT verdict as soon as it
>> receives a packet. Whenever this program is running, my max throughp=
ut
>> is cut in half, and the reason it happens is because nf_queue
>> overflows (nf_queue: full at 1024 entries, dropping packets(s)), and=
 I
>> notice my CPU utilization is 100%. However, when my program is not
>> running and I am not passing packets through NFQUEUE and the router
>> routes packets as normal, I get full throughput with only 0.1% CPU
>> utilization.
>>
>> I find this a bit strange, can the netfilter queue processing take t=
he
>> cpu from 0.1% to 100% and start dropping packets even with no other
>> processing than setting immediately setting the verdict? We have two
>> of these machines, with identical hardware and OS, and they experien=
ce
>> the same behavior.
>> I am also confused as we have been using these machines previously a=
nd
>> been able to obtain full throughput with our netfilter program.
>>
>> Does anyone have a clue here, or suggest what I should look into in
>> order to speed things up.
>>
>
> Hmm, this is a known problem.
>
> net/netfilter/nfnetlink_queue.c uses a single list of packets per que=
ue.
>
> If your application gives verdict for a packet not at the head of que=
ue,
> find_dequeue_entry() spend a lot of time to find the packet.
>
> So are you sure you dont forget to give verdict for some packets, and
> queue fills to its limit ?
>
> Some attempts in the past tried to convert this list in a tree but AF=
AIK
> nothing was merged.
>
> By the way, latest Ubuntu has more recent kernel, you could try it as=
 it
> includes commit c463ac972315a0 (netfilter: nfnetlink_queue: some
> optimizations)
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
