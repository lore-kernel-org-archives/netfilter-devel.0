From: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Subject: Re: Problems with standalone ipp2p compilation
Date: Wed, 30 Aug 2006 21:16:25 +0200
Message-ID: <20060830191624.GA17624@ekonomika.be>
References: <44F5B4C4.3070707@arcoscom.com> <44F5B6B9.5090209@arcoscom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ipp2p@ipp2p.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel D?az Garc?a <samueldg@arcoscom.com>
Content-Disposition: inline
In-Reply-To: <44F5B6B9.5090209@arcoscom.com>
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

On Wed, Aug 30, 2006 at 06:03:05PM +0200, Samuel D?az Garc?a wrote:
> Notes to get FC5 iptables sources (I forgot them before), as root:
> 
> #> yumdownloader --source iptables
> #> rpm -ihv iptables-1.3.5-1.2.src.rpm
> #> rpmbuild -bp /usr/src/redhat/SPECS/iptables.spec
> #> ln -fs /usr/src/redhat/BUILD/iptables-1.3.5 /usr/src/iptables
> 
> Regards

Hi,

I was unable to compile ipp2p for 2.6.17.11 untill I patched it with
this patch:
http://www.sieglitzhof.net/~doc/ipp2p/patch-ipp2p-0.8.1_rc1_v2.6.17.diff

After that, I compiled it like this:

make KERNEL_SRC=/usr/src/linux-2.6.17.11 IPTABLES_SRC=/usr/src/iptables-1.3.5

(both kernel and iptables source are vanilla)

and copying libipt_ipp2p.so and ipt_ipp2p.ko to where they need to be

kind regards,
-- Steven

-- 
My amazon wishlist:
http://www.amazon.com/gp/registry/1DB4XNEIEQBPB
