From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: latest netfilter+ipsec patches
Date: Thu, 11 Mar 2004 23:10:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4050E3DE.4010801@trash.net>
References: <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net> <4047AE0E.1080003@trash.net> <20040304231141.GA1782@alpha.home.local> <20040304234236.GB4995@samad.com.au> <4047DF27.6090904@trash.net> <20040310024526.GF1072@samad.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexander Samad <alex@samad.com.au>
In-Reply-To: <20040310024526.GF1072@samad.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Alexander Samad wrote:
> Patrick 
> 
> I seem to have found a bug in your patches, but only when used in
> conjuction with Herbert's mangle patch.
> 
> It seems like there is a loop caused when the packet traverses the
> tablesi, in particular ip_route_me_harder.
> 
> I tested this on my laptop with debian 2.6.3-2 source with these patches
> that you provided on this thread, as well as the Herbert mangle patch.
> 
> It seem like the packet on the way out gets encapsulated and then the
> encrypted packets try to get re encrypted.

Thanks for the report, for now the easiest solution is to back out
Herbert's patch.

Regards
Patrick
