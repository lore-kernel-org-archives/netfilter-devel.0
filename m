From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: u32 extension
Date: Mon, 10 Sep 2007 12:39:19 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709101238110.11640@fbirervta.pbzchgretzou.qr>
References: <46E50BE5.80401@trash.net>
	<Pine.LNX.4.64.0709101227020.11640@fbirervta.pbzchgretzou.qr>
	<46E51D7D.9000003@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46E51D7D.9000003@trash.net>
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


On Sep 10 2007 12:33, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> On Sep 10 2007 11:18, Patrick McHardy wrote:
>>>
>>>I just noticed the u32 extension is missing from iptables.
>>>Could you send me your latest version please.
>> 
>> Adds u32 to iptables.
>
>Applied, thanks Jan.
>
>>  symlink extensions/libip6t_u32.man -> extensions/libipt_u32.man
>
>I copied it and fixed a bunch of warnings on 64 bit:
>
>extensions/libxt_u32.c: In function 'u32_parse':
>extensions/libxt_u32.c:146: warning: format '%u' expects type 'unsigned
>int', but argument 3 has type 'long int'

argument 3 is actually of type ptrdiff_t, but whatever :)
Yeah should be %lu.


	Jan
-- 
