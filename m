From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Tue, 21 Oct 2003 22:00:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F959060.3000807@trash.net>
References: <Pine.LNX.4.44.0310212149340.7523-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0310212149340.7523-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

>On Tue, 21 Oct 2003, Patrick McHardy wrote:
>
>  
>
>>Ok there's another problem, for fast lookups by id (we don't want to
>>search the entire hash) we need to encode the hash chain of a tuple 
>>in the id. We basically have two choices now for the remaining bits:
>>    
>>
>
>You can always make the userspace ID larger by including the bucket
>number. There is no need to extend the ID stored in the conntrack for
>this as it is already known.
>
>Regards
>Henrik
>  
>

Ok I have to admit I didn't think of this obvious solution.

Thanks again,
Patrick
