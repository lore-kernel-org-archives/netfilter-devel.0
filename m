From: Chee Yong TAN <chee_yong_tan@hotmail.com>
Subject: Re: Sending back out A TCP Packet from netfilter
Date: Mon, 23 Feb 2004 20:14:42 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4039EEB2.70705@hotmail.com>
References: <Pine.LNX.4.44.0402230831240.29722-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0402230831240.29722-100000@filer.marasystems.com>
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

>On Mon, 23 Feb 2004, Chee Yong TAN wrote:
>
>  
>
>>What is the proper procedure in getting the packet send out back to the 
>>network ?
>>    
>>
>
>See the REJECT iptables target for example on how this can be done.
>  
>
I have tried to follow the codes closely but seems that it kills the 
interrupt handler. I keep getting Oops with that dread Aiyee killing the 
interrupt handler

>Regards
>Henrik
>  
>
