From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: MARK-Operations problems
Date: Thu, 8 Jul 2004 02:10:40 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407080210100.9492-100000@filer.marasystems.com>
References: <20040707115753.GA22265@samad.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Fabrice MARIE <fabrice@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexander Samad <alex@samad.com.au>
In-Reply-To: <20040707115753.GA22265@samad.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 7 Jul 2004, Alexander Samad wrote:

> I build a static linked iptables for testing but when I attempt to run
> this command 
> 
> iptables -t mangle -I PREROUTING 1  -j MARK  --or-mark 0x1
> I get iptables: Target problem
> and this is dmesg MARK: targinfosize 8 != 4

Looks to me like you are running a patched iptables userspace command on
an unpatched kernel...

Regards
Henrik
