From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE:Re: netfilter programming
Date: Mon, 29 Mar 2004 18:08:21 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403291757510.28533-100000@filer.marasystems.com>
References: <20040329130856.ED26B3BA3E9@smtp.latinmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jorge Garcia <anarkophobia@latinmail.com>
In-Reply-To: <20040329130856.ED26B3BA3E9@smtp.latinmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 29 Mar 2004, Jorge Garcia wrote:

> hi, and thanx for answer me, im sorry if i didnt explain well on my last post.
> for educational and intelectual satisfaction i want to make a module that do this:
> iptables -A INPUT -i eth0 -s 192.168.100.7 -p tcp --dport 23 -j DROP
> So i search the internet and i find very little stuff about this but i make the following code :
> 
> 	/* Descarta paquetes si vienen de la direccion 192.168.100.7 */ 	
> 
> 	if(sock_buff->nh.iph->saddr == *(unsigned int*)direccion_ip){
>             return NF_DROP; 
>         }
> 
> 	if(sock_buff->nh.iph->protocol != 17){	/* Nos aseguramos de que el paquete sea tcp */
>            return NF_ACCEPT; 
>         }  	
> 
> 	cabecera_tcp = (struct tcphdr *)(sock_buff->data   (sock_buff->nh.iph->ihl *4));	/* Descartamos por puerto */
> 
> 	if((cabecera_tcp->dest) == *(unsigned short*)puerto){
>             return NF_DROP; 
>         }  
>
>       return NF_ACCEPT;

>From what I can tell the above logics is qeuovalent to

iptables -A INPUT -s 192.168.100.7 -j DROP
iptables -A INPUT ! -p tcp -j ACCEPT
iptables -A INPUT -p tcp --port 23 -j DROP
iptables -A INPUT -j ACCEPT

> I dont understand how it drops from source port, i only copy and paste from a code i found in the net, please explain me something about how to programming that part.

cabecera_tcp = (struct tcphdr *)(sock_buff->data   (sock_buff->nh.iph->ihl 
*4));        /* Descartamos por puerto */

references the TCP header, where the source/destination port etc can be 
found within the packet payload.

> The other problem is that this module is this:
> This code showld drop incomming connections to port 23 from 192.168.1007, but its drop connections to port 23 from all the addresses in the local network, like 192.168.100.12

Yes, and a generic C programming question, nothing special to netfilter.  
If you want a aggregate condition then you need to and the parts together,
or narrowing it down by eleminating the opposites..


  if (A && B && C)
     return X;
  return Y;

and

  if (!A)
    return Y;
  if (!B)
    return Y;
  if (!C)
    return Y;
  return X;

is logically equivalent..

   if (A)
     return X;
   if (!B)
     return Y;
   if (C);
     return X;
   return Y;

is not..



Another hint: There is htonX/ntohX macros for converting network/host byte 
order..

Regards
Henrik
