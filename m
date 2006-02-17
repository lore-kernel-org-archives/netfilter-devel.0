From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec with 2.6.16-rc3-git6
Date: Fri, 17 Feb 2006 09:53:10 +0100
Message-ID: <43F58EF6.4010803@trash.net>
References: <BAY103-F4055BADFA80BE01E71246CB2F80@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F4055BADFA80BE01E71246CB2F80@phx.gbl>
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

Marco Berizzi wrote:
> With these rules I'm able to send/receive packets from the two
> private networks each other (172.16.0.0/23<->172.23.0.0/23).
> If I delete the first rule in the INPUT table (on firenze-gateway)
> 
> ACCEPT     all  --  venezia-gateway       0.0.0.0/0
> 
> there is no packet flow inside the tunnel. I don't understand,
> as I accept esp packets in the red-me chain.

What does your policy look like?
