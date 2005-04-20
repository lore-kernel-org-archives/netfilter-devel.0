From: Tim Burress <tim@variosecure.net>
Subject: Re: TCP Connection tracking and SYN/ACK/PSH
Date: Wed, 20 Apr 2005 10:30:31 +0900
Message-ID: <4265B0B7.5090707@variosecure.net>
References: <20050417193718.6a7f0809.gniibe@fsij.org>
	<Pine.LNX.4.61.0504180316120.4321@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, NIIBE Yutaka <gniibe@fsij.org>,
	ukai@debian.or.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0504180316120.4321@filer.marasystems.com>
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

Henrik Nordstrom wrote:

> Just a small note to support this: SYN+ACK+PSH is a perfectly valid 
> flags combination, even more so if there actually is data enclosed in 
> the SYN+ACK (which is valid, only a little odd).
>
> There is not really any good reason why conntrack should care in 
> detail about the PSH flag. Most if not all valid flag combinations are 
> good both with and without PSH (even SYN).

We recently had a similar issue, and initially I thought it was overly 
paranoid for Netfilter to mark these segments invalid, but after some 
digging I've changed my mind. The problem is that, even though there is 
no statement in the standards classifying SYN/ACK/PSH itself as invalid, 
the operation that PSH demands -- immediate transmission to the 
application -- is explicitly forbidden during the handshake [RFC 793, 
pg. 30]. In any other protocol, a request to perform a prohibited 
operation would, I think, be considered invalid, so in the end I think 
Netfilter is doing the right thing, inconvenient as it may be for a few 
devices.

In our case the device was a Panasonic WJ-NT104 interface/server for 
network cameras. Apparently there is an embedded TCP/IP stack making the 
rounds in Japan that sets the PSH flag on *every* segment. Panasonic's 
technical support have not yet replied to queries about the issue, but 
we're hoping they will issue a firmware upgrade to fix the problem. In 
the meantime, we modified our rules to allow INVALID traffic to/from the 
device. Obviously it's not ideal, but it gets the job done. If Panasonic 
is unable/unwilling to fix the TCP behavior, we would probably patch 
Netfilter to clear the PSH flag when it occurs in combination with SYN. 
That way we could accept the traffic without allowing invalid segments 
through to hosts on the other side.

Tim
