From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Tue, 13 Jul 2004 17:56:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40F4062B.9060308@trash.net>
References: <20040415212034.GE7611@obs.bg> <20040713023700.GM21419@ns.snowman.net> <40F34EF2.2010405@trash.net> <20040713115306.GN21419@ns.snowman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20040713115306.GN21419@ns.snowman.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Stephen Frost wrote:
> * Patrick McHardy (kaber@trash.net) wrote:
>
>>The --spi option matches the spi given in the setkey policy with
>>unique:number. I'll update the manpage ..
> 
> 
> Ahhh, now that makes much more sense.  I just had 'require' before.  I'm
> getting closer it seems.  Now, at least, I seem to be able to match the
> number I put after the 'unique:' using '--reqid'.  Still doesn't work
> when using '--spi' though.  Not sure that I care though, unless someone
> can tell me a reason why I should?  It's important, of course, to match
> the right packets, since I'm doing tunneling and different remote sites
> will have access to different things and so different firewall rules to
> handle them...

Ooops, right, that was the --reqid option. I need to update the manpage
again ;) Not sure what the problem with --spi is, I will test is myself
soon.

Regards
Patrick


> 
> 	Thanks,
> 
> 		Stephen
