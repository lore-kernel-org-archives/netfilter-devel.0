From: Brad Fisher <brad@info-link.net>
Subject: Re: [PATCH] comment match port to pom-ng
Date: Tue, 18 May 2004 10:06:56 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AA2690.8A693A6A@info-link.net>
References: <Pine.LNX.4.33.0405180110430.31252-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:

> On Wed, 12 May 2004, Brad Fisher wrote:
>
> > Attached is a tar file containing the comment match I wrote a while back
> > (Also posted before for old POM with no response:
> > http://marc.theaimsgroup.com/?l=netfilter-devel&m=107056927528485&w=2).
> > I've ported it to pom-ng, and it should work for 2.4 kernels fine.
> > Haven't tested 2.6 kernels, but will hopefully get a chance soon.
>
> Patch is added to pom-ng. :-)
> It is marked as for 2.4 only in the info file, because it won't work with
> 2.6 (API changed).

Thanks!  I'll try to get a 2.6 version of the patch together then :)  BTW, is
there any 2.6 specific documentation out there beyond the source?

> Best regards,
> Jozsef

-Brad Fisher
