From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Wrong MAC in redirected packet
Date: Thu, 26 Mar 2009 21:54:54 +0100
Message-ID: <49CBEB9E.7080902@gmail.com>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>  <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr>  <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com>  <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr>  <49CA8A6B.1020603@gmail.com>  <alpine.LSU.2.00.0903252047020.28681@fbirervta.pbzchgretzou.qr>  <49CA8C5A.1030908@gmail.com>  <alpine.LSU.2.00.0903252057190.29156@fbirervta.pbzchgretzou.qr>  <49CA9B8B.7080605@gmail.com> <17e3a8f80903260326i636c7c0byaf4d9b0b8e77c514@mail.gmail.com> <alpine.LSU.2.00.0903262106140.15111@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:63168 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbZCZUuo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:50:44 -0400
Received: by ewy9 with SMTP id 9so781939ewy.37
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 13:50:40 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0903262106140.15111@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt skrev:
> On Thursday 2009-03-26 11:26, Kristian Evensen wrote:
>   
>> Turned out that it was the checksums. They were calculated correctly,
>> but since I processed packets on input, tcp_hdr and udp_hdr of course
>> returned invalid pointers. My code is now more or less RAWNAT, so if
>> it is of interest to anybody else I will merge them and make it
>> available.
>>     
>
> I have now rebased the RAWNAT branch to Xt-a's master and
> made the rawpost tables workable with all kernel versions.
> It does not have MAC addr punning yet.
>   
Great, but I think I see a small bug (I left my Linux-machine at work so 
I am not able to try it out). If you use RAWDNAT in prerouting, tcp_hdr 
and udp_hdr will return the wrong values since the corresponsing values 
in the SKB are not set yet. At least, that is what I experienced in my 
own module. Please let me know if I am wrong :)

Would a better solution by to use conntrack to determine the direction, 
check the name of the chain (is that possible?) or just simply ip_hdr + 
1? :)

-Kristian
