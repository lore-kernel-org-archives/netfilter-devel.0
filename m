From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_time 20070915
Date: Mon, 17 Sep 2007 19:57:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709171957100.21412@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57160 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbXIQR5V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:57:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 8E30E1C012244
	for <netfilter-devel@vger.kernel.org>;
	Mon, 17 Sep 2007 19:57:20 +0200 (CEST)
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Part 2/2.

---------- Forwarded message ----------
Date: Mon, 17 Sep 2007 17:13:55 +0200 (CEST)
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Subject: Re: xt_time 20070915

netfilter list is kinda slow...

On Sep 17 2007 17:01, Jan Engelhardt wrote:
>>> +	u_int32_t monthdays_match;
>>> +	u_int16_t time_start;
>>> +	u_int16_t time_stop;
>>> +	u_int8_t weekdays_match;
>>
>>No inversion?
>
>[...Length explanation about set theory...]

Actually, there is also a technical limitation. There are three evil
cases the user could do:

	(1)	! --timestart 05:00   --timestop 07:00
	(2)	  --timestart 05:00 ! --timestop 07:00
	(3)	! --timestart 05:00 ! --timestop 07:00

and in all of these, we would have to record that ! was given and
fix up the start and stop times in time_final(). Thay may work,
but cases 2 and 3 look so odd that I am not sure I should do that.

I would really leave it as is now and assume the user is smart
enough to write

	--timestart 07:00 --timestop 05:00

if he wanted to match everything but the morning hours
!(--timestart 05:00 --timestop 07:00)


thanks,
Jan
