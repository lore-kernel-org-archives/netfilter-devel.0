From: Grzegorz Janoszka <Grzegorz.Janoszka@pro.onet.pl>
Subject: Re: IPMARK nfcache
Date: Sat, 29 Oct 2005 19:12:44 +0200 (CEST)
Message-ID: <Pine.GSO.4.63.0510291912370.28447@galaxy.agh.edu.pl>
References: <20051028221728.GC10248@samad.com.au>
	<Pine.GSO.4.63.0510291849040.28447@galaxy.agh.edu.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexander Samad <alex@samad.com.au>
In-Reply-To: <Pine.GSO.4.63.0510291849040.28447@galaxy.agh.edu.pl>
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

On Sat, 29 Oct 2005, Grzegorz Janoszka wrote:

> My IPMARK was based on original MARK target. You can look what has changed in 
> libipt_MARK.c and correct it.

http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=2689

The patch dedicated to net/ipv4/netfilter/ipt_MARK.c should go to 
ipt_IPMARK.c

> I don't know if I have to submit a new patch or it will be corrected by 
> netfilter developers?

I suggest you make the changes, can you do it?

-- 
Grzegorz Janoszka
