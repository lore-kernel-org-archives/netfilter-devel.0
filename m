From: cranium2003 <cranium2003@yahoo.com>
Subject: Re: IP packet logging  function help
Date: Fri, 20 May 2005 05:26:07 -0700 (PDT)
Message-ID: <20050520122607.90281.qmail@web33012.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter <netfilter-devel@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: 6667
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

hello,
       Then how can i get information of on which
interface packet is going out of stack? I want to know
this in kenrel. I am doing some network kernel
programming where i want to get device name of
outgoing packet.
       I thought that when we use LOG rule it shows
that info. so decided to use that function. 
regards,
cranium
--- Patrick Schaaf <bof@bof.de> wrote:
> > I want to know which file in source code has
> pointer
> > to call ipt_log_target function?
> 
> Like any other target function, you'll find the
> call, as an indirect
> function call to ->target(), in
> net/ipv4/netfilter/ip_tables.c, function
> ipt_do_table.
> 
> > I want instance/copy of const struct net_device
> *out to my function in
> > kernel to know that eth0 or eth1 is transmitting
> packet.
> 
> The above information will not help you at all with
> this quest.
> The LOG target already shows input and output
> interface, IF THEY ARE
> KNOWN.
> 
> So, in which iptables table do you intend to get at
> the output device?
> Because, in some table it is simply not yet
> determined, and you won't
> change anything about that by meddling with the
> generic target function
> call site.
> 
> best regards
>   Patrick
> 


		
__________________________________ 
Do you Yahoo!? 
Yahoo! Mail - Find what you need with new enhanced search. 
http://info.mail.yahoo.com/mail_250
