From: Patrick McHardy <kaber@trash.net>
Subject: Re: new iptables policy match
Date: Sun, 22 Jan 2006 14:38:44 +0100
Message-ID: <43D38AE4.9020701@trash.net>
References: <BAY103-F3EE617C3194F61E05CC5CB2270@phx.gbl>
	<43C616B1.6060101@trash.net>
	<200601200754.40865.teastep@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <200601200754.40865.teastep@shorewall.net>
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

Tom Eastep wrote:
> On Thursday 12 January 2006 00:43, Patrick McHardy wrote:
> 
> 
>>Yes, --next is needed only if your policy has multiple elements, like
>>"--mode tunnel --tunnel-src 1.2.3.4/32 --next --mode transform". I'll
>>fix up the userspace part to reject this incorrect use.
> 
> 
> The second of those patches (Revision 6395 -- Move empty policy element check 
> to also catch last element) has broken compatibility with previous versions 
> of policy match.
> 
> Previously, the following command succeeded and matched any traffic that is to 
> be subsequently transformed:
> 
> gw:~ # iptables -A foo -m policy --pol ipsec --dir out -j ACCEPT
> iptables v1.3.4: policy match: empty policy element
> Try `iptables -h' or 'iptables --help' for more information.
> gw:~ #
> 
> Is this incompatibility intentional? If so, I need to change Shorewall 
> accordingly. 

Its a bug, thanks for catching this. I've fixed it up in SVN.
