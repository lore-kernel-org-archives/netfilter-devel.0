From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TCP Connection tracking and SYN/ACK/PSH
Date: Wed, 20 Apr 2005 09:42:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504200842001.22001@filer.marasystems.com>
References: <20050417193718.6a7f0809.gniibe@fsij.org>
	<Pine.LNX.4.61.0504180316120.4321@filer.marasystems.com>
	<4265B0B7.5090707@variosecure.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, NIIBE Yutaka <gniibe@fsij.org>,
	ukai@debian.or.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tim Burress <tim@variosecure.net>
In-Reply-To: <4265B0B7.5090707@variosecure.net>
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

On Wed, 20 Apr 2005, Tim Burress wrote:

> explicitly forbidden during the handshake [RFC 793, pg. 30]. In any other 
> protocol, a request to perform a prohibited operation would, I think, be 
> considered invalid, so in the end I think Netfilter is doing the right thing, 
> inconvenient as it may be for a few devices.

I am of a slightly different opinion. These segments is not invalid (only 
odd) and won't cause any disturbance to the TCP protocol as long as the 
standard on how to process received segments is followed.

I am of the opinion that as long as the traffic is not explicitly 
violating the protocol conntrack should track it. Stricter checking 
belongs in a separate match such as unclean if desired imho.

Regards
Henrik
