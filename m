From: XiChimos <xichimos@plobe.com>
Subject: Re: Buffer size
Date: Tue, 20 Jan 2004 21:47:18 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <400DE836.8050604@plobe.com>
References: <Pine.LNX.4.44.0401210325200.30308-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <henrik@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0401210325200.30308-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Well, basically one that contains the payload and IP header, which is 
returned by ipq_read.  Basically my question is if I am casting the 
payload of the ipq packet msg structure into a data-type, what is the 
maximum size that this type should be?  Or in other words, what is the 
largest value of the ipq packet msg structure's data length field?  I 
thought it should be 2^16 bytes, but when I saw that in the example code 
they had ipq_read only needing a buffer of size 2046 bytes, I started to 
question myself.

Henrik Nordstrom wrote:

>What buffer are you referring to?
>
>Regars
>Henrik
>
>On Tue, 20 Jan 2004, XiChimos wrote:
>
>  
>
>>The application adds an IP option to every TCP packet that it sees.
>>
>>Henrik Nordstrom wrote:
>>
>>    
>>
>>>On Tue, 20 Jan 2004, XiChimos wrote:
>>>
>>> 
>>>
>>>      
>>>
>>>>I was looking at the code for a userspace application and noticed that 
>>>>the buffer size was 2048.
>>>>   
>>>>
>>>>        
>>>>
>>>What kind of userspace application?
>>>
>>>Regards
>>>Henrik
>>> 
>>>
>>>      
>>>
>>    
>>
