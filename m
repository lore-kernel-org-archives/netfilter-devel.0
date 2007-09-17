From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_time 20070915
Date: Mon, 17 Sep 2007 17:13:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709171710320.4516@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709151806080.24423@fbirervta.pbzchgretzou.qr>
	<46EE86FA.10604@trash.net>
	<Pine.LNX.4.64.0709171616070.4516@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0709171616070.4516@fbirervta.pbzchgretzou.qr>
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
