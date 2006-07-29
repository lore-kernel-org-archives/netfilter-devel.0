From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnetfilter_queue hang when flooding
Date: Sat, 29 Jul 2006 17:07:36 +0200
Message-ID: <44CB79B8.3060502@trash.net>
References: <1154175007.8178.28.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: victor@inl.fr,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1154175007.8178.28.camel@localhost>
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

Eric Leblond wrote:
> Hi,
> 
> I've proceed to some stress test of libnetfilter_queue using hping3.
> 
> ./hping3 -p 5000  --flood localhost
> 
> 
> The main issue is that the recv buffer of the netlink socket gets full.
> We've got error 105 during recv.
> unbinding from queue 0
> 
> I provide a patch to print error and avoid printf to be able to test
> performance of libnetfilter_queue.
> 
> The problem is that when socket is full we disconnect and try to close
> the queue :
> 	got error 105 during recv.
> 	unbinding from queue 0
> It hangs here. gdb shows that we hang in recvmsg.

Its waiting for an ACK from the kernel .. which doesn't seem to
be very reasonable unless measures are taken in case it doesn't
arrive within some timeframe. So I think you could do one of:

- don't require an ACK
- implement timeouts and retransmissions in case ACK doesn't arrive
