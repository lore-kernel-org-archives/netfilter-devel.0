From: Amin Azez <azez@ufomechanic.net>
Subject: Re: nfnetlink-ctnetlink working: INSTRUCTIONS
Date: Mon, 18 Apr 2005 13:49:48 +0100
Message-ID: <4263ACEC.7070209@ufomechanic.net>
References: <20050414175616.0331.LARK@linux.net.cn>	<425E4403.5010101@eurodev.net>	<20050415142613.033A.LARK@linux.net.cn>
	<42602331.6060706@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42602331.6060706@eurodev.net>
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

Pablo Neira wrote:
> Wang Jian wrote:
> 
>> Hi Pablo Neira,
>>
>> The current patches (dated 14-Apr), seems to not emit event messages,
>> such as when new connection is established.
> 
> 
> Hm it works just fine here.
> 
> o The ct-event notification API is ok, try this test:
> http://people.netfilter.org/~pablo/patches/test/ct-event-test.tar.gz
> 
> o Netlink notification works fine as well via:
> http://people.netfilter.org/~pablo/conntrack-tool/
> 
> Try:
> # conntrack -E conntrack

I'm just taking conntrack to bits, and I am puzzled about the existance 
of libctnetlink.h and libnfnetlink.h in conntrack's include directory.

The main difference seems to be the extra parameter in 
ctnl_get_conntrack and ctnl_del_conntrack which is not part of my 
libctnetlink library.

Pablo, is this the old id that is no longer needed because the tuples 
are enough, but still in your libctnetlink? Or something else?

Sam
