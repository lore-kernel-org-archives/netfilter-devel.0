From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] Debian packages for libnfnetlink, libnetfilter-{queue,
 log, conntrack}, conntrack
Date: Mon, 19 Dec 2005 12:22:57 +0100
Message-ID: <43A69811.8000609@trash.net>
References: <20051127173411.GA2031@roonstrasse.net>
	<438A02D3.3030203@trash.net>
	<20051202102345.GA29691@roonstrasse.net>
	<43A59A5F.1010006@trash.net>
	<20051219104728.GZ7006@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>, Max Kellermann <max@duempel.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051219104728.GZ7006@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Sun, Dec 18, 2005 at 06:20:31PM +0100, Patrick McHardy wrote:
> 
>>I've changed libnetlink_conntrack to use the correct type, I guess
>>we should release this soon. Harald, I'm not familiar with the
>>process, can you please take care of this?
> 
> 
> yes, I'll do a new release.  Do we only need libnetfilter_conntrack, or
> also other packages (libnfnetlink / conntrack)?

Thanks. The CTA_PROTO_NUM issue only requires a new
libnetfilter_conntrack release, but there might be other reasons
for releasing the other libraries as well. Pablo probably knows
better than me.
