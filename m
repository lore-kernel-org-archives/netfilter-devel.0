From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ip_conntrack cleanup on reconnection?
Date: Sat, 10 Jul 2004 17:36:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40F00D16.9040109@eurodev.net>
References: <opsan10edrkwfgqe@starbug.karlshof.de> <20040710115729.GA2230@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040710115729.GA2230@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Herve,

Herve Eychenne wrote:

>>Having a look at net/ip_MASQUARDE.c the ip_conntrack list should be empty  
>>after a device was down (cleanup?), but
>>the list still is full of entries.
>>Shouldnt the list be empty or, at least rewritten with the new  
>>ip-addresses?
>>    
>>
>
>Yes, it should. During the last netfilter workshop, after one of my remarks,
>Rusty Russell wrote a patch to the MASQUERADE target which cleans the tables
>only if the address changes (before, they were cleaned
>unconditionnaly).
>I don't know when the patch was applied upstream in 2.4 or if it's related
>to your problem...
>  
>

If I think that I observed a similar behaviour in 2.6, but using 
DNAT/SNAT targets instead of MASQUERADE. Well, actually I'm not sure if 
this exactly what you mean.

root@legba:/home/pablo# iptables -I POSTROUTING -t nat -j SNAT --to 
192.168.30.30
root@legba:/home/pablo# telnet 192.168.0.44 80
Trying 192.168.0.44... ^c
root@legba:/home/pablo# cat /proc/net/ip_conntrack
tcp      6 114 SYN_SENT src=192.168.0.3 dst=192.168.0.44 sport=32779 
dport=80 [UNREPLIED] src=192.168.0.44 dst=192.168.30.30 sport=80 
dport=32779 use=1
                                          ^^^

root@legba:/home/pablo# iptables -D POSTROUTING -t nat -j SNAT --to 
192.168.30.30
root@legba:/home/pablo# cat /proc/net/ip_conntrack
tcp      6 108 SYN_SENT src=192.168.0.3 dst=192.168.0.44 sport=32779 
dport=80 [UNREPLIED] src=192.168.0.44 dst=192.168.30.30 sport=80 
dport=32779 use=1
                                          ^^^

root@legba:/home/pablo# telnet 192.168.0.44 80
Trying 192.168.0.44...
root@legba:/home/pablo# cat /proc/net/ip_conntrack
tcp      6 2 SYN_SENT src=192.168.0.3 dst=192.168.0.44 sport=32779 
dport=80 [UNREPLIED] src=192.168.0.44 dst=192.168.30.30 sport=80 
dport=32779 use=1
                                       ^^^
tcp      6 106 SYN_SENT src=192.168.0.3 dst=192.168.0.44 sport=32780 
dport=80 [UNREPLIED] src=192.168.0.44 dst=192.168.0.3 sport=80 
dport=32780 use=1
                                        ^^^

I'll have a look at this issue (just for fun (tm)), I'll also look for 
that Rusty's patch if someone doesn't post it to the list before. This 
could generate a lot of established (for tcp) entries with a long 
timeout but, it's also true that I don't usually remove NAT rules once 
the box is configured.

regards,
Pablo
