From: Patrick McHardy <kaber@trash.net>
Subject: Re: LibIPQ issue
Date: Mon, 07 Mar 2005 14:10:03 +0100
Message-ID: <422C52AB.4030801@trash.net>
References: <e54bc1880503070451419fc57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
To: =?ISO-8859-1?Q?S=E9rgio_Bernardino?= <sergio.bernardino@gmail.com>
In-Reply-To: <e54bc1880503070451419fc57@mail.gmail.com>
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
> 
> iptables -t filter -A OUTPUT -p ip -j QUEUE
> 
> I can alter the destination address of the outgoing packet (for
> example, a packet that goes from A to B becomes a packet that goes
> from A to A, a localhost packet), and it all works fine.
> I seems like i'm doing something wrong but i can't quite figure out
> what. Any ideas?

Packets in LOCAL_OUT are manually rerouted by ip_queue. Packets
mangled in PRE_ROUTING should be routed correctly according to
the data contained in the new packet. Could it be that you are
testing on loopback ?

Regards
Patrick
