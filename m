From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Fri, 21 May 2004 11:33:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40ADCCF0.9040505@eurodev.net>
References: <Pine.LNX.4.44.0405210317470.14542-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0405210317470.14542-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Henrik,

Henrik Nordstrom wrote:

>>e) I'm not sure if it's worthy optimizing this case. In tcp_new, we are 
>>checking if a packet is clean as well as size of tcp header, then in 
>>tcp_packet we will do the same, so we are doing twice the same checking. 
>>If we consider that general case is that packets are clean, will be this 
>>double check worthy?
>>    
>>
>
>But there is one obvious way to optimize this.. move the check for a valid 
>TCP header to the pkt_to_tuple function. 
>

We can't do that because we are not only checking the tcp header but 
also using the information for window scaling.

regards,
Pablo
