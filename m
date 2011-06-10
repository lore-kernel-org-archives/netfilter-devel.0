From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: FTP Packet Mangling & NAT
Date: Fri, 10 Jun 2011 21:26:11 +1200
Message-ID: <4DF1E333.2060604@treenet.co.nz>
References: <BANLkTintTA8T_FEqF-vWe85iTonfZHGn3w@mail.gmail.com>	<81c0aab748c6ad27b289055e31777945@treenet.co.nz> <BANLkTim6WA1AW=ARNXKEx1kyVDo6TjCp-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Nadeem Douba <ndouba@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:59724
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1FJJ2i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:28:38 -0400
In-Reply-To: <BANLkTim6WA1AW=ARNXKEx1kyVDo6TjCp-Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/06/11 07:06, Nadeem Douba wrote:
>>   The proxy completely controls what the client gets given. It is
>>   breaking transparency by not reverse-mapping the response properly.
>>   Mention it to the authors and get it fixed.
>
> The authors (Websense) are of a different opinion of how this issue is
> fixed. They recommended that we enable active FTP (significant
> security risk).
>

Strange opinion. PORT needs the same types of handing in a relay/proxy 
as PASV does. Only the control channel syntax is different.
  Perhapse they meant websense accepts active FTP 
(client-ACTIVE->proxy-PASV->server) or something like that.


As I see it they have two scenarios to pick from:

a) opening relay data connection themselves and setting that as the PASV 
advertised port. Then "manually" as it were shuffling the bytes back and 
forward there. Being websense and wanting to see inside the data this is 
probably their best fix.

b) sending some port mapping details into netfilter indicating that 
packets from server IP:port are going to be related to client IP:port.

>
>>   A transparent proxy is equivalent to a NAT module in all respects.
>>   Merely operates on the FTP layer in this case.
>>   Switch "module" for "proxy" and you have a good plan for fixing the
>>   bug.
>
> Not really, even proxying these requests would result in the same
> issue as the child proxy would relay the parent proxy's response.

huh? "even proxying these requests". The whole point of your original 
post was that they *are* proxied, and the proxy is failing to NAPT the 
control channel syntax on the reply.

A->B->C->D chaining of relays does not matter. Each relay hop can, and 
must, do its own NAPT.


Just to clarify; what I read you asking about was this scenario:

   When layer-7 software (proxy) does a NAPT mapping of text syntax 
IP1:port1 -> IP2:port2 sent out on IP3:port3 (proxy->server control 
control).
   How to implement a layer-2 software (netfilter) to figure out this 
mapping and to do the reverse IP2:port2 -> IP1:port1 mapping on the text 
data inside the TCP packet body of packets returning on IP4:port4 
(client->proxy control channel).
So the packet flow is:
   control: client--nf_nat (DNAT/REDIRECT)-->proxy->server
   data:    client<--nf_nat (SNAT)----server

Keep in mind that websense proxy terminates a TCP connection and 
generates a completely separate independent TCP connection from itself 
to the source server. Whether that is FTP origin or other proxy.

  So that the client->proxy information is in the INPUT tables.  The 
server->proxy response is in the OUTPUT tables.  And NAT is done in a 
third place the proxy normally does not have write access to.

  So to me those factors all mean layer-2 where netfilter modules 
operate is a very hard place to figure out what the correct mapping 
should be.

(Jan, please correct me if you have some advanced magic voodoo that lets 
INPUT and OUTPUT chain connections link as RELATED state)


Things get particularly nasty when, as you can see from that very first 
comment I made above, the connections between proxy and server can 
differ in their active/passive mode. Things like that happen at layer-7, 
on some developers whim.


>
>>   NOTE: If you do steps 5 and 6 in the IP layer you will be bypassing the
>>   proxy data handling and void all your reasons for having it done by a
>>   proxy in the first place. Instead of by the conntrack NAT module for FTP
>>   for both outgoing and returning traffic.
>
> The point is not to get rid of the proxy but to fix the issue that the
> proxy is presenting to all FTP communications.

Which was the gist of my point.


AYJ
