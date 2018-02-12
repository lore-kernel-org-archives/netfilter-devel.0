From: Gregory Vander Schueren <gregory.vanderschueren@tessares.net>
Subject: Re: How to retrieve original source address with FTP/NAT/TPROXY
Date: Mon, 12 Feb 2018 17:39:54 +0100
Message-ID: <19d784d0-beb7-6bc8-d86f-7c77470c7bea@tessares.net>
References: <1d02f5e0-2a45-f12a-8f81-bc47e84a9455@tessares.net>
 <20180208165520.gh5qjmo6vrz2jg42@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Cc: netfilter-devel@vger.kernel.org, matthieu.baerts@tessares.net,
        Gregory Detal <gregory.detal@tessares.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:51349 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964902AbeBLQj5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Feb 2018 11:39:57 -0500
Received: by mail-wm0-f52.google.com with SMTP id r71so10781393wmd.1
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Feb 2018 08:39:56 -0800 (PST)
In-Reply-To: <20180208165520.gh5qjmo6vrz2jg42@salvia>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Thank you for getting back to me. Also thanks for pointing me to
libnetfilter_conntrack, I will definitely have a look.

I am using kernel 4.1.39 and the issue can be reproduced with the 
following ruleset on the Proxy host:

iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -t mangle -N DIVERT
iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
iptables -t mangle -A DIVERT -j MARK --set-mark 1
iptables -t mangle -A DIVERT -j ACCEPT
ip rule add fwmark 1 lookup 100
ip route add local 0.0.0.0/0 dev lo table 100
iptables -t mangle -A PREROUTING -p tcp ! --dport 21 -i eth0 -j TPROXY 
--tproxy-mark 0x1/0x1 --on-port 9999

Then I simply retrieve an FTP file (in passive mode) from the client and 
I use a toy C program (see below) on the Proxy to retrieve the source IP.

I am still wondering if the IP returned by accept is a normal behavior. 
What do you think? Don't we expect accept() to return the client's IP?

Regards,
Gregory

#include <stdio.h>
#include <arpa/inet.h>
int main()
{
         struct sockaddr_in addr;
         socklen_t len = sizeof(addr);
         int sock;
         int one = 1;

         addr.sin_family = AF_INET;
         addr.sin_port = htons(9999);
         addr.sin_addr.s_addr = INADDR_ANY;

         sock = socket(PF_INET, SOCK_STREAM, 0);
         setsockopt(sock, SOL_IP, IP_TRANSPARENT, &one, sizeof(one));
         bind(sock, (struct sockaddr*)&addr, sizeof(addr));
         listen(sock, 1);
         accept(sock,(struct sockaddr *)&addr, &len);

         char *ip = inet_ntoa(addr.sin_addr);
         printf("%s\n", ip);
}

On 02/08/2018 05:55 PM, Pablo Neira Ayuso wrote:
> Hi Gregory,
> 
> On Tue, Feb 06, 2018 at 03:40:20PM +0100, Gregory Vander Schueren wrote:
>> Hello,
>>
>> I have the following IPv4 network:
>>
>> FTPClient <-----------------> Proxy <--------------> FTPServer.
>>       10.0.0.2          10.0.0.1   1.1.1.1        1.1.1.2
>>
>> FTPClient connects to FTPServer in PASSIVE mode, meaning the FTPClient
>> initiates the data connection towards FTPServer. Proxy performs NAT in the
>> POSTROUTING chain using the iptables MASQUERADE target. On Proxy, I use the
>> iptables TPROXY target to redirect the FTP data connection towards a local
>> socket.
>>
>> Upon accept() on this socket, the address returned by accept() is 1.1.1.1,
>> not the IP of the Client (10.0.0.2) as I expected. Using getpeername() also
>> returns 1.1.1.1. For other TCP connections than FTP accept() or
>> getpeername() returns 10.0.0.2.
>>
>> I noticed this only occurs when using the NF_CONNTRACK_FTP and NF_NAT_FTP
>> kernel modules.
>>
>> Note that I was able to retrieve the FTPClient IP on Proxy from
>> /proc/net/ip_conntrack. I also made a quick patch to add a SO_ORIGINAL_SRC socket option
>> (similar to SO_ORIGINAL_DST) which allows to retrieve the FTPClient
>> IP. Since this option does not exist yet, I am wondering if this is
>> relevant to add such an option?
> 
> You can use libnetfilter_conntrack to do this these days, via ctnetlink.
> 
>> Also, this does not occur in IPv6.
>>
>> Is this behavior normal?
> 
> Probably it is related to your ruleset? You could post an example to
> reproduce the issue and your kernel version.
> 
> Thanks.
> 

-- 

------------------------------
DISCLAIMER.
This email and any files transmitted with it are confidential and intended 
solely for the use of the individual or entity to whom they are addressed. 
If you have received this email in error please notify the system manager. 
This message contains confidential information and is intended only for the 
individual named. If you are not the named addressee you should not 
disseminate, distribute or copy this e-mail. Please notify the sender 
immediately by e-mail if you have received this e-mail by mistake and 
delete this e-mail from your system. If you are not the intended recipient 
you are notified that disclosing, copying, distributing or taking any 
action in reliance on the contents of this information is strictly 
prohibited.
