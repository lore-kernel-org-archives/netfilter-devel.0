From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: IP Connection Tracking - which connections?
Date: Sun, 16 Jun 2002 15:21:38 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206161521.39215@henrik.marasystems.com>
References: <1024229576.13234.4.camel@trent.nin>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: alex <alex@bennee.com>,
	Netfilter Development Mailing List <netfilter-devel@lists.samba.org>
In-Reply-To: <1024229576.13234.4.camel@trent.nin>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sunday 16 June 2002 14:12, alex wrote:
> I'm running a NAT'ed firewall on my gateway box and recently I've
> been having problems with the connection chocking and I have been
> unable to ssh onto the box to see what was going on. I think (as
> I've not got loads of memory) its probably due to the maximum
> number of tracked connections being exceeded (the logs show
> ip_conntrack droping new conenction).
>
> However I'm still unsure as to why I couldn't shell onto the box.
> After all the ssh connection doesn't need to tracked as it
> terminates on that box (and should't go through any of the -t nat
> tables). Or am I misunderstanding the workings of conntrack?

conntrack currently tracks every connection. Does not matter if you 
actually use any features depending on conntrack for the connection 
or not.

If you don't have too much memory in the netfilter box then you most 
likely will need to instruct conntrack to use a bigger connection 
tracking table, best set by increasing the hash size. (hashsize= 
module argument)

Regards
Henrik
