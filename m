From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: "ip_tables: table screwed up!" on pom 20031023 - raw patch?
Date: Fri, 21 Nov 2003 01:49:32 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311210139300.23998-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0311201359480.17842-100000@sparrow>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, <kadlec@netfilter.org>,
   ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
In-Reply-To: <Pine.LNX.4.44.0311201359480.17842-100000@sparrow>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 Nov 2003, William Stearns wrote:

> 	Just for reference, using the stock compiled iptables rpm from 
> Redhat 7.3's updates collection (after cleaning out every trace of the 
> self-compiled iptables and modules) gives:
> 
> bash-2.05a# iptables -L INPUT
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination         
> bash-2.05a# iptables -A INPUT -s 99.99.99.99     
> iptables: Invalid argument

This is a know error in the version of the "raw" patch you are using
causing a binary incompatibility, and is corrected in POM to only cause 
this if the TRACE patch is used (was part of "raw", now separate).

Your other problems I am not familiar with. But at the same time I am 
currently trying to hunt down a odd problem where iptables is very 
unstable in our UML kernel but not on "real" boxes.. and your reference to 
the "raw" table makes me suspect my problems may in fact be from that 
patch (we have the "raw" patch applied to the UML kernel, not to the 
kernel for "real" boxes). I will know more tomorrow.

Regards
Henrik
