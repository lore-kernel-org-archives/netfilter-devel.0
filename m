From: Patrick McHardy <kaber@trash.net>
Subject: Re: new iptables policy match
Date: Thu, 12 Jan 2006 17:31:24 +0100
Message-ID: <43C6845C.1010405@trash.net>
References: <BAY103-F17E50648E467F94FCCFAC6B2270@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F17E50648E467F94FCCFAC6B2270@phx.gbl>
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
> Ok. Here is my suggestion:
> 
> --tunnel-src addr[/mask]
> matches the source end-point address of the SA. Only valid
> with --mode tunnel
> 
> --tunnel-dst addr[/mask]
> matches the destination end-point address of the SA. Only valid
> with --mode tunnel

Thanks, I've updated the man-page.
