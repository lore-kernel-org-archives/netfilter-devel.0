From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Unable to build iptables on linux kernel 2.6.10 + 2.6.11-rc2
 +	2.6.11-rc2-bk5
Date: Tue, 01 Feb 2005 02:31:17 +0100
Message-ID: <41FEDBE5.3030606@eurodev.net>
References: <200501271553.j0RFr747004108@StraightRunning.com>
	<41FD5F3C.1060009@eurodev.net>
	<20050201005133.GJ31837@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Colin Harrison <colin.harrison@virgin.net>
To: Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20050201005133.GJ31837@postel.suug.ch>
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

Thomas Graf wrote:

>> 		/* The protocol. */
>>-		u8 protonum;
>>+		u_int8_t protonum;
>> 
>> 		/* The direction (for tuplehash) */
>>-		u8 dir;
>>+		u_int8_t dir;
>>    
>>
>
>I think __u8 would be a better choice.
>  
>

I don't think so. With __u8 iptables doesn't compile anymore on my laptop.

cc -O2 -Wall -Wunused -I/home/pablo/bk/linux-2.5/include -Iinclude/ 
-DIPTABLES_VERSION=\"1.3.0\"  -fPIC -o extensions/libipt_conntrack_sh.o 
-c extensions/libipt_conntrack.c
In file included from extensions/libipt_conntrack.c:13:
/home/pablo/bk/linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_tuple.h:67: 
parse error before `__u8'
/home/pablo/bk/linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_tuple.h:67: 
warning: no semicolon at end of struct or union
...

--
Pablo
