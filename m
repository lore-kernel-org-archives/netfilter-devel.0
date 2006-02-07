From: "Vasantha Kumar Puttappa" <vasanthakumar@iitb.ac.in>
Subject: Re: ip_local_deliver related query
Date: Tue, 7 Feb 2006 11:58:05 +0530 (IST)
Message-ID: <37547.10.107.26.27.1139293685.squirrel@gpo.iitb.ac.in>
References: <60828.10.107.26.27.1138947199.squirrel@gpo.iitb.ac.in>   
	<43E36101.8020708@trash.net>
	<4503.10.12.25.5.1139034091.squirrel@gpo.iitb.ac.in>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Vasantha Kumar Puttappa <vasanthakumar@iitb.ac.in>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4503.10.12.25.5.1139034091.squirrel@gpo.iitb.ac.in>
To: "Vasantha Kumar Puttappa" <vasanthakumar@iitb.ac.in>
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

Hi Patrick,
  Thanks for your response. I have one more thing to clarify.
  ( Sorry in the previous I made a great mistake, I wanted to change
  destination IP address of the packet and not the source IP address).

  ( I am referring to first figure in the following link
 http://www.linuxsecurity.com/resource_files/firewalls/IPTables-Tutorial/iptables-tutorial.html)

  If I am not wrong, NAT is being in done in PREROUTING AND POST-ROUTING
 stage. But what I want to do is to take packets in FILTER INPUT stage and
 change the destination IP address ( I don't want to create any SNAT
 corresponding to that) and give it to local process.
 (Assume that a socket waiting with that new destination address)

  So, will there be any problem ?


 Also, Let me tell you what I am planning to do..

 1. Create a TCP socket(connection) with machine ip address X
 2. Now I am changing machine IP address to Y
 3. Now capture the incoming packets coming to the machine  corresponding
 to this TCP connection with new IP addres as destination address
   ( assume that all problems related to TCP binding have been taken care
     and packets are able to reach the machine with new IP address although
     application TCP is still binded to old IP address x)
and replace new IP address Y with old IP address X(in FILTER INPUT stage).


  So, will socket works fine after doing Destination IP address translation
 in FILTER INPUT stage or will there be any problem as soon as IP address
changes ?

 Please give me your valueable feedback


 --------
 Vasanth
 IIT Bombau
>
>
>
>
>
>> Vasantha Kumar Puttappa wrote:
>>> Hi,
>>>
>>> ( I am assuming packet arrival to the local host)
>>>
>>>   As far as I know Netfilter hook  for "INPUT" chain is called just
>>> before
>>> the ip_local_deliver() function is called. If I am not wrong,
>>> ip_local_deliver function will remove the IP header and gives the
>>> packet
>>> to appropriate function in transport layer ( TCP or UDP or ICMP
>>> Process).
>>>
>>>
>>>  What I am want to do is to change the source IP address of the IP
>>> packet
>>> just before calling the ip_local_deliver() using IPtables.
>>>
>>> So I want know, will this go smoothly assuming there is a socket
>>> waiting
>>> for this kind of packet(packet with new source IP address) or will
>>> something go wrong ?
>>
>> This is exactly what NAT does. If you use DNAT in LOCAL_OUT, a SNAT
>> mapping is also set up for LOCAL_IN. The socket lookup is performed
>> later in the individual protocols, so it will use the rewritten
>> source address.
>>
>
>
>
