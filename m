From: Patrick McHardy <kaber@trash.net>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 18:13:38 +0200
Message-ID: <44E0A132.6040709@trash.net>
References: <44E07BCD.8030206@trash.net>
	<20060814142559.GS7194@kriss.csbnet.se>
	<44E08946.1040105@trash.net>
	<20060814152026.GU7194@kriss.csbnet.se>
	<44E09693.9000606@trash.net>
	<20060814160443.GX7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060814160443.GX7194@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> 2006-08-14 17:28:19+0200, Patrick McHardy <kaber@trash.net> ->
> 
>>>
>>>Please have a look here for 4 modules "needing" this patch:
>>>http://www.gozem.se/~gozem/netfilter/
>>
>>Please post your examples to the list.
>>
> 
> 
> In which format? As a full patch for the kernel or something that fits in
> pom-ng? The current code works for 2.4 and early 2.6. I don't want to spend
> time porting it into "wrong" API now when we are discussing priv_data to be
> or not to be :-)

I'm mostly interested in the way you wish to use it, so I can better
judge whether this change is worth doing or not.

> Yes, its ugly but has been working in our routers for atleast a year now. I
> will however port it to use a global list state instead as some of the
> modules already does.

I don't say its not working, but we can't put something like this
in the kernel. So you need some identifier to find your state after
changes. Besides the uglyness, we don't have anywhere to put it in
the blob so userspace can return it, so it would end up beeing something
local to the individual modules again (like table name in recent
and hashlimit), just what we're doing today.
