From: Patrick McHardy <kaber@trash.net>
Subject: Re: udp portforward on same interface
Date: Tue, 15 Jul 2003 14:36:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F13F542.4010301@trash.net>
References: <060e01c34a32$ad0df860$15d2f181@TheTraveller>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Amir Zangeneh <amir@noytrino.com>
In-Reply-To: <060e01c34a32$ad0df860$15d2f181@TheTraveller>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This doesn't belong on netfilter-devel as it's clearly a user question which
can even be easily answered by looking at the manpage.

Example:
iptables -t nat -A PREROUTING -i <if> -p udp --dport 78 -j REDIRECT 
--to-ports 98
iptables -A INPUT -i <if> -p tcp --dport 98 -j ACCEPT

Bye
Patrick

Amir Zangeneh wrote:

> Hi
>  
> I'm using iptables as a firewall system and I'm very pleased. But I'm 
> trying to make a rule which forwards a udp port to another on the same 
> interface.. I want users who connect to port 78 be redirected to port 
> 98.. Is it possible to do this with iptables? If yes.. Could someone 
> give me an example.. thank you..
>  
>  
> Amir
