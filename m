From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ip_conntrack table full problem
Date: Tue, 15 Mar 2005 11:13:48 +0100
Message-ID: <200503151113.48298.thomas.jarosch@intra2net.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<20050314171821.GA29034@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050314171821.GA29034@linuxace.com>
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

> > I'm facing a problem with conntrack on a 2.4.21 kernel.
> > One machine which firewalls a webradio reproducable
> > becomes unresponsive every week with
> > "ip_conntrack: table full, dropping packet."
>
> When this happens, what does output from this look like:
>
> wc -l /proc/net/ip_conntrack ; grep ip_conntrack /proc/slabinfo

Thanks Phil, I've extended my logger. The machine freezed yesterday,
so it will take a week until it freezes again. I'll keep you posted.

Thomas
