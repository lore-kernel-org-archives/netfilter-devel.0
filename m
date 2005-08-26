From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] TTL target goes mainline ?
Date: Fri, 26 Aug 2005 15:41:27 +0200
Message-ID: <430F1C07.5020305@trash.net>
References: <20050826111832.GT4226@rama.de.gnumonks.org>
	<430F007B.20605@trash.net>
	<20050826131901.GY4226@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050826131901.GY4226@rama.de.gnumonks.org>
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
> On Fri, Aug 26, 2005 at 01:43:55PM +0200, Patrick McHardy wrote:
> 
> 
>>Why not, people can just as easy shoot themselves using bridging or
>>tc actions. But I'm not sure about enabling only parts of functionality
>>without CONFIG_EXPERIMENTAL, why not simply depend entirely on it?
> 
> 
> because decrementing the TTL is considered safe, routers do it all the day ;)

Sure :) I just think its nicer than to enable "sub-functionality" by
config options, so if its there, its usable. I also don't think there
are people who actually have CONFIG_EXPERIMENTAL disabled, so in
the end, we just save a few ifdefs in the code.
