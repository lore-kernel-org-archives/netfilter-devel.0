From: Tim Burress <tim@variosecure.net>
Subject: Re: TCP Connection tracking and SYN/ACK/PSH
Date: Fri, 22 Apr 2005 18:38:03 +0900
Message-ID: <4268C5FB.5040201@variosecure.net>
References: <20050417193718.6a7f0809.gniibe@fsij.org>	<Pine.LNX.4.61.0504180316120.4321@filer.marasystems.com>	<4265B0B7.5090707@variosecure.net>
	<Pine.LNX.4.61.0504200842001.22001@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, NIIBE Yutaka <gniibe@fsij.org>,
	ukai@debian.or.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0504200842001.22001@filer.marasystems.com>
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

Hello!

Henrik Nordstrom wrote:

> On Wed, 20 Apr 2005, Tim Burress wrote:
>
>> explicitly forbidden during the handshake [RFC 793, pg. 30]. In any 
>> other protocol, a request to perform a prohibited operation would, I 
>> think, be considered invalid, so in the end I think Netfilter is 
>> doing the right thing, inconvenient as it may be for a few devices.
>
>
> I am of a slightly different opinion. These segments is not invalid 
> (only odd) and won't cause any disturbance to the TCP protocol as long 
> as the standard on how to process received segments is followed.
>
> I am of the opinion that as long as the traffic is not explicitly 
> violating the protocol conntrack should track it. Stricter checking 
> belongs in a separate match such as unclean if desired imho.

I think the segments are invalid (or at least in-something), but I agree 
with your second point. Since PSH has no bearing on TCP connection 
state, it seems like it might be better to treat PSH the same way as ECE 
and CWR, and have conntrack ignore it. Other layers could then decide 
whether to accept or drop combinations like SYN+ACK+PSH depending on how 
strictly they want to enforce protocol conventions in the firewall. It's 
not so much a question of whether the segments are valid or not as 
whether strict protocol enforcement (beyond what is needed for 
connection tracking) is really conntrack's job. And since I didn't 
design it, I'm not sure!

Tim
