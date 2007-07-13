From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] LOG target - log GID
Date: Fri, 13 Jul 2007 11:59:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707131158220.25352@fbirervta.pbzchgretzou.qr>
References: <4693DD17.9020406@ae.poznan.pl>
	<200707120903.l6C93PS2025329@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: maciej.soltysiak@ae.poznan.pl, netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707120903.l6C93PS2025329@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Jul 12 2007 18:03, Yasuyuki KOZAKAI wrote:
>> Hi,
>> 
>> While I was browsing through the files in my home directory I stumbled 
>> upon my patch from
>> May 2003 that adds to the LOG target an option to log UID and GID.
>> 
>> I noticed that someone already has done that in the past 4 years ;-)
>> However currently LOG only logs UID. My patch used to log GID too, so
>> what do you say about applying the patches attached.
>
>We cannot change format of LOG target because that breaks programs parsing logs.

Hm, then it's time to write a specification on how to correctly parse things
(namely, splitting at whitespace and parsing the ^\S+= component of it rather
than assuming things were in a fixed order)

>But it might be possible by introducing new option like '--log-gid'.


	Jan
-- 
