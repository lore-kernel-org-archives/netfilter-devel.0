From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Tue, 22 Jun 2004 13:14:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D81480.3000402@eurodev.net>
References: <Pine.LNX.4.44.0406211102000.23953-100000@filer.marasystems.com> <Pine.LNX.4.33.0406211240500.31871-100000@blackhole.kfki.hu> <20040622043928.GA21406@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Henrik Nordstrom <hno@marasystems.com>,
 Martin Josefsson <gandalf@wlug.westbo.se>,
 Patrick McHardy <kaber@trash.net>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20040622043928.GA21406@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Willy,

Willy Tarreau wrote:

>Hi Jozsef,
>
>On Mon, Jun 21, 2004 at 12:51:41PM +0200, Jozsef Kadlecsik wrote:
> 
>  
>
>>So you could live happily if such packets are marked as INVALID by
>>conntrack, which implies then that the ICMP code/type checking would be
>>acceptable as well? [Pablo's patch did not want to drop the packets but
>>mark as INVALID.]
>>
>>It's time to add documentation exactly which packets are dropped or marked
>>as INVALID by conntrack.
>>    
>>
>
>May I ask that we could have a new result other than INVALID for such
>packets ? It's becoming difficult to differenciate :
>
>  - valid packets for which there is no session
>  - valid packets for which there is a session but which are invalid wrt
>    this session (wrong flags, sequence numbers, retransmits, ...)
>  - invalid packets (in the 'unclean' sense)
>  
>

I have an idea, in the case of unclean packets, perhaps we could use the 
nfcache field in skb to set a special flag like "NFC_CLEAN". Could we 
use nfcache for that purpose?

regards,
Pablo
