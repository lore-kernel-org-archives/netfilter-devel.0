From: Oskar Andreasson <blueflux@koffein.net>
Subject: Re: Error in rules DNAT
Date: Sun, 29 Jun 2003 16:03:15 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0306291601130.24424-100000@laptop1.agatha>
References: <007b01c34328$5449a050$0100000a@william>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William da Rocha Lima <wrochal@linuxit.com.br>
In-Reply-To: <007b01c34328$5449a050$0100000a@william>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi William,

Sorry to say this, but I must ask, what are you talking about? 

On Sat, 5 Jul 2003, William da Rocha Lima wrote:

> Oskar Andreasson,
> 
> Verifies that rule DNAT this incorrect one:
> iptables - t nat - the PREROUTING - p tcp - d 15,45,23,67 -- dport 80 - j
> DNAT -- to-destination 192,168,1,1
> 
> the correct one is:
> 
> iptables - t nat - the PREROUTING - p tcp - i ethX - d 15,45,23,67 -- 
> dport - 80 j DNAT -- to-destination 192,168,1,1
> 
> being that ethX is entrance interface
> 
> Articles write iam:
> http://www.linuxit.com.br/modules.php?name=Sections&op=viewarticle&artid=21
> 
> bye,
> 
> ====================
> William da Rocha Lima
> wrochal@linuxit.com.br
> www.linuxit.com.br
> 
> 
> 

-- 
----
Oskar Andreasson
http://www.frozentux.net
http://iptables-tutorial.frozentux.net
http://ipsysctl-tutorial.frozentux.net
mailto:blueflux@koffein.net
