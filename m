From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How to implement attack detection?
Date: Tue, 6 Apr 2004 12:18:11 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404061216050.7298-100000@filer.marasystems.com>
References: <s07225f2.012@prv-mail25.provo.novell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org,
   <netfilter-devel-request@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Swaroop Ashish <sashish@novell.com>
In-Reply-To: <s07225f2.012@prv-mail25.provo.novell.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 6 Apr 2004, Swaroop Ashish wrote:

> limits to incoming/outgoing packets for example if I am getting more
> than 5 SYN packets from a particular IP address, I can block any further
> SYN requests from that IP Address.

Are you sure you want to do this? Makes it trivial for attackers to block 
others access to your server by only knowign their IP address..

> Now to write a Intrusion Detection System, how that limit counter is
> exposed by Nefilter/Iptables and how can I use it in my userspace
> firewall? So that I can easily check for the exposed counter and
> drop/reject the packets or allow them.

You can do what you describe in the kernel by using a combination of the 
limit match and the pool/ipset functions to remember the offending IP 
address.

You can also use the QUEUE method to have selected packets sent to 
userspace for further processing.

Regards
Henrik
