From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v3] Add refcounts to LED target
Date: Thu, 08 Apr 2010 14:57:56 +0200
Message-ID: <4BBDD2D4.2090205@trash.net>
References: <4A18A70F.50808@shikadi.net> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net> <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net> <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr> <4B14EA81.5030603@trash.net> <4B1B82D5.2070607@shikadi.net> <4B1BB086.3030700@trash.net> <4BAB6CB2.3050904@trash.net> <alpine.LSU.2.01.1003251504500.32573@obet.zrqbmnf.qr> <4BAB6E70.8090605@trash.net> <4BAD841A.9060103@shikadi.net> <alpine.LSU.2.01.1003271214440.13915@obet.zrqbmnf.qr> <4BADEE6A.5000103@shikadi.net> <alpine.LSU.2.01.1003271253190.1149@obet.zrqbmnf.qr> <4BAEB013.6060001@shikadi.net> <alpine.L
 SU.2.01.1004041327160.22215@obet.zrqbmnf.qr> <4BBCAF97.6040806@trash.net> <4BBD478F.4050208@shikadi.net> <4BBDBF09.6070403@trash.net> <alpine.LSU.2.01.1004081444520.28332@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36789 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab0DHM55 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:57:57 -0400
In-Reply-To: <alpine.LSU.2.01.1004081444520.28332@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-04-08 13:33, Patrick McHardy wrote:
>> Adam Nielsen wrote:
>>> I've moved the mutex around so that hopefully all these operations are now atomic.
>>>
>>>> The remaining parts look fine to me, thanks.
>>> Great, I hope you're happy with this one!
>> Looks good to me, thanks. Jan, any further issues from your side?
> 
> None at this time.
> 

Thanks. Adam, please send a formal submission, including a changelog and
a Signed-off-by.
