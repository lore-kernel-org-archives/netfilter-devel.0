From: Jim Mar <jmar@metavize.com>
Subject: Re: Bridging and IPT Queueing
Date: Sun, 11 Jul 2004 21:13:51 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40F20FFF.2030403@metavize.com>
References: <Pine.LNX.4.44.0407091846360.8729-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0407091846360.8729-100000@filer.marasystems.com>
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

>On Thu, 8 Jul 2004, Jim Mar wrote:
>
>  
>
>>I've been looking at IPT Queueing in a bridging environment on
>>a 2.6 kernel and noticed that the indev associated with the
>>queued packet is the bridge device, eg. br0, instead of the
>>physical interface. While this is true, it would be nice to know
>>the physical indev of the packet. Is there a way of finding it?
>>    
>>
>
>The physdev match?
>  
>
Yes, physdev match will work. Thanks. Using physdev match, can I get
the physical indev for a redirected packet?

>  
>
>>I tried looking at the HW address, but that seems broken.
>>    
>>
>
>This should give you the destination HW address of the packet, not the 
>interface it was received on.
>
>Regards
>Henrik
>
>
>  
>
