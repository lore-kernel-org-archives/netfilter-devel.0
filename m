From: Patrick McHardy <kaber@trash.net>
Subject: Re: LibIPQ issue
Date: Wed, 09 Mar 2005 00:29:28 +0100
Message-ID: <422E3558.8050200@trash.net>
References: <e54bc1880503070451419fc57@mail.gmail.com>	<422C52AB.4030801@trash.net>	<e54bc1880503071117322999d@mail.gmail.com>	<Pine.LNX.4.62.0503072027540.5934@kaber.coreworks.de>
	<e54bc188050308150854d6b128@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
To: =?ISO-8859-1?Q?S=E9rgio_Bernardino?= <sergio.bernardino@gmail.com>
In-Reply-To: <e54bc188050308150854d6b128@mail.gmail.com>
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

Sérgio Bernardino wrote:
> After a bit more time working with this i realized something "interesting":
> When i send a packet from a machine A to a machine B and capture it in
> PRE_ROUTING, if i change the destination address so that it points to
> machine C, the packet disappears and i can't track it anywhere. On the
> other hand, if i instead change the source address of the packet so
> that it points to machine C everything works fine. I can "see" the
> packet traversing into machine B, which receives the packet and
> promptly replies sending a packet to machine C. Machine A never
> receives a reply to the packet it sent and machine C receives a reply
> from a packet it never sent. Exactly the behaviour expected when
> changing the source address field. Now, if this works in this case,
> merely changing it to alter the destination address (my original
> intention) should work also, but it doesn't.
> My code can't be incorrect in a situation like this, so what exactly
> is wrong? And is there a away to solve such situation?
> Ideas anyone?

Have you got IP forwarding enabled ?

echo 1 >/proc/sys/net/ipv4/ip_forward

Regards
Patrick
