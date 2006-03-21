From: "Shekhar Kshirsagar" <shekhar.kshirsagar@gmail.com>
Subject: Re: Memory scaling issues with Per CPU copy of ipt_entry tables in
	iptables
Date: Tue, 21 Mar 2006 09:43:41 -0800
Message-ID: <8cfc57e20603210943y4f618f8bx3cf798dabf769cb3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Trying again...
It will be really helpful, if someone can provide historic perspective on t=
his:

Thanks,
Shekhar

On 3/18/06, Shekhar Kshirsagar <shekhar.kshirsagar@gmail.com> wrote:
> iptables code (2.4/2.6), iptables implementation makes per CPU copy of
> the ipt_entry tables.
> Looking in the code, it seems that per CPU copy is really required
> only for two variables in ipt_entry structure - 'comefrom' and
> 'counters'.
>
> But further investigation reveals that, old ipchains implementation
> (ipchains_core.c) had per CPU copy of only counters instead of the
> complete structure. So it seems like there was some specific reason to
> move away from per CPU copy of just counters to per CPU copy of
> complete ipt_entry tables.
>
> Can somebody who knows history of these changes help me understand the
> implications if one wants to reduce iptables memory requirements by
> going per CPU copy of only two variables - 'comefrom' and 'counters'.
>
> Thanks,
> Shekhar
>
