From: Peteris Krumins <newsgroups@lf.lv>
Subject: Re[2]: iptables icmp protocol match bug.
Date: Fri, 1 Aug 2003 01:17:02 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <172274899714.20030801011702@lf.lv>
References: <54265908055.20030731224710@lf.lv> <3F298F80.2000304@trash.net>
Reply-To: Peteris Krumins <newsgroups@lf.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3F298F80.2000304@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Friday, August 1, 2003, 12:52:00 AM, you wrote:

PM> Peteris Krumins wrote:

>>Hello,
>>
>> A quick bug report:
>>
>> iptables -A INPUT -p icmp --icmp-type 255 -i lo -j REJECT
>>

PM> This is deliberate. There is no valid icmp-type 255, it is used as a
PM> wildcard to match every possible type. See icmp_type_code_match()
PM> in ip_tables.c. Perhaps the userspace tool should warn about invalid
PM> types ?

Why there is no valid icmp-type 255? Maybe it is not defined by rfc or
(IANA?), but it could still be used, couldnt it? (Tho i block all but
those really needed).

Why is it defined to be used as a wildcard worldwide? If not, I think
this is wrong - because if it is not defined to be used for this
purpose, then it is still valid and could be used (by some
application which constructs packets itself and has chosen 0xff for
communications, for example).


P.Krumins
