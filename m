From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Fw: [Bugme-new] [Bug 4180] New: masquarade and source ip
Date: Mon, 07 Feb 2005 21:15:50 +0100
Message-ID: <4207CC76.8040500@trash.net>
References: <20050207114212.024a09bb.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>, netfilter-devel@lists.netfilter.org
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050207114212.024a09bb.davem@davemloft.net>
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

David S. Miller wrote:

>Didn't this get changed on purpose?
>
Yes. One thing we could do to make it more consistent is treat
local packets the same way as forwarded ones in MASQUERADE, then
at least all packets would have the same source address. This check
currently prevents local packets from beeing masqueraded:

        /* FIXME: For the moment, don't do local packets, breaks
           testsuite for 2.3.49 --RR */
        if ((*pskb)->sk)
                return NF_ACCEPT;

I'm not sure if we can simply remove it, maybe Rusty remembers :)

Regards
Patrick

>
>Begin forwarded message:
>
>if i do ping www.google.com from router source ip is 2.3.4.5, but if i do ping
>from local network source ip is 1.2.3.4 (i think it's wrong)
>
>with older kernel source ip is always set to 2.3.4.5
>
>
