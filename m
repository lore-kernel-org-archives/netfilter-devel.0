From: Diego Casado Mansilla <diego.casadomansilla@gmail.com>
Subject: Re: NAT in an already established TCP connection
Date: Wed, 29 Oct 2008 11:01:04 +0100
Message-ID: <49083460.1050104@gmail.com>
References: <4906F699.6010006@gmail.com> <362dff85992463f0566f965662f8b75b@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Julien Vehent <julien@linuxwall.info>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <362dff85992463f0566f965662f8b75b@localhost>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi all,

Julien Vehent wrote:
> On Tue, 28 Oct 2008 12:25:13 +0100, Diego Casado Mansilla
> <diego.casadomansilla@gmail.com> wrote:
>   
>> Hello all!!!
>>
>> This is my first mail in the list.
>>
>> Hopefully the question is interesting and you can figure out how to help
>> me.
>>
>> I use iptables rules to manage the connections from internet to my local 
>> network. I know how to filter, do nat, etc...
>> But this days I'm trying to do NAT in connections that are already 
>> established. The problem is (as far as I know) the packets which pass 
>> throught the nat table are only the SYN packets (once), thus, the 
>> packets that are used to perform a NEW connection.
>>
>> After that the connection is created, the maintenance and the resolution 
>> of the SNAT and DNAT are kept till the connection finish.
>> What I'm wondering is: how can I change the ports or IPs of an already 
>> established connection if my packets just go throught the nat table at 
>> the connection time?
>>
>>     
>
> What you want is to redirect an existing connection to a new destination.
> If you use TCP protocol, the only way to do that is to record the current
> connection and, in parralel, create a second connection to you new
> destination and replay the payload on the packet in the new one.
>
> If you use UDP, this doesn't apply since there's no connection tracking in
> the UDP protocol. Netfilter, however, does some connection tracking on UDP
> packets, so make some test to see if it's doable.
>
> I had to solve the same problem in a honeypot project to redirect active
> connections from low interaction honeypots to high interactions honeypots.
> The solution I choosed was to queue the connections in userland using
> netfilter_queue, process them and replay those I've selected to the new
> destination in parrallel, and then drop the packet from the initial
> connection.
>
> It's tricky to do, and there's many issue to solve, but AFAIK this is the
> most reliable solution.
>   
I have also thought in that solution (or something like that), but I was 
expecting something easier with iptables-conntrack... :o).
So what I will do is to create a new connection between a C'/S' in my 
local machine, and when a packet from the real Server go trouhgt my 
transparent-proxi, I will enqueue it, record the pay-load, do something 
"tricky" with the ack and seq. number (I think that a substraction 
should be enought) and use all this stuff to send the data from S' to 
the Real Client...

After that the client replies with an ACK to the real server...thus.. I 
have to do a replication of that ACK in order to send one copy to the 
real Server and annother one to the S' in order to keep the 
TCP-connection state and flow control.
So...Do I must to use annother time the QUEUE to do so?? I think so.
>   
>> **** Maybe doing packets' replication since those ones are redirected to 
>> annother machine?
>>     
>
> Note : window-tracking is for the tracking of the window size in the tcp
> header, it has nothing to do with this.
>
>
>   
>> **** NAT TCP Extensions??Patch-O-Matic --> window-tracking??
>>
>> **** I read this in an interntet site:
>>
>> --- NEW (and RELATED non-icmp)
>>     This is a very important part relevant for understanding the whole
>>     
> NAT
>   
>>     subsystem. Only if the packet has the state NEW (i.e. it would
>>     establish
>>     a new connection, if we'd accept it), the NAT table is traversed by
>>     calling ip_nat_rule.c:ip_nat_rule_find(), which in turn calls
>>     ip_tables.c:ipt_do_table() for the actual IP table traversal. The 
>> traversal
>>     ends up in either ACCEPTing the packet as it is, or one of the nat 
>> targets
>>     (SNAT, DNAT and if loaded: REDIRECT, MASQUERADE) Please see
>>     chapter FIXME for further description of those targets.
>>
>> --- ESTABLISHED
>>     This packet belongs to an already established connection. We don't
>>     
> need
>   
>>     to traverse the NAT table again, as the necessary information
>>     (struct ip_nat_info) was already gained Hello everybody,
>>
>>
>> Thank you very much in advance and if my questions are not clear don't 
>> doubt to send me a message.
>>
>> Diego.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
>
>
>
> Regards,
> Julien
>
>   
Thanks and regards,
Diego.
