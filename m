From: Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>
Subject: Re: [PATCH] remove overzealous checks in REJECT target]
Date: Fri, 17 Dec 2004 11:47:42 +0100
Message-ID: <41C2B94E.4010200@gmx.net>
References: <20041216133959.GH10165@sunbeam.de.gnumonks.org>
	<41C2720B.7@trash.net>
	<20041217075442.GB11436@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041217075442.GB11436@sunbeam.de.gnumonks.org>
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

Harald Welte schrieb:
> On Fri, Dec 17, 2004 at 06:43:39AM +0100, Patrick McHardy wrote:
> 
>>Harald Welte wrote:
>>
>>
>>>Hi Patrick!
>>>
>>>I agree with Yasuyuki's proposed changes, do you already have this patch
>>>in your pending queue?
>>
>>I missed it, but the patch is wrong. We must return at least 8 byte of
>>protocol header, so the check can't be removed. The skb_header_pointer
>>part looks fine, I'm going to apply it after getting some sleep.
> 
> 
>>RFC1122: §3.2.2:
> 
> 
> Thanks for pointing this out.  I certainly read it a number of times
> before, but it slipped my mind temporarily.

Well, the kernel for sure doesn't care if netfilter isn't loaded. My
patch (and by consequence, Yasuyuki's patch) only tried to behave the
same as a kernel without netfilter enabled.

Hint: Try nmap "protocol scan" on a host without netfilter loaded. It
will happiliy reject packets which are too short. Then enable REJECT
for all IP protocols you don't want to support. And you'll see that
the too short packets will suddenly stay unanswered.

So we either break the standard or we don't, but breaking it only if
netfilter is not loaded doesn't sound like a sensible default to me.


Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
