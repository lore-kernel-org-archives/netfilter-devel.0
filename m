From: Simon Lodal <simonl@parknet.dk>
Subject: RFC: Partial IP4 syntax
Date: Wed, 29 Sep 2004 03:41:02 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415A12AE.1060901@parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


While writing yet another IP4 address parser I came up with an idea for 
a more compact IP address/mask notation, to make stuff simpler to write 
and read.

The idea is to just leave out irrelevant octets. There are 3 forms of 
partial addresses:
1) .b.c.d | .c.d | .d (leading dot): Incomplete at beginning.
2) a..d | a..c.d | a.b..d (double dot): Incomplete in the middle.
3) a | a. | a.b | a.b. | a.b.c | a.b.c. (trailing dot or missing 
octets): Incomplete at end.

In each case the position and number of missing octets can be deduced 
and zeroes inserted for them. The parser then calculates a default mask 
which only covers the octets that were defined.

Examples:
10 = 10.0.0.0/8
10. = 10.0.0.0/8
10.0 = 10.0.0.0/16
10.0. = 10.0.0.0/16
.4 = 0.0.0.4/0.0.0.255
.3.4 = 0.0.3.4/0.0.255.255
1..4 = 1.0.0.4/255.0.0.255
.2.3. = invalid, can only be incomplete at one end

I know IP address syntax should not change every day. But this will not 
break or exclude old syntax. I do not see it clashing with other/future 
syntax.

Only minor problem I know of is when parsing netmask which can be in 
cidr or dotted quad form: /32 could be interpreted as a partial address, 
expanded to 32.0.0.0. But it is simple to special case this; make it a 
cidr mask when there is only one octet and it is <=32, otherwise 
interpret as dotted quad (partial or not).

What do you think? Old hat?


Simon
