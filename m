From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: NAT breaks my TCP SYN/ACK?
Date: Fri, 19 Dec 2003 11:21:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FE2C324.6010902@netlab.hut.fi>
References: <Pine.LNX.4.44.0312161850090.3671-100000@filer.marasystems.com>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hei!

Sorry for my late answer, I wasn't really at work these last days.

Henrik Nordstrom wrote:

>On Tue, 16 Dec 2003, Emmanuel Guiton wrote:
>
>  
>
>>In my tests, I'm trying from a host at adress X to reach a website at 
>>address Y. However this website does not exist on that address but on 
>>address Z. Thus, basically in my target, I change address Y for Z. But 
>>the connection to the website is refused, and tcpdump shows the following:
>>
>>17:25:21.568709 11.11.11.10.1262 > 10.10.10.10.www: SWE 
>>1338652779:1338652779(0) win 5840 <mss 1460,sackOK,timestamp 
>>8306468[|tcp]> (DF)
>>17:25:21.569136 10.10.10.10.www > 11.11.11.10.1262: R 0:0(0) ack 
>>1338652780 win 0 (DF)
>>    
>>
>
>What does tcpdump on the "website" indicate?
>
>My quess is that the port is not mapped correcly causing the SYN to hit 
>another port on the server than you intended.
>  
>
You are right, I gathered a few more data and that's it:

11:12:41.535710 11.11.11.10.1266 > pc104.4: SWE 2321994237:2321994237(0) 
win 5840 <mss 1460,sackOK,timestamp 31990183[|tcp]> (DF)
11:12:41.535941 pc104.4 > 11.11.11.10.1266: R 0:0(0) ack 2321994238 win 
0 (DF)

The port here is 4 instead of being 80. I'm going to investigate this.
Thanks,

         Emmanuel
