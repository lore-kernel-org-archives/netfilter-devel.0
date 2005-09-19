From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
	not
Date: Mon, 19 Sep 2005 13:54:47 +0300
Message-ID: <87mzm972fc.fsf@aka.i.naked.iki.fi>
References: <4326FF69.9060004@trash.net> <871x3p875j.fsf@aka.i.naked.iki.fi>
	<432C58F5.8030306@trash.net>
	<20050918.002730.74976897.davem@davemloft.net>
	<87vf0y7jb8.fsf@aka.i.naked.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <87vf0y7jb8.fsf@aka.i.naked.iki.fi> (Nuutti Kotivuori's message
	of "Sun, 18 Sep 2005 13:37:47 +0300")
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

Nuutti Kotivuori wrote:
> Our next step in testing is to modify the application handling the
> QUEUE packets to detect TCP FIN,ACK packets and intentionally sleep
> for a bit before accepting them - with that we can see if it crashes a
> lot sooner that way and pinpoint the problem at something bad
> happening while the packets sit in the QUEUE.

Well, this is now done - and makes no difference. So simply letting
the FIN,ACK packets delay in QUEUE does not make it crash.

-- Naked
