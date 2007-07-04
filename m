From: "=?ISO-8859-2?Q?Stanis=B3aw_Pitucha?=" <viraptor@gmail.com>
Subject: Re: netfilter queue not on filter table
Date: Wed, 4 Jul 2007 13:00:24 +0100
Message-ID: <717e7cba0707040500y1bf24073x59d4c6621b25292b@mail.gmail.com>
References: <717e7cba0707030739h48ce146es8a0e67744af3f790@mail.gmail.com>
	<717e7cba0707030814h2de28c4fx8b672b518a9c008d@mail.gmail.com>
	<717e7cba0707030818m2e646709wea0e8a5306904f79@mail.gmail.com>
	<200707040308.l643826W014886@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707040308.l643826W014886@toshiba.co.jp>
Content-Disposition: inline
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

> If you mean that 'outgoing ones' are the packets generated at the local
> node queueing packets, they don't pass through PREROUTING, but OUTPUT.
>
> Please refer following.
> ...

Great - thanks! That solved the capturing problem. Now I'm using QUEUE
on both PREROUTING and OUTPUT.
But now I've got another one:
I'm rewriting addresses like in standard dnat:
client <-> gateway (choosing server) <-> servers

Outgoing ones are delivered as they should: (own logging fragment)
Tried packet: From: 192.168.1.37:32938 to: 192.168.1.111:53
Redirection! - Sent packet: From: 192.168.1.37:32938 to: 192.168.1.1:53

Incoming packet gets changed:
Got packet: From: 192.168.1.1:53 to: 192.168.1.37:32938  'n redirected
Delivered packet: From: 192.168.1.111:53 to: 192.168.1.37:32938

but application doesn't see it. Additionally wireshark sees outgoing
packet changed, but incoming one original:
192.168.1.1:53->192.168.1.37:32938. Is that normal? What can be the
reason? If I leave source address unchanged, packet arrives to the app
with real source without problems.

Thanks
