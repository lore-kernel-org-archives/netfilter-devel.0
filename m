From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: udp portforward on same interface
Date: Tue, 15 Jul 2003 15:37:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F14037E.8050206@gmx.de>
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


Hello,

first of all this is the the netfilter developing mailing list, maybe
you try the users mailing list next time?? ;-)

What you want to do can easily be done with the REDIRECT
target. Try something like

iptables -t nat -A PREROUTING -p udp --dport 78 -j REDIRECT --to-ports 98

Hope this helps ;-)

Sven


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
