From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 00/09]: Netfilter update
Date: Tue, 21 Mar 2006 09:56:42 +0100
Message-ID: <441FBFCA.9030802@trash.net>
References: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>	<441F6280.3020201@trash.net>
	<20060320.234255.32496441.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060320.234255.32496441.davem@davemloft.net>
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

David S. Miller wrote:
> Ok, but please kill trailing whitespace in patches, GIT even warns
> about this now and you can check and fix it up before applying a patch
> by using:
> 
> 	git apply --check --whitespace=error-all
> 
> So, for example, on this H323 patch we get:
> 
> + git apply --check --whitespace=error-all diff
> Adds trailing whitespace.
> diff:73:	 
> Adds trailing whitespace.
> diff:146: *  
> Adds trailing whitespace.
> diff:156: *	 
> Adds trailing whitespace.
> diff:171: * 	 
> Adds trailing whitespace.
> diff:5747: *	 
> fatal: 5 lines add trailing whitespaces.
> 
> I fixed it up by hand this time, but I may stop doing so in
> the future and push it back to you instead :-)

Thanks. Actually my scripts are supposed to take care of that (and
usually do), but I seem to have had bad fortune yesterday :)
