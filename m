From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] updated ctnetlink patches
Date: Sun, 01 Jun 2003 01:11:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED9369B.3000203@trash.net>
References: <3ED4BD16.8030606@trash.net>	 <20030531205210.GE29312@sunbeam.de.gnumonks.org>	 <3ED9306B.6000607@trash.net> <1054422066.24777.1.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1054422066.24777.1.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



Martin Josefsson wrote:

>>then this change would probably also make sense for mainline kernel. i was
>>even thinking about going a bit further and only doing changes if they are
>>bigger than say 1s, it doesn't seem to matter. if not that, maybe reduce
>>only event messages to 1/s for timer changes.
>>    
>>
>
>Look at the last part of optimizations/ip_ct_refresh_optimization.patch
>I've been running with that patch for a long time and it works fine.
>

thanks, i will add it to the patch.

Best regards,
Patrick
