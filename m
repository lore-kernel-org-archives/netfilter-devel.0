From: Patrick Schaaf <bof@bof.de>
Subject: Re: IP packet logging  function help
Date: Fri, 20 May 2005 08:39:03 +0200
Message-ID: <20050520063903.GA5261@oknodo.bof.de>
References: <20050520041917.322.qmail@web33004.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter <netfilter-devel@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: cranium2003 <cranium2003@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20050520041917.322.qmail@web33004.mail.mud.yahoo.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> I want to know which file in source code has pointer
> to call ipt_log_target function?

Like any other target function, you'll find the call, as an indirect
function call to ->target(), in net/ipv4/netfilter/ip_tables.c, function
ipt_do_table.

> I want instance/copy of const struct net_device *out to my function in
> kernel to know that eth0 or eth1 is transmitting packet.

The above information will not help you at all with this quest.
The LOG target already shows input and output interface, IF THEY ARE
KNOWN.

So, in which iptables table do you intend to get at the output device?
Because, in some table it is simply not yet determined, and you won't
change anything about that by meddling with the generic target function
call site.

best regards
  Patrick
