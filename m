From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: connection destruction question
Date: Fri, 12 Mar 2004 14:58:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4051B401.3070005@netlab.hut.fi>
References: <200403112155.i2BLt8Er012209@sirius.cs.pdx.edu>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kristen Carlson <kristenc@cs.pdx.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

No, you're not insane: you need the patch. I'm not sure it's available 
for 2.4.18, but at least it is for 2.4.23 (as it is what I use).

          Emmanuel



Kristen Carlson wrote:

>>Hi!
>>
>>Did you take a look at the events used in nf_conntrack?
>>I had a similar problem and I solved it that way. You may have to define 
>>a new event (in ip_conntrack.h), or may not, I don't remember if it's 
>>already included. if you have to use a new event, you can send it with 
>>the ip_conntrack_cache_event() function.
>>    
>>
>
>
>	Hum, I don't see any such thing in my kernel version.  I'm using
>a kernel for an embedded system, so it isn't straight forward for me to 
>upgrade.  I should have specified: on 2.4.18.  Unless I am insane and 
>this is really somewhere I didn't grep properly.  I didn't see it in
>net/ipv4/netfilter or include/linux/netfilter_ipv4.
>  
>
