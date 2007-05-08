From: "Doc Nielsen" <docnielsen@gmail.com>
Subject: Re: Compile errors for debian-amd64
Date: Tue, 8 May 2007 14:52:10 +0200
Message-ID: <78e398b30705080552nc68462ckb13f7a295f6ed7e5@mail.gmail.com>
References: <20070508110905.GA3768482@metu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070508110905.GA3768482@metu.edu.tr>
Content-Disposition: inline
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

On 5/8/07, husnu demir <hdemir@metu.edu.tr> wrote:
> I am getting compile errors on debian-amd64. Can somebody point me correct place?

>   MODPOST 754 modules
> WARNING: "ip6t_register_target" [net/ipv6/netfilter/ip6t_ROUTE.ko] undefined!
> WARNING: "ip6t_unregister_target" [net/ipv6/netfilter/ip6t_ROUTE.ko] undefined!
> WARNING: "ipt_register_match" [net/ipv4/netfilter/ipt_set.ko] undefined!
> WARNING: "ipt_unregister_match" [net/ipv4/netfilter/ipt_set.ko] undefined!
> WARNING: "ipt_register_match" [net/ipv4/netfilter/ipt_connlimit.ko] undefined!
> WARNING: "ipt_unregister_match" [net/ipv4/netfilter/ipt_connlimit.ko] undefined!
> WARNING: "ipt_register_target" [net/ipv4/netfilter/ipt_SET.ko] undefined!
> WARNING: "ipt_unregister_target" [net/ipv4/netfilter/ipt_SET.ko] undefined!
> WARNING: "ipt_register_target" [net/ipv4/netfilter/ipt_ROUTE.ko] undefined!
> WARNING: "ipt_unregister_target" [net/ipv4/netfilter/ipt_ROUTE.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

thats funny, i got the same error while compiling a fresh 2.6.21.1 last night.
Guess it wasn't just my system acting up.

-Doc
-- 
No trees were killed in the sending of this message
However, a large number of electrons were terribly inconvenienced.
Join the Revolution: 09f911029d74e35bd84156c5635688c0
