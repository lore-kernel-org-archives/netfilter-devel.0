From: Ben Efros <ben@xgendev.com>
Subject: Re: iptables.c changes submitted argv value
Date: Thu, 12 Aug 2004 19:01:59 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411C2117.7010709@xgendev.com>
References: <IDEAKKJENKGNPNLKJKODOEAECAAA.listuser@epygi.de> <Pine.LNX.4.61.0408121254480.20263@filer.marasystems.com> <411C05AD.6030408@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Sascha <listuser@epygi.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <411C05AD.6030408@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


>
> You probably want to have iptables still for debugging/diagnostics.
> If so, get the latest version of iptables from CVS and enable DO_MULTI.
> This combines all three programs into the one binary.
>
Additionally if you need to save space, you can use the strip utility:

iptables    (orig)         64486 bytes
#strip -s iptables
iptables    (stripped)  56612 bytes

Yea! 87.8% of the original size!

(I used gcc 3.4.1 2004-6-11 on iptables-1.2.11 2004-8-12 snapshot)

There are a number of other ways to easily cut the size down much 
smaller and keep the same functionality.
