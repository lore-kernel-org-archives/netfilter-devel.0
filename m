From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] Die to NOTRACK/TRACE, long live MARK!
Date: Fri, 28 May 2004 13:41:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B72556.2050902@eurodev.net>
References: <Pine.LNX.4.44.0405271232190.11108-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.44.0405271232190.11108-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Henrik Nordstrom wrote:

>On Tue, 25 May 2004, Pablo Neira wrote:
>  
>
>>if we use atomic operations *_bit for status field in ip_conntrack, we 
>>only use 24 bits of that unsigned long, this issue lets us keep 
>>compatibility with some special platforms which only support atomic 
>>operations of that size.
>>    
>>
>
>Correct. This is also documented int the Kernel API IIRC.
>  
>
yes, but I made a mistake, I was talking about atomic operations but 
actually Patrick asked about test_bit/set_bit operations.

regards,
Pablo
