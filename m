From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables icmp protocol match bug.
Date: Mon, 04 Aug 2003 22:50:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F2EC72A.7040308@trash.net>
References: <54265908055.20030731224710@lf.lv> <3F298F80.2000304@trash.net> <20030802160551.GB21637@naboo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Peteris Krumins <newsgroups@lf.lv>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030802160551.GB21637@naboo>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>On Thu, Jul 31, 2003 at 11:52:00PM +0200, Patrick McHardy wrote:
> 
>  
>
>>This is deliberate. There is no valid icmp-type 255, it is used as a
>>wildcard to match every possible type. See icmp_type_code_match()
>>in ip_tables.c. Perhaps the userspace tool should warn about invalid
>>types ?
>>    
>>
>
>yes, please make this a bugzilla entry so we don't forget about that.
>  
>

I'll do that later or just send a patch.

Bye
Patrick
