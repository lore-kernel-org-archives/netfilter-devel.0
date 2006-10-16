From: Yoshioka Tsuneo <tsuneo.yoshioka@f-secure.com>
Subject: Re: Request: including tproxy patch to official iptables/kernel.
Date: Mon, 16 Oct 2006 16:28:42 +0900
Message-ID: <20061016161823.E8F0.TSUNEO.YOSHIOKA@f-secure.com>
References: <20061016114331.AF36.TSUNEO.YOSHIOKA@f-secure.com>
	<45331D32.5070209@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45331D32.5070209@trash.net>
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

Hello Patrick McHardy

Thank you for your reply !

> > So, I would like to suggest to include tproxy patch to official
> > iptables/kernel release.
> > Can you think about including this patch to official iptables/kernel
> > release, if possible ?
> > 
> >    TPROXY
> >        http://www.balabit.com/products/oss/tproxy/
> > 
> >    patch-o-matic extra repository
> >      tproxy - iptables TPROXY target
> >        http://www.iptables.org/projects/patch-o-matic/pom-extra.html#pom-extra-tproxy
> 
> 
> These look quite old (2.4). The TPROXY developers were working on
> a new approach last year at the netfilter workshop, but I don't
> know if there was any further progress. Please talk to them directly
> and ask them if they want to merge it upstream, and if so to submit
> patches.
Both patch for kernel2.4 and 2.6 is available on the following URL.
  http://www.balabit.com/downloads/tproxy/linux-2.4/

Now, following packages are available as the latest version.
	cttproxy-2.4.32-2.0.5.tar.gz File 70.47k 09/12/2006 
	cttproxy-2.4.33-2.0.5.tar.gz File 70.29k 09/12/2006 
	cttproxy-2.6.16-2.0.5.tar.gz File 55.49k 09/12/2006 
	cttproxy-2.6.17-2.0.5.tar.gz File 55.64k 09/12/2006 
	cttproxy-2.6.18-2.0.5.tar.gz File 55.58k 09/12/2006 

Is there any other thing I or the patch developer can do ?
I would appreciate it if you can merge these patches to the official
iptables/release. How about it ?

Thank you !

-- 
Nihon F-Secure Corporation
(Yoshioka Tsuneo)
E-MAIL: Tsuneo.Yoshioka@f-secure.com
