From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: Side effect? - Re: Changing the content of tcp timeouts in
	ip_conntrack_proto_tcp.c
Date: Thu, 15 Jan 2004 14:14:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1074172485.1305.21.camel@nienna.balabit>
References: <Pine.LNX.4.44.0401141203530.29640-100000@filer.marasystems.com>
	 <40053873.6000806@netlab.hut.fi> <1074084643.15865.6.camel@nienna.balabit>
	 <400542BD.6050706@netlab.hut.fi>  <40064EA0.3050603@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: emmanuel@netlab.hut.fi
In-Reply-To: <40064EA0.3050603@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Thu, 2004-01-15 at 09:26, Emmanuel Guiton wrote:
> I was a bit optimistic in my last e-mail. Compilation is totally ok, 
> insertion of the modules in the kernel seems to go fine... until I want 
> to use them. The nat table does not work anymore.
> The ip_tables module seems to be there:
> pc104:# iptables -L   
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination        
> 
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination        
> 
> Chain OUTPUT (policy ACCEPT)
> target     prot opt source               destination  
> 
> But if I try the nat table:
> pc104:# iptables -t nat -L
> modprobe: Can't locate module ip_tables
> iptables v1.2.9: can't initialize iptables table `nat': Table does not 
> exist (do you need to insmod?)
> Perhaps iptables or your kernel needs to be upgraded.

  Are you sure iptable_nat is loaded in the kernel? And what does your
kernel log say?

-- 
 Regards,
   Krisztian KOVACS
