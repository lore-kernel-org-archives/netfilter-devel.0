From: James Morris <jmorris@intercode.com.au>
Subject: Re: FYI: QUEUE & ipqmpd bugs
Date: Sat, 6 Jul 2002 02:12:01 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Mutt.LNX.4.44.0207060211190.19025-100000@blackbird.intercode.com.au>
References: <003301c2242d$7fca2e40$0689cb8a@etbx180>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org, <netfilter@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
In-Reply-To: <003301c2242d$7fca2e40$0689cb8a@etbx180>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 5 Jul 2002, Jean-Michel Hemstedt wrote:

> FYI,
> 
> I upgraded to iptables-1.2.6a (user & kernel-2.4.18 patches)
> and got the following (maybe known) problems:
> 
> - QUEUE target is NOK with kernel compiled with CONFIG_IP_NF_QUEUE=m
>   => the packets are queued, but ipq_create_handle() returns 
>      "can't create netlink socket"
>      "ERROR: Unable to create netlink socket: Connection refused"
>     (problem with exported symbols?)
>   =>quick fix: compile kernel with CONFIG_IP_NF_QUEUE=y
> 

You need to explicitly load the ip_queue module.


- James
-- 
James Morris
<jmorris@intercode.com.au>
