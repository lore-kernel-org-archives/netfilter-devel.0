From: Patrick McHardy <kaber@trash.net>
Subject: Re: Unable to build iptables on linux kernel 2.6.10 + 2.6.11-rc2
 +	2.6.11-rc2-bk5
Date: Tue, 01 Feb 2005 14:17:56 +0100
Message-ID: <41FF8184.2070809@trash.net>
References: <200501271553.j0RFr747004108@StraightRunning.com>
	<41FD5F3C.1060009@eurodev.net>
	<20050201005133.GJ31837@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>,
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
>
>I think __u8 would be a better choice.
>
Usually yes, but all netfilter headers use u_intX_t.
