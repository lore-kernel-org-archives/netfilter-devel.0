From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables icmp protocol match bug.
Date: Fri, 01 Aug 2003 00:39:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F299A94.5040003@trash.net>
References: <54265908055.20030731224710@lf.lv> <3F298F80.2000304@trash.net> <172274899714.20030801011702@lf.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peteris Krumins <newsgroups@lf.lv>
In-Reply-To: <172274899714.20030801011702@lf.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Peteris Krumins wrote:

> PM> This is deliberate. There is no valid icmp-type 255, it is used as a
>
>PM> wildcard to match every possible type. See icmp_type_code_match()
>PM> in ip_tables.c. Perhaps the userspace tool should warn about invalid
>PM> types ?
>
>Why there is no valid icmp-type 255? Maybe it is not defined by rfc or
>(IANA?), but it could still be used, couldnt it? (Tho i block all but
>those really needed).
>

It is not defined. The highest defined type is ICMP_ADDRESSREPLY (18).
Of course some application could construct _invalid_ icmp packets, but
who cares ?

>Why is it defined to be used as a wildcard worldwide? If not, I think
>this is wrong - because if it is not defined to be used for this
>purpose, then it is still valid and could be used (by some
>application which constructs packets itself and has chosen 0xff for
>communications, for example).
>  
>

Ok i see your point, "icmp-type 255 equals wildcard" was introduced
as a workaround for "-m icmp" not matching all (or none, i can't
remember exactly) types. I suppose if you submit a patch with a better
solution, everyone will be fine with it, but it doesn't sound as if you
would need it yourself. IIRC one of the reason this way was chosen was
backwards-compatibility, if you introduce a new flag you break the ABI.

Bye
Patrick

>
>P.Krumins
>  
>
