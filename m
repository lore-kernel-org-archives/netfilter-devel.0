From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables extension help
Date: Sun, 16 Nov 2003 18:14:28 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311161812280.31812-100000@filer.marasystems.com>
References: <20031116043510.936426D9B5@barrel.tokuda.cs-private>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter_devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: xiao shao <shao@tt.cs.titech.ac.jp>
In-Reply-To: <20031116043510.936426D9B5@barrel.tokuda.cs-private>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 16 Nov 2003, xiao shao wrote:

> I write a new iptables target for a test and compiled the
> kernel without error messages. But when I tried to use this
> target, I got the following error message.
> 
> *********************************************
> 
> ptables v1.2.6a: Couldn't load target `ORG':/lib/iptables/libipt_ORG.so: cannot open
> shared object file: No such file or directory

This is the iptables userspace program looking for the userspace half of
your new "ORG" target. This half is responsible for parsing the iptables
command line arguments and translating it into a suitable target structure
for your target.

This is separate from the kernel module. Sources to the userspace modules 
is in userspace/extensions/, not in the kernel or patch-o-matic.

Regards
Henrik
