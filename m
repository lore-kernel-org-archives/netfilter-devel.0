From: Michael Gale <michael.gale@utilitran.com>
Subject: Re: NAT and ICMP
Date: Fri, 18 Feb 2005 14:10:40 -0700
Message-ID: <421659D0.6020301@utilitran.com>
References: <200502171912.j1HJCFV06530@isis.cs3-inc.com>	<16918.17766.816573.731012@isis.cs3-inc.com>
	<421648BD.6060809@utilitran.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <421648BD.6060809@utilitran.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Sorry ... I was thinking of the system with out NATing ... obviously I 
need a day off.

Michael.

Michael Gale wrote:
> Hello,
> 
>     This makes sense from a routing perspective, if your RH box was a 
> router on the web or routing to public networks then it would be 
> functioning normally.
> 
> How ever is a firewall setup this is a undesirable response ... I would 
> suggest blocking ICMP traffic on the external interface. Some people 
> like to allow some specific ICMP traffic like Destination Unreachable or 
> PATH MTU ... some people simple block all ICMP traffic.
> 
> I do not think this is a netfilter problem just a simple configuration 
> issue depending on your setup.
> 
> Michael.
> 
> 
> Don Cohen wrote:
> 
>> Here's some behavior that seems clearly wrong, though I'm not
>> sure what is right.  This is from a redhat 8 box, 2.4.18-14,
>> so it's possible that this could be either specific to redhat
>> or fixed (or at least altered) in later kernels.
>>
>> This box is connected to a LAN, and doing NAT for that LAN:
>>
>> inside 10.0.0.2 --- 10.0.0.1 redhat8 24... --- internet --- server
>>
>> The inside machine connects to the server in the internet.
>> In my test case it's doing ssh, running a program that prints
>> the time every minute.
>> I now disconnect the inside machine.
>> The server sends the next time update (to 24..., the address of
>> the redhat NAT machine, to be forwarded to the inside machine).
>> The redhat machine can no longer reach the inside machine and
>> replies with ICMP host unreachable - returning the packet that
>> it could not deliver, which is addressed to 10.0.0.2 !
>> This is clearly wrong, since the server has no idea who 10.0.0.2
>> is.  On the other hand, it also makes no sense to claim that
>> 24... is an unreachable host - that's the one that is actually
>> answering.  The best I can think of is that it ought to say that
>> the port is unreachable for the packet it received (pre-NAT, so
>> its own address and the port as seen at the server).
>>
>>
> 

-- 
Michael Gale
Lan Administrator
Utilitran Corp.

Hey, let me file that under important .... > /dev/null
...
"Hey did you read my e-mail"
"Let my check"
^From:.* > /dev/null
"Nope, I missed it, send it again"
