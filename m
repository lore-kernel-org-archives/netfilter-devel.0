From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Tue, 13 Jul 2004 04:54:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40F34EF2.2010405@trash.net>
References: <20040415212034.GE7611@obs.bg> <20040713023700.GM21419@ns.snowman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20040713023700.GM21419@ns.snowman.net>
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
> * Ivan Mitev (imitev@obs.bg) wrote:
> 
>>i'm using the CVS (20040415) version of iptables and pom-ng, and kernel
>>2.6.5, to test the new ipsec patches (ipsec-XX + policy).  
> 
> 
> I'm doing basically the same thing.  20040710 or so of POM and iptables
> and 2.6.7.  Got everything built/compiled/installed/etc.  IPSEC is all
> working and whatnot.  My problem is matching things.  I've been trying
> to match using spi and I just can't seem to get it to work.  I'm using
> the spi I get from setkey -D and from tcpdump but no matter what I try
> it doesn't work.
> 
> Sorry I can't give more details, but is this supposted to work?  I'll
> see about adding something to ipt_policy.c to get it to print out what
> it thinks the SPI is tommorow, hopefully.  Anyone else tried this?
> 
> The match works if I don't have --spi 0x<blah>, doesn't work if I do. :/

The --spi option matches the spi given in the setkey policy with
unique:number. I'll update the manpage ..

Regards
Patrick

> 
> 	Thanks,
> 
> 		Stephen
