From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] kill NFC_* stuff in iptables [was Re: iptables compile
 error: NFC_IP_TOS undeclared]
Date: Fri, 11 Feb 2005 20:07:34 +0100
Message-ID: <420D0276.5080200@trash.net>
References: <Pine.GSO.4.33.0502101758010.19216-100000@indigo>	<420B8623.9050308@niksula.hut.fi>
	<420B9ED0.1020303@trash.net> <420BEB36.7080209@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <420BEB36.7080209@eurodev.net>
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

Pablo Neira wrote:

> I've renamed all NFC_* stuff != NFC_UNKNOWN to NFC_UNKNOWN. So people 
> using ct_sync won't complain about this again. I see this as a first 
> step to remove the old behaviour of nfcache. Please, see the patch 
> attached.

Why didn't you remove it entirely instead ?

Regards
Patrick
