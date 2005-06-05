From: =?ISO-8859-1?Q?J=F8rn_Andre?= <jornandr@stud.ntnu.no>
Subject: Re: The big Picture of all the tables ...
Date: Sun, 05 Jun 2005 12:08:16 +0200
Message-ID: <42A2CF10.2020201@stud.ntnu.no>
References: <3abe8064b60ddf1a@mayday.cix.co.uk>
	<42A218B8.8060504@outerspace.dyndns.org>
	<5559d90e8cb32fad@mayday.cix.co.uk>
	<42A22703.5090000@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <42A22703.5090000@outerspace.dyndns.org>
To: netfilter-devel@lists.netfilter.org
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



Jonas Berlin wrote:

>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>Quoting Robert de Bath on 2005-06-04 21:49 UTC:
>  
>
>>>>3) What happens if you use NOTRACK.
>>>>        
>>>>
>>>If you look at my pic, NOTRACK makes the packet skip all the green boxes.
>>>      
>>>
>>But what about the pink boxes (NAT), they can't do anything without
>>connection tracking but do they try?
>>    
>>
>
>Yeah, I'm 99% sure nat isn't traversed either, nat afaik requires
>connection tracking..
>
>  
>
>>>>4) Is there anything else that can make a packet deviate (cf: DROP)
>>>>        
>>>>
>>>Well there is QUEUE but I guess it continues from where it left off..
>>>I'm not really sure.
>>>      
>>>
>>Hmmm, QUEUE ... :-/
>>    
>>
>
>I mean
>
>  iptables ... -j QUEUE
>
>I don't know where in the chain it should/can go..
>  
>
I've made an app that uses -j QUEUE and inserted the rule into mangle 
PREROUTING on one host and OUTPUT on another.
This is to change destination on a packet to make sure all packets are 
routed between them.
The conntrack module is hooked into PREROUTING and OUTPUT also, but with a
high priority (-200, see <linux/netfilter_ipv4.h>) such that every 
user-inserted  rule with iptables get below it, i.e -j QUEUE -t mangle
This means packet mangling (in case src/dst IP change) wont be noticed 
by conntrack and will not work. I have made my own NAT'ing
for now, but the best solution would be an integration to the existing 
conntrack. If anyone has a suggestion....

With QUEUE you can accept/drop/change packets. QUEUE is able to be 
inserted into any chain it seems.

Picture of the iptables flow? Take a look at  
https://lists.netfilter.org/pipermail/netfilter/2004-March/051131.html
[ googling: iptables flow chart]

>- --
>- - xkr47
>-----BEGIN PGP SIGNATURE-----
>Version: GnuPG v1.4.1 (GNU/Linux)
>
>iD8DBQFCoicBxyF48ZTvn+4RAvE2AKDmyW8VVf1rwtgwAcP7lC2Z/9u9YQCfZJm7
>ySFngQVolJnutrFFFln4IzE=
>=q2uT
>-----END PGP SIGNATURE-----
>  
>
